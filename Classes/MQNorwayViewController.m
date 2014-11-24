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
#import "MagnifierView.h"


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
    
    createPlayerVC = [[CreatePlayerVC alloc] initWithNibName:@"CreatePlayerVC" bundle:NULL];
    [createPlayerVC.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [createPlayerVC.view setAlpha:0];
    [createPlayerVC setDelegate:self];
    [self.view addSubview:createPlayerVC.view];
    
    message = [[UIAlertView alloc] initWithTitle:@"Sorry!"
                                       message:@"Not allowed to pause game" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    /*
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
     */
}

//createPlayerVC delegate
-(void) cleanUpCreatePlayerVC
{
    
    [createPlayerVC.view removeFromSuperview];
    //[createPlayerVC dealloc];
    //[createPlayerVC release];
	//[highscoreGlobalView dealloc];
	createPlayerVC = nil;
    
    [self FirstLoad];
}

-(void) showMessage
{
    [message show];
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
	
    
    
    [[GlobalSettingsHelper Instance] SetPlayerID: [GlobalHelper Instance].ReadPlayerID];
    [[GlobalSettingsHelper Instance] SetPlayerName: [GlobalHelper Instance].ReadPlayerName];
    /*
    FMResultSet *resultsGlobalID = [[SqliteHelper Instance] executeQuery:@"SELECT playerID FROM globalID"];
    [resultsGlobalID next];
    if ([resultsGlobalID hasAnotherRow]) {
		[[GlobalSettingsHelper Instance] SetPlayerID:[resultsGlobalID stringForColumn:@"playerID"]];	}
	else {
		[[GlobalSettingsHelper Instance] SetPlayerID:@"tempID"];}*/
    
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
    [screen release];
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

-(void) RemoveGameElementsForPlayer
{
    //only remove clock after points animation done
    if ([m_gameRef IsTrainingMode] == NO) {

        [clockView stop];
        [self AnimateAndGiveTimePoints];
        //in singleplayer, dont remove clock before message of timebonus is shown
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
            [quitButton setDelegate:self];
            [[self view] addSubview:quitButton];
        }

        [self SetHintButton];

        [self SetPassButton];
    }
}

-(void) SetPassButton
{
    Player *player = [[m_gameRef GetPlayer] retain];
    
    if([player GetPassesLeft] > 0)
    {
        if (passButton == nil) {
            passButton = [[PassButtonView alloc] init];
            [passButton setDelegate:self];
            [[self view] addSubview:passButton];
        }
        [passButton SetTimesLeft:[player GetPassesLeft]];

    }
    
    [player release];
}

-(void) SetHintButton
{
    Player *player = [[m_gameRef GetPlayer] retain];
    int maxHintsPrRound = 2;
    if (hintButton == nil) {
        hintButton = [[HintButtonView alloc] init];
        [hintButton setDelegate:self];
        [hintButton setAlpha:0];
        [[self view] addSubview:hintButton];
    }
    if ([hintButton CostOfHint] < [player GetKmLeft]) {
        int hintsForThisRound = (long)[player GetKmLeft]/(long)[hintButton CostOfHint];
        if(hintsForThisRound > maxHintsPrRound)
            hintsForThisRound = maxHintsPrRound;
        
        [hintButton SetTimesLeft:hintsForThisRound];
        [hintButton SetHint:[[m_gameRef GetQuestion] GetHintArray]];
        [hintButton setAlpha:1];
    }
    [player release];
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
        [timePointsLabel setFrame:CGRectMake(0, 0, 180, 20)];
        timePointsLabel.center = CGPointMake([screen applicationFrame].size.width /2 , ([screen applicationFrame].size.height /2) -100 );
        timePointsLabel.backgroundColor = [UIColor clearColor]; 
        [timePointsLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        timePointsLabel.textAlignment = NSTextAlignmentCenter;
        timePointsLabel.shadowColor = [UIColor whiteColor];
        timePointsLabel.shadowOffset = CGSizeMake(-1,-2);
        timePointsLabel.text = [NSString stringWithFormat:@"%d x %d %@ %@",[clockView GetMultiplier],
                                [[GlobalSettingsHelper Instance] ConvertToRightDistance:const_timeBonusKm],
                                [[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                                [[GlobalSettingsHelper Instance] GetStringByLanguage:@"timebonus"]];
        [[self view] addSubview:timePointsLabel];
        [screen release];

        [self GiveTimePoints];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:2.5];
        [timePointsLabel setTransform:CGAffineTransformMakeScale(1.1f, 1.1f)];
        /*
        CGFloat clockViewXTransform = (40.0f*2)-320.0f;
        if (clockView.self.center.x < (320/2) ) {
            clockViewXTransform = 40.f;
        }*/
        clockView.center = CGPointMake(timePointsLabel.center.x - (timePointsLabel.frame.size.width/2),timePointsLabel.center.y);
        CGAffineTransform clockScale = CGAffineTransformMakeScale(0.55f, 0.55f);
        //CGAffineTransform clockMove = CGAffineTransformMakeTranslation(clockViewXTransform, -20.0f);
        //[clockView setTransform:CGAffineTransformMakeScale(0.4f, 0.4f)];
        //[clockView setTransform:CGAffineTransformMakeTranslation(30.0f, 0.0f)];
        //[clockView setTransform:CGAffineTransformConcat(clockScale, clockMove)];
        [clockView setTransform:clockScale];

        [UIView commitAnimations];
    }
}

-(void) GiveTimePoints
{
    Player *player = [[m_gameRef GetPlayer] retain];
    long timeDistanceBonus = [clockView GetMultiplier] * const_timeBonusKm;
    if ([player GetKmLeft] > timeDistanceBonus) {
        [player SetCurrentKmTimeBonus:timeDistanceBonus];
        [player SetCurrentTimeMultiplier:[clockView GetMultiplier]];
    }

    [player release];
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
    NSString *imageName;
    
    if ([m_gameRef UsingBorders] ==YES) {
        imageName = [NSString stringWithFormat:@"world_%d_border_%d_%d.jpg", resolutionPercentage, column, row];
    }
    else{
        imageName = [NSString stringWithFormat:@"world_%d_%d_%d.jpg", resolutionPercentage, column, row];
    }
    UIImage* image = [UIImage imageNamed:imageName];

	[tile setImage:image];

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
-(void) fadeInLoop
{
    if(loop == nil){
		loop = [[MagnifierView alloc] initWithFrame:[self view].bounds];
		loop.viewref = playingBoardView;
		[loop setAlpha:0];
        [[self view] addSubview:loop];
	}
    [loop setClocViewRef:clockView];
	
	//new _2.0
	[loop setPlayerSymbol:[[m_gameRef GetPlayer] GetPlayerSymbol]];
    loop.center = touchImageView.center;
	[loop setTransform:CGAffineTransformMakeScale(0.2, 0.2)];
    
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(updateLoopeAnimationDone)];
    
	[UIView setAnimationDuration:0.6];
	[loop setAlpha:1];
    [loop setTransform:CGAffineTransformMakeScale(1, 1)];
    [loop positionLeft];
	[UIView commitAnimations];
	loop.touchPoint = touchImageView.center;
	
	//start in new thread
	[loop setNeedsDisplay];
}


-(void)updateLoope
{
    [loop setClocViewRef:clockView];
	[loop setPlayerSymbol:[[m_gameRef GetPlayer] GetPlayerSymbol]];
	[loop setAlpha:1];
	loop.touchPoint = touchImageView.center;
	//start in new thread
	[loop setNeedsDisplay];
}


-(void) closeLoope
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	//[touchImageView setTransform:CGAffineTransformIdentity];
	[loop setAlpha:0];
	[UIView commitAnimations];
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
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	questionBarTop.center = CGPointMake(questionBarTop.center.x,  - questionBarTop.frame.size.height/2);
	[UIView commitAnimations];	
}

-(void) showQuestionBar
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	questionBarTop.center = CGPointMake(questionBarTop.center.x, questionBarTop.frame.size.height/2);
	[UIView commitAnimations];	
}

