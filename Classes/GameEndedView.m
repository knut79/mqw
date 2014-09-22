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
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		m_labelsXoffset = 0;
		m_labelsYoffset = 0;
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0];
		[self addSubview:m_skyView];
		
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
//				playerNameLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//				playerNameLabel.layer.shadowRadius = 1.5;
//				playerNameLabel.layer.shadowOpacity = 0.5;
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
//				playerDistanceLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//				playerDistanceLabel.layer.shadowRadius = 1.5;
//				playerDistanceLabel.layer.shadowOpacity = 0.5;
			}
//			playerDistanceLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//			playerDistanceLabel.layer.shadowOpacity = 1.0;
//			playerDistanceLabel.layer.shadowRadius = 1.5;
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
//		m_questionsPassedLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_questionsPassedLabel.layer.shadowOpacity = 1.0;
//		m_questionsPassedLabel.layer.shadowRadius = 1.5;
		m_questionsPassedLabel.shadowColor = [UIColor whiteColor];
		m_questionsPassedLabel.shadowOffset = CGSizeMake(-1,-2);
		m_questionsPassedLabel.adjustsFontSizeToFitWidth = YES;
		[m_questionsPassedLabel setAlpha:0];
		[self addSubview:m_questionsPassedLabel];
		
		m_scoreLabel = [[UILabel alloc] init];
		[m_scoreLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_scoreLabel.backgroundColor = [UIColor clearColor]; 
		[m_scoreLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_scoreLabel.textAlignment = NSTextAlignmentCenter;
//		m_scoreLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_scoreLabel.layer.shadowOpacity = 1.0;
//		m_scoreLabel.layer.shadowRadius = 1.5;
		m_scoreLabel.shadowColor = [UIColor whiteColor];
		m_scoreLabel.shadowOffset = CGSizeMake(-1,-2);
		m_scoreLabel.adjustsFontSizeToFitWidth = YES;
		[m_scoreLabel setAlpha:0];
		[self addSubview:m_scoreLabel];
		
        
        m_localHeaderLabel = [[UILabel alloc] init];
		[m_localHeaderLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_localHeaderLabel.backgroundColor = [UIColor clearColor]; 
		[m_localHeaderLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_localHeaderLabel.textAlignment = NSTextAlignmentCenter;
        m_localHeaderLabel.shadowColor = [UIColor whiteColor];
		m_localHeaderLabel.shadowOffset = CGSizeMake(-1,-2);
		m_localHeaderLabel.adjustsFontSizeToFitWidth = YES;
		[m_localHeaderLabel setAlpha:0];
		[self addSubview:m_localHeaderLabel];
        
		m_localHighscoreLabel = [[UILabel alloc] init];
		[m_localHighscoreLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_localHighscoreLabel.backgroundColor = [UIColor clearColor]; 
		[m_localHighscoreLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_localHighscoreLabel.textAlignment = NSTextAlignmentCenter;
		m_localHighscoreLabel.shadowColor = [UIColor whiteColor];
		m_localHighscoreLabel.shadowOffset = CGSizeMake(-1,-2);
		m_localHighscoreLabel.adjustsFontSizeToFitWidth = YES;
		[m_localHighscoreLabel setAlpha:0];
		[self addSubview:m_localHighscoreLabel];
        
        m_globalHeaderLabel = [[UILabel alloc] init];
		[m_globalHeaderLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_globalHeaderLabel.backgroundColor = [UIColor clearColor]; 
		[m_globalHeaderLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_globalHeaderLabel.textAlignment = NSTextAlignmentCenter;
        m_globalHeaderLabel.shadowColor = [UIColor whiteColor];
		m_globalHeaderLabel.shadowOffset = CGSizeMake(-1,-2);
		m_globalHeaderLabel.adjustsFontSizeToFitWidth = YES;
		[m_globalHeaderLabel setAlpha:0];
		[self addSubview:m_globalHeaderLabel];
        
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
//		m_dynamicLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_dynamicLabel.layer.shadowOpacity = 1.0;
//		m_dynamicLabel.layer.shadowRadius = 1.5;
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
//		m_secondsUsedLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_secondsUsedLabel.layer.shadowOpacity = 1.0;
//		m_secondsUsedLabel.layer.shadowRadius = 1.5;
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

    if ([m_gameRef IsMultiplayer] == YES) {
        if(adBannerViewIsVisible == YES)
        {
            //_? what is this for
            UIScreen *screen = [[UIScreen mainScreen] retain];
            [UIView beginAnimations:@"showAdBar" context:nil];
            CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
            if (currentPoint.y < ([screen applicationFrame].size.height - 50) ) 
            {
                [self setUserInteractionEnabled:NO];
                NSLog(@"tap on GameEnded view caught");
                //start timer for player
                [self FadeOut];
            }
            [screen release];
        }
        else
        {
            [self setUserInteractionEnabled:NO];
            NSLog(@"tap on GameEnded view caught");
            //start timer for player
            [self FadeOut];
        }
    }

}

-(void) ResetLabels
{
	m_questionsPassedLabel.text = @"";
	m_scoreLabel.text = @"";
	m_localHighscoreLabel.text = @"";
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
	//[self setUserInteractionEnabled:NO];
	[self ResetLabels];
    UIScreen *screen = [[UIScreen mainScreen] retain];
	
	//NSMutableArray *players = [[gameRef GetSortedPlayersForGame] retain];
	Player *tempPlayer;
	NSString *measurementString = @"";
	if ([gameRef IsMultiplayer] == YES) {

        self.userInteractionEnabled = YES;
		UIImage *headerImage = [[UIImage imageNamed:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"TheWinner.png"]] retain];
		m_headerImageView.image = headerImage;
		[headerImage release];
		
		if ([gameRef GetGameType] == lastStanding )  
		{
            [self setUpMultiplayerLastStandingGame:gameRef];
		}
		else //points game
		{
            [self setUpMultiplayerMostPointsGame:gameRef];
		}
		
        m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
        

	} //singleplayer game
	else {
        [self setUpSinglePlayer:gameRef];

	}

//	m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
//	m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, yOffset + 120);
	
	m_headerImageView.center = CGPointMake([screen applicationFrame].size.width/2,  50);
	
	
	//[players release];
	[screen release];
	[self FadeIn];
	
	[self AnimateElementsIn:[[gameRef GetPlayers] count]];
	//[self AnimateElementsIn:[[gameRef GetSortedPlayersForGame] count]];
}

-(void) setUpMultiplayerLastStandingGame:(Game*) gameRef
{
    UIScreen *screen = [[UIScreen mainScreen] retain];
	NSInteger yOffset = 40;
	NSInteger yOffsetConstant = 70;
    Player *tempPlayer;
    NSString *measurementString = @"";
    NSArray *players = [[gameRef GetSortedPlayersForGame_LastStanding] retain];
    for (int i = 0; i < [players count]; i++) 
    {
        UILabel *playerNameLabel = [m_playerNameLabelsArray objectAtIndex:i];
        UILabel *playerDistanceLabel = [m_playerDistanceLabelsArray objectAtIndex:i];
        UIImageView *lineImageView = [m_linesArray objectAtIndex:i];
        tempPlayer = [[players objectAtIndex:i] retain];
        
        //				DistanceMeasurement measurement = [[GlobalSettingsHelper Instance] GetDistance];
        //				if (measurement == mile) {
        //					measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"miles"];
        //				}
        //				else {
        //					measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"kilometers"];
        //				}
        
        if([tempPlayer HasGivenUp] == YES)
        {
            playerDistanceLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player gave up"]];
            
        }
        else
        {
            if ([tempPlayer GetKmLeft] < 0) {
                playerDistanceLabel.text = [NSString stringWithFormat:@"%@: %d %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance exceeded"] ,[[GlobalSettingsHelper Instance] ConvertToRightDistance:[tempPlayer GetKmLeft]] * -1,[[GlobalSettingsHelper Instance] GetDistanceMeasurementString]];
            }
            else
                playerDistanceLabel.text = [NSString stringWithFormat:@"%@: %d %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance left"] ,[[GlobalSettingsHelper Instance] ConvertToRightDistance:[tempPlayer GetKmLeft]],[[GlobalSettingsHelper Instance] GetDistanceMeasurementString]];
            
        }
        
        
        //display the winner
        if (i == 0) 
        {
            [playerNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2,  70 + yOffset);
            [playerDistanceLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        }
        else 
        {
            playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2,  70 + yOffset);
        }
        
        playerDistanceLabel.center = CGPointMake([screen applicationFrame].size.width/2,  90 + yOffset);
        playerNameLabel.text = [NSString stringWithFormat:@"%@. %@: %d",[[tempPlayer GetName] retain],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Questions completed"] ,[tempPlayer GetQuestionsPassed]];
        lineImageView.center = CGPointMake([screen applicationFrame].size.width/2,  100 + yOffset);
        
        yOffset = yOffset + yOffsetConstant;
        
        [playerDistanceLabel setAlpha:0];
        [playerNameLabel setAlpha:0];
        [tempPlayer release];
    }
    m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, yOffset + 120);
    [players release];
    [screen release];
}

-(void) setUpMultiplayerMostPointsGame:(Game*) gameRef
{
    UIScreen *screen = [[UIScreen mainScreen] retain];
	NSInteger yOffset = 40;
	NSInteger yOffsetConstant = 70;
    Player *tempPlayer;
    NSString *measurementString = @"";
    NSArray *players = [[gameRef GetSortedPlayersForGame] retain];
    for (int i = 0; i < [players count]; i++) 
    {
        UILabel *playerNameLabel = [m_playerNameLabelsArray objectAtIndex:i];
        UILabel *playerDistanceLabel = [m_playerDistanceLabelsArray objectAtIndex:i];
        UIImageView *lineImageView = [m_linesArray objectAtIndex:i];
        tempPlayer = [[players objectAtIndex:i] retain];
        
        
        measurementString = [NSString stringWithFormat:@"%@: %d %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Combined distance to targets"] ,[[GlobalSettingsHelper Instance] ConvertToRightDistance:[tempPlayer GetTotalDistanceFromAllDestinations]],
                             [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]];
        
        //display the winner
        if (i == 0) 
        {
            [playerNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
            [playerDistanceLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        }
        
        playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2,  70 + yOffset);
        playerDistanceLabel.center = CGPointMake([screen applicationFrame].size.width/2,  90 + yOffset);
        if ([tempPlayer HasGivenUp]  == YES) {
            playerNameLabel.text = [NSString stringWithFormat:@"%@ %@",[tempPlayer GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"has given up"]];
            playerDistanceLabel.text = [NSString stringWithFormat:@"-"];
        }
        else
        {
            playerNameLabel.text = [NSString stringWithFormat:@"%@. %@: %d. %@: %d",[tempPlayer GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Score"],[tempPlayer GetScore],
                                    [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Seconds used"],[tempPlayer GetSecondsUsed]];
            playerDistanceLabel.text = [NSString stringWithFormat:@"%@",measurementString];
        }
        
        
        
        lineImageView.center = CGPointMake([screen applicationFrame].size.width/2,  100 + yOffset);
        
        yOffset = yOffset + yOffsetConstant;
        
        [playerDistanceLabel setAlpha:0];
        [playerNameLabel setAlpha:0];
        //[self addSubview:playerNameLabel];
        [tempPlayer release];
    }
    m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, yOffset + 120);
    [players release];
    [screen release];
}

-(void) setUpSinglePlayer:(Game*) gameRef
{
    UIScreen *screen = [[UIScreen mainScreen] retain];
//	NSInteger yOffset = 40;
//	NSInteger yOffsetConstant = 70;
	
	//NSMutableArray *players = [[gameRef GetSortedPlayersForGame] retain];
	Player *tempPlayer;
    
    self.userInteractionEnabled = NO;
    //NSMutableArray *players = [[gameRef GetPlayers] retain];
    UIImage *headerImage = [[UIImage imageNamed:@"GameOver.png"] retain];
    m_headerImageView.image = headerImage;
    [headerImage release];
    
    //tempPlayer = [[players objectAtIndex:0] retain];
    tempPlayer = [[gameRef GetPlayer] retain];
    //passed xx questions in easy game
    m_questionsPassedLabel.text = [NSString stringWithFormat:@"%@: %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Questions completed"],[tempPlayer GetQuestionsPassed]];
    m_questionsPassedLabel.center = CGPointMake([screen applicationFrame].size.width/2,  85);
    
    
    //score
    m_scoreLabel.text = [NSString stringWithFormat:@"%@: %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Score"],[tempPlayer GetScore]];
    m_scoreLabel.center = CGPointMake([screen applicationFrame].size.width/2,  105);
    
    NSInteger time = [tempPlayer GetSecondsUsed];
    NSString *seconds = [[NSString stringWithFormat:@"%d",time%60] retain];
    if ([seconds length] == 1 ) {
        m_secondsUsedLabel.text = [NSString stringWithFormat:@"%@: %d:0%d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time used"],time/60,time%60];
    }
    else {
        m_secondsUsedLabel.text = [NSString stringWithFormat:@"%@: %d:%d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time used"],time/60,time%60];
    }
    [seconds release];
    
    m_secondsUsedLabel.center = CGPointMake([screen applicationFrame].size.width/2,  130);
    
    m_localHeaderLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Local:"]];
    m_localHeaderLabel.center = CGPointMake([screen applicationFrame].size.width/2,  175);
    
    Highscore *hs = [gameRef GetHighscore];
    NSInteger newHighScorePlace = [hs CheckIfNewHighScore:tempPlayer difficultyLevel:[gameRef GetGameDifficulty]];
    if (newHighScorePlace < 99) {
        NSString *gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"];
        Difficulty diffLevel = [gameRef GetGameDifficulty];
        switch (diffLevel) {
            case hardDif:
            case veryhardDif:
                gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"];
                break;
            case medium:
                gameDifficultyString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"medium"];
            default:
                break;
        }
        m_localHighscoreLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"New local"],gameDifficultyString,[[GlobalSettingsHelper Instance] GetStringByLanguage:@"game highscore"],
                                      [[GlobalSettingsHelper Instance] GetStringByLanguage:@"at place"],newHighScorePlace];
        
        m_localHighscoreLabel.textAlignment = NSTextAlignmentLeft;
        
        UIImage *trophyImage = [[UIImage imageNamed:@"trophy.png"] retain];
        m_highscoreImageView.image = trophyImage;
        [trophyImage release];
        m_highscoreImageView.center = CGPointMake(30,  190);
        m_localHighscoreLabel.frame = CGRectMake(60,190,[m_localHighscoreLabel frame].size.width,  [m_localHighscoreLabel frame].size.height);
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1];
        [m_highscoreImageView setAlpha:1];
        [UIView commitAnimations];	
    }
    else {
        m_localHighscoreLabel.textAlignment = NSTextAlignmentCenter;
        m_localHighscoreLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"No local highscore"]];
        m_localHighscoreLabel.center = CGPointMake([screen applicationFrame].size.width/2,  190);
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
    
    
    
    
    m_globalHeaderLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Global:"]];
    m_globalHeaderLabel.center = CGPointMake([screen applicationFrame].size.width/2,  220);
    
    m_globalHighscoreLabel.textAlignment = NSTextAlignmentCenter;
    m_globalHighscoreLabel.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Waiting for result..."]];
    m_globalHighscoreLabel.center = CGPointMake([screen applicationFrame].size.width/2,  235);
    
    

     challengeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
     [challengeButton addTarget:self action:@selector(doChallenge) forControlEvents:UIControlEventTouchDown];
     [challengeButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Challenge"] forState:UIControlStateNormal];
     challengeButton.frame = CGRectMake(0, 0, 180.0, 40.0);
     challengeButton.center = CGPointMake([screen applicationFrame].size.width/2,350);
     [self addSubview:challengeButton];
    
    exitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [exitButton addTarget:self action:@selector(doSkip) forControlEvents:UIControlEventTouchDown];
    [exitButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Skip challenging"] forState:UIControlStateNormal];
    exitButton.frame = CGRectMake(0, 0, 180.0, 40.0);
    exitButton.center = CGPointMake([screen applicationFrame].size.width/2,390);
    [self addSubview:exitButton];
    
    
    [tempPlayer release];
    
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
	[m_scoreLabel setAlpha:1];
	[m_localHighscoreLabel setAlpha:1];
    [m_localHeaderLabel setAlpha:1];
    [m_globalHighscoreLabel setAlpha:1];
    [m_globalHeaderLabel setAlpha:1];
	[m_dynamicLabel setAlpha:1];
	[m_secondsUsedLabel setAlpha:1];
	[m_skyView setAlpha:0.5];
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
