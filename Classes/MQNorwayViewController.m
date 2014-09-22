//
//  MQNorwayViewController.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "MQNorwayViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Answer.h"
#import "GlobalSettingsHelper.h"
#import "LocationsHelper.h"
#import  "SqliteHelper.h"
#import "EnumHelper.h"
#import <stdio.h>
#import "ChallengeQuestionItem.h"
#import "GlobalConstants.h"

#define ZOOM_VIEW_TAG 100
#define ZOOM_STEP 1.5

#define TILESIZE 256
#define THUMB_HEIGHT 150
#define THUMB_V_PADDING 10
#define THUMB_H_PADDING 10
#define CREDIT_LABEL_HEIGHT 20

#define AUTOSCROLL_THRESHOLD 30



@interface MQNorwayViewController (ViewHandlingMethods)
//- (NSArray *)imageData;
@end

@interface MQNorwayViewController (AutoscrollingMethods)
- (void)autoscrollTimerFired:(NSTimer *)timer;
- (void)legalizeAutoscrollDistance;
- (float)autoscrollDistanceForProximityToEdge:(float)proximity;
@end

@interface MQNorwayViewController (UtilityMethods)
- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center;
@end

@implementation MQNorwayViewController


- (void)loadView {
	[super loadView];
	
    
    //only done once 
    
    if ([[GlobalHelper Instance] getStartFlag] == 0) 
    {
        
        if ([[[GlobalHelper Instance] ReadPlayerID] isEqualToString:@"empty"]) {
            createPlayerVC = [[CreatePlayerVC alloc] initWithNibName:@"CreatePlayerVC" bundle:NULL];
            [createPlayerVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [createPlayerVC.view setAlpha:1];
            [createPlayerVC setDelegate:self];
            [self.view addSubview:createPlayerVC.view];
        }
        else
           [self FirstLoad]; 
    }
    else
    {
        [self FirstLoad];
    }
}

//createPlayerVC delegate
-(void) cleanUpCreatePlayerVC
{
    [createPlayerVC.view removeFromSuperview];
	//[highscoreGlobalView dealloc];
	createPlayerVC = nil;
    
    [self FirstLoad];
}

-(void) FirstLoad
{
    ssb = [[SoapHelper alloc] init];
    //_?[ssb setDelegate:self];
    [ssb sendDeviceToken];
    //_?[self sendDeviceToken];
    
    [[GlobalHelper Instance] setStartFlag:1];
    

	//set default global values
	FMResultSet *resultsLanguage = [[SqliteHelper Instance] executeQuery:@"SELECT language FROM savestate"];
    [resultsLanguage next];
	if ([resultsLanguage hasAnotherRow]) {
		[[GlobalSettingsHelper Instance] SetLanguage:[EnumHelper stringToLanguage:[resultsLanguage stringForColumn:@"language"]]];	}
	else {
		[[GlobalSettingsHelper Instance] SetLanguage:english];
	}
	
    FMResultSet *resultsGlobalID = [[SqliteHelper Instance] executeQuery:@"SELECT playerID FROM globalID"];
    [resultsGlobalID next];
    if ([resultsGlobalID hasAnotherRow]) {
		[[GlobalSettingsHelper Instance] SetPlayerID:[resultsGlobalID stringForColumn:@"playerID"]];	}
	else {
		[[GlobalSettingsHelper Instance] SetPlayerID:@"tempID"];}
    
	[[GlobalSettingsHelper Instance] SetDistanceMeasurement:km];
	[[GlobalSettingsHelper Instance] SetDocumentsDirectory];
	documentsDir = [[[GlobalSettingsHelper Instance] GetDocumentsDirectory] retain];
	
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
	
    
	UIScreen *screen = [[UIScreen mainScreen] retain];
    [self.view setFrame:[screen applicationFrame]];
	
	m_restoreGameState = NO;
    
	
    if(mainMenuView == nil)
	{
		mainMenuView = [[MainMenuView alloc] initWithFrame:[[self view] bounds]];
		[mainMenuView setDelegate:self];
		mainMenuView.hidden = NO;
		[[self view] addSubview:mainMenuView];
	}
    [mainMenuView FadeIn];
	
	//_? add to germanyMQ view controller (remember also to remove from startnewgame method)
    
    //    UIImage *directionsImage = [[UIImage imageNamed:@"directions.png"] retain];
    //    CGRect directionsImageRect = CGRectMake(0.0,0.0, 50, 50);
    //	directionsTouchView = [[[DirectionsTouchImageView alloc] initWithFrame:directionsImageRect] retain];
    //	directionsTouchView.image = directionsImage;
    //	[self.view addSubview:directionsTouchView];
    //	directionsTouchView.center = CGPointMake([screen applicationFrame].size.width - 25, [screen applicationFrame].size.height - 44 - 25);
    //	[directionsImage release];
    //    
    //	
    //	
    //	
    //	infoBarBottom = [[InfoBarViewBottom alloc]initWithFrame:CGRectMake(0,440, 320, 40)];
    //	[infoBarBottom setDelegate:self];
    //	[[self view] addSubview:infoBarBottom];
    //	
    //	//set first question
    //	questionBarTop = [[QuestionBarViewTop alloc] initWithFrame:CGRectMake(0,0, 320, 40)];
    //	[questionBarTop setDelegate:self];
    //	[self.view addSubview:questionBarTop];
    //	[questionBarTop setAlpha:0];
    //	
    //	answerBarTop = [[AnswerBarViewTop alloc] initWithFrame:CGRectMake(0,0, 320, 50)];
    //	[self.view addSubview:answerBarTop];
    //	[answerBarTop setAlpha:0];
    //	
    //	[self setZoomScale:CGSizeMake(1800, 4500)];
    
    [screen release];
    
	//end new _2.0
}



-(void) LoadGameAndResume
{
	[[LocationsHelper Instance] ReInitQuestions];
	//[self LoadSubViews];
	
	FMResultSet *resultsSavestate = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM savestate"];
    [resultsSavestate next];
	//NSDictionary *dictionarySavestate = [resultsSavestate objectAtIndex:0];
	
	if(![[resultsSavestate stringForColumn:@"gameState"] isEqualToString:@"outOfGame"])
	{
		//game started
		//[mainMenuView setAlpha:0];
		
		m_gameRef = [[Game alloc] init] ;
		
		
		NSMutableArray *players = [[NSMutableArray alloc] init];
		FMResultSet *resultsPlayers = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM player"];
		
		NSInteger playerNumber = 1;
		while ([resultsPlayers next])
		{
			
			UIColor *tempColor = [UIColor redColor];
			if (playerNumber == 2) {
				tempColor = [UIColor greenColor];
			}
			else if(playerNumber == 3)
			{
				tempColor = [UIColor blueColor];
			}
			else if(playerNumber == 4)
			{
				tempColor = [UIColor whiteColor];
			}
			
			Player *tempPlayer = [[Player alloc] initWithName:[resultsPlayers stringForColumn:@"name"] andColor:tempColor andPlayerSymbol:[resultsPlayers stringForColumn:@"symbol"]];
			
			NSLog(@"THE VALUE OF gamepoint %@",[resultsPlayers stringForColumn:@"gamemarkerPoint"]);
			//Convert cgpoint string to real cgpoint value
			CGPoint storedGamePoint;
			NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
			NSString *tempString = [NSString stringWithFormat:@"%@",[[resultsPlayers stringForColumn:@"gamemarkerPoint"] stringByTrimmingCharactersInSet:characterSet]];
			NSArray *simpleSplitArray = [tempString componentsSeparatedByString:@","];
			if (simpleSplitArray.count == 2) {
				storedGamePoint = CGPointMake([[simpleSplitArray objectAtIndex:0] intValue], [[simpleSplitArray objectAtIndex:1] intValue]);
			}
			
			
			NSLog(@"WHAT VALUE : %@", [resultsPlayers stringForColumn:@"secondsUsed"]);
			
			[tempPlayer SetPlayerState_Score:[[resultsPlayers stringForColumn:@"score"] integerValue]
							 QuestionsPassed:[[resultsPlayers stringForColumn:@"questionsPassed"] integerValue]
								   GamePoint:storedGamePoint
									  KmLeft:[[resultsPlayers stringForColumn:@"distanceLeft"] integerValue]
									TimeUsed:[[resultsPlayers stringForColumn:@"secondsUsed"] integerValue]
							   TotalDistance:[[resultsPlayers stringForColumn:@"totalDistance"] integerValue]
										 Out:[[resultsPlayers stringForColumn:@"isOut"] boolValue]
									BarWidth:[[resultsPlayers stringForColumn:@"barWidth"] integerValue]];
			//Question *quest = [[[Question alloc] initWithLocation:tempLocation andID:[dictionaryPlayer objectForKey:@"questionID"]];
			[players addObject:tempPlayer];
			playerNumber++;
		}
		[resultsPlayers close];
		
		BOOL isMultiplayers = NO;
		if (players.count > 1) {
			isMultiplayers = YES;
		}
		
		[m_gameRef SetPlayers:players andDifficulty:[EnumHelper stringToDifficulty:[resultsSavestate stringForColumn:@"difficulty"]] andMultiplayers:isMultiplayers
				  andGameType:[EnumHelper stringToGametype:[resultsSavestate stringForColumn:@"gameType"]] andNumberOfQuestions: [[resultsSavestate stringForColumn:@"numberOfQuestions"]integerValue] ];
		
		
		
		NSLog(@"loading game with question %@",[resultsSavestate stringForColumn:@"questionID"] ); //@"qs00_Munchen"
		[m_gameRef SetGameState_QuestionID:[resultsSavestate stringForColumn:@"questionID"] Difficulty:[EnumHelper stringToDifficulty:[resultsSavestate stringForColumn:@"difficulty"]]
					   currentPlayerByName:[resultsSavestate stringForColumn:@"playerRefTurn"] questionsPassed:[[resultsSavestate stringForColumn:@"gameQuestionsPassed"]integerValue]];
		
		Player *currentPlayer = [m_gameRef GetPlayerByName:[resultsSavestate stringForColumn:@"playerRefTurn"]];
		//[m_gameRef SetNextQuestion];
		
		//imageScrollView.hidden = YES;
		//current player shown with StartPlayerView
		UIScreen *screen = [[UIScreen mainScreen] retain];
		if ([[resultsSavestate stringForColumn:@"gameState"] isEqualToString:@"inGame"]) {
			m_restoreGameState = NO;
			
			[currentPlayer StartTimer];
			
			//[withFiguresView setAlpha:1];
			resultBoardView.hidden = YES;
			playingBoardView.hidden = NO;
			
			[resultBoardView setGameRef:m_gameRef];
			
			[questionBarTop SetQuestion:[resultsSavestate stringForColumn:@"playerRefTurn"] gameRef:m_gameRef];
			
			[infoBarBottom SetGameRef:m_gameRef];
			NSInteger playerIndex = 0;
            resultsPlayers = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM player"];
			while ([resultsPlayers next])
			{
				[[players objectAtIndex:playerIndex] SetBarWidth:[[resultsPlayers stringForColumn:@"barWidth"] integerValue]];
				playerIndex++;
			}
			
			//_?12
			directionsTouchView.center = CGPointMake([screen applicationFrame].size.width - 25, [screen applicationFrame].size.height - 44 - 25);
			
			UIImage *image = [[UIImage imageNamed:[currentPlayer GetPlayerSymbol]] retain];
			touchImageView.image = image;
			[image release];
			
			
			
			[self FadeInGameElements];
		}
		else if([[resultsSavestate stringForColumn:@"gameState"] isEqualToString:@"showResult"])
		{
			m_restoreGameState = YES;
			//[self FadeInGameElements];
			//[withFiguresView setAlpha:1];
			resultBoardView.hidden = NO;
			playingBoardView.hidden = YES;
			
			[resultBoardView setGameRef:m_gameRef];
			[resultBoardView drawResult_UpdateGameData:NO];
			[resultBoardView setNeedsDisplay];
			
			[answerBarTop SetResult:m_gameRef];
			[answerBarTop FadeIn];
			
			[infoBarBottom SetGameRef:m_gameRef];
			NSInteger playerIndex = 0;
            resultsPlayers = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM player"];
			while ([resultsPlayers next])
			{
				//			NSLog(@"---%d",[dictionaryPlayer objectForKey:@"barWidth"]);
				[[players objectAtIndex:playerIndex] SetBarWidth:[[resultsPlayers stringForColumn:@"barWidth"] integerValue]];
				playerIndex++;
			}
			
			//_?12
			directionsTouchView.center = CGPointMake([screen applicationFrame].size.width - 25, [screen applicationFrame].size.height - 44 - 25);
			
			//_?12
			UIImage *image = [[UIImage imageNamed:[currentPlayer GetPlayerSymbol]] retain];
			touchImageView.image = image;
			[image release];
			
		}
		//_?12
		touchImageView.center = CGPointMake([screen applicationFrame].size.width/2, [screen applicationFrame].size.height/2);
		[screen release];
		
	}
}


-(void) SaveGameData
{
	if (m_gameRef != nil) 
		[m_gameRef SaveGame];
	
	//[self UnLoadViews];
}



-(void) UnLoadViews
{
	NSLog(@"subviews Count=%d",[[[self view] subviews]count]);
	NSInteger index = 1;
	for(UIView *subview in [[self view] subviews]) {
        NSLog(@"remove subview %d",index++);
        //[subview release];
		[subview removeFromSuperview];
	}
}

-(void) SetGameElementsForPlayer:(Player*) player
{

    //restart clock
//    if (clockView != nil) {
//        clockView = [[ClockView alloc] init];
//        //[clockView setDelegate:self];
//        [[self view] addSubview:clockView];
//    }
//    [clockView StartClock];
//    
//   
//    if (hintButton == nil) {
//        hintButton = [[HintButtonView alloc] init];
//        [hintButton setDelegate:self];
//        [[self view] addSubview:hintButton];
//    }
     
    
}

-(void) RemoveGameElementsForPlayer
{
    //only remove clock after points animation done
    
    
    
    if ([m_gameRef IsTrainingMode] == NO) {
        if ([m_gameRef IsMultiplayer] == NO) {
            [clockView stop];
            [self AnimateAndGiveTimePoints];
            //in singleplayer, dont remove clock before message of timebonus is shown
        }
        else
        {
            [clockView stop];
            //[self AnimateAndGiveTimePoints];
            [self GiveTimePoints];
            [clockView removeFromSuperview];
            clockView = nil;
        }
    }
          

    
    [quitButton removeFromSuperview];
    quitButton = nil;
    
    [hintButton removeFromSuperview];
    hintButton = nil;
    
    [passButton removeFromSuperview];
    passButton = nil;
}

-(void) SetPlayerButtons
{
    if ([m_gameRef IsTrainingMode] == NO) {
		
        
        
        if (quitButton == nil) {
            quitButton = [[QuitButtonView alloc] init];
            [quitButton IsMultiplayer:[m_gameRef IsMultiplayer]];
            [quitButton setDelegate:self];
            [[self view] addSubview:quitButton];
        }
        
        Player *player = [[m_gameRef GetPlayer] retain];
        if([player GetHintsLeft] > 0)
        {
            if (hintButton == nil) {
                hintButton = [[HintButtonView alloc] init];
                [hintButton setDelegate:self];
                [[self view] addSubview:hintButton];
            }
            
            [hintButton SetTimesLeft:[player GetHintsLeft]];
            [hintButton SetHint:[[m_gameRef GetQuestion] GetHintString]];
        }
		
        if([player GetPassesLeft] > 0)
        {
            if ([m_gameRef IsMultiplayer] == NO) {
                if (passButton == nil) {
                    passButton = [[PassButtonView alloc] init];
                    [passButton setDelegate:self];
                    [[self view] addSubview:passButton];
                }
                [passButton SetTimesLeft:[player GetPassesLeft]];
            }

        }
        
        [player release];
    }
    
    
    
}

-(void) SetPlayerClock
{
    if ([m_gameRef IsTrainingMode] == NO) {
        if (clockView == nil) {
            clockView = [[ClockView alloc] init];
            //[clockView setDelegate:self];
            [[self view] addSubview:clockView];
        }
        [clockView StartClock];
    }

}

-(void) AnimateAndGiveTimePoints
{
    if([clockView GetMultiplier] > 0)
    {
        UIScreen *screen = [[UIScreen mainScreen] retain];
        timePointsLabel = [[UILabel alloc] init];
        [timePointsLabel setFrame:CGRectMake(0, 0, 250, 20)];
        timePointsLabel.center = CGPointMake([screen applicationFrame].size.width /2 , ([screen applicationFrame].size.height /2) -100 );
        timePointsLabel.backgroundColor = [UIColor clearColor]; 
        [timePointsLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        timePointsLabel.textAlignment = NSTextAlignmentCenter;
        timePointsLabel.shadowColor = [UIColor whiteColor];
        timePointsLabel.shadowOffset = CGSizeMake(-1,-2);
        timePointsLabel.text = [NSString stringWithFormat:@"%d x %d %@ %@",[clockView GetMultiplier],
                                [[GlobalSettingsHelper Instance] ConvertToRightDistance:20],
                                [[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                                [[GlobalSettingsHelper Instance] GetStringByLanguage:@"timebonus"]];
        [[self view] addSubview:timePointsLabel];
        [screen release];

        [self GiveTimePoints];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.5];
        //[UIView setAnimationDelegate:self];
        //[UIView setAnimationDidStopSelector:@selector(timePointsShown)];
        [timePointsLabel setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
        [clockView setTransform:CGAffineTransformMakeScale(1.2f, 1.2f)];
    //	[timePointsLabel setAlpha:0.0f];
    //    [clockView setAlpha:0.0f];
        [UIView commitAnimations];
    }
}

-(void) GiveTimePoints
{
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer SetCurrentKmTimeBonus:[clockView GetMultiplier] * const_timeBonusKm];
    [currentPlayer SetCurrentTimeMultiplier:[clockView GetMultiplier]];
    [currentPlayer release]; 
}

//-(void) timePointsShown
//{
//    [timePointsLabel removeFromSuperview];
//    timePointsLabel = nil;
//    [clockView removeFromSuperview];
//    clockView = nil;
//}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	[[SqliteHelper Instance]  executeUpdate:@"DELETE FROM savestate;"];
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [playingBoardView release];
    [slideUpView release];
    [thumbScrollView release];
    [super dealloc];
}


#pragma mark TiledScrollViewDataSource method

- (UIView *)tiledScrollView:(TiledScrollView *)tiledScrollView tileForRow:(int)row column:(int)column resolution:(int)resolution {
	
    // re-use a tile rather than creating a new one, if possible
    UIImageView *tile = (UIImageView *)[tiledScrollView dequeueReusableTile];
	
    if (!tile) {
        // the scroll view will handle setting the tile's frame, so we don't have to worry about it
        tile = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease]; 
		
        // Some of the tiles won't be completely filled, because they're on the right or bottom edge.
        // By default, the image would be stretched to fill the frame of the image view, but we don't
        // want this. Setting the content mode to "top left" ensures that the images around the edge are
        // positioned properly in their tiles. 
        [tile setContentMode:UIViewContentModeTopLeft]; 
    }
    
    // The resolution is stored as a power of 2, so -1 means 50%, -2 means 25%, and 0 means 100%.
    // We've named the tiles things like BlackLagoon_50_0_2.png, where the 50 represents 50% resolution.
    resolutionPercentage = 100 * pow(2, resolution);
	[tile setImage:[UIImage imageNamed:[NSString stringWithFormat:@"world_%d_%d_%d.jpg", resolutionPercentage, column, row]]];

    return tile;
}

#pragma mark TapDetectingViewDelegate 

- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint {

	[touchImageView setTransform:CGAffineTransformMakeScale(3, 3)];
	touchImageView.center = tapPoint;
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	CGAffineTransform implode = CGAffineTransformMakeScale(1, 1);
	[touchImageView setTransform:implode];
	[UIView setAnimationDidStopSelector:@selector(movedArrowDone)];
	[UIView commitAnimations];	
}

-(void) positionPlayerSymbol:(CGPoint)thePoint zoomOffsetScale:(float) zoomOffsetScale
{
	
	CGPoint currentLoc = touchImageView.center;
	
	//	currentLoc.x = currentLoc.x - thePoint.x;
	//	currentLoc.y = currentLoc.y - thePoint.y;
	//update current point
	if (zoomOffsetScale != 0.0f)
	{

	}
	else {
		//set new value
		touchImageView.center = CGPointMake(currentLoc.x - thePoint.x,currentLoc.y - thePoint.y);
	}
	
}

#pragma mark TouchImageViewDelegate

-(void)updateLoope
{
	
	if(loop == nil){
		loop = [[MagnifierView alloc] initWithFrame:[self view].bounds];
		loop.viewref = playingBoardView;
		[loop setAlpha:0];
	}
    [loop setClocViewRef:clockView];
	
	//new _2.0
	[loop setPlayerSymbol:[[m_gameRef GetPlayer] GetPlayerSymbol]];
	
	//CGPoint  tempLoopPosition = loop.center;
	//loop.lastPosition = loop.center;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(updateLoopeAnimationDone)];
	
	
	[[self view] addSubview:loop];
	
	[UIView setAnimationDuration:0.3];
	//[touchImageView setTransform:CGAffineTransformIdentity];
	[loop setAlpha:1];
	
	
	//[loop setPlacement];
	
	//	if (loop.isPositionedLeft == YES) {
	//		if (loop.touchPoint.x < 100 && loop.touchPoint.y < 170 ) {
	//			loop.center = CGPointMake(loop.center.x + 220 , loop.center.y);
	//			//loop.isPositionedLeft = NO;
	//		}
	//	}
	//	else {
	//		if (loop.touchPoint.x > 220 && loop.touchPoint.y < 170 ) {
	//			//loop.loopLocation = CGPointMake(50, 130);
	//			loop.center = CGPointMake(loop.center.x - 220 , loop.center.y);
	//			loop.isPositionedLeft = YES;
	//		}
	//	}
	[UIView commitAnimations];	
	
	
	//	loop.center = tempLoopPosition;
	loop.touchPoint = touchImageView.center;//[touch locationInView:self];
	
	//start in new thread
	[loop setNeedsDisplay];
	
	//[NSThread detachNewThreadSelector:@selector(startTheBackgroundJob) toTarget:self withObject:nil];
}

//- (void)startTheBackgroundJob {  
//	
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];  
//    // wait for 3 seconds before starting the thread, you don't have to do that. This is just an example how to stop the NSThread for some time  
//    //[NSThread sleepForTimeInterval:3];  
//    [self performSelectorOnMainThread:@selector(makeMyProgressBarMoving) withObject:nil waitUntilDone:NO];  
//    [pool release];  
//	
//} 
//
//- (void)makeMyProgressBarMoving {  
//	
//	[loop setNeedsDisplay];
//	
//} 

