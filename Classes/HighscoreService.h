//
//  HighscoreService.h
//  MQNorway
//
//  Created by knut on 03/12/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//


#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import <Foundation/Foundation.h>


#pragma mark * Block Definitions


typedef void (^QSCompletionBlock) ();
typedef void (^QSCompletionWithIndexBlock) (NSUInteger index);
typedef void (^QSBusyUpdateBlock) (BOOL busy);



@interface HighscoreService : NSObject

@property (nonatomic, strong)   NSArray *items;
@property (nonatomic, strong)   MSClient *client;
@property (nonatomic, copy)     QSBusyUpdateBlock busyUpdate;

+ (HighscoreService *)defaultService;

- (void)writeItemIfHigherScore:(NSDictionary *)item predicate:(NSPredicate*) predicate completion:(QSCompletionBlock)completion;

- (void)addItem:(NSDictionary *)item
     completion:(QSCompletionWithIndexBlock)completion;

- (void)completeItem:(NSDictionary *)item
          completion:(QSCompletionWithIndexBlock)completion;


- (void)handleRequest:(NSURLRequest *)request
                 next:(MSFilterNextBlock)next
             response:(MSFilterResponseBlock)response;

- (void) sendScoreGetRankForPlayer:(NSDictionary*) jsonDictionary completion:(MSAPIDataBlock)completion;
- (void) getHigscoreForPlayerAndLevel:(NSDictionary*) jsonDictionary completion:(MSAPIDataBlock)completion;


@end