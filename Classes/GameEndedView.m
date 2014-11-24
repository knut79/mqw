//
//  GameEndedView.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "GameEndedView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "SoapHelper.h"

@implementation GameEndedView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        
        //_?AZURE send inn results
        
        // Initialization code
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		
		m_labelsXoffset = 0;
		m_labelsYoffset = 0;

        
		m_playerNameLabelsArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) {
			UILabel *playerNameLabel = [[UILabel alloc] init];
			playerNameLabel.numberOfLines = 1;
			playerNameLabel.adjustsFontSizeToFitWidth = YES;
			playerNameLabel.backgroundColor = [UIColor clearColor]; 
			[playerNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
			playerNameLabel.textAlignment = NSTextAlignmentCenter;
			if (i == 0) {
				playerNameLabel.layer.shadowColor = [[UIColor yellowColor] CGColor];
				playerNameLabel.layer.shadowRadius = 2.5;
				playerNameLabel.layer.shadowOpacity = 1.0;
			}
			else {
				playerNameLabel.shadowColor = [UIColor whiteColor];
				playerNameLabel.shadowOffset = CGSizeMake(-1,-2);
			}

			
			
			[playerNameLabel setFrame:CGRectMake(0, 0, 300, 20)];
			[m_playerNameLabelsArray addObject:playerNameLabel];
			[self addSubview:playerNameLabel];
		}
		
		m_playerDistanceLabelsArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) {
			UILabel *playerDistanceLabel = [[UILabel alloc] init];
			playerDistanceLabel.numberOfLines = 1;
			playerDistanceLabel.adjustsFontSizeToFitWidth = YES;
			playerDistanceLabel.backgroundColor = [UIColor clearColor]; 
			[playerDistanceLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
			playerDistanceLabel.textAlignment = NSTextAlignmentCenter;
			if (i == 0) {
				playerDistanceLabel.layer.shadowColor = [[UIColor yellowColor] CGColor];
				playerDistanceLabel.layer.shadowRadius = 2.5;
				playerDistanceLabel.layer.shadowOpacity = 1.0;
			}
			else {
				playerDistanceLabel.shadowColor = [UIColor whiteColor];
				playerDistanceLabel.shadowOffset = CGSizeMake(-1,-2);

			}

			[playerDistanceLabel setFrame:CGRectMake(0, 0, 300, 20)];
			[m_playerDistanceLabelsArray addObject:playerDistanceLabel];
			[self addSubview:playerDistanceLabel];
		}
		
		m_linesArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) {
			UIImage *lineImage = [[UIImage imageNamed:@"line.png"] retain];
			CGRect imageRect = CGRectMake(-99, -99, 200, 4);
			UIImageView* lineImageView = [[[UIImageView alloc] initWithFrame:imageRect] retain];
			lineImageView.image = lineImage;
			[lineImageView setAlpha:0];
			[m_linesArray addObject:lineImageView];
			[self addSubview:lineImageView];
			[lineImage release];
		}
		
		
		CGRect imageRect = CGRectMake(-99, -99, 223, 57);
		m_headerImageView = [[[UIImageView alloc] initWithFrame:imageRect] retain];
		[m_headerImageView setAlpha:0];
		[self addSubview:m_headerImageView];
		
		m_questionsPassedLabel = [[UILabel alloc] init];
		[m_questionsPassedLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_questionsPassedLabel.backgroundColor = [UIColor clearColor]; 
		[m_questionsPassedLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_questionsPassedLabel.textAlignment = NSTextAlignmentCenter;
		m_questionsPassedLabel.shadowColor = [UIColor whiteColor];
		m_questionsPassedLabel.shadowOffset = CGSizeMake(-1,-2);
		m_questionsPassedLabel.adjustsFontSizeToFitWidth = YES;
		[m_questionsPassedLabel setAlpha:0];
		[self addSubview:m_questionsPassedLabel];
		
        
        m_globalHighscoreLabel = [[UILabel alloc] init];
		[m_globalHighscoreLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_globalHighscoreLabel.backgroundColor = [UIColor clearColor]; 
		[m_globalHighscoreLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_globalHighscoreLabel.textAlignment = NSTextAlignmentCenter;
		m_globalHighscoreLabel.shadowColor = [UIColor whiteColor];
		m_globalHighscoreLabel.shadowOffset = CGSizeMake(-1,-2);
		m_globalHighscoreLabel.adjustsFontSizeToFitWidth = YES;
		[m_globalHighscoreLabel setAlpha:0];
		[self addSubview:m_globalHighscoreLabel];
		
		
		CGRect tropyImageRect = CGRectMake(-99, -99, 50, 57);
		m_highscoreImageView = [[[UIImageView alloc] initWithFrame:tropyImageRect] retain];
		[m_highscoreImageView setAlpha:0];
		[self addSubview:m_highscoreImageView];
		
		m_dynamicLabel = [[UILabel alloc] init];
		[m_dynamicLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_dynamicLabel.backgroundColor = [UIColor clearColor]; 
		[m_dynamicLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_dynamicLabel.textAlignment = NSTextAlignmentCenter;
		m_dynamicLabel.shadowColor = [UIColor whiteColor];
		m_dynamicLabel.shadowOffset = CGSizeMake(-1,-2);
		m_dynamicLabel.adjustsFontSizeToFitWidth = YES;
		[m_dynamicLabel setAlpha:0];
		[self addSubview:m_dynamicLabel];
		
		
		m_secondsUsedLabel = [[UILabel alloc] init];
		[m_secondsUsedLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_secondsUsedLabel.backgroundColor = [UIColor clearColor]; 
		[m_secondsUsedLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_secondsUsedLabel.textAlignment = NSTextAlignmentCenter;
		m_secondsUsedLabel.shadowColor = [UIColor whiteColor];
		m_secondsUsedLabel.shadowOffset = CGSizeMake(-1,-2);
		m_secondsUsedLabel.adjustsFontSizeToFitWidth = YES;
		[m_secondsUsedLabel setAlpha:0];
		[self addSubview:m_secondsUsedLabel];
		
		
		m_tapWhenReadyLabel = [[UILabel alloc] init];
		[m_tapWhenReadyLabel setFrame:CGRectMake(0,0, 250, 20)];
		m_tapWhenReadyLabel.backgroundColor = [UIColor clearColor]; 
		m_tapWhenReadyLabel.textAlignment = NSTextAlignmentCenter;
		[m_tapWhenReadyLabel setAlpha:0];
		m_tapWhenReadyLabel.textColor = [UIColor whiteColor];
		m_tapWhenReadyLabel.textAlignment = NSTextAlignmentCenter;
		m_tapWhenReadyLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		m_tapWhenReadyLabel.layer.shadowOpacity = 1.0;
		m_tapWhenReadyLabel.layer.shadowRadius = 1.5;
		[m_tapWhenReadyLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[self addSubview:m_tapWhenReadyLabel];
		
		//[self setUserInteractionEnabled:NO];
		
		self.hidden = YES;
        
        adBannerViewIsVisible = NO;
        [self createAdBannerView];
		
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

}

-(void) ResetLabels
{
	m_questionsPassedLabel.text = @"";
    m_globalHighscoreLabel.text = @"";
	m_dynamicLabel.text = @"";
	m_secondsUsedLabel.text = @"";
	for (int i = 0; i < 4; i++) {
		UILabel *playerNameLabel = [m_playerNameLabelsArray objectAtIndex:i];
		playerNameLabel.text = @"";
		UILabel *playerDistanceLabel = [m_playerDistanceLabelsArray objectAtIndex:i];
		playerDistanceLabel.text = @"";
		UIImageView *lineImageView = [m_linesArray objectAtIndex:i];
		lineImageView.center = CGPointMake(-99,-99);
	}
}

-(void)SetHeader:(Game*) gameRef
{
    m_gameRef = gameRef;
	[self ResetLabels];
    UIScreen *screen = [[UIScreen mainScreen] retain];

    [self setUpSinglePlayer:gameRef];

	m_headerImageView.center = CGPointMake([screen applicationFrame].size.width/2,  50);

	[screen release];
	[self FadeIn];
	
	[self AnimateElementsIn:1];
}

-(void) setUpSinglePlayer:(Game*) gameRef
{
    UIScreen *screen = [[UIScreen mainScreen] retain];

	
    
    self.userInteractionEnabled = NO;
    //NSMutableArray *players = [[gameRef GetPlayers] retain];
    UIImage *headerImage = [[UIImage imageNamed:@"GameOver.png"] retain];
    m_headerImageView.image = headerImage;
    [headerImage release];
    
    //tempPlayer = [[players objectAtIndex:0] retain];
    Player *player = [[gameRef GetPlayer] retain];
    //passed xx questions in easy game
    m_questionsPassedLabel.text = [NSString stringWithFormat:@"%@: %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Questions completed"],[player GetQuestionsPassed]];
    m_questionsPassedLabel.center = CGPointMake([screen applicationFrame].size.width/2,  85);

    
    NSInteger time = [player GetSecondsUsed];
    NSString *seconds = [[NSString stringWithFormat:@"%d",time%60] retain];
    if ([seconds length] == 1 ) {
        m_secondsUsedLabel.text = [NSString stringWithFormat:@"%@: %d:0%d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time used"],time/60,time%60];
    }
    else {
        m_secondsUsedLabel.text = [NSString stringWithFormat:@"%@: %d:%d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time used"],time/60,time%60];
    }
    [seconds release];
    
    m_secondsUsedLabel.center = CGPointMake([screen applicationFrame].size.width/2,  130);
    

    
    Highscore *hs = [gameRef GetHighscore];
    NSInteger newHighScorePlace = [hs CheckIfNewHighScore:player difficultyLevel:[gameRef GetGameDifficulty]];
    if (newHighScorePlace < 99) {
        NSString *gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"set level difficulty"];
        Difficulty diffLevel = [gameRef GetGameDifficulty];
        /*
        switch (diffLevel) {
            case hardDif:
            case veryhardDif:
                gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"];
                break;
            case medium:
                gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"medium"];
            default:
                break;
        }*/

        
        UIImage *trophyImage = [[UIImage imageNamed:@"trophy.png"] retain];
        m_highscoreImageView.image = trophyImage;
        [trophyImage release];
        m_highscoreImageView.center = CGPointMake(30,  190);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [m_highscoreImageView setAlpha:1];
        [UIView commitAnimations];	
    }


    //set score via webservice . This view must be user inactive . enable when not singleplayer. On singleplayer enable when no connection or when result is recived
    //get global position
    ssb = [[SoapHelper alloc] init];
    [ssb setDelegate:self];
    [ssb setScore];
    //give notice if points are better than current global score (result from setscorebridge.setscore) V
    
    
    //if challenge is taken , inform if this is won or lost. X
    //else just ask if user wants to challenge someone X
    
       
    
    //set up 
    //button "challenge friends" -> opens new view where contacts with emails can be added, emails can be manually written or (search /Users/lambchopnot/Projects/MQNorway/MQNorway/Classes/QuestionBarViewTop.mup users)
    //button "rechallenge" , if challenge taken was won  -> when pressed spinning -> enable button with text "rechallenge of user sendt" eller "no connection with server"
    //
    //and button "continue without challenge"

    m_globalHighscoreLabel.textAlignment = NSTextAlignmentCenter;
    m_globalHighscoreLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Waiting for result..."]];
    m_globalHighscoreLabel.center = CGPointMake([screen applicationFrame].size.width/2,  235);
    
    

    challengeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [challengeButton addTarget:self action:@selector(doChallenge) forControlEvents:UIControlEventTouchDown];
    [challengeButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Challenge"] forState:UIControlStateNormal];
    challengeButton.layer.borderWidth=1.0f;
    [challengeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    challengeButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    challengeButton.frame = CGRectMake(0, 0, 180.0, 40.0);
    challengeButton.center = CGPointMake([screen applicationFrame].size.width/2,350);
    [self addSubview:challengeButton];
    
    exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exitButton addTarget:self action:@selector(doSkip) forControlEvents:UIControlEventTouchDown];
    [exitButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Skip challenging"] forState:UIControlStateNormal];
    exitButton.layer.borderWidth=1.0f;
    [exitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    exitButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    exitButton.frame = CGRectMake(0, 0, 180.0, 40.0);
    exitButton.center = CGPointMake([screen applicationFrame].size.width/2,420);
    [self addSubview:exitButton];
    
    
    [player release];
    
    [screen release];
}

-(void) doChallenge
{
    NSLog(@"questions : %@",[m_gameRef.challenge getQuestionIDs]);
    if (challengeViewController == nil) {
        challengeViewController = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil]; 
        [challengeViewController setDelegate:self];
        [challengeViewController setChallenge:m_gameRef.challenge];
        [self addSubview:challengeViewController.view];
    }
}

#pragma mark challengeViewControllerDelegate
-(void) cleanUpChallengView
{
    [challengeViewController removeFromParentViewController];
    challengeViewController = nil; 
}

-(void) doSkip
{
    [self FadeOut];
}

-(void) AnimateElementsIn:(NSInteger) numberOfPlayers
{
	m_playerIndexToAnimate = numberOfPlayers - 1;
	m_numberOfPlayersToAnimate = numberOfPlayers;
	[self AnimatePlayerIn];
}

-(void) AnimatePlayerIn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 	      
	[UIView setAnimationDidStopSelector:@selector(FinishedAnimatingPlayer)];  
	[UIView setAnimationDuration:0.5];

	UILabel *playerNameLabel = [m_playerNameLabelsArray objectAtIndex:m_playerIndexToAnimate];
	[playerNameLabel setAlpha:1]; 
	UILabel *playerDistanceLabel = [m_playerDistanceLabelsArray objectAtIndex:m_playerIndexToAnimate];
	[playerDistanceLabel setAlpha:1];
	UIImageView *lineImageView = [m_linesArray objectAtIndex:m_playerIndexToAnimate];
	[lineImageView setAlpha:1];

	m_playerIndexToAnimate --;
	[UIView commitAnimations];	
}

-(void) FinishedAnimatingPlayer
{
	if (m_playerIndexToAnimate >= 0) {
		[self AnimatePlayerIn];
	}
	else {
		[self AnimateLastElements];
	}
}

-(void) AnimateLastElements
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(FinishedAnimatingLastElements)];  
	[UIView setAnimationDuration:0.5];	
	[m_headerImageView setAlpha: 1];
	[m_tapWhenReadyLabel setAlpha: 1];
	[UIView commitAnimations];	
}

-(void) FinishedAnimatingLastElements
{
	[self setUserInteractionEnabled:YES];
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(FinishedFadingOut)];   
    [self setAlpha:0];
	[UIView commitAnimations];	

}

- (void) FinishedFadingOut
{
	self.hidden = YES;
    [adBannerView removeFromSuperview];
    adBannerView = nil;
	//send message fading in game elements
	if ([delegate respondsToSelector:@selector(GameOver)])
		[delegate GameOver];
}

-(void) FadeIn
{
	self.hidden = NO;

	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedFadingIn)];
	[UIView setAnimationDuration:0.5];
	[self SetAlphaIn];
	[UIView commitAnimations];	

}

