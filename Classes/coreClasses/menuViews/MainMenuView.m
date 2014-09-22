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


@implementation MainMenuView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		UILabel *copyrightLabel = [[UILabel alloc] init];
		[copyrightLabel setFrame:CGRectMake(80, 0, 180, 40)];
		copyrightLabel.textAlignment = UITextAlignmentCenter;
		copyrightLabel.center = CGPointMake([screen applicationFrame].size.width/2, [screen applicationFrame].size.height - 30);
		copyrightLabel.backgroundColor = [UIColor clearColor]; 
		copyrightLabel.textColor = [UIColor whiteColor];
		[copyrightLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		copyrightLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"© 2011"];
		[self addSubview:copyrightLabel];
		[copyrightLabel release];
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.5];
		[self addSubview:m_skyView];
		
		buttonStartMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonStartMenu addTarget:self action:@selector(startGameMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonStartMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
		buttonStartMenu.frame = CGRectMake(80.0, 60.0, 160.0, 40.0);
		buttonStartMenu.center = CGPointMake([screen applicationFrame].size.width/2,70);
		[self addSubview:buttonStartMenu];
		
		buttonSettingsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonSettingsMenu addTarget:self action:@selector(gameSettingsMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonSettingsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"] forState:UIControlStateNormal];
		buttonSettingsMenu.frame = CGRectMake(80.0, 160.0, 160.0, 40.0);
		buttonSettingsMenu.center = CGPointMake([screen applicationFrame].size.width/2,170);
		[self addSubview:buttonSettingsMenu];
		
		buttonInstructionsMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonInstructionsMenu addTarget:self action:@selector(instructionsMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonInstructionsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"] forState:UIControlStateNormal];
		buttonInstructionsMenu.frame = CGRectMake(80.0, 260.0, 160.0, 40.0);
		buttonInstructionsMenu.center = CGPointMake([screen applicationFrame].size.width/2,270);
		[self addSubview:buttonInstructionsMenu];
		
		buttonHighscoreMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonHighscoreMenu addTarget:self action:@selector(highscoreMenu:) forControlEvents:UIControlEventTouchDown];
		[buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
		buttonHighscoreMenu.frame = CGRectMake(80.0, 360.0, 160.0, 40.0);
		buttonHighscoreMenu.center = CGPointMake([screen applicationFrame].size.width/2,370);
		[self addSubview:buttonHighscoreMenu];

		[screen release];
    }
    return self;
}


-(void)gameSettingsMenu:(id)Sender
{
	if(settingsMenuView == nil)
	{
		settingsMenuView = [[SettingsMenuView alloc] initWithFrame:[self frame]];
		[settingsMenuView setDelegate:self];
		[self addSubview:settingsMenuView];
		[settingsMenuView FadeIn];
	}
	else {
		[settingsMenuView FadeIn];
	}

}

-(void) instructionsMenu:(id)Sender
{
	if(instructionsView == nil)
	{
		instructionsView = [[InstructionsView alloc] initWithFrame:[self frame]];
		[self addSubview:instructionsView];
		[instructionsView FadeIn];
	}
	else {
		[instructionsView UpdateText];
		[instructionsView FadeIn];
	}
}

- (void)SettingsMenuViewHiding;
{
	[self UpdateLabels];
}

-(void) UpdateLabels
{
	[buttonHighscoreMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore"] forState:UIControlStateNormal];
	[buttonSettingsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"] forState:UIControlStateNormal];
	[buttonStartMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
	[buttonInstructionsMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"] forState:UIControlStateNormal];
}

-(void)startGameMenu:(id)Sender
{
	if (startGameMenu == nil) {
		startGameMenu = [[StartGameMenu alloc] initWithFrame:[self frame]];
		startGameMenu.delegate = self;
		[self addSubview:startGameMenu];
		[startGameMenu FadeIn];
	}
	else {
		[startGameMenu UpdateLabels];
		[startGameMenu FadeIn];
	}
}

-(void)highscoreMenu:(id)Sender
{
	if (highscoreView == nil) {
		highscoreView = [[HighscoreView alloc] initWithFrame:[self frame]];
		[self addSubview:highscoreView];
		[highscoreView FadeIn];
	}
	else {
		[highscoreView UpdateLabels];
		//if flagged new highscores
		[highscoreView ReadHighscoresIntoArrays];
		[highscoreView FadeIn];
	}
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
	[UIView setAnimationDuration:0.9];
	[self setAlpha:0];
	[UIView commitAnimations];	
}



#pragma mark StartGameMenuViewDelegate

- (void)switchToMapViewAndStart:(Game *) gameRef {
	//pass throug to gamemenuviewcontroller
	if ([delegate respondsToSelector:@selector(switchToMapViewAndStart:)])
        [delegate switchToMapViewAndStart:gameRef];
}


- (void)dealloc {
    [super dealloc];
}
@end