-(void) hideQuitButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	quitButton.center = CGPointMake(-quitButton.frame.size.width/2, quitButton.center.y);
	[UIView commitAnimations];	
}

-(void) showQuitButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	quitButton.center = CGPointMake(20, quitButton.center.y);
	[UIView commitAnimations];	
}

-(void) hideHintButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	hintButton.center = CGPointMake(-hintButton.frame.size.width/2, hintButton.center.y);
	[UIView commitAnimations];	
}

-(void) showHintButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	hintButton.center = CGPointMake(20, hintButton.center.y);
	[UIView commitAnimations];	
}

-(void) hidePassButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	passButton.center = CGPointMake(-passButton.frame.size.width/2, passButton.center.y);
	[UIView commitAnimations];	
}

-(void) showPassButton
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	passButton.center = CGPointMake(20, passButton.center.y);
	[UIView commitAnimations];	
}

#pragma mark RoundEndedViewDelegate
-(void) FinishedShowinRoundEndedView
{
    [m_roundEndedView removeFromSuperview];
    m_roundEndedView = nil;
	
	[self AnimateQuestion:NO];
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
    
    //[self AnimateQuestion];
    //[self finishedShowingResultMap];
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

#pragma mark AnimateTextViewDelegate

//start next round
- (void)finishedShowingResultMap{		
    
    if(clockView != nil)
    {
        [clockView stop];
        [clockView removeFromSuperview];
        [clockView dealloc];
        clockView = nil;
    }
    if(timePointsLabel != nil)
    {
        [timePointsLabel removeFromSuperview];
        timePointsLabel = nil;
    }
    
    [m_animTextView removeFromSuperview];
    m_animTextView = nil;
    
    UIScreen *screen = [[UIScreen mainScreen] retain];
    [resultBoardView ResetRegionBoundValues];
    [resultBoardView.sectionFiguresView setTransform:CGAffineTransformIdentity];
    resultBoardView.sectionFiguresView.center = CGPointMake(([screen applicationFrame].size.width/2), ([screen applicationFrame].size.height/2));
    [screen release];
    
    [resultBoardView.layer removeAllAnimations];
    
    if (resultBoardView.playerSymbolMiniWindowView != nil) {
        [resultBoardView.playerSymbolMiniWindowView removeFromSuperview];
        //[resultBoardView.playerSymbolMiniWindowView dealloc];
        //resultBoardView.playerSymbolMiniWindowView = nil;
    }

    
    

    Player *player = [[m_gameRef GetPlayer] retain];

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

    
    
    //draw bars without showing timebonus
    //____?? DRAW BARS WITHOUT TIMEBONUS
    [infoBarBottom DrawBarsOnce];
        


	
    if ([player IsOut] == NO) {
        Question* question = [[m_gameRef GetQuestion] retain];
        [player IncreasQuestionsPassed:question];
        [question release];
    }
    
    [player release];

	[answerBarTop FadeOut];
	[self FadeOutGameElements];
    
    [self performTransition];
    [self AnimateQuestion:NO];

}

-(void) finishedAnimatingResultText
{
    [resultBoardView.layer removeAllAnimations];
    [resultBoardView AnimateResult];
}

#pragma mark WithFiguresViewDelegate
//round is finished
- (void)finishedDrawingResultMap
{
    [self RemoveGameElementsForPlayer];

    UIScreen *screen = [[UIScreen mainScreen] retain];
    CGRect regionBoundsRect = resultBoardView.boundsOfRegion;
    if (regionBoundsRect.size.width > 0 && regionBoundsRect.size.height > 0) {
        CGPoint regionBoundsPoint = CGPointMake(regionBoundsRect.origin.x + (regionBoundsRect.size.width/2), regionBoundsRect.origin.y + (regionBoundsRect.size.height/2));
        float scaleFactor = ([screen applicationFrame].size.width * 0.5)/regionBoundsRect.size.width;
        int xOffset = ([screen applicationFrame].size.width/2) - regionBoundsPoint.x;
        int yOffset =([screen applicationFrame].size.height/2) - regionBoundsPoint.y;
        xOffset = xOffset * scaleFactor;
        yOffset = yOffset * scaleFactor;
        [resultBoardView.sectionFiguresView setAlpha:1];
        resultBoardView.lastCenterPoint = resultBoardView.sectionFiguresView.center;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.5];
        [UIView setAnimationDidStopSelector:@selector(sectionAnimationDidStop)];
        [UIView setAnimationDelegate:self];
        
        resultBoardView.sectionFiguresView.center = CGPointMake(resultBoardView.sectionFiguresView.center.x + xOffset, resultBoardView.sectionFiguresView.center.y + yOffset);
        [resultBoardView.sectionFiguresView setTransform:CGAffineTransformMakeScale(scaleFactor, scaleFactor)];
        [UIView commitAnimations];
        
    }

    [screen release];
    
    [self prepareForNextQuestion];
   

}