-(void) finishedFadingIn
{
//    if ([delegate respondsToSelector:@selector(showAdBar)])
//        [delegate showAdBar];
    [self showAdBar];
}

-(void) SetAlphaIn
{
	[m_questionsPassedLabel setAlpha:1];
    [m_globalHighscoreLabel setAlpha:1];
	[m_dynamicLabel setAlpha:1];
	[m_secondsUsedLabel setAlpha:1];
}

#pragma mark AdBar methods


- (void)createAdBannerView {
    
    adBannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    //_? check out .. adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    UIScreen *screen = [[UIScreen mainScreen] retain];
//    CGRect adBannerViewFrame = [adBannerView frame];
    adBannerView.center = CGPointMake(160, [screen applicationFrame].size.height + (50/2));
//    adBannerViewFrame.origin.x = 0;
//    adBannerViewFrame.origin.y = [screen applicationFrame].size.height;
    [screen release];
    [self addSubview:adBannerView];
}

-(void) showAdBar
{
    [self bringSubviewToFront:adBannerView];
    adBannerViewIsVisible = YES;
    UIScreen *screen = [[UIScreen mainScreen] retain];
    [UIView beginAnimations:@"showAdBar" context:nil];
    adBannerView.center = CGPointMake(160, [screen applicationFrame].size.height - (50/2));
    [UIView commitAnimations];  
    [screen release];
}

