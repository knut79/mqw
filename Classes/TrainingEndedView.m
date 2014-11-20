//
//  TrainingEndedView.m
//  MQNorway
//
//  Created by knut dullum on 22/06/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "TrainingEndedView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "EnumHelper.h"



@implementation TrainingEndedView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(100, 0, 250, 40)];
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
		//		headerLabel.shadowColor = [UIColor blackColor];
		//		headerLabel.shadowOffset = CGSizeMake(2,2);
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		headerLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"End of"],[[GlobalSettingsHelper Instance] GetStringByLanguage:[EnumHelper difficultyToNiceString:[m_gameRef GetGameDifficulty]]],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"training"]];
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,20);
		[self addSubview:headerLabel];
		
		buttonMainMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonMainMenu addTarget:self action:@selector(mainMenu) forControlEvents:UIControlEventTouchDown];
		[buttonMainMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Main menu"] forState:UIControlStateNormal];
		buttonMainMenu.frame = CGRectMake(80.0, 60.0, 160.0, 40.0);
		buttonMainMenu.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) - 40);
		[self addSubview:buttonMainMenu];
		
		buttonRestart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonRestart addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchDown];
		[buttonRestart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Restart training"] forState:UIControlStateNormal];
		buttonRestart.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
		buttonRestart.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) + 40);
		[self addSubview:buttonRestart];
		
		[self setAlpha:0];

		
		placeLabels = [[NSMutableArray alloc] init];
		for (int i = 0; i < 6; i++) {
			
			//set labels for names
			UILabel *placeLabel = [[UILabel alloc] init];
			[placeLabel setFrame:CGRectMake(0, 0, [screen applicationFrame].size.width, 20)];
			placeLabel.backgroundColor = [UIColor clearColor]; 
			placeLabel.textColor = [UIColor blackColor];
			[placeLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
			[placeLabel setAlpha:1];

	
			placeLabel.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) - 55 - (i*25));
			placeLabel.textAlignment = NSTextAlignmentCenter;
			[self addSubview:placeLabel];
			[placeLabels addObject:placeLabel];
			[placeLabel release];
		}
		
		newAvgLabel = [[UILabel alloc] init];
		[newAvgLabel setFrame:CGRectMake(0, 0, 80, 40)];
		newAvgLabel.backgroundColor = [UIColor clearColor]; 
		newAvgLabel.textColor = [UIColor blueColor];
		[newAvgLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		[newAvgLabel setAlpha:0];
		newAvgLabel.center = CGPointMake(0, ([screen applicationFrame].size.height/2) - 55 - 25);
		newAvgLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:newAvgLabel];
		
		placeIndex = 0;
		
		[screen release];
    }
    return self;
}

-(void) mainMenu
{
	//self.hidden = YES;
	[self FadeOut];
	if ([delegate respondsToSelector:@selector(DisplayMainMenu)])
		[delegate DisplayMainMenu];
}

-(void) restart
{
	//self.hidden = YES;
	[self FadeOut];
	if ([delegate respondsToSelector:@selector(RestartGame)])
		[delegate RestartGame];
}

-(void) SetGameRef:(Game*) game
{
	m_gameRef = game;
}