-(void) prepareForNextQuestion
{
    if (m_animTextView == nil) {
		m_animTextView = [[AnimateTextView alloc] initWithFrame:[[self view] bounds]];
		[m_animTextView setDelegate:self];
		[[self view] addSubview:m_animTextView];
	}
    
    
    Player *player = [[m_gameRef GetPlayer] retain];
    
    //add question for challenge
    ChallengeQuestionItem* newQuestion = [[[ChallengeQuestionItem alloc] init] autorelease];
    newQuestion.qid = [[m_gameRef GetQuestion] GetID];
    newQuestion.kmLeft = [player GetKmLeft];   //[currentPlayer GetLastDistanceFromDestination ];
    newQuestion.kmTimeBonus = [player GetCurrentKmTimeBonus];
    newQuestion.answered = 1;
    NSLog(@"Question values %@ %d %d %d", newQuestion.qid,newQuestion.kmLeft,newQuestion.kmTimeBonus,newQuestion.answered);
    [m_gameRef.challenge addQuestion:newQuestion];
    
    
    [questionBarTop FadeOut];
    
    
    m_animTextView.hidden = NO;
    [m_animTextView setText:[player GetPepTalk]];
    
    [m_animTextView startTextAnimation];
    
    
    [resultBoardView drawResult_UpdateGameData:YES];
    

    [player release];
    
	if ([m_gameRef IsTrainingMode] == YES) {
		//[infoBarBottom SetTrainingText];
		[infoBarBottom UpdateTrainingText];
	}
	else
	{
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
	[[self view] addSubview:resultBoardView.playerSymbolMiniWindowView];
	[answerBarTop SetResult:m_gameRef];
	
	[infoBarBottom FadeIn];
	[self.view bringSubviewToFront:m_animTextView];
    [self.view bringSubviewToFront:resultBoardView.playerSymbolMiniWindowView];
	[self.view bringSubviewToFront:answerBarTop];
}


-(void) sectionAnimationDidStop
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    //[UIView setAnimationDidStopSelector:@selector(sectionAnimationResetAnimationDidStop)];
    [UIView setAnimationDelegate:self];
    [resultBoardView.sectionFiguresView setAlpha:0];
    resultBoardView.sectionFiguresView.center = resultBoardView.lastCenterPoint;
    [resultBoardView.sectionFiguresView setTransform:CGAffineTransformMakeScale(1, 1)];
    [UIView commitAnimations];
    //[self prepareForNextQuestion];
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
    /*

    [self RemoveGameBoardAndBars];

    [self cleanUpGameElements];
    */
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
    
    [self RemoveGameBoardAndBars];
    [self cleanUpGameElements];
    
    [self DisplayMainMenu];
}

