//
//  OtherInfoView.m
//  MQNorway
//
//  Created by knut dullum on 03/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "OtherInfoView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>


@implementation OtherInfoView
@synthesize delegate;
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame]; 
    if (self) {
		[self setAlpha:0];
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[m_skyView setBackgroundFile:@"clouds.png"];
		[self addSubview:m_skyView];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(100, 0, 250, 40)];
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,25);
		headerLabel.textAlignment = NSTextAlignmentCenter;

		headerLabel.backgroundColor = [UIColor clearColor]; 

		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];

		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Status"];
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
	
		[self addSubview:headerLabel];

		
//		buttonInstructionsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		[buttonInstructionsMenu addTarget:self action:@selector(instructionsMenu:) forControlEvents:UIControlEventTouchDown];
//		[buttonInstructionsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"] forState:UIControlStateNormal];
//		buttonInstructionsMenu.frame = CGRectMake(80.0, 260.0, 160.0, 40.0);
//		buttonInstructionsMenu.center = CGPointMake([screen applicationFrame].size.width/2,100);
//		[self addSubview:buttonInstructionsMenu];
		
		buttonStatisticsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonStatisticsMenu addTarget:self action:@selector(statisticsMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonStatisticsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Answer stats"] forState:UIControlStateNormal];
		buttonStatisticsMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonStatisticsMenu.center = CGPointMake([screen applicationFrame].size.width/2,100);
		[self addSubview:buttonStatisticsMenu];
		
		buttonHighscoreMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonHighscoreMenu addTarget:self action:@selector(highscoreMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
		buttonHighscoreMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonHighscoreMenu.center = CGPointMake([screen applicationFrame].size.width/2,150);
		[self addSubview:buttonHighscoreMenu];
        
        buttonPlayerStatsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonPlayerStatsMenu addTarget:self action:@selector(playerStatsMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonPlayerStatsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player stats"] forState:UIControlStateNormal];
		buttonPlayerStatsMenu.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonPlayerStatsMenu.center = CGPointMake([screen applicationFrame].size.width/2,200);
		[self addSubview:buttonPlayerStatsMenu];
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(0, 0, 160.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,270);
		[self addSubview:buttonBack];
		
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
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(TellParentToCleanUp)]; 
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void) TellParentToCleanUp
{
	if ([delegate respondsToSelector:@selector(cleanUpOtherInfoView)])
		[delegate cleanUpOtherInfoView];
}

-(void) UpdateLabels
{
	[buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
	[buttonInstructionsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"] forState:UIControlStateNormal];
	[buttonStatisticsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Statistics"] forState:UIControlStateNormal];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Other info"];
}


-(void) statisticsMenu:(id)Sender
{
	if(statisticsView == nil)
	{
		statisticsView = [[StatisticsView alloc] initWithFrame:[self frame]];
        [statisticsView setDelegate:self];
		[self addSubview:statisticsView];
	}

	[statisticsView FadeIn];
}


-(void) instructionsMenu:(id)Sender
{
	if(instructionsView == nil)
	{
		instructionsView = [[InstructionsView alloc] initWithFrame:[self frame]];
        [instructionsView setDelegate:self];
		[self addSubview:instructionsView];
		[instructionsView FadeIn];
	}
	else {
		[instructionsView UpdateText];
		[instructionsView FadeIn];
	}
}

-(void)highscoreMenu:(id)Sender
{
	if (highscoreView == nil) {
		highscoreView = [[HighscoreTopLevelMenu alloc] initWithFrame:[self frame]];
		[highscoreView setDelegate:self];
        [self addSubview:highscoreView];
	}
	else {
		[highscoreView UpdateLabels];
	}
    [highscoreView FadeIn];
}

-(void)playerStatsMenu:(id)Sender
{
    if (playerstatsViewCtrl == nil) {
        playerstatsViewCtrl = [[PlayerStats alloc] initWithNibName:@"PlayerStats" bundle:nil]; 
        [playerstatsViewCtrl setDelegate:self];
        [self addSubview:playerstatsViewCtrl.view];
    }
    else
        [playerstatsViewCtrl.view setAlpha:1];
}
#pragma mark delegatemethods
-(void) cleanUpPlayerStatsViewCtrl
{
    //_?
    [playerstatsViewCtrl release];
    //[playerstatsViewCtrl removeFromParentViewController];
    playerstatsViewCtrl = nil;
}
-(void) cleanUpHighscoreTopLevelMenu
{
    [highscoreView release];
    [highscoreView removeFromSuperview];
    highscoreView = nil;
}

-(void) cleanUpStatisticsView
{
    [statisticsView release];
    [statisticsView removeFromSuperview];
    statisticsView = nil;
}

-(void) cleanUpInstructionsView
{
    [instructionsView release];
    [instructionsView removeFromSuperview];
    instructionsView = nil;
}

- (void)drawRect:(CGRect)dirtyRect {
    // Drawing code here.
}

@end
