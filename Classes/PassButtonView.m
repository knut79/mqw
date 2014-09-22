//
//  PassButtonView.m
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "PassButtonView.h"


@implementation PassButtonView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(5, 280, 30, 30)];
    if (self) {
		[self setAlpha:1];
		
        [self setBackgroundColor: [UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		UIImage *vImage = [UIImage imageNamed:@"passBtn.png"];		
		[backgroundImageView setImage:vImage];
		[self addSubview:backgroundImageView];
        
        
		
		timesLeftLabel = [[UILabel alloc] init];
		[timesLeftLabel setFrame:CGRectMake(0, 3, 10, 10)];
		timesLeftLabel.textAlignment = NSTextAlignmentCenter;
		timesLeftLabel.backgroundColor = [UIColor clearColor]; 
		timesLeftLabel.textColor = [UIColor whiteColor];
		[timesLeftLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		timesLeftLabel.text = @"2";
		timesLeftLabel.shadowColor = [UIColor blackColor];
		timesLeftLabel.shadowOffset = CGSizeMake(1,1);
		[self addSubview:timesLeftLabel];
        
        alert = [[UIAlertView alloc] initWithTitle:@"Pass" 
                                           message:@"Pass question?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
		
    }
    return self;
}

-(void) SetTimesLeft:(NSInteger) value
{
    timesLeft = value;
    timesLeftLabel.text = [NSString stringWithFormat:@"%d",value];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self setBackgroundColor:[UIColor blueColor]];
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
    [alert show];
//	if ([delegate respondsToSelector:@selector(PassQuestion)])
//		[delegate PassQuestion];
	[self setBackgroundColor:[UIColor clearColor]];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{
    
    if(buttonIndex == 0)
    {
        NSLog(@"no button was pressed\n");
    }
    else
    {
        timesLeft--;
        timesLeftLabel.text = [NSString stringWithFormat:@"%d",timesLeft];
        if (timesLeft <= 0) {
            [self setAlpha:0];
        }
        
        NSLog(@"yes button was pressed\n");
        if ([delegate respondsToSelector:@selector(PassQuestion)])
            [delegate PassQuestion];
    }
    
}


- (void)dealloc {
    [super dealloc];
}


@end