//-(void) updateLoopeAnimationDone
//{
//	loop.center = loop.lastPosition;
//	loop.touchPoint = touchImageView.center;//[touch locationInView:self];
//	[loop setNeedsDisplay];
//}

-(void) closeLoope
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	//[touchImageView setTransform:CGAffineTransformIdentity];
	[loop setAlpha:0];
	//[UIView SetAnimationCurve:
	[UIView setAnimationDidStopSelector:@selector(releaseLoop)];
	[UIView commitAnimations];	
	//	[loop removeFromSuperview];
	//	[loop release];
	//	loop = nil;	
}

-(void) releaseLoop
{
	[loop releaseCachedImage];
	//	[loop removeFromSuperview];
	//	[loop release];
	//	loop = nil;	
}


-(void) hideInfoBar
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	infoBarBottom.center = CGPointMake(infoBarBottom.center.x, [screen applicationFrame].size.height + infoBarBottom.frame.size.height/2);
	[UIView commitAnimations];	
	[screen release];
}

-(void) showInfoBar
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	infoBarBottom.center = CGPointMake(infoBarBottom.center.x, [screen applicationFrame].size.height - infoBarBottom.frame.size.height/2);
	[UIView commitAnimations];	
	[screen release];
}

-(void) hideQuestionBar
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	questionBarTop.center = CGPointMake(questionBarTop.center.x,  - questionBarTop.frame.size.height/2);
	[UIView commitAnimations];	
	[screen release];
}

