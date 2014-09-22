//
//  StoreView.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "StoreView.h"
#import "GlobalSettingsHelper.h"


@implementation StoreView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
		[self setAlpha:0];
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[m_skyView setBackgroundFile:@"clouds.png"];
		[self addSubview:m_skyView];
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,240);
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
	[UIView setAnimationDuration:0.9];
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

-(void) UpdateLabels
{
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
}


- (void)drawRect:(CGRect)dirtyRect {
    // Drawing code here.
}

@end
