//
//  AnswerBarViewTop.m
//  MQNorway
//
//  Created by knut dullum on 03/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "AnswerBarViewTop.h"


@implementation AnswerBarViewTop

- (id)initWithFrame:(CGRect)frame {
	if ([super initWithFrame:frame] == nil) {
        return nil;
    }
	
	m_initialRect = (CGRect)frame;
	
	self.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
	m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 0, 30.0, 30.0)];
	m_label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 310, 30) ];
	m_label.backgroundColor = [UIColor clearColor];
	m_label.textAlignment = NSTextAlignmentCenter;
	[m_label setFont:[UIFont systemFontOfSize:12.0f]];
	
	m_tapToEnlarge = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, 310, 30) ];
	[m_tapToEnlarge setFont:[UIFont systemFontOfSize:12.0f]];
	m_tapToEnlarge.backgroundColor = [UIColor clearColor]; 
	m_tapToEnlarge.textAlignment = NSTextAlignmentCenter;
	
	m_resultLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, 280, 60) ];
	m_resultLabel.numberOfLines = 0;
	m_resultLabel.backgroundColor = [UIColor clearColor];
	m_resultLabel.lineBreakMode = UILineBreakModeWordWrap; 
	
	//m_resultLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:12.0];  
	m_resultLabel.font = [UIFont systemFontOfSize:12.0f];
	m_resultLabel.textAlignment = NSTextAlignmentLeft;
	
	UIImage *lineImage = [UIImage imageNamed:@"BarLineUp.png"];
	m_lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
	[m_lineImageView setImage:lineImage];
	[self addSubview:m_lineImageView];
	
	[self setAlpha:0];
	[self addSubview:m_resultLabel];
	[self addSubview:m_imageView];
	[self addSubview:m_label];
	[self addSubview:m_tapToEnlarge];
//	[m_label setAlpha:0];
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
		UIScreen *screen = [[UIScreen mainScreen] retain];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		//[UIView setAnimationDidStopSelector:@selector(doMoveOn)];
		if(self.frame.size.height < 100)
		{
			//strech
			[m_label setFont:[UIFont boldSystemFontOfSize:12.0f]];
			[m_tapToEnlarge setAlpha:0];
			[self setFrame:CGRectMake(0, 0, 320, 110)];
			[m_resultLabel setAlpha:1];
			m_resultLabel.center = CGPointMake([self frame].size.width/2, 52);
			[m_lineImageView setImage: [UIImage imageNamed:@"BarLineDown.png"]];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		
		}
		else {
			//shrink
			[m_label setFont:[UIFont systemFontOfSize:12.0f]];
			[m_tapToEnlarge setAlpha:1];
			[self setFrame:m_initialRect];
			[m_resultLabel setAlpha:0];
			m_resultLabel.center = CGPointMake([self frame].size.width/2, -(m_resultLabel.frame.size.height/2));
			[m_lineImageView setImage: [UIImage imageNamed:@"BarLineUp.png"]];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		}
		
		[UIView commitAnimations];	
		[screen release];
}



-(void) SetResult:(Game*) gameRef
{
	
	[self setFrame:m_initialRect];
	[m_tapToEnlarge setAlpha:1];
	
	m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
	[m_label setFont:[UIFont systemFontOfSize:12.0f]];
	
	m_tapToEnlarge.text = [NSString stringWithFormat:@"--%@--",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap this bar to get more info"]];
	m_imageView.hidden = YES;
	UIScreen *screen = [[UIScreen mainScreen] retain];
	Question* questionRef = [[gameRef GetQuestion] retain];
	
	NSMutableString *addInfo = [[[questionRef GetLocation] GetAdditionalInfo] retain];
	
	//set text for single player game
	//and multiplayergame , both last standing and most points
	if ([gameRef IsMultiplayer] == YES) 
	{
		//m_resultLabel.adjustsFontSizeToFitWidth = YES;
		m_label.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Target"],[questionRef GetName]];
		
	}
	//single player
	else 
	{
		NSInteger distanceFromDestination = [[gameRef GetPlayer] GetLastDistanceFromDestination];
		
		if (distanceFromDestination > 0) 
		{
//			DistanceMeasurement measurement = [[GlobalSettingsHelper Instance] GetDistance];
//			if (measurement == mile) {
//				m_label.text = [NSString stringWithFormat:@"%d %@ %@",[[GlobalSettingsHelper Instance] ConvertToRightDistance:distanceFromDestination],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"miles from destination"],[questionRef GetName]];
//			}
//			else
//			{
//				m_label.text = [NSString stringWithFormat:@"%d %@ %@",[[GlobalSettingsHelper Instance] ConvertToRightDistance:distanceFromDestination],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"km from destination"],[questionRef GetName]];
//			}
            
            m_label.text = [NSString stringWithFormat:@"%d %@ %@ %@",[[GlobalSettingsHelper Instance] ConvertToRightDistance:distanceFromDestination],[[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                [[GlobalSettingsHelper Instance] GetStringByLanguage:@"from destination"],[questionRef GetName]];
		}
		else 
		{
			m_label.text = [NSString stringWithFormat:@"%@ %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Correct location of"],[questionRef GetName]];
		}
	}
	
	m_label.numberOfLines = 1;
	m_label.adjustsFontSizeToFitWidth = YES;
	m_label.textAlignment = NSTextAlignmentCenter;
	
	if ([addInfo isEqualToString:@""]) {
		m_label.center = CGPointMake([screen applicationFrame].size.width/2, 20);
		[m_label setFont:[UIFont systemFontOfSize:14.0f]];
	}
	else {
		m_label.center = CGPointMake([screen applicationFrame].size.width/2, 8);
		[m_label setFont:[UIFont systemFontOfSize:12.0f]];
	}
	
	m_resultLabel.text = [NSString stringWithFormat:@"%@",[addInfo stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"]];
	
	m_resultLabel.center = CGPointMake([self frame].size.width/2, -(m_resultLabel.frame.size.height/2));
	
//	CGSize labelSize = [m_resultLabel.text sizeWithFont:m_resultLabel.font
//							  constrainedToSize:m_resultLabel.frame.size
//								  lineBreakMode:m_resultLabel.lineBreakMode];
//	m_resultLabel.frame = CGRectMake(
//							 m_resultLabel.origin.x, m_resultLabel.origin.y, 
//							 m_resultLabel.size.width, labelSize.height);
	//m_resultLabel.numberOfLines = 1;
	//m_resultLabel.adjustsFontSizeToFitWidth = YES;
	//m_resultLabel.textAlignment = NSTextAlignmentCenter;
	//m_resultLabel.center = CGPointMake([screen applicationFrame].size.width/2, 28);	
	
	
	//[m_resultLabel setFont:[UIFont systemFontOfSize:12.0f]];
	
//	NSLog([NSString stringWithFormat:@"resLab %@ , lab %@",m_resultLabel.text,m_label.text]);
	
	[m_resultLabel setAlpha:0];
	
	[addInfo release];
	[screen release];	
	[questionRef release];
//	[m_resultLabel setAlpha:1];
//	[m_label setAlpha:1];
}

//-(void) HideResultLabel
//{
//	[m_resultLabel setAlpha:0];
//}
//
//-(void) DisplayNonResult
//{
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.5];
//	[m_resultLabel setAlpha:0];
//	[m_label setAlpha:1];
//	[UIView commitAnimations];	
//}


-(void) FadeIn
{
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