-(void) showQuestionBar
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	questionBarTop.center = CGPointMake(questionBarTop.center.x, questionBarTop.frame.size.height/2);
	[UIView commitAnimations];	
	[screen release];
}

-(void) hideQuitButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	quitButton.center = CGPointMake(-quitButton.frame.size.width/2, quitButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

-(void) showQuitButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	quitButton.center = CGPointMake(20, quitButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

-(void) hideHintButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	hintButton.center = CGPointMake(-hintButton.frame.size.width/2, hintButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

-(void) showHintButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	hintButton.center = CGPointMake(20, hintButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

-(void) hidePassButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	passButton.center = CGPointMake(-passButton.frame.size.width/2, passButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

-(void) showPassButton
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	passButton.center = CGPointMake(20, passButton.center.y);
	[UIView commitAnimations];	
	[screen release];
}

#pragma mark RoundEndedViewDelegate
-(void) FinishedShowinRoundEndedView
{
    [m_roundEndedView removeFromSuperview];
    m_roundEndedView = nil;
	
	if ([m_gameRef GetGameType] == mostPoints) {
		[infoBarBottom setNeedsDisplay];
	}
	
	[self StartNextRound];
}
#pragma mark StartPlayerViewDelegate
- (void)StartPlayer
{
    if (m_startPlayerView != nil) {
        [m_startPlayerView removeFromSuperview];
        m_startPlayerView = nil;
    }
    //in case firstTimeIstruction
    if (firstTimeInstructionsView != nil) {
        [firstTimeInstructionsView removeFromSuperview];
        firstTimeInstructionsView = nil;
    }

    [self SetPlayerButtons];
    [self SetPlayerClock];
	[questionBarTop SetQuestion:[[m_gameRef GetPlayer] GetName] gameRef:m_gameRef];
	[self FadeInGameElements];
	
	
	//get player and starttime
	Player *player = [[m_gameRef GetPlayer] retain];
	[player StartTimer];
	[player release];
}

#pragma mark QuestionBarViewTopDelegate
-(void) HideGameIcons
{
	[touchImageView setAlpha:0];
	[directionsTouchView setAlpha:0];
}

-(void) ShowGameIcons
{
	[touchImageView setAlpha:1];
	[directionsTouchView setAlpha:1];
}


#pragma mark InfoBarBottomViewDelegate
-(void) FinishedAnimating
{
   
	resultBoardView.userInteractionEnabled = YES;
}

#pragma mark WithFiguresViewDelegate

//start next round
- (void)finishedShowingResultMap{		
    
    if(clockView != nil)
    {
        [clockView removeFromSuperview];
        clockView = nil;
    }
    if(timePointsLabel != nil)
    {
        [timePointsLabel removeFromSuperview];
        timePointsLabel = nil;
    }
    
    [m_animTextView removeFromSuperview];
    m_animTextView = nil;
    
	if ([m_gameRef GetGameType] == lastStanding) {
        


		NSMutableArray *players = [[m_gameRef GetPlayers] retain];
		for (Player *player in players) 
		{
            //add bonus to kmleft
            [player SetKmLeft:[player GetKmLeft] + [player GetCurrentKmTimeBonus]];
            //reset timebonus
            [player SetCurrentKmTimeBonus:0];
            [player SetCurrentTimeMultiplier:0];
            [player SetTimeBonusBarWidth:0];
            
			if ([player IsOut] == NO ) {
				int kmLeft = [player GetKmLeft];
				
				if (kmLeft <= 0) {
					[player SetOut:YES];
				}
			}
		}
		[players release];
        
        //draw bars without showing timebonus
        //____?? DRAW BARS WITHOUT TIMEBONUS
        [infoBarBottom DrawBarsOnce];
        
	}

	
	
	if (([[m_gameRef GetPlayer] IsOut] == YES) || ([[m_gameRef GetPlayer] HasGivenUp] == YES)) {
        
        [m_gameRef SetNextPlayer];
		
        
        Player *nextPlayer = [[m_gameRef GetPlayer] retain];
        [self SetGameElementsForPlayer:nextPlayer];
		
		if ([m_gameRef IsMultiplayer] == YES) 
		{	
			UIScreen *screen = [[UIScreen mainScreen] retain];
			touchImageView.center = CGPointMake([screen applicationFrame].size.width/2, [screen applicationFrame].size.height/2);
			[screen release];
		}
		
		

		NSString *playerName = [[nextPlayer GetName] retain];
		
		
		NSString *playerSymbol = [[nextPlayer GetPlayerSymbol] retain];
		UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
		touchImageView.image = image;
		[image release];
		[playerSymbol release];
		

		[playerName release];
		[nextPlayer release];		
	}

	[answerBarTop FadeOut];
	[self FadeOutGameElements];
	if ([m_gameRef IsMultiplayer] == YES) 
	{
		if (m_roundEndedView == nil) {
			m_roundEndedView = [[RoundEndedView alloc] initWithFrame:[[self view] bounds]];
			[m_roundEndedView setDelegate:self];
			[[self view] addSubview:m_roundEndedView];
		}
		[m_roundEndedView SetRoundResults:m_gameRef];
	}
	else
	{
		[self StartNextRound];
	}
}


//round is finished
- (void)finishedDrawingResultMap
{
	
	[m_gameRef SetPlayerPositionsByScore];
	
	if (m_animTextView == nil) {
		m_animTextView = [[AnimateTextView alloc] initWithFrame:[[self view] bounds]];
		[m_animTextView setDelegate:self];
		[[self view] addSubview:m_animTextView];
	}
	
	if ([m_gameRef IsMultiplayer] == NO) {

		Player *currentPlayer = [[m_gameRef GetPlayer] retain];
        
        //add question for challenge 
        ChallengeQuestionItem* newQuestion = [[[ChallengeQuestionItem alloc] init] autorelease];
        newQuestion.qid = [[m_gameRef GetQuestion] GetID];
        newQuestion.kmLeft = [currentPlayer GetKmLeft];   //[currentPlayer GetLastDistanceFromDestination ];
        newQuestion.kmTimeBonus = [currentPlayer GetCurrentKmTimeBonus];
        newQuestion.answered = 1;
        NSLog(@"Question values %@ %d %d %d", newQuestion.qid,newQuestion.kmLeft,newQuestion.kmTimeBonus,newQuestion.answered);
        [m_gameRef.challenge addQuestion:newQuestion];        
        
        
		[questionBarTop FadeOut];
		
		
		m_animTextView.hidden = NO;
		[m_animTextView setText:[currentPlayer GetPepTalk]];
		[m_animTextView startTextAnimation];

		[currentPlayer release];
		
	}
	else {
		m_animTextView.hidden = NO;
		[m_animTextView startTapMessage];
	}
	
	
	if ([m_gameRef IsTrainingMode] == YES) {
		//[infoBarBottom SetTrainingText];
		[infoBarBottom UpdateTrainingText];
	}
	else 
	{		
		if ([m_gameRef GetGameType] == lastStanding )  {
			if (m_restoreGameState)
			{
				m_restoreGameState = NO;
				[infoBarBottom SetBars];
			}
			else
			{	
				
				[infoBarBottom UpdateBars];
			}
		}
		else {

			//set points for players
			NSMutableArray *players = [[m_gameRef GetPlayers] retain];
            
            
            //if player has given up , no points should be given
            NSInteger playersLeft = 0;
            for (Player *player in players)  {
                if([player HasGivenUp] == NO)
                    playersLeft++;
                else{
                    [player ResetScore];
                    [player SetLastDistanceFromDestination:9999];
                }
            }
            [m_gameRef SetPlayersLeft:playersLeft];
            
            
            
			NSInteger correctPlayers = 0;
			switch ([players count]) {
				case 2:
					//check if both correct
					if ([m_gameRef GetCorrectAnswersAndSetScore:10] == 0) {
						[m_gameRef FirstPlaceSetScore:10];
						[m_gameRef SecondPlaceSetScore:0];
					}
					
					break;
				case 3:
					correctPlayers = [m_gameRef GetCorrectAnswersAndSetScore:20];
					if (correctPlayers == 0) {
						[m_gameRef FirstPlaceSetScore:20];
						[m_gameRef SecondPlaceSetScore:10];
						[m_gameRef ThirdPlaceSetScore:0];
					}
					else if(correctPlayers == 1) {
						[m_gameRef SecondPlaceSetScore:10];
						[m_gameRef ThirdPlaceSetScore:0];
					}
					else if(correctPlayers == 2) {
						[m_gameRef ThirdPlaceSetScore:0];
					}
					
					
					break;
				case 4:
					correctPlayers = [m_gameRef GetCorrectAnswersAndSetScore:3];
					if (correctPlayers == 0) {
						[m_gameRef FirstPlaceSetScore:30];
						[m_gameRef SecondPlaceSetScore:20];
						[m_gameRef ThirdPlaceSetScore:10];
						[m_gameRef FourthPlaceSetScore:0];
					}
					else if(correctPlayers == 1) {
						[m_gameRef SecondPlaceSetScore:20];
						[m_gameRef ThirdPlaceSetScore:10];
						[m_gameRef FourthPlaceSetScore:0];
					}
					else if(correctPlayers == 2) {
						[m_gameRef ThirdPlaceSetScore:10];
						[m_gameRef FourthPlaceSetScore:0];
					}
					
					break;
				default:
					break;
			}
			
			
            //[m_gameRef SetTimeBonusPoints];
            //[m_gameRef IncreaseScoresWithRoundScores];
            
			
			[infoBarBottom UpdatePoints];
			
			
			[players release];
			
		}
	}
	
	[answerBarTop SetResult:m_gameRef];
	
	[infoBarBottom FadeIn];
	[self.view bringSubviewToFront:m_animTextView];
	[self.view bringSubviewToFront:answerBarTop];
}


#pragma mark RestartViewDelegate
-(void) RestartGame
{
	[m_gameRef ResetPlayerData];
	[m_gameRef ResetGameData];
	if ([m_gameRef IsTrainingMode] == NO) {
		[[LocationsHelper Instance] ShuffleQuestions];
	}

	[self ZoomOutMap];
	
	[infoBarBottom setNeedsDisplay];
	
	//Next player
	Player *firstPlayer = [[m_gameRef GetPlayer] retain]; 
	NSString *currentPlayerName = [[firstPlayer GetName] retain];
	//new 2.0
	[firstPlayer StartTimer];
	
	[questionBarTop SetQuestion:currentPlayerName gameRef:m_gameRef];
	
	[infoBarBottom ResetPlayersLeft];
	
	if ([m_gameRef IsTrainingMode] == NO) {
		if(m_startPlayerView == nil)
		{
			m_startPlayerView = [[StartPlayerView alloc] initWithFrame:[[self view] bounds]];
			[m_startPlayerView setDelegate:self];
			[[self view] addSubview:m_startPlayerView];
		}
		[m_startPlayerView SetPlayerRef:firstPlayer gameRef:m_gameRef];
		[[self view] bringSubviewToFront:m_startPlayerView];
		[m_startPlayerView FadeIn];
	}
	else {
		[m_gameRef ResetTrainingValues];
		[infoBarBottom SetTrainingText];
		[self StartPlayer];
	}
	
	[currentPlayerName release];
	[firstPlayer release];
}

-(void) DisplayMainMenu
{
    
	//[self FadeOutGameElements];
	
    [self RemoveGameBoardAndBars];
	
	if(mainMenuView == nil)
	{
		mainMenuView = [[MainMenuView alloc] initWithFrame:[[self view] bounds]];
		[mainMenuView setDelegate:self];
		//mainMenuView.hidden = NO;
		[[self view] addSubview:mainMenuView];
	}

    [mainMenuView FadeIn];
}


#pragma mark GameEndedViewDelegate
-(void) GameOver
{
    //clean up GamesEndedView
    [m_gameEndedView removeFromSuperview];
    m_gameEndedView = nil;
    
	[self DisplayReplayGameMenu];
	if (m_restartView == nil) {
		m_restartView = [[RestartView alloc] initWithFrame:[[self view] bounds]];
		[m_restartView setDelegate:self];
		[[self view] addSubview:m_restartView];
	}
    [[self view] bringSubviewToFront:m_restartView];
	[m_restartView FadeIn];
}

-(void) LoadGameBoardAndBars
{
    playingBoardView = [[TiledScrollView alloc] initWithFrame:[[self view] bounds]];
    [playingBoardView setDataSource:self];
    [[playingBoardView tileContainerView] setDelegate:self];
    [playingBoardView setTileSize:CGSizeMake(TILESIZE, TILESIZE)];
    [playingBoardView setBackgroundColor:[UIColor blackColor]];
    [playingBoardView setBouncesZoom:YES];
    [playingBoardView setMaximumResolution:0];
	[playingBoardView setMinimumResolution:-2];
    [[self view] addSubview:playingBoardView];
    
	//game board result view
	resultBoardView = [[WithFiguresView alloc] initWithFrame:[[self view] bounds]];
	//must allways be sat together, oposite of eachother
	resultBoardView.hidden = YES;
	playingBoardView.hidden = NO;
	transitioning = NO;
	[resultBoardView setDelegate:self];
	[[self view] addSubview:resultBoardView];
    
    UIScreen *screen = [[UIScreen mainScreen] retain];
    /*UIImage *directionsImage = [[UIImage imageNamed:@"directions.png"] retain];
    CGRect directionsImageRect = CGRectMake(0.0,0.0, 50, 50);
	directionsTouchView = [[[DirectionsTouchImageView alloc] initWithFrame:directionsImageRect] retain];
	directionsTouchView.image = directionsImage;
	[self.view addSubview:directionsTouchView];
	directionsTouchView.center = CGPointMake([screen applicationFrame].size.width - 25, [screen applicationFrame].size.height - 44 - 25);
	[directionsImage release];*/
    
	[screen release];
    
//    if (touchImageView == nil) {
		touchImageView = [[[TouchImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50, 50)] retain];
		touchImageView.center = CGPointMake(160.0, 230.0);
		//[touchImageView setMapView:imageScrollView];
		[touchImageView setDelegate:self];
		[self.view addSubview:touchImageView];
//	}

	infoBarBottom = [[InfoBarViewBottom alloc]initWithFrame:CGRectMake(0,0, 320, constInfobarBottomHeight)];
    infoBarBottom.center = CGPointMake(infoBarBottom.center.x, [screen applicationFrame].size.height - infoBarBottom.frame.size.height/2);
	[infoBarBottom setDelegate:self];
	[[self view] addSubview:infoBarBottom];
	
	//set first question
	questionBarTop = [[QuestionBarViewTop alloc] initWithFrame:CGRectMake(0,0, 320, 40)];
	[questionBarTop setDelegate:self];
	[self.view addSubview:questionBarTop];
	[questionBarTop setAlpha:0];
	
	answerBarTop = [[AnswerBarViewTop alloc] initWithFrame:CGRectMake(0,0, 320, 50)];
	[self.view addSubview:answerBarTop];
	[answerBarTop setAlpha:0];
	
	//[self setZoomScale:CGSizeMake(1800, 4500)];
    [self setZoomScale:CGSizeMake(4444, 3040)];
}

-(void) RemoveGameBoardAndBars
{
    [playingBoardView release];
    [playingBoardView removeFromSuperview];
    playingBoardView = nil;
    [resultBoardView release];
    [resultBoardView removeFromSuperview];
    resultBoardView = nil;
    [directionsTouchView release];
    [directionsTouchView removeFromSuperview];
    directionsTouchView = nil;
    [infoBarBottom release];
    [infoBarBottom removeFromSuperview];
    infoBarBottom = nil;
    [questionBarTop release];
    [questionBarTop removeFromSuperview];
    questionBarTop = nil;
    [answerBarTop release];
    [answerBarTop removeFromSuperview];
    answerBarTop = nil;
    [touchImageView release];
    [touchImageView removeFromSuperview];
    touchImageView = nil;
    
}


#pragma mark GameMenuDelegate

-(void) PreStartNewGame:(Game*) gameRef
{
    [self LoadGameBoardAndBars];

    [mainMenuView removeFromSuperview];
    mainMenuView = nil;
    
	[m_gameRef ResetPlayerData];
	
	[self ZoomOutMap];
	
	m_gameRef = gameRef;
	Player *firstPlayer = [[m_gameRef GetPlayer] retain];
	NSString *currentPlayerName = [[firstPlayer GetName] retain];
	
	if(firstTimeInstructionsView == nil)
	{
		firstTimeInstructionsView = [[FirstTimeInstructionsView alloc] initWithFrame:[[self view] bounds]];
		[firstTimeInstructionsView setAlpha:0];
		[firstTimeInstructionsView setDelegate:self];
		[[self view] addSubview:firstTimeInstructionsView];
	}
	//show instructions
	[firstTimeInstructionsView SetPlayer:currentPlayerName];
	[[self view] bringSubviewToFront:firstTimeInstructionsView];
	BOOL firstTime = [firstTimeInstructionsView FadeIn];
	
    //if first time , startNEwGame will be called through firstTimeInstructions
	if (firstTime == NO) {
		[self StartNewGame];
	}
	
	[currentPlayerName release];
	[firstPlayer release];
}

//Begin game
- (void)StartNewGame
{
    if (firstTimeInstructionsView != nil) {
        [firstTimeInstructionsView removeFromSuperview];
        firstTimeInstructionsView = nil;
    }
    
	[m_gameRef ResetPlayerData];
	
	[self ZoomOutMap];

	//m_gameRef = gameRef;
	
	if ([m_gameRef IsTrainingMode] == NO) {
		[[LocationsHelper Instance] ShuffleQuestions];
	}
	else {
		[[LocationsHelper Instance] OrderQuestionsForTraining:[m_gameRef GetGameDifficulty]];
	}

	
	[resultBoardView setGameRef:m_gameRef];
	
    NSMutableArray *players = [[m_gameRef GetPlayers] retain];
    for (Player *player in players) 
    {
        [player SetCurrentKmTimeBonus:0];
    }
    [players release];
	//Next player
	Player *firstPlayer = [[m_gameRef GetPlayer] retain];
    //[firstPlayer SetCurrentKmTimeBonus:0];
	NSString *currentPlayerName = [[firstPlayer GetName] retain];
	//new 2.0
	[firstPlayer StartTimer];
	

	
	NSString *playerSymbol = [[firstPlayer GetPlayerSymbol] retain];
	UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
	touchImageView.image = image;
	[playerSymbol release];
	[image release];	
	
    [[self view] bringSubviewToFront:touchImageView];
	[[self view] bringSubviewToFront:infoBarBottom];
	[[self view] bringSubviewToFront:questionBarTop];
	[[self view] bringSubviewToFront:answerBarTop];
	
	[infoBarBottom SetGameRef:m_gameRef];
	
	//set first question
	[questionBarTop SetQuestion:currentPlayerName gameRef:m_gameRef];
	
	[self FadeOutGameElements];
	
	if ([m_gameRef IsTrainingMode] == NO) {
		
		
		if ([m_gameRef IsMultiplayer] == YES) {
			if(m_startPlayerView == nil)
			{
				m_startPlayerView = [[StartPlayerView alloc] initWithFrame:[[self view] bounds]];
				[m_startPlayerView setDelegate:self];
				[[self view] addSubview:m_startPlayerView];
			}
			[m_startPlayerView SetPlayerRef:firstPlayer gameRef:m_gameRef];
			[[self view] bringSubviewToFront:m_startPlayerView];
			[m_startPlayerView FadeIn];
		}
		else {
            //single player game
            
            //set up challenge
            m_gameRef.challenge.creator = [[GlobalSettingsHelper Instance] GetPlayerID];
            m_gameRef.challenge.kmToUse = const_startKmDistance;
            m_gameRef.challenge.difficulty = [m_gameRef GetGameDifficulty];
            
			[self StartPlayer];
		}

		
//		if(firstTimeInstructionsView == nil)
//		{
//			firstTimeInstructionsView = [[FirstTimeInstructionsView alloc] initWithFrame:[[self view] bounds]];
//			[firstTimeInstructionsView setAlpha:0];
//			[[self view] addSubview:firstTimeInstructionsView];
//		}
//		//show instructions
//		[firstTimeInstructionsView SetPlayer:currentPlayerName];
//		[[self view] bringSubviewToFront:firstTimeInstructionsView];
//		[firstTimeInstructionsView FadeIn];

		[m_gameRef SetGameState:inGame];
	}
	else {
		[m_gameRef ResetTrainingValues];
		[infoBarBottom SetTrainingText];
		[self StartPlayer];
	}

	
	[currentPlayerName release];
	[firstPlayer release];
}



-(void) StartNextRound
{
	Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer SetCurrentKmTimeBonus:0];
	NSString *playerName = [[currentPlayer GetName] retain];
	[questionBarTop setAlpha:0];
	
	BOOL gameFinished = NO;
	
	if ([m_gameRef SetNextQuestion] == NO) 
		gameFinished = YES;
	else
		[questionBarTop SetQuestion:playerName gameRef:m_gameRef];
	
	
	if ([m_gameRef IsMultiplayer] == NO) {
		NSMutableArray *players = [[m_gameRef GetPlayers] retain];
		Player *singlePlayer = [players objectAtIndex:0];
		if ([singlePlayer GetKmLeft] <= 0) {
			gameFinished = YES;
		}
		[players release];
		[singlePlayer release];	
	}
	else {
		if ([m_gameRef GetGameType] == mostPoints) {
            
            if ([m_gameRef GetPlayersLeft] <= 1) 
			{
				gameFinished = YES;
			}
            else
            {
                if ([m_gameRef GetQuestionsPassed] >= [m_gameRef GetNumberOfQuestions]){
                    BOOL OnePlayerAtTop = [m_gameRef IsOnePlayerAtTop];
                    if(OnePlayerAtTop == YES) {
                        gameFinished = YES;
                    }
                }
            }
		}
		//Laststanding
		else {
			
			if ([m_gameRef GetPlayersLeft] <= 1) 
			{
				gameFinished = YES;
			}
		}
	}
	
	if (gameFinished == NO) {
		if ([m_gameRef IsTrainingMode] == NO) {
			[m_gameRef SetGameState:inGame];
			//NEW _?
			if ([m_gameRef IsMultiplayer] == YES) {

				if(m_startPlayerView == nil)
				{
					m_startPlayerView = [[StartPlayerView alloc] initWithFrame:[[self view] bounds]];
					[m_startPlayerView setDelegate:self];
					[[self view] addSubview:m_startPlayerView];
				}
				[m_startPlayerView SetPlayerRef:currentPlayer gameRef:m_gameRef];
				[[self view] bringSubviewToFront:m_startPlayerView];
				[m_startPlayerView FadeIn];
			
			}
			else {
				[self StartPlayer];
			}
		}
		else {
			[infoBarBottom SetTrainingText];
			[self StartPlayer];
			//			[questionBarTop SetQuestion:[[m_gameRef GetPlayer] GetName] gameRef:m_gameRef];
			//			[self FadeInGameElements];
		}
	}
	else {

		[m_gameRef SetGameState:outOfGame];
		if ([m_gameRef IsTrainingMode] == NO) {
			if(m_gameEndedView == nil)
			{
				m_gameEndedView = [[GameEndedView alloc] initWithFrame:[[self view] bounds]];
				[m_gameEndedView setDelegate:self];
				[[self view] addSubview:m_gameEndedView];
			}
			[m_gameEndedView SetHeader:m_gameRef];
		}
		else {
			[self DisplayReplayGameMenu];
			if(m_trainingEndedView == nil)
			{
				m_trainingEndedView = [[TrainingEndedView alloc] initWithFrame:[[self view] bounds]];
				[m_trainingEndedView setDelegate:self];
				[m_trainingEndedView setAlpha:0];
				[m_trainingEndedView SetGameRef:m_gameRef];
				[[self view] addSubview:m_trainingEndedView];
			}
			[m_trainingEndedView FadeIn];
		}
		
	}
	
	
	[currentPlayer release];
	[playerName release];
	
	[self performTransition];
	
//    if (clockView == nil) {
//        clockView = [[ClockView alloc] init];
//        //[clockView setDelegate:self];
//        [[self view] addSubview:clockView];
//    }
//	[clockView StartClock];
}

#pragma mark QuitButtonViewDelegate
-(void) QuitGame
{

    [clockView removeFromSuperview];
    clockView = nil;
    [quitButton removeFromSuperview];
    quitButton = nil;
    [passButton removeFromSuperview];
    passButton = nil;
    [hintButton removeFromSuperview];
    hintButton = nil;
    
	[self DisplayMainMenu];
}

-(void) GiveUp
{
    //the current player gives up
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer GiveUp];
    [currentPlayer release];
    [self PlayerGaveUp]; 
}

#pragma mark HintButtonViewDelegate
-(void) UseHint
{
    //subtract hint from player 
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer HintUsed];
    [currentPlayer release];
}

#pragma mark PassButtonViewDelegate
-(void) PassQuestion
{
    //subtract pass from player
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer PassUsed];
    
    //if singleplayer game add question to challenge
    if([m_gameRef IsMultiplayer] == NO)
    {
        ChallengeQuestionItem* newQuestion = [[[ChallengeQuestionItem alloc] init] autorelease];
        newQuestion.qid = [[m_gameRef GetQuestion] GetID];
        newQuestion.kmLeft = [currentPlayer GetKmLeft]; 
        newQuestion.kmTimeBonus = 0;
        newQuestion.answered = 0;
        NSLog(@"Question values %@ %d %d %d", newQuestion.qid,newQuestion.kmLeft,newQuestion.kmTimeBonus,newQuestion.answered);
        [m_gameRef.challenge addQuestion:newQuestion];
    }
    [m_gameRef SetNextQuestion];
    [questionBarTop SetQuestion:[[m_gameRef GetPlayer] GetName] gameRef:m_gameRef];
    [currentPlayer release];
    
}


