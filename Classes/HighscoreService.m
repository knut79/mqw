//
//  HighscoreService.m
//  MQNorway
//
//  Created by knut on 03/12/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//


#import "HighscoreService.h"
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>


#pragma mark * Private interace


@interface HighscoreService() <MSFilter>

@property (nonatomic, strong)   MSTable *table;
@property (nonatomic)           NSInteger busyCount;

@end


#pragma mark * Implementation


@implementation HighscoreService

@synthesize items;


+ (HighscoreService *)defaultService
{
    // Create a singleton instance of QSTodoService
    static HighscoreService* service;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        service = [[HighscoreService alloc] init];
    });
    
    return service;
}

-(HighscoreService *)init
{
    self = [super init];
    
    if (self)
    {
        // Initialize the Mobile Service client with your URL and key
        MSClient *client = [MSClient clientWithApplicationURLString:@"https://mapfight1.azure-mobile.net/"
                                                     applicationKey:@"SaKOQUnJGCKObnhsMMeWMqdOMeAxrv44"];
        
        // Add a Mobile Service filter to enable the busy indicator
        self.client = [client clientWithFilter:self];
        
        // Create an MSTable instance to allow us to work with the TodoItem table
        self.table = [_client tableWithName:@"Highscore"];
        
        self.items = [[NSMutableArray alloc] init];
        self.busyCount = 0;
    }
    
    return self;
}

- (void) writeItemIfHigherScore:(NSDictionary *)itemToWrite predicate:(NSPredicate*) predicate completion:(QSCompletionBlock)completion
{
    // Create a predicate that finds items where complete is false
    
    //NSPredicate * predicate = [NSPredicate predicateWithFormat:@"deleted == NO"];
    /*NSPredicate *predicateTest = [NSPredicate predicateWithFormat:@"%K like %@",
     @"userId", @"123"];*/
    // Query the TodoItem table and update the items property with the results from the service
    [self.table readWithPredicate:predicate completion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         [self logErrorIfNotNil:error];
         if (error) {
             NSLog(@"error : %@",error);
         }
         items = [results mutableCopy];
         if (items.count == 0) {
             [self addItem:itemToWrite completion:^(NSUInteger index)
              {}];
         }
         else
         {
             if(items.count > 1)
                 [NSException raise:@"Error" format:@"Collected more than one highscore row"];
             
             //check if answered questions and time is better than the current
             NSDictionary *item = [items objectAtIndex:0];
             NSNumber * secondsUsed = [item objectForKey:@"seconds"];
             NSNumber * questionsAnswered = [item objectForKey:@"answeredQuestions"];
             
             NSNumber * secondsUsedToWrite = [itemToWrite objectForKey:@"seconds"];
             NSNumber * questionsAnsweredToWrite = [itemToWrite objectForKey:@"answeredQuestions"];
             
             if ([questionsAnswered longValue] < [questionsAnsweredToWrite longValue] ||
                 ([questionsAnswered longValue] == [questionsAnsweredToWrite longValue] && [secondsUsed longValue] > [secondsUsedToWrite longValue])) {
                 [item setValue:secondsUsedToWrite forKey:@"seconds"];
                 [item setValue:questionsAnsweredToWrite forKey:@"answeredQuestions"];
                 [self.table update:item completion:^(NSDictionary *item, NSError *error)
                  {
                      if (error) {
                          NSLog(@"error : %@",error);
                      }
                  }];
             }
         }
         
         // Let the caller know that we finished
         completion();
     }];
}

-(void) readPositionForPlayerResult:(NSDictionary *)item predicate:(NSPredicate*) predicate completion:(QSCompletionBlock)completion
{
    
    /*
     
     WITH RankNames AS
     (
        SELECT ROW_NUMBER() OVER (ORDER BY AnsweredQuestions desc, Seconds asc) AS RowRank, AnsweredQuestions, Seconds, Level, UserId 
        FROM [MapFight1].[Highscores]
     )
     SELECT RowRank, AnsweredQuestions, Seconds, UserId FROM RankNames
     WHERE Level =%level% AND UserId like ´%userid%´
     
     */
    
    /*
    MSQuery *query = [self.table query];//[self.table queryWithPredicate: predicate];
    [query re queryStringOrError:]
    
    
    [query orderByAscending:@"answeredQuestions"];
    [query orderByAscending:@"seconds"];
    
    [query readWithCompletion:^(NSArray *results, NSInteger totalCount, NSError *error)
     {
         
     }];*/
}

-(void)addItem:(NSDictionary *)item completion:(QSCompletionWithIndexBlock)completion
{
    // Insert the item into the TodoItem table and add to the items array on completion
    [self.table insert:item completion:^(NSDictionary *result, NSError *error)
     {
         if (error) {
             NSLog(@"error is %@",error);
         }
         [self logErrorIfNotNil:error];
         
         NSUInteger index = [items count];
         [(NSMutableArray *)items insertObject:result atIndex:index];
         
         // Let the caller know that we finished
         completion(index);
     }];
}

-(void)completeItem:(NSDictionary *)item completion:(QSCompletionWithIndexBlock)completion
{
    // Cast the public items property to the mutable type (it was created as mutable)
    NSMutableArray *mutableItems = (NSMutableArray *) items;
    
    // Set the item to be complete (we need a mutable copy)
    NSMutableDictionary *mutable = [item mutableCopy];
    [mutable setObject:@YES forKey:@"complete"];
    
    // Replace the original in the items array
    NSUInteger index = [items indexOfObjectIdenticalTo:item];
    [mutableItems replaceObjectAtIndex:index withObject:mutable];
    
    // Update the item in the TodoItem table and remove from the items array on completion
    [self.table update:mutable completion:^(NSDictionary *item, NSError *error) {
        
        [self logErrorIfNotNil:error];
        
        NSUInteger index = [items indexOfObjectIdenticalTo:mutable];
        if (index != NSNotFound)
        {
            [mutableItems removeObjectAtIndex:index];
        }
        
        // Let the caller know that we have finished
        completion(index);
    }];
}

- (void) sendScoreGetRankForPlayer:(NSDictionary*) jsonDictionary completion:(MSAPIDataBlock)completion
{
    //NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys: @"1", @"level", nil];
    [self.client
     invokeAPI:@"highscorerank"
     data:nil
     HTTPMethod:@"POST"
     parameters:jsonDictionary
     headers:nil
     completion:completion ];
}

- (void)busy:(BOOL)busy
{
    // assumes always executes on UI thread
    if (busy)
    {
        if (self.busyCount == 0 && self.busyUpdate != nil)
        {
            self.busyUpdate(YES);
        }
        self.busyCount++;
    }
    else
    {
        if (self.busyCount == 1 && self.busyUpdate != nil)
        {
            self.busyUpdate(FALSE);
        }
        self.busyCount--;
    }
}

- (void)logErrorIfNotNil:(NSError *) error
{
    if (error)
    {
        NSLog(@"ERROR %@", error);
    }
}


#pragma mark * MSFilter methods


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response
{
    // A wrapped response block that decrements the busy counter
    MSFilterResponseBlock wrappedResponse = ^(NSHTTPURLResponse *innerResponse, NSData *data, NSError *error)
    {
        [self busy:NO];
        response(innerResponse, data, error);
    };
    
    // Increment the busy counter before sending the request
    [self busy:YES];
    next(request, wrappedResponse);
}

@end