-(void) NextPlace
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	newAvgLabel.center = CGPointMake(0, ([screen applicationFrame].size.height/2) - 55 - 25);
	newAvgLabel.textColor = [UIColor blueColor];
	newAvgLabel.transform = CGAffineTransformIdentity;
	[screen release];
	
	if (placeIndex < [placesArray count]) {
	//not done first time
	//reset label position and set text
		if (placeIndex != 0) {
			
			for (int i = 5; i>0; i--) {
				UILabel *tempLabelLower = [[placeLabels objectAtIndex:i - 1] retain];

				UILabel *tempLabelHigher = [[placeLabels objectAtIndex:i] retain];
				tempLabelHigher.text = tempLabelLower.text;
				tempLabelHigher.center = CGPointMake(tempLabelHigher.center.x,tempLabelHigher.center.y + 25);
				[tempLabelHigher release];
				[tempLabelLower release];
			}
			UILabel *tempLabelFirst = [[placeLabels objectAtIndex:0] retain];
			[tempLabelFirst setAlpha:0];
			//the first label is the only one with the NEW value
			int oldValue = [[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex]] intValue];
			if (oldValue == -1)
				tempLabelFirst.text = [NSString stringWithFormat:@"%@ - no value",[placesArray objectAtIndex:placeIndex]];
			else	
				tempLabelFirst.text = [NSString stringWithFormat:@"%@ %@ km",[placesArray objectAtIndex:placeIndex],[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex]]];
			tempLabelFirst.center = CGPointMake(tempLabelFirst.center.x,tempLabelFirst.center.y + 25);
			[tempLabelFirst release];
			
			
		}
		else {
			UILabel *tempLabelFirst = [[placeLabels objectAtIndex:0] retain];
			[tempLabelFirst setAlpha:0];
			int oldValue = [[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex]] intValue];
			if (oldValue == -1)
				tempLabelFirst.text = [NSString stringWithFormat:@"%@ - no value",[placesArray objectAtIndex:placeIndex]];
			else	
				tempLabelFirst.text = [NSString stringWithFormat:@"%@ %@ km",[placesArray objectAtIndex:placeIndex],[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex]]];
			[tempLabelFirst release];
		}
	
	
		UILabel *tempLabel = [[placeLabels objectAtIndex:0] retain];
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationDelegate:self];       
		[UIView setAnimationDidStopSelector:@selector(BounceInNewAvgValue)];
		for (int i = 0; i< 6; i++) {
			UILabel *tempLabel2 = [[placeLabels objectAtIndex:i] retain];
			tempLabel2.center = CGPointMake(tempLabel2.center.x,tempLabel2.center.y - 25);
			if (i==3) 
				[tempLabel2 setAlpha:0.8];
			if (i==4) 
				[tempLabel2 setAlpha:0.6];
			if (i==5) 
				[tempLabel2 setAlpha:0.3];
			[tempLabel2 release];
		}
		[tempLabel setAlpha:1];
		[UIView commitAnimations];
		[tempLabel release];
		

	}
	else {
		[newAvgLabel setAlpha:0];
	}

	placeIndex++;
}

-(void) BounceInNewAvgValue
{
	newAvgLabel.text = [NSString stringWithFormat:@"%d",[[newResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex - 1]] intValue]];
	UIScreen *screen = [[UIScreen mainScreen] retain];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(UpdateValue)];
	[newAvgLabel setAlpha:1];
	newAvgLabel.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) - 55 - 25);
	[UIView commitAnimations];
	[screen release];

}



-(void) UpdateValue
{
	UILabel *tempLabelFirst = [[placeLabels objectAtIndex:0] retain];
	//the first label is the only one with the NEW value
	tempLabelFirst.text = [NSString stringWithFormat:@"%@ %@ km",[placesArray objectAtIndex:placeIndex - 1],[newResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex - 1]]];
	[tempLabelFirst release];
	[self RicochetAvgDifference];
}

-(void) RicochetAvgDifference
{
	int oldValue = [[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex - 1]] intValue];
	int sum = [[newResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex - 1]] intValue] - [[oldResultDictionary objectForKey:[placesArray objectAtIndex:placeIndex - 1]] intValue];
	if (sum>0) 
		newAvgLabel.text = [NSString stringWithFormat:@"+ %d km",sum];
	else 		
		newAvgLabel.text = [NSString stringWithFormat:@"%d km",sum];

	
	UIScreen *screen = [[UIScreen mainScreen] retain];
	int yValue = ([screen applicationFrame].size.height/2) - 55 - 25;

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(NextPlace)];
	if (oldValue != -1) {
		if (sum >0) {
			newAvgLabel.textColor = [UIColor redColor];
			yValue += 40;
		}
		else {
			newAvgLabel.textColor = [UIColor greenColor];
			yValue -= 40;
		}
	}

	newAvgLabel.center = CGPointMake([screen applicationFrame].size.width - 20 ,yValue);
	[newAvgLabel setAlpha:0];
	newAvgLabel.transform = CGAffineTransformMakeScale(2.3, 2.3);
	[UIView commitAnimations];
	[screen release];
	
}


-(void) FadeIn
{
	placesArray = [m_gameRef Training_GetPlaces];
	oldResultDictionary = [m_gameRef Training_GetOldResults];
	newResultDictionary = [m_gameRef Training_GetNewResults];
	
	UIScreen *screen = [[UIScreen mainScreen] retain];
	placeIndex=0;
	for (int i = 0; i < 6; i++) {
		UILabel *tempLabel = [[placeLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:1];
		tempLabel.center = CGPointMake([screen applicationFrame].size.width/2, ([screen applicationFrame].size.height/2) - 55 - (i*25));
		tempLabel.text = @"";
	}
	[screen release];
	[buttonMainMenu setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Main menu"] forState:UIControlStateNormal];
	[buttonRestart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Restart training"] forState:UIControlStateNormal];
	headerLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"End of"],[EnumHelper difficultyToNiceString:[m_gameRef GetGameDifficulty]],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"training"]];
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(NextPlace)];   
	[self setAlpha:1];
	[UIView commitAnimations];
}

-(void) FadeOut
{
	placeIndex = [placesArray count];
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
