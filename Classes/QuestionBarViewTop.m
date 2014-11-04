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

    UIScreen *screen = [[UIScreen mainScreen] retain];
	self.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
	m_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(280, 0, 30.0, 30.0)];
	m_label = [[UILabel alloc]init];
    m_touchEnabled = NO;
	m_label.backgroundColor = [UIColor clearColor];
	
    
	//m_tapToEnlarge = [[UILabel alloc] initWithFrame:CGRectMake(40, 25, [screen applicationFrame].size.width - 40, 15)];
	//[m_tapToEnlarge setFont:[UIFont systemFontOfSize:12.0f]];
	//m_tapToEnlarge.backgroundColor = [UIColor clearColor];
	
	UIImage *lineImage = [UIImage imageNamed:@"BarLine.png"];
	m_lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [screen applicationFrame].size.width, 30)];
	m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
	[m_lineImageView setImage:lineImage];
	[self addSubview:m_lineImageView];

	[self addSubview:m_imageView];
	[self addSubview:m_label];
	//[self addSubview:m_tapToEnlarge];
	[self setAlpha:0];
    [screen release];
	
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
			[self setFrame:CGRectMake(0, 0, [screen applicationFrame].size.width, [screen applicationFrame].size.height)];
			[m_lineImageView setAlpha:0];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);

			[self StrechImage:[screen applicationFrame].size.width andYOffset:0];
			//[m_tapToEnlarge setAlpha:0];
			
			[m_label setFrame:CGRectMake(2, 2, [screen applicationFrame].size.width -10, 20)];
			m_label.textAlignment = NSTextAlignmentCenter;
			CGPoint centerPoint = CGPointMake([screen applicationFrame].size.width/2, 13);
			m_label.center = centerPoint;
			
			if ([delegate respondsToSelector:@selector(HideGameIcons)])
				[delegate HideGameIcons];
			
		}
		else {
			//shrink
			[self setFrame:CGRectMake(0,0, [screen applicationFrame].size.width, 50)];
			[m_lineImageView setAlpha:1];
			m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);

			[self ShrinkImage];
			//m_tapToEnlarge.text = [NSString stringWithFormat:@" %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap image to resize"]];
			//[m_tapToEnlarge setAlpha:1];
			
			m_label.textAlignment = NSTextAlignmentLeft;
			[m_label setFrame:CGRectMake(40, 2, [screen applicationFrame].size.width - 40, 20)];
			
			if ([delegate respondsToSelector:@selector(ShowGameIcons)])
				[delegate ShowGameIcons];
		}

		[UIView commitAnimations];	
		[screen release];
	}
}

-(void) StrechImage:(float) width andYOffset:(float) yOffset
{
    UIScreen *screen = [[UIScreen mainScreen] retain];
    int orgImageWidth = m_image.size.width;
    int orgImageHeight = m_image.size.height;
    float newWidth = width;
    float scaleFactor = newWidth / orgImageWidth;
    float newHeight = orgImageHeight * scaleFactor;
    if (orgImageWidth < orgImageHeight) {
        newHeight = [self frame].size.width * 0.8; //decrease by 20 percent to make space for bars
        scaleFactor = newHeight / orgImageHeight;
        newWidth = orgImageWidth * scaleFactor;
    }
    [m_imageView setFrame:CGRectMake(([screen applicationFrame].size.width/2) - (newWidth/2), ([screen applicationFrame].size.height/2) - (newHeight/2) + yOffset, newWidth, newHeight)];
    [screen release];
}

-(void) ShrinkImage
{
    int orgImageWidth = m_image.size.width;
    int orgImageHeight = m_image.size.height;
    float newWidth = 30;
    float scaleFactor = newWidth / orgImageWidth;
    float newHeight = orgImageHeight * scaleFactor;
    if (orgImageWidth < orgImageHeight) {
        newHeight = 30;
        scaleFactor = newHeight / orgImageHeight;
        newWidth = orgImageWidth * scaleFactor;
    }
    [m_imageView setFrame:CGRectMake(5, 5, newWidth, newHeight)];
}

-(void) AnimateQuestion:(BOOL) firstQuestion
{
    [self PreAnimation];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelay:0.9];
    [UIView setAnimationDelegate:self];
	[self SetForAnimation];
    if (firstQuestion == NO) {
        [UIView setAnimationDidStopSelector:@selector(AnimateQuestionDone)];
    }
    else
    {
        [UIView setAnimationDidStopSelector:@selector(AnimateFirstQuestionDone)];
    }
    
	[UIView commitAnimations];
}

