//
//  EnterBackgroundMenuView.m
//  MQNorway
//
//  Created by knut dullum on 18/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "EnterBackgroundMenuView.h"
#import "GlobalSettingsHelper.h"


@implementation EnterBackgroundMenuView


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		buttonResume = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonResume addTarget:self action:@selector(doResume:) forControlEvents:UIControlEventTouchDown];
		[buttonResume setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Resume"] forState:UIControlStateNormal];
		buttonResume.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonResume.center = CGPointMake([screen applicationFrame].size.width/2,[screen applicationFrame].size.height/2);
		[self addSubview:buttonResume];
		
		[screen release];
		
    }
    return self;
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
	[UIView setAnimationDuration:0.5];
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void)doResume:(id)Sender
{
	self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