#pragma mark InfoBarViewBottomDelegate

-(void) PauseTraining
{
	if (m_pauseView == nil) {
		m_pauseView = [[PauseView alloc] initWithFrame:[[self view] bounds]];
		[m_pauseView setDelegate:self];
		m_pauseView.hidden = YES;
		[m_pauseView SetGameRef:m_gameRef];
		[[self view] addSubview:m_pauseView];
	}
	[[self view] bringSubviewToFront:m_pauseView];
	[m_pauseView FadeIn];
}

-(void)SetPositionDone
{
	@try {
		
        [self RemoveGameElementsForPlayer];

		
		[touchImageView setAlpha:0];
		
		CGRect  teeet = [touchImageView frame];
		CGPoint gamePoint = CGPointMake(teeet.origin.x + 25, teeet.origin.y + 25);
		
		//convert to reel map point
		CGRect imgScrollViewBounds = [playingBoardView bounds];
		CGPoint realMapGamePoint = CGPointMake(gamePoint.x + imgScrollViewBounds.origin.x, gamePoint.y + imgScrollViewBounds.origin.y); 
		//scale to tile 
		float imgScrollViewZoomScale = [playingBoardView zoomScale];
		realMapGamePoint.x = realMapGamePoint.x /imgScrollViewZoomScale ;
		realMapGamePoint.y = realMapGamePoint.y /imgScrollViewZoomScale ;
		//scale to map
		float resolutionFactor = (float)resolutionPercentage/100;
		realMapGamePoint.x = (float)realMapGamePoint.x/ resolutionFactor; 
		realMapGamePoint.y = realMapGamePoint.y/ resolutionFactor;
		//end convert reel map point
		
		
		Player *currentPlayer = [[m_gameRef GetPlayer] retain];
		[currentPlayer SetGamePoint:realMapGamePoint];
		
		[currentPlayer PauseTimer];
		
		
		BOOL showingResult = NO;
		if ([m_gameRef CurrentPlayerIsLast] == YES) 
		{
			showingResult = YES;
			
			//make game point into real map coordinates
			CGPoint realMapGamePoint;
			realMapGamePoint = CGPointMake(gamePoint.x + [playingBoardView bounds].origin.x, gamePoint.y + [playingBoardView bounds].origin.y); 
			//scale to tile 
			realMapGamePoint.x = realMapGamePoint.x /[playingBoardView zoomScale] ;
			realMapGamePoint.y = realMapGamePoint.y /[playingBoardView zoomScale] ;					   
			//scale to map
			realMapGamePoint.x = realMapGamePoint.x/ ((float)resolutionPercentage/100); 
			realMapGamePoint.y = realMapGamePoint.y/ ((float)resolutionPercentage/100);
			
			[currentPlayer SetGamePoint:realMapGamePoint];
			
			//_?12
			[touchImageView setAlpha:0];
			
			if ([m_gameRef IsTrainingMode] == NO) {
				[m_gameRef SetGameState:showResult];
			}
            //_TEST
            /*
			[self performTransition];
			
			[questionBarTop FadeOut];
			[answerBarTop FadeIn];
            [self FadeOutGameElements];*/
            //_END TEST
            
			[resultBoardView drawResult_UpdateGameData:YES];
            
			[self performTransition];
			
			[questionBarTop FadeOut];
			[answerBarTop FadeIn];
            
            
			
		}
		else {
			
			
			CGPoint realMapGamePoint;
			realMapGamePoint = CGPointMake(gamePoint.x + [playingBoardView bounds].origin.x, gamePoint.y + [playingBoardView bounds].origin.y); 
			//scale to tile 
			realMapGamePoint.x = realMapGamePoint.x /[playingBoardView zoomScale] ;
			realMapGamePoint.y = realMapGamePoint.y /[playingBoardView zoomScale] ;					   
			//scale to map
			realMapGamePoint.x = realMapGamePoint.x/ ((float)resolutionPercentage/100); 
			realMapGamePoint.y = realMapGamePoint.y/ ((float)resolutionPercentage/100);
			
			[currentPlayer SetGamePoint:realMapGamePoint]; 
			
			
		}
		
        //this is where we decide if the player should be played
        
		[m_gameRef SetNextPlayer];
		Player *nextPlayer = [[m_gameRef GetPlayer] retain];
        [nextPlayer SetCurrentTimeMultiplier:0];
        [self SetGameElementsForPlayer:nextPlayer];
		
		//		if ([m_gameRef IsTrainingMode] == NO) {
		//set the next player
		
		//check if last player is same as current player
		//showingResult = drawing map with results
		if ([m_gameRef IsMultiplayer] == YES && showingResult == NO) {
			if(m_startPlayerView == nil)
			{
				m_startPlayerView = [[StartPlayerView alloc] initWithFrame:[[self view] bounds]];
				[m_startPlayerView setDelegate:self];
				[[self view] addSubview:m_startPlayerView];
			}
			[m_startPlayerView SetPlayerRef:nextPlayer gameRef:m_gameRef];
			[[self view] bringSubviewToFront:m_startPlayerView];
			[m_startPlayerView FadeIn];
			
			if(firstTimeInstructionsView == nil)
			{
                //no delegate for this . A delegate would trigger the StartGame method
				firstTimeInstructionsView = [[FirstTimeInstructionsView alloc] initWithFrame:[[self view] bounds]];
				[firstTimeInstructionsView setAlpha:0];
				[[self view] addSubview:firstTimeInstructionsView];
			}
			[firstTimeInstructionsView SetPlayer:[nextPlayer GetName]];
			[[self view] bringSubviewToFront:firstTimeInstructionsView];
			[firstTimeInstructionsView FadeIn];
			
		}
		
		if ([m_gameRef IsMultiplayer] == YES) 
		{	
			[self ZoomOutMap];
			
			CGPoint gamepoint = [nextPlayer GetGamePoint];
			
			CGPoint scaledGamePoint;
			scaledGamePoint.x = gamepoint.x * 0.25;
			scaledGamePoint.y = gamepoint.y * 0.25;
			//scale to tile
			scaledGamePoint.x = scaledGamePoint.x * playingBoardView.zoomScale;
			scaledGamePoint.y = scaledGamePoint.y * playingBoardView.zoomScale;
			
			//when last gamepoint is over half of this move map to lower part 
			if (scaledGamePoint.y > 390) {
				CGRect oldBounds = [playingBoardView bounds];
				oldBounds.origin.y = oldBounds.origin.y + 320;
				[playingBoardView setBounds:oldBounds];
				scaledGamePoint.y = scaledGamePoint.y - 320;
			}
			
			//reajust point
			if (scaledGamePoint.x < 7) {
				scaledGamePoint.x = 7;
			}
			if (scaledGamePoint.x > 318) {
				scaledGamePoint.x = 318;
			}
			if (scaledGamePoint.y < 43) {
				scaledGamePoint.y = 43;
			}
			if (scaledGamePoint.y > 436) {
				scaledGamePoint.y = 436;
			}
			
			touchImageView.center = scaledGamePoint;
			
		}

		
		NSString *playerSymbol = [[nextPlayer GetPlayerSymbol] retain];
		UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
		touchImageView.image = image;
		[image release];
		[playerSymbol release];
		
		//_?[self FadeOutGameElements];
		
		[nextPlayer release];
        [currentPlayer release];
	}
	@catch (NSException * e) {
		NSLog(@"failed in doSetPosition: %@",e);
	}
}


