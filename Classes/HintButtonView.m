//
//  HintButtonView.m
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "HintButtonView.h"


@implementation HintButtonView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(5, 240, 30, 30)];
    if (self) {
		[self setAlpha:1];
		
        [self setBackgroundColor: [UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		UIImage *vImage = [UIImage imageNamed:@"hintBtn.png"];		
		[backgroundImageView setImage:vImage];
		[self addSubview:backgroundImageView];
		
		//timesLeft = 2;
		
		timesLeftLabel = [[UILabel alloc] init];
		[timesLeftLabel setFrame:CGRectMake(0, 3, 10, 10)];
		timesLeftLabel.textAlignment = NSTextAlignmentCenter;
		timesLeftLabel.backgroundColor = [UIColor clearColor]; 
		timesLeftLabel.textColor = [UIColor whiteColor];
		[timesLeftLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		timesLeftLabel.text = [NSString stringWithFormat:@"%d",timesLeft];
		timesLeftLabel.shadowColor = [UIColor blackColor];
		timesLeftLabel.shadowOffset = CGSizeMake(1,1);
		[self addSubview:timesLeftLabel];

		
		
		hitBox = [[UIAlertView alloc] initWithTitle:@"Hint!" 
											message:@"No hint given!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];		
		
		
    }
    return self;
}

-(void) SetTimesLeft:(NSInteger) value
{
    timesLeft = value;
    timesLeftLabel.text = [NSString stringWithFormat:@"%d",value];
}

-(void) SetHint:(NSString*) hint
{
	hitBox.message = hint;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self setBackgroundColor:[UIColor blueColor]];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[hitBox show];
	//[alert release];
	
	
	[self setBackgroundColor:[UIColor clearColor]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor clearColor]];
}


- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{
	//[hitBox dealloc];	

	timesLeft--;
	timesLeftLabel.text = [NSString stringWithFormat:@"%d",timesLeft];
	if (timesLeft <= 0) {
		[self setAlpha:0];
	}
	
	if ([delegate respondsToSelector:@selector(UseHint)])
		[delegate UseHint];
	
}

- (void)dealloc {
    [super dealloc];
}


@end