-(void) LoadGameBoardAndBars
{
    playingBoardView = [[TiledScrollView alloc] initWithFrame:[[self view] bounds]];
    [playingBoardView setDataSource:self];
    [[playingBoardView tileContainerView] setDelegate:self];
    [playingBoardView setTileSize:CGSizeMake(256, 256)];
    //[playingBoardView setTileSize:CGSizeMake(TILESIZE, TILESIZE)];
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
    
	

    
    touchImageView = [[[TouchImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 50, 50)] retain];
    touchImageView.center = CGPointMake([screen applicationFrame].size.width/2.0, 230.0);
	[touchImageView setDelegate:self];
	[self.view addSubview:touchImageView];


	infoBarBottom = [[InfoBarViewBottom alloc]initWithFrame:CGRectMake(0,0, [screen applicationFrame].size.width, constInfobarBottomHeight)];
    infoBarBottom.center = CGPointMake(infoBarBottom.center.x, [screen applicationFrame].size.height - infoBarBottom.frame.size.height/2);
	[infoBarBottom setDelegate:self];
	[[self view] addSubview:infoBarBottom];
	
	//set first question
	questionBarTop = [[QuestionBarViewTop alloc] initWithFrame:CGRectMake(0,0, [screen applicationFrame].size.width, 40)];
	[questionBarTop setDelegate:self];
	[self.view addSubview:questionBarTop];
	[questionBarTop setAlpha:0];
    

	
	answerBarTop = [[AnswerBarViewTop alloc] initWithFrame:CGRectMake(0,0, [screen applicationFrame].size.width, 50)];
	[self.view addSubview:answerBarTop];
	[answerBarTop setAlpha:0];

    hackBackgroundStatusbar = [[UIView alloc] initWithFrame:CGRectMake(0,-20, [screen applicationFrame].size.width, 20)];
    hackBackgroundStatusbar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:hackBackgroundStatusbar];
	[hackBackgroundStatusbar setAlpha:1];
    
    [screen release];
	//[self setZoomScale:CGSizeMake(1800, 4500)];
    [self setZoomScale:CGSizeMake(constMapWidth, constMapHeight)];
}

