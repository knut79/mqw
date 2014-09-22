//
//  HighscoreTopLevelMenu.m
//  MQNorway
//
//  Created by knut dullum on 24/09/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "HighscoreTopLevelMenu.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation HighscoreTopLevelMenu
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
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore menu"];
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		[self addSubview:headerLabel];
		

		buttonHighscoreLocal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonHighscoreLocal addTarget:self action:@selector(highscoreLocal:) forControlEvents:UIControlEventTouchDown];
		[buttonHighscoreLocal setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Local Highscore"] forState:UIControlStateNormal];
		buttonHighscoreLocal.frame = CGRectMake(80.0, 260.0, 160.0, 40.0);
		buttonHighscoreLocal.center = CGPointMake([screen applicationFrame].size.width/2,160);
		[self addSubview:buttonHighscoreLocal];
		
		buttonHighscoreGlobal = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonHighscoreGlobal addTarget:self action:@selector(highscoreGlobal:) forControlEvents:UIControlEventTouchDown];
		[buttonHighscoreGlobal setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Global Highscore"] forState:UIControlStateNormal];
		buttonHighscoreGlobal.frame = CGRectMake(80.0, 360.0, 160.0, 40.0);
		buttonHighscoreGlobal.center = CGPointMake([screen applicationFrame].size.width/2,220);
		[self addSubview:buttonHighscoreGlobal];
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 260.0, 160.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,320);
		[self addSubview:buttonBack];
		
		[screen release];
		
		
    }
    return self;
}

-(void)highscoreLocal:(id)Sender
{
	if (highscoreLocalView == nil) {
		highscoreLocalView = [[HighscoreLocalView alloc] initWithFrame:[self frame]];
        [highscoreLocalView setDelegate:self];
		[self addSubview:highscoreLocalView];
		[highscoreLocalView FadeIn];
	}
	else {
		[highscoreLocalView UpdateLabels];
		//if flagged new highscores
		[highscoreLocalView ReadHighscoresIntoArrays];
		[highscoreLocalView FadeIn];
	}
}

-(void)highscoreGlobal:(id)Sender
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

-(void)cleanUpHigscoreLocalView
{
	[highscoreLocalView removeFromSuperview];
	//[highscoreGlobalView dealloc];
	highscoreLocalView = nil;
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
    if ([delegate respondsToSelector:@selector(cleanUpHighscoreTopLevelMenu)])
    		[delegate cleanUpHighscoreTopLevelMenu];
}


-(void) UpdateLabels
{
	[buttonHighscoreLocal setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Local Highscore"] forState:UIControlStateNormal];
	[buttonHighscoreGlobal setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Global Highscore"] forState:UIControlStateNormal];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscore menu"];
}

- (void)dealloc {
    [super dealloc];
}


@end
