//
//  ClockView.m
//  MQNorway
//
//  Created by knut dullum on 21/08/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "ClockView.h"
#import <QuartzCore/QuartzCore.h>


@implementation ClockView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(5, 130, 40, 40)];
    if (self) {
		[self setAlpha:0];
		
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 1;
		self.layer.cornerRadius = 20;
		self.layer.masksToBounds = YES;
        [self setBackgroundColor: [UIColor greenColor]];
		
		//UIImage *directionsImage = retain];
		watchHandView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,0.0, 40, 40)];
		watchHandView.image = [UIImage imageNamed:@"watchhand.png"];
		[self addSubview:watchHandView];
		watchHandView.center = CGPointMake(20,20);
		angle = 0.0f;
		timeMultiplier = 2;
		
		timesTimeLabel = [[UILabel alloc] init];
		[timesTimeLabel setFrame:CGRectMake(0, 0, 15, 15)];
		timesTimeLabel.center = CGPointMake(10,10);
		timesTimeLabel.textAlignment = NSTextAlignmentCenter;
		timesTimeLabel.backgroundColor = [UIColor clearColor]; 
		timesTimeLabel.textColor = [UIColor whiteColor];
		[timesTimeLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
		timesTimeLabel.text = @"2";
				timesTimeLabel.shadowColor = [UIColor blackColor];
				timesTimeLabel.shadowOffset = CGSizeMake(1,1);
		[self addSubview:timesTimeLabel];


    }
    return self;
}

//-(void) StartClock
//{
//
//	[UIView beginAnimations:@"fade" context:nil];
//	[UIView setAnimationDuration:15];
//	[self setBackgroundColor: [UIColor redColor]];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
//	timer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(hadleTimer:) userInfo: nil repeats: YES];
//
//	[UIView commitAnimations];	
//}

-(void) StartClock
{
    m_clockRunning = TRUE;
	[self FadeIn];
	timeMultiplier = 2;
	timesTimeLabel.text = @"2";
	watchHandView.center = CGPointMake(20,20);
	angle = 0.0f;
	
	[NSThread detachNewThreadSelector:@selector(startAnimTimer) toTarget:self withObject:nil];
	//timer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(hadleTimer:) userInfo: nil repeats: YES];
	
}

-(void) startAnimTimer
{
	red = 0.0;
	green = 1.0;
	NSAutoreleasePool *newPool = [[NSAutoreleasePool alloc] init];
	NSRunLoop* runLoop = [NSRunLoop currentRunLoop];
	masterTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/20.0 target:self selector:@selector(timerIteration) userInfo:nil repeats:YES];
	[runLoop run];
	[newPool drain];
}

-(void)timerIteration
{
	@try {
	

	angle += 0.05;
	if (angle > 6.283) { 
		angle = 0;
		//[self DeductPoint];
		timeMultiplier --;
		timesTimeLabel.text = [NSString stringWithFormat:@"%d",timeMultiplier];
	}
	
	if (timeMultiplier <= 0) {
		//[timer invalidate];
        m_clockRunning = FALSE;
		[masterTimer invalidate];
		timesTimeLabel.text = @"0";
		[self FadeOut];
	}
	red += 0.005;
	green -= 0.005;
	
	if (red > 1.0) {
		red = 1.0;
	}
	if (green < 0.1) {
		green = 0.1;
	}

	[self setBackgroundColor: [UIColor colorWithRed:red green:green blue:0.0 alpha:0.5]];
	
	CGAffineTransform transform=CGAffineTransformMakeRotation(angle);
	watchHandView.transform = transform;

		
	}
	@catch (NSException * e) {
		NSLog(@"failed in timerIteration: %@",e);
        m_clockRunning = FALSE;
		[masterTimer invalidate];
		[self FadeOut];
	}
	
	
}

-(NSInteger) GetMultiplier
{
    return timeMultiplier;
}



-(void) DeductPoint
{
//	if ([delegate respondsToSelector:@selector(DeductPoint)])
//        [delegate DeductPoint];
	
//	[UIView beginAnimations:@"fade" context:nil];
//	[UIView setAnimationDuration:5];
//	[pointLabel setAlpha:1];
//	pointLabel.center = CGPointMake(70, 70);
//	[UIView commitAnimations];	
}

//-(void)hadleTimer:(NSTimer *)timer
//{
//	angle += 0.01;
//	if (angle > 6.283) { 
//		angle = 0;
//		[self DeductPoint];
//		timesDeductedPoint ++;
//	}
//	
//	if (timesDeductedPoint >= 2) {
//		[timer invalidate];
//	}
//	
//	
//	
//	CGAffineTransform transform=CGAffineTransformMakeRotation(angle);
//	watchHandView.transform = transform;
//}

-(void)stop
{
    if (m_clockRunning == TRUE) {
        m_clockRunning = FALSE;
        [masterTimer invalidate];
    }
	
}

-(void) FadeOut
{
	//[loadingLabel setAlpha:1];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void) FadeIn
{
	//[loadingLabel setAlpha:1];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[UIView commitAnimations];	
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
