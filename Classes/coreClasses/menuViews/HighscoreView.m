//
//  HighscoreView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "HighscoreView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "UISwitch-extended.h"
#import "GlobalSettingsHelper.h"


@implementation HighscoreView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		pathEasy = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreEasy.plist"] retain];
		pathMedium = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreMedium.plist"] retain];
		pathHard = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreHard.plist"] retain];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if(![fileManager fileExistsAtPath:pathEasy])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreEasy" ofType:@"plist"];
			[fileManager removeItemAtPath:pathEasy error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathEasy error:&error];
		}
		if(![fileManager fileExistsAtPath:pathMedium])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreMedium" ofType:@"plist"];
			[fileManager removeItemAtPath:pathMedium error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathMedium error:&error];
		}
		if(![fileManager fileExistsAtPath:pathHard])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreHard" ofType:@"plist"];
			[fileManager removeItemAtPath:pathHard error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathHard error:&error];
		}
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_centerX = [screen applicationFrame].size.width/2;
		m_centerY = [screen applicationFrame].size.height/2;
		[screen release];

		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 180, 40)];
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
		[self addSubview:headerLabel];

		subheaderLabel = [[UILabel alloc] init];
		[subheaderLabel setFrame:CGRectMake(40, 5, 70, 60)];
		subheaderLabel.backgroundColor = [UIColor clearColor]; 
		subheaderLabel.textColor = [UIColor redColor];
		[subheaderLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
		subheaderLabel.transform = CGAffineTransformMakeRotation( M_PI/4 );
		subheaderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"];
		subheaderLabelCenter = subheaderLabel.center;
		[self addSubview:subheaderLabel];

		nameLabels = [[NSMutableArray alloc] init];
		nameLabelsCenter = [[NSMutableArray alloc] init];
		easyQLabels = [[NSMutableArray alloc] init];
		qLabelsCenter = [[NSMutableArray alloc] init];
		timeLabels = [[NSMutableArray alloc] init];
		timeLabelsCenter = [[NSMutableArray alloc] init];
		pointsLabels = [[NSMutableArray alloc] init];
		pointsLabelsCenter = [[NSMutableArray alloc] init];
		
		int labelsXoffset = 0;
		int labeslYoffset = 0;
		

		int yPos = 0;
		NSValue *tempval;
		for (int i = 0; i < 10; i++) {

			//set labels for names
			UILabel *playerNameLabel = [[UILabel alloc] init];
			[playerNameLabel setFrame:CGRectMake(3 + labelsXoffset, 100 + yPos + labeslYoffset, 100, 20)];
			playerNameLabel.backgroundColor = [UIColor clearColor]; 
			playerNameLabel.textColor = [UIColor whiteColor];
			[playerNameLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerNameLabel];
			[nameLabels addObject:playerNameLabel];
			tempval = [[NSValue valueWithCGPoint:playerNameLabel.center] retain];
			[nameLabelsCenter addObject:tempval];
			[tempval release];
			[playerNameLabel release];
			
			//set labels for questions passed
			UILabel *playerQLabel = [[UILabel alloc] init];
			[playerQLabel setFrame:CGRectMake(130 + labelsXoffset, 100 + yPos + labeslYoffset, 50, 20)];
			playerQLabel.backgroundColor = [UIColor clearColor]; 
			playerQLabel.textColor = [UIColor whiteColor];
			[playerQLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerQLabel];
			[easyQLabels addObject:playerQLabel];
			tempval = [[NSValue valueWithCGPoint:playerQLabel.center] retain];
			[qLabelsCenter addObject:tempval];
			[tempval release];
			[playerQLabel release];
			
			
			//time labels
			UILabel *playerTimeLabel = [[UILabel alloc] init];
			[playerTimeLabel setFrame:CGRectMake(220 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerTimeLabel.backgroundColor = [UIColor clearColor]; 
			playerTimeLabel.textColor = [UIColor whiteColor];
			[playerTimeLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerTimeLabel];
			[timeLabels addObject:playerTimeLabel];
			tempval = [[NSValue valueWithCGPoint:playerTimeLabel.center] retain];
			[timeLabelsCenter addObject:tempval];
			[tempval release];
			[playerTimeLabel release];
			
			UILabel *playerPointsLabel = [[UILabel alloc] init];
			[playerPointsLabel setFrame:CGRectMake(280 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerPointsLabel.backgroundColor = [UIColor clearColor]; 
			playerPointsLabel.textColor = [UIColor whiteColor];
			[playerPointsLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerPointsLabel];
			[pointsLabels addObject:playerPointsLabel];
			tempval = [[NSValue valueWithCGPoint:playerPointsLabel.center] retain];
			[pointsLabelsCenter addObject:tempval];
			[tempval release];
			[playerPointsLabel release];
			
			yPos += 25;
		}
		
		UILabel *headerHighscorePosition = [[UILabel alloc] init];
		[headerHighscorePosition setFrame:CGRectMake(3, 60, 50, 40)];
		headerHighscorePosition.backgroundColor = [UIColor clearColor]; 
		headerHighscorePosition.textColor = [UIColor yellowColor];
		[headerHighscorePosition setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerHighscorePosition.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Pos."];
		[self addSubview:headerHighscorePosition];
		
		UILabel *headerQuestionsAnsw = [[UILabel alloc] init];
		[headerQuestionsAnsw setFrame:CGRectMake(118, 60, 70, 40)];
		headerQuestionsAnsw.backgroundColor = [UIColor clearColor]; 
		headerQuestionsAnsw.textColor = [UIColor yellowColor];
		[headerQuestionsAnsw setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerQuestionsAnsw.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No. answers"];
		[self addSubview:headerQuestionsAnsw];
		
		
		UILabel *headerTime = [[UILabel alloc] init];
		[headerTime setFrame:CGRectMake(221, 60, 90, 40)];
		headerTime.backgroundColor = [UIColor clearColor]; 
		headerTime.textColor = [UIColor yellowColor];
		[headerTime setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerTime.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time"];
		[self addSubview:headerTime];
		
		
		headerScore = [[UILabel alloc] init];
		[headerScore setFrame:CGRectMake(275, 60, 90, 40)];
		headerScore.backgroundColor = [UIColor clearColor]; 
		headerScore.textColor = [UIColor yellowColor];
		[headerScore setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerScore.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Score"];
		[self addSubview:headerScore];
		
		
		
		button_levelDown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelDown addTarget:self action:@selector(levelDown) forControlEvents:UIControlEventTouchDown];
		[button_levelDown setTitle:@"<- Level down" forState:UIControlStateNormal];
		button_levelDown.frame = CGRectMake(5, 350, 140, 40);
		button_levelDownCenter = button_levelDown.center;
		[self addSubview:button_levelDown];
		
		button_levelUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelUp addTarget:self action:@selector(levelUp) forControlEvents:UIControlEventTouchDown];
		[button_levelUp setTitle:@"Level up ->" forState:UIControlStateNormal];
		button_levelUp.frame = CGRectMake(170, 350, 140, 40);
		button_levelUpCenter = button_levelUp.center;
		[self addSubview:button_levelUp];
		
		button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
		[button_levelUp setAlpha:0];

		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 410.0, 180.0, 40.0);
		[self addSubview:buttonBack];
		
		[self ReadHighscoresIntoArrays];
		m_showingLevel = hardDif;
		[self ReadHighScoresAtDifficulty:m_showingLevel];
		
		[self setAlpha:0];
    }
    return self;
}

-(void) levelUp
{
	if (m_showingLevel == easy) {
		m_showingLevel = medium;
		[self changeLevel];
	}
	else  if(m_showingLevel == medium){
		m_showingLevel = hardDif;
		[self changeLevel];
	}
}

-(void) levelDown
{
	if (m_showingLevel == hardDif) {
		m_showingLevel = medium;
		[self changeLevel];
	}
	else if(m_showingLevel == medium){
		m_showingLevel = easy;
		[self changeLevel];
	}
}

-(void) changeLevel
{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self];  
	
	switch (m_showingLevel) {
		case easy:
			button_levelUp.center = CGPointMake(m_centerX, button_levelUp.frame.origin.y + (button_levelUp.frame.size.height/2) );
			[button_levelDown setAlpha:0];
			break;
		case medium:
			button_levelUp.center = button_levelUpCenter;
			[button_levelUp setAlpha:1];
			button_levelDown.center = button_levelDownCenter;
			[button_levelDown setAlpha:1];
			break;
		default:
			button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
			[button_levelUp setAlpha:0];
			break;
	}


	CGPoint centerPoint = CGPointMake(m_centerX, m_centerY);
	[UIView setAnimationDidStopSelector:@selector(finishedMovingLabelsIn)]; 
	for (int i = 0; i < 10; i++) 
	{
		UILabel *tempLabel = [[nameLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:0];
		tempLabel.center = centerPoint;
		[tempLabel release];
		tempLabel = [[easyQLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:0];
		tempLabel.center = centerPoint;
		[tempLabel release];
		tempLabel = [[timeLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:0];
		tempLabel.center = centerPoint;
		[tempLabel release];
		tempLabel = [[pointsLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:0];
		tempLabel.center = centerPoint;
		[tempLabel release];
	}
	[subheaderLabel setAlpha:0];
	subheaderLabel.center = centerPoint;
	[UIView commitAnimations];	
}

-(void) finishedMovingLabelsIn
{
	[self ReadHighScoresAtDifficulty:m_showingLevel];	
	switch (m_showingLevel) {
		case easy:
			subheaderLabel.text = @"easy";
			subheaderLabel.center = CGPointMake(m_centerX, subheaderLabel.frame.origin.y + (subheaderLabel.frame.size.height/2));
			break;
		case medium:
			subheaderLabel.text = @"medium";
			subheaderLabel.center = CGPointMake(m_centerX, subheaderLabel.frame.origin.y + (subheaderLabel.frame.size.height/2));
			break;
		case hardDif:
		case veryhardDif:
			subheaderLabel.text = @"hard";
			subheaderLabel.center = CGPointMake(m_centerX, subheaderLabel.frame.origin.y + (subheaderLabel.frame.size.height/2));
			break;
		default:
			break;
	}
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[subheaderLabel setAlpha:1];
	for (int i = 0; i < 10; i++) 
	{
		UILabel *tempLabel = [[nameLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:1];
		tempLabel.center = [[nameLabelsCenter objectAtIndex:i] CGPointValue];
		[tempLabel release];
		tempLabel = [[easyQLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:1];
		tempLabel.center = [[qLabelsCenter objectAtIndex:i] CGPointValue];
		[tempLabel release];
		tempLabel = [[timeLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:1];
		tempLabel.center = [[timeLabelsCenter objectAtIndex:i] CGPointValue];
		[tempLabel release];
		tempLabel = [[pointsLabels objectAtIndex:i] retain];
		[tempLabel setAlpha:1];
		tempLabel.center = [[pointsLabelsCenter objectAtIndex:i] CGPointValue];
		[tempLabel release];
		
	}
	subheaderLabel.center = subheaderLabelCenter;
	[UIView commitAnimations];	
}


-(void) ReadHighscoresIntoArrays
{
	easyScoreArray = [[NSArray alloc] initWithContentsOfFile:pathEasy];
	mediumScoreArray = [[NSArray alloc] initWithContentsOfFile:pathMedium];
	hardScoreArray = [[NSArray alloc] initWithContentsOfFile:pathHard];
}

-(void) ReadHighScoresAtDifficulty:(Difficulty) difficulty
{
	NSArray *tempArray;
	if (difficulty == medium){
		tempArray = [mediumScoreArray retain];
	}
	else if(difficulty == hardDif){
		tempArray = [hardScoreArray retain];
	}
	else if(difficulty == veryhardDif){
		tempArray = [hardScoreArray retain];
	}
	else {
		tempArray = [easyScoreArray retain];
	}
	
	int index = 0;
	for (NSDictionary *highscorePlayerData in tempArray) {
		NSString *name = [[highscorePlayerData objectForKey:@"name"] retain] ;
		NSInteger questions = [[highscorePlayerData objectForKey:@"questions"] intValue];
		NSInteger time = [[highscorePlayerData objectForKey:@"time"] intValue];
		NSInteger points = [[highscorePlayerData objectForKey:@"points"] intValue];
		
		
		UILabel *tempLabel = [[nameLabels objectAtIndex:index] retain];
		tempLabel.text = [NSString stringWithFormat:@"%d. %@",index + 1, name];
		[tempLabel release];
		
		UILabel *tempEasyQlabel = [[easyQLabels objectAtIndex:index] retain];
		tempEasyQlabel.text = [NSString stringWithFormat:@"%d",questions];
		[tempEasyQlabel release];
		
		UILabel *timeLabel = [[timeLabels objectAtIndex:index]retain];
		NSString *seconds = [[NSString stringWithFormat:@"%d",time%60] retain];
		if ([seconds length] == 1 ) {
			timeLabel.text = [NSString stringWithFormat:@"%d:0%d ",time/60,time%60];
		}
		else {
			timeLabel.text = [NSString stringWithFormat:@"%d:%d ",time/60,time%60];
		}
		[seconds release];
		
		[timeLabel release];
		
		UILabel *pointsLabel = [[pointsLabels objectAtIndex:index]retain];
		pointsLabel.text = [NSString stringWithFormat:@"%d", points];
		[name release];
		[pointsLabel release];
		
		index ++;
	}
	
	[tempArray release];

}

-(void) WriteHighscores
{
	NSMutableArray *dataArray = [[NSMutableArray alloc] initWithContentsOfFile:pathEasy];
	NSMutableDictionary *data = [dataArray objectAtIndex:0];

	int value = 6;
	[data setObject:[NSNumber numberWithInt:value] forKey:@"value"];
	[dataArray writeToFile:pathEasy atomically:YES];
	[dataArray release];

}

-(void) UpdateLabels
{
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
}

-(void)goBack:(id)Sender
{
	[self FadeOut];
}


-(void) FadeIn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[self setAlpha:0];
	[UIView commitAnimations];	
}


#define HORIZ_SWIPE_DRAG_MIN 100

BOOL isProcessingListMove;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self];
	if(startTouchPosition.x != newTouchPosition.x || startTouchPosition.y != newTouchPosition.y) {
		isProcessingListMove = NO;
	}
	startTouchPosition = [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = touches.anyObject;
	CGPoint currentTouchPosition = [touch locationInView:self];
	
	// If the swipe tracks correctly.
	double diffx = startTouchPosition.x - currentTouchPosition.x + 0.1; // adding 0.1 to avoid division by zero
	double diffy = startTouchPosition.y - currentTouchPosition.y + 0.1; // adding 0.1 to avoid division by zero
	
	if(abs(diffx / diffy) > 1 && abs(diffx) > HORIZ_SWIPE_DRAG_MIN)
	{
		// It appears to be a swipe.
		if(isProcessingListMove) {
			// ignore move, we're currently processing the swipe
			return;
		}
		
		if (startTouchPosition.x < currentTouchPosition.x) {
			isProcessingListMove = YES;
			[self levelDown];
			return;
		}
		else {
			isProcessingListMove = YES;
			[self levelUp];
			return;
		}
	}
	else if(abs(diffy / diffx) > 1)
	{
		isProcessingListMove = YES;
		[super touchesMoved:touches	withEvent:event];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	isProcessingListMove = NO;
	[super touchesEnded:touches withEvent:event];
}


- (void)dealloc {
	[pathEasy release];
	[pathMedium release];
	[pathHard release];
	
    [super dealloc];
}
@end
