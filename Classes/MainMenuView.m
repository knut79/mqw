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
        
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
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
		
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.5];
		[self addSubview:m_skyView];
		
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
		buttonStartMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonStartMenu.center = CGPointMake([screen applicationFrame].size.width/2,160);
		[self addSubview:buttonStartMenu];
        
        buttonChallengesMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonChallengesMenu addTarget:self action:@selector(takeChallengeGameMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonChallengesMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Challenges"] forState:UIControlStateNormal];
		buttonChallengesMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonChallengesMenu.center = CGPointMake([screen applicationFrame].size.width/2,220);
		[self addSubview:buttonChallengesMenu];
		
		buttonSettingsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonSettingsMenu addTarget:self action:@selector(gameSettingsMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonSettingsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"] forState:UIControlStateNormal];
		buttonSettingsMenu.frame = CGRectMake(0, 0, 120.0, 40.0);
		buttonSettingsMenu.center = CGPointMake([screen applicationFrame].size.width/2,300);
//		[buttonSettingsMenu setAlpha:0];
		[self addSubview:buttonSettingsMenu];
		
		buttonOtherInfoMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonOtherInfoMenu addTarget:self action:@selector(otherInfoMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonOtherInfoMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Status"] forState:UIControlStateNormal];
		buttonOtherInfoMenu.frame = CGRectMake(0, 0, 120.0, 40.0);
		buttonOtherInfoMenu.center = CGPointMake([screen applicationFrame].size.width/2,360);
//		[buttonOtherInfoMenu setAlpha:0];
		[self addSubview:buttonOtherInfoMenu];


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

-(void)gameSettingsMenu:(id)Sender
{
	if(settingsMenuView == nil)
	{
		settingsMenuView = [[SettingsMenuView alloc] initWithFrame:[self frame]];
		[settingsMenuView setDelegate:self];
		[self addSubview:settingsMenuView];
	}

    [settingsMenuView FadeIn];
}


-(void) UpdateLabels
{
	[buttonOtherInfoMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Status"] forState:UIControlStateNormal];
	[buttonSettingsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"] forState:UIControlStateNormal];
	[buttonStartMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
}



-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
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

    [startGameMenu removeFromSuperview];
    startGameMenu = nil;
    
	if ([delegate respondsToSelector:@selector(PreStartNewGame:)])
        [delegate PreStartNewGame:gameRef];
}

-(void) cleanUpStartGameMenu
{
    [startGameMenu removeFromSuperview];
    startGameMenu = nil;
}

#pragma mark OtherDelegates
-(void) takeChallengeGameMenu:(id)Sender
{
    if (takeChallengeViewCtrl == nil) {
        takeChallengeViewCtrl = [[TakeChallenge alloc] initWithNibName:@"TakeChallenge" bundle:nil]; 
        [takeChallengeViewCtrl setDelegate:self];
        [self addSubview:takeChallengeViewCtrl.view];
    }
    else
        [takeChallengeViewCtrl.view setAlpha:1];
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


-(void) cleanUpOtherInfoView
{
    [otherInfoView removeFromSuperview];
    otherInfoView = nil;
}

- (void)cleanUpSettingsMenuView;
{
    [settingsMenuView removeFromSuperview];
    settingsMenuView = nil;
	[self UpdateLabels];
}


- (void)dealloc {
	[self removeFromSuperview];
    [super dealloc];
}
@end