-(void)PlayerGaveUp
{
	@try {
		
        [self RemoveGameElementsForPlayer];
        
		
		[touchImageView setAlpha:0];
		
//		//convert to reel map point
        CGPoint realMapGamePoint = CGPointMake(9999, 9999); 
		
		Player *currentPlayer = [[m_gameRef GetPlayer] retain];
		[currentPlayer SetGamePoint:realMapGamePoint];
		
		[currentPlayer PauseTimer];
		
		
		BOOL showingResult = NO;
		if ([m_gameRef CurrentPlayerIsLast] == YES) 
		{
			showingResult = YES;
			
			//make game point into real map coordinates
			CGPoint realMapGamePoint;
            realMapGamePoint = CGPointMake(9999, 9999); 
			
			[currentPlayer SetGamePoint:realMapGamePoint];
			
			//_?12
			[touchImageView setAlpha:0];
			
			if ([m_gameRef IsTrainingMode] == NO) {
				[m_gameRef SetGameState:showResult];
			}
			
			[resultBoardView drawResult_UpdateGameData:YES];
			[self performTransition];
			
			[questionBarTop FadeOut];
			[answerBarTop FadeIn];
			
		}
		else {

			CGPoint realMapGamePoint;
            realMapGamePoint = CGPointMake(9999, 9999);
			[currentPlayer SetGamePoint:realMapGamePoint]; 
		}
		
		[m_gameRef SetNextPlayer];
		Player *nextPlayer = [[m_gameRef GetPlayer] retain];
        [self SetGameElementsForPlayer:nextPlayer];
		
		//		if ([m_gameRef IsTrainingMode] == NO) {
		//set the next player
		
		//check if last player is same as current player
		//showingResult = drawing map with results
		if ([m_gameRef IsMultiplayer] == YES && showingResult == NO) {
			if(m_startPlayerView == nil)
			{
				m_startPlayerView = [[StartPlayerView alloc] initWithFrame:[[self view] bounds]];
				[m_startPlayerView setDelegate:self];
				[[self view] addSubview:m_startPlayerView];
			}
			[m_startPlayerView SetPlayerRef:nextPlayer gameRef:m_gameRef];
			[[self view] bringSubviewToFront:m_startPlayerView];
			[m_startPlayerView FadeIn];
			
			if(firstTimeInstructionsView == nil)
			{
				firstTimeInstructionsView = [[FirstTimeInstructionsView alloc] initWithFrame:[[self view] bounds]];
				[firstTimeInstructionsView setAlpha:0];
				[[self view] addSubview:firstTimeInstructionsView];
			}
			[firstTimeInstructionsView SetPlayer:[nextPlayer GetName]];
			[[self view] bringSubviewToFront:firstTimeInstructionsView];
			[firstTimeInstructionsView FadeIn];
			
		}
		
		if ([m_gameRef IsMultiplayer] == YES) 
		{	
			[self ZoomOutMap];
			
			CGPoint gamepoint = [nextPlayer GetGamePoint];
			
			CGPoint scaledGamePoint;
			scaledGamePoint.x = gamepoint.x * 0.25;
			scaledGamePoint.y = gamepoint.y * 0.25;
			//scale to tile
			scaledGamePoint.x = scaledGamePoint.x * playingBoardView.zoomScale;
			scaledGamePoint.y = scaledGamePoint.y * playingBoardView.zoomScale;
			
			//when last gamepoint is over half of this move map to lower part 
			if (scaledGamePoint.y > 390) {
				CGRect oldBounds = [playingBoardView bounds];
				oldBounds.origin.y = oldBounds.origin.y + 320;
				[playingBoardView setBounds:oldBounds];
				scaledGamePoint.y = scaledGamePoint.y - 320;
			}
			
			//reajust point
			if (scaledGamePoint.x < 7) {
				scaledGamePoint.x = 7;
			}
			if (scaledGamePoint.x > 318) {
				scaledGamePoint.x = 318;
			}
			if (scaledGamePoint.y < 43) {
				scaledGamePoint.y = 43;
			}
			if (scaledGamePoint.y > 436) {
				scaledGamePoint.y = 436;
			}
			
			touchImageView.center = scaledGamePoint;
			
		}

		
		NSString *playerSymbol = [[nextPlayer GetPlayerSymbol] retain];
		UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
		touchImageView.image = image;
		[image release];
		[playerSymbol release];
		
		[self FadeOutGameElements];
		
		[nextPlayer release];
	}
	@catch (NSException * e) {
		NSLog(@"failed in doSetPosition: %@",e);
	}
}


