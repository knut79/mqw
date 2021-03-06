//
//  MainMenuView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "MainMenuView.h"
#import "EnumDefs.h"
#import "GlobalSettingsHelper.h"
#import "GlobalConstants.h"
#import "LocationsHelper.h"


@implementation MainMenuView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
        [self setAlpha:0];
        
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		//put before skyview to make less visible
		UILabel *copyrightLabel = [[UILabel alloc] init];
		[copyrightLabel setFrame:CGRectMake(80, 0, 180, 40)];
		copyrightLabel.textAlignment = NSTextAlignmentCenter;
		copyrightLabel.center = CGPointMake([screen applicationFrame].size.width/2, [screen applicationFrame].size.height - 30);
		copyrightLabel.backgroundColor = [UIColor clearColor]; 
		copyrightLabel.textColor = [UIColor whiteColor];
		[copyrightLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		copyrightLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@""];
		[self addSubview:copyrightLabel];
		[copyrightLabel release];
		
		//UIImage *miniLogoImage = [UIImage imageNamed:@"miniLogoMainMenu.png"];
		NSLog(@"minilogo is:%@",mini_logo_image);
		UIImage *miniLogoImage = [UIImage imageNamed:mini_logo_image];
		UIImageView *miniLogoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 220, 70)];
		miniLogoImageView.center = CGPointMake([screen applicationFrame].size.width/2, 70);
		[miniLogoImageView setImage:miniLogoImage];
		[self addSubview:miniLogoImageView];
        

		buttonStartMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonStartMenu addTarget:self action:@selector(startGameMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonStartMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
        buttonStartMenu.layer.borderWidth=1.0f;
        [buttonStartMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonStartMenu.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonStartMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonStartMenu.center = CGPointMake([screen applicationFrame].size.width/2,160);
		[self addSubview:buttonStartMenu];
        [buttonStartMenu setAlpha:0];
        
        buttonChallengesMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonChallengesMenu addTarget:self action:@selector(takeChallengeGameMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonChallengesMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Challenges"] forState:UIControlStateNormal];
        buttonChallengesMenu.layer.borderWidth=1.0f;
        [buttonChallengesMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonChallengesMenu.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonChallengesMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonChallengesMenu.center = CGPointMake([screen applicationFrame].size.width/2,220);
		[self addSubview:buttonChallengesMenu];
        [buttonChallengesMenu setAlpha:0];
        
       
        activityMessageLabel = [[UILabel alloc] init];
        [activityMessageLabel setFrame:CGRectMake(0, 0, 250, 40)];
        activityMessageLabel.backgroundColor = [UIColor clearColor];
        activityMessageLabel.textColor = [UIColor whiteColor];
        [activityMessageLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        activityMessageLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
        activityMessageLabel.layer.shadowOpacity = 1.0;
        activityMessageLabel.center = CGPointMake([screen applicationFrame].size.width/2,[screen applicationFrame].size.height*0.55);
        activityMessageLabel.text = @"Collecting user data";
        activityMessageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:activityMessageLabel];
        
        activityIndicatorCollectingId = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        [self addSubview:activityIndicatorCollectingId];
        activityIndicatorCollectingId.center = CGPointMake([screen applicationFrame].size.width/2,[screen applicationFrame].size.height*0.45);
        
        [activityIndicatorCollectingId startAnimating];
        

        /*
		buttonOtherInfoMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonOtherInfoMenu addTarget:self action:@selector(otherInfoMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonOtherInfoMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Status"] forState:UIControlStateNormal];
        buttonOtherInfoMenu.layer.borderWidth=1.0f;
        [buttonOtherInfoMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonOtherInfoMenu.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonOtherInfoMenu.frame = CGRectMake(0, 0, 120.0, 40.0);
		buttonOtherInfoMenu.center = CGPointMake([screen applicationFrame].size.width/2,360);
		[self addSubview:buttonOtherInfoMenu];
        */
        
        buttonHighscoreMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonHighscoreMenu addTarget:self action:@selector(highscoreMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
        buttonHighscoreMenu.layer.borderWidth=1.0f;
        [buttonHighscoreMenu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonHighscoreMenu.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonHighscoreMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonHighscoreMenu.center = CGPointMake([screen applicationFrame].size.width/2,280);
		[self addSubview:buttonHighscoreMenu];
        [buttonHighscoreMenu setAlpha:0];


		[screen release];
		
        if (startGameMenu == nil) {
            startGameMenu = [[StartGameMenu alloc] initWithFrame:[self frame]];
            startGameMenu.delegate = self;
            [startGameMenu ShowLoadingGameObjects];
            [self addSubview:startGameMenu];
        }
		
		[self performSelectorInBackground:@selector (LoadGameObjects) withObject:nil];
    }
    return self;
}

-(void) ShowChallengeButton
{
    [activityIndicatorCollectingId stopAnimating];
    
    [buttonChallengesMenu setAlpha:1];
    [buttonHighscoreMenu setAlpha:1];
    [buttonStartMenu setAlpha:1];
    
    activityIndicatorCollectingId.hidden = YES;
    activityMessageLabel.hidden = YES;
    [activityIndicatorCollectingId removeFromSuperview];
    [activityMessageLabel removeFromSuperview];
}

-(void)LoadGameObjects
{
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [LocationsHelper Instance];
    [self performSelectorOnMainThread:@selector(LoadGameObjectsDone)  
						   withObject:nil waitUntilDone:NO]; 
    [pool release];
}

-(void)LoadGameObjectsDone
{
	[startGameMenu SetFinishedLoadingGameObjects];
}


-(void) UpdateLabels
{
	//[buttonOtherInfoMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Status"] forState:UIControlStateNormal];
	[buttonStartMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
    [buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
}



-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.6];
	[self setAlpha:0];
	[UIView commitAnimations];	
}


#pragma mark StartGameMenuViewDelegate

//switch to map view and start game
- (void)cleanUpStartGameMenuAndStart:(Game *)gameRef {

    [self cleanUpStartGameMenu];
    
	if ([delegate respondsToSelector:@selector(PreStartNewGame:)])
        [delegate PreStartNewGame:gameRef];
}

-(void) cleanUpStartGameMenu
{
    
    [startGameMenu removeFromSuperview];
    //[startGameMenu dealloc];
    startGameMenu = nil;
     
}

#pragma mark OtherDelegates
-(void) takeChallengeGameMenu:(id)Sender
{
    if (takeChallengeViewCtrl == nil) {
        takeChallengeViewCtrl = [[TakeChallenge alloc] initWithNibName:@"TakeChallenge" bundle:nil]; 
        [takeChallengeViewCtrl setDelegate:self];
        [self addSubview:takeChallengeViewCtrl.view];
        [takeChallengeViewCtrl FadeIn];
    }
    else
    {
        [takeChallengeViewCtrl FadeIn];
    }
}

-(void) cleanUpTakeChallengeViewCtrl
{
    //_?
    //[takeChallengeViewCtrl release];
    //[takeChallengeViewCtrl removeFromParentViewController];
    takeChallengeViewCtrl = nil;
}

-(void)startGameMenu:(id)Sender
{
	if (startGameMenu == nil) {
		startGameMenu = [[StartGameMenu alloc] initWithFrame:[self frame]];
		startGameMenu.delegate = self;
		[self addSubview:startGameMenu];
	}
    
    [startGameMenu UpdateLabels];
    [startGameMenu FadeIn];
}

/*
-(void) otherInfoMenu:(id)Sender
{
	if(otherInfoView == nil)
	{
		otherInfoView = [[OtherInfoView alloc] initWithFrame:[self frame]];
		[otherInfoView setDelegate:self];
        [self addSubview:otherInfoView];
		[otherInfoView FadeIn];
	}
	else {
		[otherInfoView UpdateLabels];
		[otherInfoView FadeIn];
	}
}
*/

-(void)highscoreMenu:(id)Sender
{
    if (highscoreGlobalView == nil) {
		highscoreGlobalView = [[HighscoreGlobalView alloc] initWithFrame:[self frame]];
		[highscoreGlobalView setDelegate:self];
		[self addSubview:highscoreGlobalView];
		[highscoreGlobalView FadeIn];
	}
	else {
		[highscoreGlobalView UpdateLabels];
		//if flagged new highscores
		[highscoreGlobalView FadeIn];
    }
}

-(void)cleanUpHigscoreGlobalView
{
	[highscoreGlobalView removeFromSuperview];
	//[highscoreGlobalView dealloc];
	highscoreGlobalView = nil;
}

/*
-(void) cleanUpOtherInfoView
{
    [otherInfoView removeFromSuperview];
    otherInfoView = nil;
}
*/

- (void)cleanUpSettingsMenuView;
{
	[self UpdateLabels];
}


- (void)dealloc {
	[self removeFromSuperview];
    [super dealloc];
}
@end
