//
//  RestartView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "RestartView.h"
#import "GlobalSettingsHelper.h"


@implementation RestartView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[self addSubview:m_skyView];
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		buttonMainMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonMainMenu addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchDown];
		[buttonMainMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Main menu"] forState:UIControlStateNormal];
		buttonMainMenu.frame = CGRectMake(80.0, 60.0, 160.0, 40.0);
		buttonMainMenu.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) - 40);
		[self addSubview:buttonMainMenu];
		
		buttonRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonRestart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchDown];
		[buttonRestart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Restart game"] forState:UIControlStateNormal];
		buttonRestart.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
		buttonRestart.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) + 40);
		[self addSubview:buttonRestart];
		
		[self setAlpha:0];
		
		[screen release];
		
		self.hidden = YES;
    }
    return self;
}

-(void) mainMenu
{
	//self.hidden = YES;
	[self FadeOut];
	if ([delegate respondsToSelector:@selector(DisplayMainMenu)])
		[delegate DisplayMainMenu];
}

-(void) restart
{
	//self.hidden = YES;
	[self FadeOut];
	if ([delegate respondsToSelector:@selector(RestartGame)])
		[delegate RestartGame];
}


-(void) FadeIn
{
	[buttonMainMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Main menu"] forState:UIControlStateNormal];
	[buttonRestart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Restart game"] forState:UIControlStateNormal];
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.5];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:0];
	[UIView commitAnimations];	
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