#pragma mark For game menu

-(void) DisplayReplayGameMenu
{
	[self FadeOutGameElements];
}


#pragma mark Transitioning
-(void)performTransition
{
	// First create a CATransition object to describe the transition
	CATransition *transition = [CATransition animation];
	// Animate over 3/4 of a second
	transition.duration = 0.75;
	// using the ease in/out timing function
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	
	// Now to set the type of transition. Since we need to choose at random, we'll setup a couple of arrays to help us.
	NSString *types[4] = {kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};
	transition.type = types[3];
	
	// Finally, to avoid overlapping transitions we assign ourselves as the delegate for the animation and wait for the
	// -animationDidStop:finished: message. When it comes in, we will flag that we are no longer transitioning.
	transitioning = YES;
	transition.delegate = self;
	
	// Next add it to the containerView's layer. This will perform the transition based on how we change its contents.
	//[containerView.layer addAnimation:transition forKey:nil];
	[self.view.layer addAnimation:transition forKey:nil];
	
	if (playingBoardView.hidden == NO) {
		playingBoardView.hidden = YES;
		resultBoardView.hidden = NO;
	}
	else {
		playingBoardView.hidden = NO;
		resultBoardView.hidden = YES;
	}
	// Here we hide view1, and show view2, which will cause Core Animation to animate view1 away and view2 in.
	//view1.hidden = YES;
	//view2.hidden = NO;
	
	// And so that we will continue to swap between our two images, we swap the instance variables referencing them.
	//	UIImageView *tmp = view2;
	//	view2 = view1;
	//	view1 = tmp;
}