-(void) RemoveGameBoardAndBars
{

    [playingBoardView removeFromSuperview];
    [playingBoardView dealloc];
    playingBoardView = nil;

    [resultBoardView removeFromSuperview];
    [resultBoardView dealloc];
    resultBoardView = nil;

    [directionsTouchView removeFromSuperview];
    [directionsTouchView dealloc];
    directionsTouchView = nil;
    
    [infoBarBottom removeFromSuperview];
    [infoBarBottom dealloc];
    infoBarBottom = nil;

    [questionBarTop removeFromSuperview];
    [questionBarTop dealloc];
    questionBarTop = nil;
    
    
    [answerBarTop removeFromSuperview];
    [answerBarTop dealloc];
    answerBarTop = nil;

    [touchImageView removeFromSuperview];
    [touchImageView dealloc];
    touchImageView = nil;

}


#pragma mark GameMenuDelegate

-(void) PreStartNewGame:(Game*) gameRef
{
    [self LoadGameBoardAndBars];

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
	
    
    if (mainMenuView != nil) {
        [mainMenuView removeFromSuperview];
        //[mainMenuView dealloc];
        mainMenuView = nil;
    }
    
    
    //if first time , startNEwGame will be called through firstTimeInstructions
	if (firstTime == NO) {
		[self PrepareNewGame];
	}
	
	[currentPlayerName release];
	[firstPlayer release];
}

//Begin game
-(void) PrepareNewGame
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
	

    [self PrepairPlayer];
    
	
    [[self view] bringSubviewToFront:touchImageView];
	[[self view] bringSubviewToFront:infoBarBottom];
	[[self view] bringSubviewToFront:questionBarTop];
	[[self view] bringSubviewToFront:answerBarTop];
	
	[infoBarBottom SetGameRef:m_gameRef];
    
    [self StartNewGame];
}

