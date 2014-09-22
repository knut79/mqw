//
//  RoundEndedView.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "RoundEndedView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "UILabelUnderline.h"



@implementation RoundEndedView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		m_labelsXoffset = 0;
		m_labelsYoffset = 0;
		
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0];
		[self addSubview:m_skyView];
		
		m_playerLabelsArray = [[NSMutableArray alloc] init];
		for (int i = 0; i < 4; i++) {
			UILabelUnderline *playerNameLabel = [[UILabelUnderline alloc] init];
			playerNameLabel.numberOfLines = 1;
			playerNameLabel.adjustsFontSizeToFitWidth = YES;
			playerNameLabel.backgroundColor = [UIColor clearColor]; 
			//[playerNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
			playerNameLabel.textAlignment = NSTextAlignmentCenter;
			//playerNameLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
			if (i==0) {
//				playerNameLabel.layer.shadowRadius = 2.0;
//				playerNameLabel.layer.shadowOpacity = 1.0;
				[playerNameLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
				playerNameLabel.shadowColor = [UIColor whiteColor];
				playerNameLabel.shadowOffset = CGSizeMake(-1,-2);
			}
			else{ 
//				playerNameLabel.layer.shadowRadius = 1.0;
//				playerNameLabel.layer.shadowOpacity = 0.5;
				[playerNameLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
				playerNameLabel.shadowColor = [UIColor whiteColor];
				playerNameLabel.shadowOffset = CGSizeMake(-1,-2);
			}

			[playerNameLabel setFrame:CGRectMake(0, -50, 300, 20)];
			[m_playerLabelsArray addObject:playerNameLabel];
			[self addSubview:playerNameLabel];
		}
		 
		
		
		CGRect imageRect = CGRectMake(-99, -99, 223, 57);
		m_headerImageView = [[[UIImageView alloc] initWithFrame:imageRect] retain];
		[m_headerImageView setAlpha:0];
		[self addSubview:m_headerImageView];
		
		m_questionsLeftLabel = [[UILabel alloc] init];
		[m_questionsLeftLabel setFrame:CGRectMake(0, 0, 250, 20)];
		m_questionsLeftLabel.backgroundColor = [UIColor clearColor]; 
		[m_questionsLeftLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
//		m_questionsLeftLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
//		m_questionsLeftLabel.layer.shadowOpacity = 1.0;
//		m_questionsLeftLabel.layer.shadowRadius = 1.5;
		m_questionsLeftLabel.shadowColor = [UIColor whiteColor];
		m_questionsLeftLabel.shadowOffset = CGSizeMake(-1,-2);
		m_questionsLeftLabel.textAlignment = NSTextAlignmentCenter;
		m_questionsLeftLabel.adjustsFontSizeToFitWidth = YES;
		[m_questionsLeftLabel setAlpha:0];
		[self addSubview:m_questionsLeftLabel];
		
		
		m_tapWhenReadyLabel = [[UILabel alloc] init];
		[m_tapWhenReadyLabel setFrame:CGRectMake(0,0, 250, 20)];
		m_tapWhenReadyLabel.backgroundColor = [UIColor clearColor]; 
		m_tapWhenReadyLabel.textAlignment = NSTextAlignmentCenter;
		m_tapWhenReadyLabel.textColor = [UIColor whiteColor];
		[m_tapWhenReadyLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		m_tapWhenReadyLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		m_tapWhenReadyLabel.layer.shadowOpacity = 1.0;
		m_tapWhenReadyLabel.layer.shadowRadius = 1.5;
		[m_tapWhenReadyLabel setAlpha:0];
		[self addSubview:m_tapWhenReadyLabel];
		
		//new _2.0
		self.hidden = YES;
		
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setUserInteractionEnabled:NO];
	NSLog(@"tap on RoundEnded view caught");
	[self FadeOut];
}

-(void)SetRoundResults:(Game*) gameRef
{
	//is only called in multiplayer games
	[self setUserInteractionEnabled:NO];
	UIScreen *screen = [[UIScreen mainScreen] retain];
	NSInteger yOffset = 0;
	NSInteger yOffsetConstant = 30;
	m_labelsYoffset = 0;
	
	UIImage *headerImage = [[UIImage imageNamed:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"RoundResults.png"]] retain];
	m_headerImageView.image = headerImage;
	[headerImage release];
	m_headerImageView.center = CGPointMake([screen applicationFrame].size.width/2,  50);
	
	NSMutableArray *players = [[gameRef GetSortedPlayersForRound] retain];
	Player *tempPlayer;
	NSString *pointsString = @"";
	NSString *distanceFromDestinationString = @"";
	NSString *measurementString = @"";

	
	if ([gameRef GetGameType] == mostPoints) {
		
		for (int i = 0; i < [players count]; i++) {
			UILabelUnderline *playerNameLabel = [m_playerLabelsArray objectAtIndex:i];
			
			yOffset = yOffset + yOffsetConstant;
			
			playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2,  70 + yOffset);

			tempPlayer = [[players objectAtIndex:i] retain];
			
			NSInteger points = [tempPlayer GetLastRoundScore];
            
			if (points > 1) {
				pointsString = [NSString stringWithFormat:@"%d %@",points, [[GlobalSettingsHelper Instance] GetStringByLanguage:@"points"] ]; 
			}
			else if(points == 1) {
				pointsString = [NSString stringWithFormat:@"1 %@", [[GlobalSettingsHelper Instance] GetStringByLanguage:@"point"] ]; 
			}
			else {
				pointsString = [NSString stringWithFormat:@"%@ %@", [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No"],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"points"]]; 
			}
			
			
			
			//make distance from target string eg. 0 km -> correct location
			NSInteger distanceFromDestination = [tempPlayer GetLastDistanceFromDestination];
			if (distanceFromDestination > 0) {
				distanceFromDestinationString = [NSString stringWithFormat:@"%d %@ %@",
                                                 [[GlobalSettingsHelper Instance] ConvertToRightDistance:distanceFromDestination],
                                                 [[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                                                 [[GlobalSettingsHelper Instance] GetStringByLanguage:@"from destination"]];
			}
			else {
				distanceFromDestinationString = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Correct location"]];
			}

            if ([tempPlayer HasGivenUp] == YES) 
                playerNameLabel.text = [NSString stringWithFormat:@"%@ %@.",[tempPlayer GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"has given up"]];
            else
                playerNameLabel.text = [NSString stringWithFormat:@"%@. %@. %@",[tempPlayer GetName],distanceFromDestinationString,pointsString];
                
            [playerNameLabel SetUnderlineColor:[tempPlayer GetColor]];

			[playerNameLabel setAlpha:0];
			[tempPlayer release];
		}
		
		
		NSInteger questionsLeft = [gameRef GetNumberOfQuestions] - [gameRef GetQuestionsPassed];
		if (questionsLeft <= 0) {
			if ([gameRef IsOnePlayerAtTop] == YES) {
				m_questionsLeftLabel.text = [NSString stringWithFormat:@"%@.",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"No more questions"]];
			}
			else {
				m_questionsLeftLabel.text = [NSString stringWithFormat:@"%@.",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Extra question"]];
			}

		}
		else
		{
			m_questionsLeftLabel.text = [NSString stringWithFormat:@"%@: %d.",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Questions left"],questionsLeft];
		}

		//player GetQuestionsPassed
		yOffset = yOffset + yOffsetConstant;
		m_questionsLeftLabel.center = CGPointMake([screen applicationFrame].size.width/2,  80 + yOffset);
	}
	//last standing game
	else {
		
		for (int i = 0; i < [players count]; i++) {
			tempPlayer = [[players objectAtIndex:i] retain];
			
			UILabelUnderline *playerNameLabel = [m_playerLabelsArray objectAtIndex:i];
			yOffset = yOffset + yOffsetConstant;
			playerNameLabel.center = CGPointMake([screen applicationFrame].size.width/2,  70 + yOffset);

//			DistanceMeasurement measurement = [[GlobalSettingsHelper Instance] GetDistance];
//			if (measurement == mile) {
//				measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"miles"];
//			}
//			else {
//				measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"kilometers"];
//			}

			//make distance from target string eg. 0 km -> correct location
			NSInteger distanceFromDestination = [tempPlayer GetLastDistanceFromDestination];
			if (distanceFromDestination > 0) {
				distanceFromDestinationString = [NSString stringWithFormat:@"%d %@ %@",
                                                 [[GlobalSettingsHelper Instance] ConvertToRightDistance:distanceFromDestination],
                                                 [[GlobalSettingsHelper Instance] GetDistanceMeasurementString],
                                                 [[GlobalSettingsHelper Instance] GetStringByLanguage:@"from destination"]];
			}
			else {
				distanceFromDestinationString = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Correct location"]];
			}
			
			if ([tempPlayer IsOut] == NO) 
			{
			
				playerNameLabel.text = [NSString stringWithFormat:@"%@. %@.",[tempPlayer GetName],distanceFromDestinationString];
			}
			else {

				NSInteger distanceFromDestination = [tempPlayer GetLastDistanceFromDestination];
				if ((distanceFromDestination != 999999) && ([tempPlayer HasGivenUp] == NO)) {
					playerNameLabel.text = [NSString stringWithFormat:@"%@ %@. %@",[tempPlayer GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"is out"],distanceFromDestinationString];
					[tempPlayer SetLastDistanceFromDestination:999999];
				}
				else {
					playerNameLabel.text = [NSString stringWithFormat:@"%@ %@.",[tempPlayer GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"is out"]];
				}
                
			}
			[playerNameLabel SetUnderlineColor:[tempPlayer GetColor]];

			[playerNameLabel setAlpha:0];
			[tempPlayer release];
		}			
		
		m_questionsLeftLabel.text = @"";
	}

	m_tapWhenReadyLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap when ready"];
	m_tapWhenReadyLabel.center = CGPointMake([screen applicationFrame].size.width/2,  270);
	
	[players release];
	[screen release];
	
	[self FadeIn];
	[self AnimateElementsIn:[[gameRef GetPlayers] count]];
	//[self AnimateElementsIn:[[gameRef GetSortedPlayersForGame] count]];
}


-(void) AnimateElementsIn:(NSInteger) numberOfPlayers
{
	m_playerIndexToAnimate = numberOfPlayers - 1;
	m_numberOfPlayersToAnimate = numberOfPlayers;
	//will trigger AnimatePlayerIn
	[self WiggleHeader];
}

-(void) AnimatePlayerIn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 	      
	[UIView setAnimationDidStopSelector:@selector(FinishedAnimatingPlayer)];  
	[UIView setAnimationDuration:0.1];
	UILabel *playerNameLabel = [m_playerLabelsArray objectAtIndex:m_playerIndexToAnimate];
	[playerNameLabel setAlpha:1]; 
	m_playerIndexToAnimate --;
	[UIView commitAnimations];	
}

-(void) FinishedAnimatingPlayer
{
	if (m_playerIndexToAnimate >= 0) {
		//will trigger AnimatePlayerIn
		[self WiggleHeader];
	}
	else {
		[self AnimateLastElements];
	}
}

-(void) WiggleHeader
{
	[self HeaderAnimateUp];
}

-(void) HeaderAnimateUp
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 	      
	[UIView setAnimationDidStopSelector:@selector(HeaderAnimateDown)];  
	[UIView setAnimationDuration:0.35];
	m_headerImageView.center = CGPointMake(m_headerImageView.center.x,  m_headerImageView.center.y +20);
	[UIView commitAnimations];	
}

-(void) HeaderAnimateDown
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 	      
	[UIView setAnimationDidStopSelector:@selector(AnimatePlayerIn)];  
	[UIView setAnimationDuration:0.15];
	m_headerImageView.center = CGPointMake(m_headerImageView.center.x,  m_headerImageView.center.y -20);
	[UIView commitAnimations];	
}

-(void) AnimateLastElements
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(FinishedAnimatingLastElements)];  
	[UIView setAnimationDuration:0.5];	
	[m_tapWhenReadyLabel setAlpha: 1];
	[UIView commitAnimations];	
}

-(void) FinishedAnimatingLastElements
{
	[self setUserInteractionEnabled:YES];
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(FinishedFadingOut)];   
//	for (int i = 0; i < 4; i++) {
//		UILabel *playerNameLabel = [m_playerLabelsArray objectAtIndex:i];
//		[playerNameLabel setAlpha:0]; 
//	}
//	[m_tapWhenReadyLabel setAlpha:0];
//	[m_headerImageView setAlpha:0];
//	[m_questionsLeftLabel setAlpha:0];
//	[m_skyView setAlpha:0];
    [self setAlpha:0];
	[UIView commitAnimations];	
}

- (void) FinishedFadingOut
{
	self.hidden = YES;
	//send message fading in game elements
	if ([delegate respondsToSelector:@selector(FinishedShowinRoundEndedView)])
		[delegate FinishedShowinRoundEndedView];
}

-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self SetAlphaIn];
	[UIView commitAnimations];	
}

-(void) SetAlphaIn
{
	[m_headerImageView setAlpha:1];
	[m_questionsLeftLabel setAlpha:1];
	[m_skyView setAlpha:0.5];
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