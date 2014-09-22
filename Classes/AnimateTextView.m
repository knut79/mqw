//
//  AnimateTextView.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "AnimateTextView.h"
#import "GlobalSettingsHelper.h"


@implementation AnimateTextView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        m_textForAnimation = @"";
		m_timerNumerator = 0;
		m_fontSize = 5.0;
		m_textAlpha = 0.0;
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_textY = [screen applicationFrame].size.height/2;
		m_textX = ([screen applicationFrame].size.width/2) - 50;
		m_imageX = [screen applicationFrame].size.width/2;
		m_imageY = [screen applicationFrame].size.height/2;
		m_imageWidth = 220;
		m_imageHeight = 50;
		
		m_animatingText = NO;
		m_animatingTapImage = NO;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		m_animateTapImageSwitch = 0;
		m_limitTapMessages = 0;
		
		m_messageLabel = [[UILabel alloc] init];
		[m_messageLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_messageLabel.center = CGPointMake([screen applicationFrame].size.width /2 , [screen applicationFrame].size.height /2 );
		m_messageLabel.backgroundColor = [UIColor clearColor]; 
		[m_messageLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_messageLabel.textAlignment = NSTextAlignmentCenter;
		m_messageLabel.shadowColor = [UIColor whiteColor];
		m_messageLabel.shadowOffset = CGSizeMake(-1,-2);
		[m_messageLabel setAlpha:0];
		[self addSubview:m_messageLabel];
		
		
		CGRect imageRect = CGRectMake(0,0, 223, 57);
		m_tapMessageImageView = [[[UIImageView alloc] initWithFrame:imageRect] retain];
		m_tapMessageImageView.center = CGPointMake([screen applicationFrame].size.width /2 , [screen applicationFrame].size.height /2 );
		m_imageName = [[NSString stringWithFormat:@"%@.png",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"tapImage2"]] retain];
		m_tapMessageImageView.image = [UIImage imageNamed:m_imageName];
		[m_tapMessageImageView setAlpha:0];
		[self addSubview:m_tapMessageImageView];
		
		self.hidden == YES;
		[screen release];
    }
    return self;
}

-(void) setText:(NSString*) text
{
	self.userInteractionEnabled = NO;
	m_textForAnimation = [text retain];
	m_messageLabel.text = [text retain];
}

-(void) setImage:(NSString*) imageName
{
	self.userInteractionEnabled = NO;
	m_imageName = [imageName retain];
	m_tapMessageImageView.image = [UIImage imageNamed:m_imageName];
}

-(void) startTextAnimation
{
	m_imageName = [[NSString stringWithFormat:@"%@.png",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"tapImage2"]] retain];
	m_tapMessageImageView.image = [UIImage imageNamed:m_imageName];
	[m_tapMessageImageView setAlpha:0.0];
	[m_messageLabel setAlpha:1];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(explodeDone)];
	[m_messageLabel setTransform:CGAffineTransformMakeScale(6, 6)];
	[m_messageLabel setAlpha:0];
	[UIView commitAnimations];
	
	[self setAlpha:1];
}

-(void) explodeDone
{
	[m_messageLabel setTransform:CGAffineTransformIdentity];
	[self startTapMessage];
}


-(void) startTapMessage
{
	self.userInteractionEnabled = YES;
	[self setAlpha:1.0];
	
	[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDelay:1.0];
	[UIView setAnimationDuration:1.6];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startTapMessageAnimation)];
	[m_tapMessageImageView setAlpha:0.4];
	[UIView commitAnimations];
}


-(void) startTapMessageAnimation
{

	[UIView beginAnimations:nil context:NULL];
	//[UIView setAnimationDelay:1.0];
	[UIView setAnimationDuration:1];
	[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationRepeatCount:3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(tapImageAnimationDone)];
	[m_tapMessageImageView setAlpha:1.0];
	[UIView commitAnimations];
}

-(void) tapImageAnimationDone
{
//	[m_tapMessageImageView setAlpha:0];
//	[m_tapMessageImageView setTransform:CGAffineTransformIdentity];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"tap on animated view caught");
	[m_tapMessageImageView setAlpha:0.0];
	//[self endTapAnimation];
	[self fadeOut];
}


-(void) fadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(doMoveOn)];
	
	[self setAlpha:0.0];
	[UIView commitAnimations];	
}

-(void)doMoveOn
{
	if ([delegate respondsToSelector:@selector(finishedShowingResultMap)])
        [delegate finishedShowingResultMap];
}

@end