-(void) PrepairPlayer
{
    Player *player = [[m_gameRef GetPlayer] retain];
    [player SetCurrentKmTimeBonus:0];
	NSString *playerSymbol = [[player GetPlayerSymbol] retain];
    [player release];
	UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
	touchImageView.image = image;
	[playerSymbol release];
	[image release];
}

- (void)StartNewGame
{

    [self FadeOutGameElements];
    
    [self AnimateQuestion:YES];

}

-(void) AnimateFirstQuestionDone
{
    Player *firstPlayer = [[m_gameRef GetPlayer] retain];
    //[firstPlayer SetCurrentKmTimeBonus:0];
	NSString *currentPlayerName = [[firstPlayer GetName] retain];
	//new 2.0
	[firstPlayer StartTimer];

	
	if ([m_gameRef IsTrainingMode] == NO) {

        //set up challenge
        m_gameRef.challenge.creator = [[GlobalSettingsHelper Instance] GetPlayerID];
        m_gameRef.challenge.kmToUse = const_startKmDistance;
        m_gameRef.challenge.difficulty = [m_gameRef GetGameDifficulty];
        
        [self StartPlayer];

        
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

-(void) AnimateQuestion:(BOOL) firstQuestion
{

    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    NSString *playerName = [[currentPlayer GetName] retain];
    if ([currentPlayer GetKmLeft] <= 0) {
        [self StartNextRound];
    }
    else
    {
        if(firstQuestion == NO)
            [m_gameRef SetNextQuestion];
        [questionBarTop SetQuestion:playerName gameRef:m_gameRef];
        [questionBarTop AnimateQuestion:firstQuestion];
    }
   
    [currentPlayer release];
    [playerName release];
}

-(void) StartNextRound
{
    
	Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer SetCurrentKmTimeBonus:0];
	NSString *playerName = [[currentPlayer GetName] retain];

	BOOL gameFinished = NO;
	
	if ([m_gameRef IsMoreQuestionsForTraining] == NO)
		gameFinished = YES;

	


    Player *player = [[m_gameRef GetPlayer] retain];
    if ([player GetKmLeft] <= 0) {
        gameFinished = YES;
    }
    [player release];
		
	if (gameFinished == NO) {
		if ([m_gameRef IsTrainingMode] == NO) {
			[m_gameRef SetGameState:inGame];

            [self StartPlayer];
			
		}
		else {
			[infoBarBottom SetTrainingText];
			[self StartPlayer];
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
            
            //[self RemoveGameBoardAndBars];
            //[self cleanUpGameElements];
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
	
	//[self performTransition];
	
}

#pragma mark QuitButtonViewDelegate
-(void) QuitGame
{
    [self RemoveGameBoardAndBars];
    [self cleanUpGameElements];
    
	[self DisplayMainMenu];
}

-(void) cleanUpGameElements
{
    [loop removeFromSuperview];
    [loop dealloc];
    loop = nil;
    [clockView stop];
    [clockView removeFromSuperview];    
    [clockView dealloc];
    clockView = nil;
    [quitButton removeFromSuperview];
    [quitButton dealloc];
    quitButton = nil;
    [passButton removeFromSuperview];
    [passButton dealloc];
    passButton = nil;
    [hintButton removeFromSuperview];
    [hintButton dealloc];
    hintButton = nil;
    [resultBoardView removeFromSuperview];
    [resultBoardView dealloc];
    resultBoardView = nil;
}

#pragma mark HintButtonViewDelegate
-(void) UseHint
{
    //subtract hint from player 
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer HintUsed];
    
    
    UIScreen *screen = [[UIScreen mainScreen] retain];
    if (hintDeductLabel == nil) {
        hintDeductLabel  = [[UILabel alloc] init];
        [hintDeductLabel setFrame:CGRectMake(0, 0, 250, 20)];
        
        hintDeductLabel.backgroundColor = [UIColor clearColor];
        hintDeductLabel.textColor = [UIColor redColor];
        hintDeductLabel.textAlignment = NSTextAlignmentCenter;
        hintDeductLabel.text = [NSString stringWithFormat:@"- %d km",[hintButton CostOfHint]];
        [self.view addSubview:hintDeductLabel];
    }
    [hintDeductLabel setTransform:CGAffineTransformMakeScale(1.9, 1.9)];
    hintDeductLabel.center = CGPointMake([screen applicationFrame].size.width /2 , ([screen applicationFrame].size.height /2) -100 );
    [hintDeductLabel setAlpha:1];

    [screen release];
    //animate deduct kms from hint
    [UIView beginAnimations:@"DeductHint" context:NULL];
	[UIView setAnimationDuration:0.7];
    [UIView setAnimationDelay:0.4];
    //[UIView setAnimationRepeatCount:3];
    //[UIView setAnimationRepeatAutoreverses:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(deductHintDidStop:finished:context:)];

    [hintDeductLabel setTransform:CGAffineTransformMakeScale(1, 1)];
    hintDeductLabel.center = infoBarBottom.center;
    [hintDeductLabel setAlpha:0];
	[UIView commitAnimations];
    
    [currentPlayer release];
}

- (void)deductHintDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer DeductKmLeft:[hintButton CostOfHint]];
    [currentPlayer release];
    
    /*
    [UIView beginAnimations:@"DeductHint2" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.0];
    [UIView commitAnimations];
*/
    [infoBarBottom UpdateBars];
}