-(void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	transitioning = NO;
}


#pragma mark Autoscrolling
/************************************** NOTE **************************************/
/* For comments on the Autoscrolling methods, please see the Autoscroll project   */
/* in this sample code suite.                                                     */
/**********************************************************************************/

- (float)autoscrollDistanceForProximityToEdge:(float)proximity {
    return ceilf((AUTOSCROLL_THRESHOLD - proximity) / 5.0);
}


#pragma mark View handling methods

- (void)setZoomScale:(CGSize)size {
    // change the content size and reset the state of the scroll view
    // to avoid interactions with different zoom scales and resolutions. 
    [playingBoardView reloadDataWithNewContentSize:size];
    [playingBoardView setContentOffset:CGPointZero];
    
    // choose minimum scale so image width fills screen
    //_??? float minScale = [playingBoardView frame].size.width  / size.width;
    //if width has a higher value than height to the ratio of the screen...  set width, else use height
    float minScale = [playingBoardView frame].size.height  / size.height;
    [playingBoardView setMinimumZoomScale:minScale];
    [playingBoardView setZoomScale:minScale];    
}


-(void) FadeInGameElements
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[questionBarTop setAlpha:1];
	[infoBarBottom setAlpha:1];
	[touchImageView setAlpha:1];
	[directionsTouchView setAlpha:1];
	[UIView commitAnimations];	
	[infoBarBottom EnableSetPositionButton];
}

-(void) FadeOutGameElements
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[questionBarTop setAlpha:0];
	[infoBarBottom setAlpha:0];
	[touchImageView setAlpha:0];
	[directionsTouchView setAlpha:0];
	[UIView commitAnimations];		
}


- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    // the zoom rect is in the content view's coordinates. 
    //    At a zoom scale of 1.0, it would be the size of the imageScrollView's bounds.
    //    As the zoom scale decreases, so more content is visible, the size of the rect grows.
    zoomRect.size.height = [playingBoardView frame].size.height / scale;
    zoomRect.size.width  = [playingBoardView frame].size.width  / scale;
    
    // choose an origin so as to get the right center.
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

-(void) ZoomOutMap
{
	[playingBoardView setZoomScale:0.01 animated:NO];
	[playingBoardView updateResolution];
	CGRect oBounds = [playingBoardView bounds];
	oBounds.origin.y = 0;
	[playingBoardView setBounds:oBounds];	
}


@end
