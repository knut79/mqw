//
//  Player.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Player.h"
#import "PepTalk.h"


@implementation Player


-(id) initWithName:(NSString*) name andColor:(UIColor*) color andPlayerSymbol:(NSString*) playerSymbol
{
	if (self = [super init]) {
		[name retain];
		m_name = [[NSString alloc]initWithString:name];
		m_gamePoint = CGPointMake(900,1500);

		m_lastKmLeft = const_startKmDistance;
		m_kmLeft = const_startKmDistance;
		m_kmLeft_infoBar = const_startKmDistance;
		//miles 31070
		m_score = 0;
		m_easyQuestionsPassed = 0;
		m_mediumQuestionsPassed = 0;
		m_hardQuestionsPassed = 0;
		m_color = color;
		m_playerSymbol = playerSymbol;
		m_durration = 0;
		m_out = NO;
		m_pepTalk = [[NSString alloc] init];
		m_lastRoundScore = 0;
		m_position = 0;
		m_totalDistanceFromAllDestinations = 0;

		
	}
	return self;
}

-(NSString*) GetName
{
	return m_name;
}

-(UIColor*) GetColor
{
	return m_color;
}

-(NSInteger) GetKmLeft
{
	return m_kmLeft;
}

-(NSInteger) GetLastKmLeft
{
	return m_lastKmLeft;
}

-(void) SetKmLeft:(NSInteger) val
{
	m_lastKmLeft = m_kmLeft;
	m_kmLeft = val;
}

-(void) SetLastDistanceFromDestination:(NSInteger)distance
{
	m_lastDistanceFromDestination = distance;
	
	//add to total
	m_totalDistanceFromAllDestinations += distance;
}

-(NSInteger) GetTotalDistanceFromAllDestinations
{
	return m_totalDistanceFromAllDestinations;
}

-(NSInteger) GetLastDistanceFromDestination
{
	return m_lastDistanceFromDestination;
}

-(void) SetGamePoint:(CGPoint) gamePoint
{
	m_gamePoint = gamePoint;
}

-(void) SetPositionByScore:(NSInteger) position
{
	m_position = position;
}

-(NSInteger) GetPositionByScore
{
	return m_position;
}

-(CGPoint) GetGamePoint
{
	return m_gamePoint;
}

-(NSInteger) GetScore
{
	return m_score;
}

-(NSString*) GetPlayerSymbol
{
	return m_playerSymbol;
}

-(BOOL) IsOut
{
	return m_out;
}

-(void) SetOut:(BOOL) outValue
{
	m_out = outValue;
}

-(void) SetPetTalk:(NSInteger) missedDistance
{
	m_pepTalk = [[PepTalk Instance] GetPepTalk:missedDistance];
}

-(NSString*) GetPepTalk
{
	return m_pepTalk;
}


-(float)GetLastScale
{
	return m_lastScale;
}

-(void)SetLastScale:(float) scale
{
	m_lastScale = scale;
}

-(void) IncreasQuestionsPassedAndScore:(Question*) question
{
	Difficulty dif = [question GetDifficulty];
	switch (dif) {
		case easy:
			m_score++;
			m_easyQuestionsPassed++;
			break;
		case medium:
			m_score += 2;
			m_mediumQuestionsPassed++;
			break;
		case hardDif:
		case veryhardDif:
			m_score += 3;
			m_hardQuestionsPassed++;
			break;
		default:
			m_score += 3;
			m_hardQuestionsPassed++;
			break;
	}
}

-(void) IncreasQuestionsPassed:(Question*) question
{
	Difficulty dif = [question GetDifficulty];
	switch (dif) {
		case easy:
			m_easyQuestionsPassed++;
			break;
		case medium:
			m_mediumQuestionsPassed++;
			break;
		case hardDif:
		case veryhardDif:
			m_hardQuestionsPassed++;
			break;
		default:
			m_hardQuestionsPassed++;
			break;
	}
}


-(void) IncreaseScoreBy:(NSInteger) value
{
	m_lastRoundScore = value;
	m_score = m_score + value;
}

-(NSInteger) GetLastRoundScore
{
	return m_lastRoundScore;
}

-(NSInteger) GetQuestionsPassed
{
	return (m_easyQuestionsPassed + m_mediumQuestionsPassed + m_hardQuestionsPassed);
}

-(NSInteger) GetEasyQuestionsPassed
{
	return m_easyQuestionsPassed;
}

-(NSInteger) GetMediumQuestionsPassed
{
	return m_mediumQuestionsPassed;
}

-(NSInteger) GetHardQuestionsPassed
{
	return m_hardQuestionsPassed;
}

-(void) IncrementDurration:(NSTimer*)theTimer
{
	m_durration ++;
}

-(void) StartTimer
{
	m_durrationTimer =[NSTimer scheduledTimerWithTimeInterval:1.0
														target:self selector:@selector(IncrementDurration:)
													  userInfo:nil repeats:YES] ;
}

-(void) PauseTimer
{
	[m_durrationTimer invalidate];
}

-(NSInteger) GetSecondsUsed
{
	return m_durration;
}

-(void) ResetScore
{
	m_lastKmLeft = const_startKmDistance;
	m_kmLeft = const_startKmDistance;
	m_kmLeft_infoBar = const_startKmDistance;
	m_score = 0;
	m_easyQuestionsPassed = 0;
	m_mediumQuestionsPassed = 0;
	m_hardQuestionsPassed = 0;
	m_durration = 0;
	m_out = NO;
	m_lastRoundScore = 0;
	m_totalDistanceFromAllDestinations = 0;
	m_lastDistanceFromDestination = 0;
}

-(void) ResetGamePoint
{
	m_gamePoint = CGPointMake(900,1500);
}

-(void) ResetPosition
{
	m_position = 0;
}

#pragma mark used by InfoBarView
-(void) SetBarWidth:(NSInteger) width
{
	m_barWidth = width;
}

-(NSInteger) GetBarWidth
{
	return m_barWidth;
}

-(void) SetKmLeft_ForInfoBar:(NSInteger) kmLeft
{
	m_kmLeft_infoBar = kmLeft;
}

-(NSInteger) GetKmLeft_ForInfoBar
{
	return m_kmLeft_infoBar;
}

@end
