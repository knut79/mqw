//
//  ChallengeStatusView.m
//  MQNorway
//
//  Created by knut on 02/02/15.
//  Copyright (c) 2015 lemmus. All rights reserved.
//

#import "ChallengeStatusView.h"
#import "GlobalSettingsHelper.h"
#import "HighscoreService.h"

@interface ChallengeStatusView ()

// Private properties
@property (strong, nonatomic) HighscoreService *highscoreService;

@end

@implementation ChallengeStatusView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
        
        getChallengesResultsRetry = 0;
        getUserVsUserResultsRetry = 0;
        UIScreen *screen = [[UIScreen mainScreen] retain];
        buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:@"Back" forState:UIControlStateNormal];
        buttonBack.layer.borderWidth=1.0f;
        [buttonBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonBack.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonBack.frame = CGRectMake([screen applicationFrame].size.width/2 - (180/2), 435.0, 180.0, 40.0);
		[self addSubview:buttonBack];
        
        self.highscoreService = [HighscoreService defaultService];
        
        
        
        
        
        pageStartToLoadRecentChallenges = [[[NSMutableString alloc] init] retain];
        [pageStartToLoadRecentChallenges appendString:@"<html><head></head><body>"];
        [pageStartToLoadRecentChallenges appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
        [pageStartToLoadRecentChallenges appendString:@"<tr bgcolor=#C0C0C0><td colspan='2'>Difficulty Creation time</td><td>Status</td></tr>"];
        [pageStartToLoadRecentChallenges release];
        
        pageMiddleToLoadRecentChallenges = [[NSMutableString alloc] init];
        
        pageEndToLoadRecentChallenges = [[[NSMutableString alloc] init] retain];
        [pageEndToLoadRecentChallenges appendString:@"</table>"];
        [pageEndToLoadRecentChallenges appendString:@"</body></html>"];
        [pageEndToLoadRecentChallenges release];
        
        webViewRecentChallenges = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, 300, 170)];
		webViewRecentChallenges.center = CGPointMake([screen applicationFrame].size.width/2, 60 + (webViewRecentChallenges.frame.size.height/2));
		//webView.backgroundColor = [UIColor clearColor];
		//[webView setOpaque:NO];
		webViewRecentChallenges.scalesPageToFit = NO;
		[self addSubview:webViewRecentChallenges];
        
        
        activityIndicatorRecentChallenges = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [self addSubview:activityIndicatorRecentChallenges];
        activityIndicatorRecentChallenges.center = CGPointMake([screen applicationFrame].size.width/2, 60 + (webViewRecentChallenges.frame.size.height/2));
        
        pageStartToLoadUserVsUser = [[[NSMutableString alloc] init] retain];
        [pageStartToLoadUserVsUser appendString:@"<html><head></head><body>"];
        [pageStartToLoadUserVsUser appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
        [pageStartToLoadUserVsUser appendString:@"<tr bgcolor=#C0C0C0><td colspan='2'>Difficulty Creation time</td><td>Status</td></tr>"];
        [pageStartToLoadUserVsUser release];
        
        pageMiddleToLoadUserVsUser = [[NSMutableString alloc] init];
        
        pageEndToLoadUserVsUser = [[[NSMutableString alloc] init] retain];
        [pageEndToLoadUserVsUser appendString:@"</table>"];
        [pageEndToLoadUserVsUser appendString:@"</body></html>"];
        [pageEndToLoadUserVsUser release];
        
        webViewUserVsUser = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, 300, 170)];
		webViewUserVsUser.center = CGPointMake([screen applicationFrame].size.width/2, 260 + (webViewUserVsUser.frame.size.height/2));
		webViewUserVsUser.scalesPageToFit = NO;
		//[self ReloadHtmlUserVsUser];
		[self addSubview:webViewUserVsUser];
        
        activityIndicatorUserVsUser = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [self addSubview:activityIndicatorUserVsUser];
        activityIndicatorUserVsUser.center = CGPointMake([screen applicationFrame].size.width/2, 60 + (webViewUserVsUser.frame.size.height/2));
        
        
        
        headerRecentChallengeResult = [[UILabel alloc] init];
		[headerRecentChallengeResult setFrame:CGRectMake(80, 0, 180, 40)];
		headerRecentChallengeResult.backgroundColor = [UIColor clearColor];
		headerRecentChallengeResult.textColor = [UIColor whiteColor];
		[headerRecentChallengeResult setFont:[UIFont boldSystemFontOfSize:12.0f]];
		headerRecentChallengeResult.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerRecentChallengeResult.layer.shadowOpacity = 1.0;
		headerRecentChallengeResult.text = @"Recent challenge result";
        headerRecentChallengeResult.center = CGPointMake([screen applicationFrame].size.width/2,webViewRecentChallenges.center.y - (webViewRecentChallenges.frame.size.height/2) -10);
		[self addSubview:headerRecentChallengeResult];
        
        
        headerUserVsUserResult = [[UILabel alloc] init];
		[headerUserVsUserResult setFrame:CGRectMake(80, 0, 180, 40)];
		headerUserVsUserResult.backgroundColor = [UIColor clearColor];
		headerUserVsUserResult.textColor = [UIColor whiteColor];
		[headerUserVsUserResult setFont:[UIFont boldSystemFontOfSize:12.0f]];
		headerUserVsUserResult.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerUserVsUserResult.layer.shadowOpacity = 1.0;
		headerUserVsUserResult.text = @"User results";
        headerRecentChallengeResult.center = CGPointMake([screen applicationFrame].size.width/2,webViewUserVsUser.center.y - (webViewUserVsUser.frame.size.height/2) -10);
		[self addSubview:headerUserVsUserResult];
        
        
        [self getChallengesResults];
        [self getUserVsUserResults];
        
        [screen release];
    }
    return self;
}