-(void) hideAdBar
{
    adBannerViewIsVisible = NO;
    UIScreen *screen = [[UIScreen mainScreen] retain];
    [UIView beginAnimations:@"hideAdBar" context:nil];
    CGRect adBannerViewFrame = [adBannerView frame];
    adBannerViewFrame.origin.x = 0;
    adBannerViewFrame.origin.y = [screen applicationFrame].size.height;
    [UIView commitAnimations];  
    [screen release];
}


#pragma mark delegate methods

-(void) gotScoreResult
{
    //self.userInteractionEnabled = YES;
    UIScreen *screen = [[UIScreen mainScreen] retain];
    m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
	m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, 270);
    
    m_globalHighscoreLabel.text = [NSString stringWithFormat:@"%@",[ssb getUserMessage]];
    [screen release];
}

-(void) noScoreResultConnection
{
    //self.userInteractionEnabled = YES;
    UIScreen *screen = [[UIScreen mainScreen] retain];
    m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
	m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, 270);
    
    m_globalHighscoreLabel.text = [NSString stringWithFormat:@"%@",[ssb getUserMessage]];
    [screen release];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (adBannerViewIsVisible) {                
        [self showAdBar];
    }

}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Error adView %@",error);
    if (adBannerViewIsVisible)
        [self showAdBar];
    else
        [self hideAdBar]; 
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (void)dealloc {
    [super dealloc];
}

@end