#pragma mark PassButtonViewDelegate
-(void) PassQuestion
{
    //subtract pass from player
    Player *currentPlayer = [[m_gameRef GetPlayer] retain];
    [currentPlayer PassUsed];
    
    ChallengeQuestionItem* newQuestion = [[[ChallengeQuestionItem alloc] init] autorelease];
    newQuestion.qid = [[m_gameRef GetQuestion] GetID];
    newQuestion.kmLeft = [currentPlayer GetKmLeft]; 
    newQuestion.kmTimeBonus = 0;
    newQuestion.answered = 0;
    NSLog(@"Question values %@ %d %d %d", newQuestion.qid,newQuestion.kmLeft,newQuestion.kmTimeBonus,newQuestion.answered);
    [m_gameRef.challenge addQuestion:newQuestion];

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
		
        //[self RemoveGameElementsForPlayer];

		
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
		
		
		Player *player = [[m_gameRef GetPlayer] retain];
		[player SetGamePoint:realMapGamePoint];
		
		[player PauseTimer];
		
		
		BOOL showingResult = NO;
		
        //if ([m_gameRef CurrentPlayerIsLast] == YES)

        showingResult = YES;
        
        //make game point into real map coordinates
        //CGPoint realMapGamePoint;
        realMapGamePoint = CGPointMake(gamePoint.x + [playingBoardView bounds].origin.x, gamePoint.y + [playingBoardView bounds].origin.y); 
        //scale to tile 
        realMapGamePoint.x = realMapGamePoint.x /[playingBoardView zoomScale] ;
        realMapGamePoint.y = realMapGamePoint.y /[playingBoardView zoomScale] ;					   
        //scale to map
        realMapGamePoint.x = realMapGamePoint.x/ ((float)resolutionPercentage/100); 
        realMapGamePoint.y = realMapGamePoint.y/ ((float)resolutionPercentage/100);
        
        [player SetGamePoint:realMapGamePoint];
        
        //_?12
        [touchImageView setAlpha:0];
        
        if ([m_gameRef IsTrainingMode] == NO) {
            [m_gameRef SetGameState:showResult];
        }
        
        [resultBoardView drawResult_UpdateGameData:YES];
        
        [self performTransition];
        
        [questionBarTop FadeOut];
        [answerBarTop FadeIn];

        [player SetCurrentTimeMultiplier:0];
		
		NSString *playerSymbol = [[player GetPlayerSymbol] retain];
		UIImage *image = [[UIImage imageNamed:playerSymbol] retain];
		touchImageView.image = image;
		[image release];
		[playerSymbol release];
		[player release];
        
        
        //[self RemoveGameElementsForPlayer];
        

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
