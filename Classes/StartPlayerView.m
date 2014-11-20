//
//  StartPlayerView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "StartPlayerView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>


@implementation StartPlayerView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		m_labelsXoffset = 0;
		m_labelsYoffset = 0;

        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		
		m_playerNameLabel = [[UILabel alloc] init];
		[m_playerNameLabel setFrame:CGRectMake(60 + m_labelsXoffset, 60 + m_labelsYoffset, 250, 20)];
		m_playerNameLabel.backgroundColor = [UIColor clearColor]; 
		[m_playerNameLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
		m_playerNameLabel.textColor = [UIColor whiteColor];
		m_playerNameLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		m_playerNameLabel.layer.shadowOpacity = 1.0;
		m_playerNameLabel.layer.shadowRadius = 1.5;
		m_playerNameLabel.textAlignment = NSTextAlignmentCenter;
		[m_playerNameLabel setAlpha:0];
		[self addSubview:m_playerNameLabel];
		
		
		m_secondsUsedLabel = [[UILabel alloc] init];
		[m_secondsUsedLabel setFrame:CGRectMake(60 + m_labelsXoffset, 100 + m_labelsYoffset, 250, 20)];
		m_secondsUsedLabel.backgroundColor = [UIColor clearColor]; 
		[m_secondsUsedLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
//		m_secondsUsedLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_secondsUsedLabel.layer.shadowOpacity = 1.0;
//		m_secondsUsedLabel.layer.shadowRadius = 1.5;
		m_secondsUsedLabel.shadowColor = [UIColor whiteColor];
		m_secondsUsedLabel.shadowOffset = CGSizeMake(-1,-2);
		m_secondsUsedLabel.textAlignment = NSTextAlignmentCenter;
		[m_secondsUsedLabel setAlpha:0];
		[self addSubview:m_secondsUsedLabel];
		
		m_dynamicLabel1 = [[UILabel alloc] init];
		[m_dynamicLabel1 setFrame:CGRectMake(60 + m_labelsXoffset, 120 + m_labelsYoffset, 250, 20)];
		m_dynamicLabel1.backgroundColor = [UIColor clearColor]; 
		[m_dynamicLabel1 setFont:[UIFont boldSystemFontOfSize:14.0f]];
//		m_dynamicLabel1.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_dynamicLabel1.layer.shadowOpacity = 1.0;
//		m_dynamicLabel1.layer.shadowRadius = 1.5;
		m_dynamicLabel1.shadowColor = [UIColor whiteColor];
		m_dynamicLabel1.shadowOffset = CGSizeMake(-1,-2);
		m_dynamicLabel1.textAlignment = NSTextAlignmentCenter;
		[m_dynamicLabel1 setAlpha:0];
		[self addSubview:m_dynamicLabel1];
		
		
		m_dynamicLabel3 = [[UILabel alloc] init];
		[m_dynamicLabel3 setFrame:CGRectMake(60 + m_labelsXoffset, 180 + m_labelsYoffset, 250, 20)];
		m_dynamicLabel3.backgroundColor = [UIColor clearColor]; 
		[m_dynamicLabel3 setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_dynamicLabel3.textAlignment = NSTextAlignmentCenter;
//		m_dynamicLabel3.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_dynamicLabel3.layer.shadowOpacity = 1.0;
//		m_dynamicLabel3.layer.shadowRadius = 1.5;
		m_dynamicLabel3.shadowColor = [UIColor whiteColor];
		m_dynamicLabel3.shadowOffset = CGSizeMake(-1,-2);
		[m_dynamicLabel3 setAlpha:0];
		[self addSubview:m_dynamicLabel3];

		m_tapWhenReadyLabel = [[UILabel alloc] init];
		[m_tapWhenReadyLabel setFrame:CGRectMake(60 + m_labelsXoffset, 220 + m_labelsYoffset, 250, 20)];
		m_tapWhenReadyLabel.backgroundColor = [UIColor clearColor]; 
		m_tapWhenReadyLabel.textColor = [UIColor whiteColor];
		m_tapWhenReadyLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		m_tapWhenReadyLabel.layer.shadowOpacity = 1.0;
		m_tapWhenReadyLabel.layer.shadowRadius = 1.5;
		[m_tapWhenReadyLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		m_tapWhenReadyLabel.textAlignment = NSTextAlignmentCenter;
		[m_tapWhenReadyLabel setAlpha:0];
		[self addSubview:m_tapWhenReadyLabel];
		
		[self setUserInteractionEnabled:NO];
		
		self.hidden = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

	[self setUserInteractionEnabled:NO];
	NSLog(@"tap on StartPlayer view caught");
	//start timer for player
	[self FadeOut];
	
	//send message to sky view ---fadeout then hide
	//[m_playerRef StartTimer];
	[m_playerRef release];
}

-(void)SetPlayerRef:(Player*) playerRef gameRef:(Game*) gameRef
{
	m_playerRef = [playerRef retain];
	m_playerNameLabel.text = [[m_playerRef GetName] retain];
	m_secondsUsedLabel.text = [NSString stringWithFormat:@"%d %@",[m_playerRef GetSecondsUsed],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Seconds used"]];
	

    //questions passed
    m_dynamicLabel1.text = [NSString stringWithFormat:@"%@: %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Questions passed"],[m_playerRef GetQuestionsPassed]];

    //km/miles left
    NSInteger kmLeft = [m_playerRef GetKmLeft];

    
    m_dynamicLabel3.text = [NSString stringWithFormat:@"%d %@ %@", 
                            [[GlobalSettingsHelper Instance] ConvertToRightDistance:kmLeft],
                            [[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                            [[GlobalSettingsHelper Instance] GetStringByLanguage:@"left"]];

	
	m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
	
	
	//center labels
	UIScreen *screen = [[UIScreen mainScreen] retain];
	m_playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2, m_playerNameLabel.frame.origin.y + (m_playerNameLabel.frame.size.height/2) );
	m_secondsUsedLabel.center = CGPointMake([screen applicationFrame].size.width/2, m_secondsUsedLabel.frame.origin.y + (m_secondsUsedLabel.frame.size.height/2) );
	m_dynamicLabel1.center = CGPointMake([screen applicationFrame].size.width/2, m_dynamicLabel1.frame.origin.y + (m_dynamicLabel1.frame.size.height/2) );
	m_dynamicLabel3.center = CGPointMake([screen applicationFrame].size.width/2, m_dynamicLabel3.frame.origin.y + (m_dynamicLabel3.frame.size.height/2) );
	m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2, m_tapWhenReadyLabel.frame.origin.y + (m_tapWhenReadyLabel.frame.size.height/2) );
	[screen release];
}



-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(FinishedFadingOut)];   
    [self setAlpha:0];
	[UIView commitAnimations];	
}

- (void) FinishedFadingOut
{
	self.hidden = YES;
	if ([delegate respondsToSelector:@selector(StartPlayer)])
		[delegate StartPlayer];
}

-(void) FadeIn
{
	//[m_skyView FadeIn];
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self SetAlphaIn];
	[UIView commitAnimations];
	[self setUserInteractionEnabled:YES];
}

-(void) SetAlphaIn
{
	[m_playerNameLabel setAlpha:1];
	[m_tapWhenReadyLabel setAlpha:1];
	[m_secondsUsedLabel setAlpha:1];
	[m_dynamicLabel1 setAlpha:1];
	[m_dynamicLabel3 setAlpha:1];
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