-(void) PreAnimation
{
    
    [self SetLabelPositionsAndPicture];
    
    m_label.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
    UIScreen *screen = [[UIScreen mainScreen] retain];
    [m_label setFrame:CGRectMake(0, 0, [screen applicationFrame].size.width, 40)];
    [self setAlpha:1];
    self.backgroundColor = [UIColor clearColor];
    [self setFrame:CGRectMake(0, 0, [screen applicationFrame].size.width, [screen applicationFrame].size.height)];
    m_label.textAlignment = NSTextAlignmentCenter;
    [m_label setCenter:self.center];
    [m_label setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
    [m_imageView setAlpha:1];
    if(m_usingPicture)
        [self StrechImage:[screen applicationFrame].size.width/2 andYOffset:100];
    [screen release];
}

-(void) SetForAnimation
{
    UIScreen *screen = [[UIScreen mainScreen] retain];
    self.backgroundColor = [UIColor clearColor];
    [self setFrame:CGRectMake(0,0, [screen applicationFrame].size.width, 50)];
    m_label.center =CGPointMake([screen applicationFrame].size.width/2, 20);
    [m_label setFont:[UIFont systemFontOfSize:12.0f]];
    [m_label setTransform:CGAffineTransformMakeScale(1, 1)];
    if (m_usingPicture)
        [self ShrinkImage];
    [screen release];
}

-(void) AnimateQuestionDone
{
    [self SetValuesAtAnimateDone];
    if ([delegate respondsToSelector:@selector(StartNextRound)])
        [delegate StartNextRound];
}

-(void) AnimateFirstQuestionDone
{
    [self SetValuesAtAnimateDone];
    if ([delegate respondsToSelector:@selector(AnimateFirstQuestionDone)])
        [delegate AnimateFirstQuestionDone];
}

-(void) SetValuesAtAnimateDone
{
    m_label.backgroundColor = [UIColor clearColor];
    m_label.transform = CGAffineTransformIdentity;
    UIScreen *screen = [[UIScreen mainScreen] retain];
    [m_label setFrame:CGRectMake(40, 2, [screen applicationFrame].size.width - 40, 20)];
    [screen release];
    self.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
}


-(void) SetQuestion:(NSString *) currentPlayerName gameRef:(Game*) gameRef
{
    
    Question* currentQuestion = [gameRef GetQuestion];
    m_usingPicture = [currentQuestion UsingPicture];
    if (m_usingPicture == YES) {
        m_image = [currentQuestion GetPicture];
    }
    NSString *questionString = [[currentQuestion GetQuestionString] retain];

    m_label.text = [NSString stringWithFormat:@"%@?",questionString];
        

    
    [self SetLabelPositionsAndPicture];

	[questionString release];
}

-(void) SetLabelPositionsAndPicture
{
	m_touchEnabled = NO;
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[m_label setFont:[UIFont systemFontOfSize:12.0f]];
	m_label.numberOfLines = 1;
	m_label.adjustsFontSizeToFitWidth = YES;
	m_label.textAlignment = NSTextAlignmentCenter;
    
	float questionLabelWidth = 310;
	if ( m_usingPicture == YES) {
		[self setFrame:CGRectMake(0,0, 320, 50)];
		[m_lineImageView setImage:[UIImage imageNamed:@"BarLineUp.png"]];
		m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		m_touchEnabled = YES;
		m_label.textAlignment = NSTextAlignmentLeft;
		[m_label setFrame:CGRectMake(40, 2, questionLabelWidth - 30, 20)];
		m_imageView.hidden = NO;
        
        int orgImageWidth = m_image.size.width;
        int orgImageHeight = m_image.size.height;
        float newWidth = 30;
        float scaleFactor = newWidth / orgImageWidth;
        float newHeight = orgImageHeight * scaleFactor;
        if (orgImageWidth < orgImageHeight) {
            newHeight = 30;
            scaleFactor = newHeight / orgImageHeight;
            newWidth = orgImageWidth * scaleFactor;
        }
        
        [m_imageView setFrame:CGRectMake(5, 5, newWidth, newHeight)];
		[m_imageView setImage:m_image];
        [m_imageView setAlpha:1];
		questionLabelWidth =280;
	}
	else {
		[self setFrame:CGRectMake(0,0, 320, 40)];
		[m_lineImageView setImage:[UIImage imageNamed:@"BarLine.png"]];
		m_lineImageView.center = CGPointMake([self frame].size.width/2, [self frame].size.height - 15);
		m_imageView.hidden = YES;
		[m_label setFrame:CGRectMake(2, 2, questionLabelWidth, 40)];
		m_label.textAlignment = NSTextAlignmentCenter;
		CGPoint centerPoint = CGPointMake([screen applicationFrame].size.width/2, 13);
		m_label.center = centerPoint;
	}
    
	[screen release];
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