-(void)goBack:(id)Sender
{
	[self FadeOut];
}

-(void) FadeIn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[UIView commitAnimations];
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(TellParentToCleanUp)];
	[self setAlpha:0];
	[UIView commitAnimations];
}

-(void) TellParentToCleanUp
{
	if ([delegate respondsToSelector:@selector(cleanUpChallengeStatusView)])
		[delegate cleanUpChallengeStatusView];
}

-(void) getChallengesResults
{
    [activityIndicatorRecentChallenges setAlpha:1];
	[activityIndicatorRecentChallenges startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", @1, @"level",nil];
    
    [self.highscoreService getHigscoreForPlayerAndLevel:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         
         [activityIndicatorRecentChallenges stopAnimating];
         [activityIndicatorRecentChallenges setAlpha:0];
         if (error)
         {
             NSLog(@"Error %@",error);
             
             
             if (getChallengesResultsRetry < 2 ) {
                 getChallengesResultsRetry++;
                 [self getChallengesResults];
             }
             else
             {
                 getChallengesResultsRetry = 0;
                 NSString* errorMessage = @"There was a problem! ";
                 errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
                 UIAlertView* myAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error!"
                                         message:errorMessage
                                         delegate:nil
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil];
                 [myAlert show];
             }
         }
         else {
             getChallengesResultsRetry = 0;
             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             //NSLog(@"The datastring : %@",newStr);
             
             //remove front [ and back ] characters
             if ([newStr rangeOfString: @"]"].length >0) {
                 [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
                 [newStr deleteCharactersInRange: NSMakeRange(0,1)];
                 NSLog(@"The datastring : %@",newStr);
             }
             
             NSMutableArray* dataArray = [[NSMutableArray alloc] init];
             [pageMiddleToLoadRecentChallenges retain];
             int ind = 0;
             while ([newStr rangeOfString: @"}"].length >0) {
                 NSRange match = [newStr rangeOfString: @"}"];
                 NSString* rowSubstring1 = [newStr substringWithRange:NSMakeRange(0, match.location+1)];
                 NSLog(@"The substring1 : %@",rowSubstring1);
                 
                 NSData *jsonData = [rowSubstring1 dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *jsonObject=[NSJSONSerialization
                                           JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableLeaves
                                           error:nil];
                 NSLog(@"jsonObject is %@",jsonObject);
                 
                 
                 
                 [dataArray addObject:jsonObject];
                 if ([newStr rangeOfString: @"}"].location + 2 < newStr.length) {
                     [newStr deleteCharactersInRange: NSMakeRange(0, match.location + 2)];
                 }
                 else{
                     [newStr deleteCharactersInRange: NSMakeRange(0, newStr.length)];
                 }
                 
                 
                 [pageMiddleToLoadRecentChallenges appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>creatorID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 [pageMiddleToLoadRecentChallenges appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>targetID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 
                 
                 ind ++;
             }
             [pageMiddleToLoadRecentChallenges release];
             
             [self ReloadHtmlRecentChallenges];
             
         }
         
     }];
}


-(void) getUserVsUserResults
{
    [activityIndicatorUserVsUser setAlpha:1];
	[activityIndicatorUserVsUser startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", @1, @"level",nil];
    
    [self.highscoreService getHigscoreForPlayerAndLevel:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         
         [activityIndicatorUserVsUser stopAnimating];
         [activityIndicatorUserVsUser setAlpha:0];
         if (error)
         {
             NSLog(@"Error %@",error);
             
             
             if (getUserVsUserResultsRetry < 2 ) {
                 getUserVsUserResultsRetry++;
                 [self getChallengesResults];
             }
             else
             {
                 getUserVsUserResultsRetry = 0;
                 NSString* errorMessage = @"There was a problem! ";
                 errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
                 UIAlertView* myAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error!"
                                         message:errorMessage
                                         delegate:nil
                                         cancelButtonTitle:@"Okay"
                                         otherButtonTitles:nil];
                 [myAlert show];
             }
         }
         else {
             getUserVsUserResultsRetry = 0;
             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             //NSLog(@"The datastring : %@",newStr);
             
             //remove front [ and back ] characters
             if ([newStr rangeOfString: @"]"].length >0) {
                 [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
                 [newStr deleteCharactersInRange: NSMakeRange(0,1)];
                 NSLog(@"The datastring : %@",newStr);
             }
             
             NSMutableArray* dataArray = [[NSMutableArray alloc] init];
             [pageMiddleToLoadRecentChallenges retain];
             int ind = 0;
             while ([newStr rangeOfString: @"}"].length >0) {
                 NSRange match = [newStr rangeOfString: @"}"];
                 NSString* rowSubstring1 = [newStr substringWithRange:NSMakeRange(0, match.location+1)];
                 NSLog(@"The substring1 : %@",rowSubstring1);
                 
                 NSData *jsonData = [rowSubstring1 dataUsingEncoding:NSUTF8StringEncoding];
                 NSDictionary *jsonObject=[NSJSONSerialization
                                           JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableLeaves
                                           error:nil];
                 NSLog(@"jsonObject is %@",jsonObject);
                 
                 
                 
                 [dataArray addObject:jsonObject];
                 if ([newStr rangeOfString: @"}"].location + 2 < newStr.length) {
                     [newStr deleteCharactersInRange: NSMakeRange(0, match.location + 2)];
                 }
                 else{
                     [newStr deleteCharactersInRange: NSMakeRange(0, newStr.length)];
                 }
                 
                 
                 [pageMiddleToLoadUserVsUser appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>creatorID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 [pageMiddleToLoadUserVsUser appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>targetID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 
                 
                 ind ++;
             }
             [pageMiddleToLoadUserVsUser release];
             
             [self ReloadHtmlUserVsUser];
             
         }
         
     }];
}


- (void) ReloadHtmlRecentChallenges
{
    
	if (webViewRecentChallenges != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoadRecentChallenges];
        [pageToLoad appendString:pageMiddleToLoadRecentChallenges];
        [pageToLoad appendString:pageEndToLoadRecentChallenges];
        
		[webViewRecentChallenges loadHTMLString:pageToLoad baseURL:nil];
    }
}

- (void) ReloadHtmlUserVsUser
{
    
	if (webViewUserVsUser != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoadUserVsUser];
        [pageToLoad appendString:pageMiddleToLoadUserVsUser];
        [pageToLoad appendString:pageEndToLoadUserVsUser];
        
		[webViewUserVsUser loadHTMLString:pageToLoad baseURL:nil];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
