//
//  QuitButtonView.m
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "QuitButtonView.h"
#import "GlobalSettingsHelper.h"


@implementation QuitButtonView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:CGRectMake(5, 200, 30, 30)];
    if (self) {
		[self setAlpha:1];
		
        [self setBackgroundColor: [UIColor clearColor]];
		[self setUserInteractionEnabled:YES];
		UIImageView* backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
		UIImage *vImage = [UIImage imageNamed:@"quitBtn.png"];		
		[backgroundImageView setImage:vImage];
		[self addSubview:backgroundImageView];
		
		alert = [[UIAlertView alloc] initWithTitle:@"Quit" 
														message:@"Quit game?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		
	[self setBackgroundColor:[UIColor redColor]];

}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	

	[alert show];
	
	
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
        NSLog(@"yes button was pressed\n");
        [[GlobalSettingsHelper Instance] setOutOfGame];
        if ([delegate respondsToSelector:@selector(QuitGame)])
            [delegate QuitGame];
    }
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
