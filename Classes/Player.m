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
		m_lastDistanceFromDestination = 0;
		m_barWidth = 0;
        m_hints = 2;
        m_passes = 2;
        m_currentKmTimeBonus = 20;
        m_givenUp = NO;
        m_currentTimeMultiplier = 0;
	}
	return self;
}

-(void) SetPlayerState_Score:(NSInteger) score QuestionsPassed:(NSInteger) questionsPassed GamePoint:(CGPoint) gamePoint KmLeft:(NSInteger) kmLeft
					TimeUsed:(NSInteger) timeUsed TotalDistance:(NSInteger) totalDistance Out:(BOOL) isOut BarWidth:(NSInteger) barWidth 
{
	m_score = score;
	m_easyQuestionsPassed = questionsPassed;
	m_gamePoint = gamePoint;
	m_kmLeft = kmLeft;
	m_lastKmLeft = kmLeft;
	m_kmLeft_infoBar = kmLeft;
	m_durration = timeUsed;
	m_totalDistanceFromAllDestinations = totalDistance;
	m_out = isOut;
	m_barWidth = barWidth;
}

//-(NSDictionary*) GetPlayerState
//{
//
//	NSMutableDictionary* playerStateDictionary = [[NSMutableDictionary alloc] init];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_score] forKey:@"score"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_easyQuestionsPassed] forKey:@"questionsPassed"];
//	[playerStateDictionary setValue:[NSValue valueWithCGPoint:m_gamePoint] forKey:@"gamePoint"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_durration] forKey:@"timeUsed"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_totalDistanceFromAllDestinations] forKey:@"kmleft"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_kmLeft] forKey:@"totalDistance"];
//	[playerStateDictionary setValue:[NSNumber numberWithBool:m_out] forKey:@"isOut"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_barWidth] forKey:@"barWidth"];
//	[playerStateDictionary setValue:[NSNumber numberWithInteger:m_playerSymbol] forKey:@"symbol"];	
//	return playerStateDictionary;
//}


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
    if(m_givenUp == YES)
        return 0;
    else
        return m_kmLeft;
}

-(NSInteger) GetLastKmLeft
{
	return m_lastKmLeft;
}

-(void) SetKmLeft:(NSInteger) val
{
    if (val > const_startKmDistance) {
        m_kmLeft = const_startKmDistance;
        m_lastKmLeft = const_startKmDistance;
    }
    else
    {
        m_lastKmLeft = m_kmLeft;
        m_kmLeft = val;
    }
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

-(void) GiveUp
{
    m_givenUp = YES;
}

-(BOOL) HasGivenUp
{
    return m_givenUp;
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

//-(void) IncreaseRoundScoreBy:(NSInteger) value
//{
//	//m_lastRoundScore = value;
//	m_score = m_score + value;
//}
//
//-(void) IncreaseScoreWithRoundScore
//{
//    m_score = m_score + m_lastRoundScore;
//    //m_lastRoundScore = 0;
//}

//-(void) SetLastRoundScore
//{
//    m_lastRoundScore = m_score;
//}

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
//	m_durration ++;
}

-(void) StartTimer
{
	startTime = (long)[[NSDate date] timeIntervalSince1970];
//	m_durrationTimer =[NSTimer scheduledTimerWithTimeInterval:1.0
//														target:self selector:@selector(IncrementDurration:)
//													  userInfo:nil repeats:YES] ;
}

-(void) PauseTimer
{
	endTime = (long)[[NSDate date] timeIntervalSince1970];
	m_durration = m_durration + (NSInteger)(endTime - startTime);
	//[m_durrationTimer invalidate];
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
	//m_durration = 0;
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

-(void) SetTimeBonusBarWidth:(NSInteger) width
{
    m_timeBonusBarWidth = width;
}

-(NSInteger) GetTimeBonusBarWidth
{
    return m_timeBonusBarWidth;
}

-(void) SetCurrentTimeMultiplier:(NSInteger) timeMultiplier
{
    m_currentTimeMultiplier = timeMultiplier;
}

-(NSInteger) GetCurrentTimeMultiplier
{
    return m_currentTimeMultiplier;
}

-(void) SetCurrentKmTimeBonus:(NSInteger) timeBonus
{
    m_currentKmTimeBonus = timeBonus;
}

-(NSInteger) GetCurrentKmTimeBonus
{
    if(m_givenUp == YES)
        return 0;
    else
        return m_currentKmTimeBonus;
}

-(NSString*) GetDistanceTimeBounusString
{
    NSString* distanceTimeBonusString = @"";
    if (m_currentKmTimeBonus > 0 ) {
        distanceTimeBonusString = [NSString stringWithFormat:@"+ %d %@",
                                   [[GlobalSettingsHelper Instance] ConvertToRightDistance:m_currentKmTimeBonus],
                                   [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]];
    }
    
    return distanceTimeBonusString;
}

-(void) SetKmLeft_ForInfoBar:(NSInteger) kmLeft
{
	m_kmLeft_infoBar = kmLeft;
}

-(NSInteger) GetKmLeft_ForInfoBar
{
	return m_kmLeft_infoBar;
}

-(void) PassUsed
{
    m_passes--;    
}

-(void) HintUsed
{
    m_hints--;
}

-(NSInteger) GetPassesLeft
{
    return m_passes;
}

-(NSInteger) GetHintsLeft;
{
    return m_hints;
}

@end
