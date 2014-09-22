//
//  QuestionView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "QuestionBarViewTop.h"
#import "GlobalSettingsHelper.h"


@implementation QuestionBarViewTop

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
	if ([super initWithFrame:frame] == nil) {
        return nil;
    }


	self.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
	m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 0, 30.0, 30.0)];
	m_label = [[UILabel alloc]init];
	m_touchEnabled = NO;
	m_label.backgroundColor = [UIColor clearColor]; 
	
	m_tapToEnlarge = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, 310 - 30, 15)];
	[m_tapToEnlarge setFont:[UIFont systemFontOfSize:12.0f]];
	m_tapToEnlarge.backgroundColor = [UIColor clearColor]; 
	
	UIImage *lineImage = [UIImage imageNamed:@"BarLine.png"];
	m_lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
	m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
	[m_lineImageView setImage:lineImage];
	[self addSubview:m_lineImageView];

	[self addSubview:m_imageView];
	[self addSubview:m_label];
	[self addSubview:m_tapToEnlarge];
	[self setAlpha:0];
	
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	if (m_touchEnabled) {

		UIScreen *screen = [[UIScreen mainScreen] retain];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];
		//[UIView setAnimationDidStopSelector:@selector(doMoveOn)];
		if(self.frame.size.height < 200)
		{
			//strech
			[self setFrame:CGRectMake(0, 0, 320, 480)];
			[m_lineImageView setAlpha:0];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
			[m_imageView setFrame:CGRectMake(([screen applicationFrame].size.width/2) - (m_image.size.width/2), ([screen applicationFrame].size.height/2) - (m_image.size.height/2), m_image.size.width, m_image.size.height)];
			
			[m_tapToEnlarge setAlpha:0];
			
			[m_label setFrame:CGRectMake(2, 2, 310, 20)];
			m_label.textAlignment = NSTextAlignmentCenter;
			CGPoint centerPoint = CGPointMake([screen applicationFrame].size.width/2, 13);
			m_label.center = centerPoint;
			
			if ([delegate respondsToSelector:@selector(HideGameIcons)])
				[delegate HideGameIcons];
			
		}
		else {
			//shrink
			[self setFrame:CGRectMake(0,0, 320, 50)];
			[m_lineImageView setAlpha:1];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
			[m_imageView setFrame:CGRectMake(5, 5, 30.0, 30.0)];
			
			m_tapToEnlarge.text = [NSString stringWithFormat:@"--%@--",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap image to resize"]];
			[m_tapToEnlarge setAlpha:1];
			
			m_label.textAlignment = NSTextAlignmentLeft;
			[m_label setFrame:CGRectMake(40, 2, 310 - 30, 20)];
			
			if ([delegate respondsToSelector:@selector(ShowGameIcons)])
				[delegate ShowGameIcons];
		}

		[UIView commitAnimations];	
		[screen release];
	}

	
}


-(void) SetQuestion:(NSString *) currentPlayerName gameRef:(Game*) gameRef
{
	//_? maby retain .. release on currentQuestion
	Question* currentQuestion = [gameRef GetQuestion];
	m_touchEnabled = NO;
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[m_label setFont:[UIFont systemFontOfSize:12.0f]];
	m_label.numberOfLines = 1;
	m_label.adjustsFontSizeToFitWidth = YES;
	m_label.textAlignment = NSTextAlignmentCenter;

	float questionLabelWidth = 310;
	if ([currentQuestion UsingPicture] == YES) {
		[self setFrame:CGRectMake(0,0, 320, 50)];
		[m_lineImageView setImage:[UIImage imageNamed:@"BarLineUp.png"]];
		m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		m_touchEnabled = YES;
		m_label.textAlignment = NSTextAlignmentLeft;
		[m_label setFrame:CGRectMake(40, 2, questionLabelWidth - 30, 20)];
		m_imageView.hidden = NO;
		m_tapToEnlarge.hidden = NO; 
		m_tapToEnlarge.text = [NSString stringWithFormat:@"--%@--",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap to resize image"]];

		m_image = [currentQuestion GetPicture];
		[m_imageView setFrame:CGRectMake(5, 5, 30.0, 30.0)];
		[m_imageView setImage:m_image];
		questionLabelWidth =280;
	}
	else {
		[self setFrame:CGRectMake(0,0, 320, 40)];
		[m_lineImageView setImage:[UIImage imageNamed:@"BarLine.png"]];
		m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		//[self setFrame:CGRectMake(0,0, 320, 40)];
		m_imageView.hidden = YES;
		m_tapToEnlarge.hidden = YES; 
		[m_label setFrame:CGRectMake(2, 2, questionLabelWidth, 40)];
		m_label.textAlignment = NSTextAlignmentCenter;
		CGPoint centerPoint = CGPointMake([screen applicationFrame].size.width/2, 13);
		m_label.center = centerPoint;
	}
	
	
	
	NSString *questionString = [[currentQuestion GetQuestionString] retain];
	if ([gameRef IsMultiplayer] == NO ) {
		m_label.text = [NSString stringWithFormat:@"%@?",questionString];
	}
	else {
		m_label.text = [NSString stringWithFormat:@"%@ : %@?",currentPlayerName, questionString];
	}

	[screen release];
	[questionString release];
}


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
