//
//  Player.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#import "Question.h"
#import "GlobalSettingsHelper.h"

@interface Player : NSObject {
	
	NSString *m_name;
	CGPoint m_gamePoint;
	float m_lastScale;
	NSInteger m_kmLeft;
	NSInteger m_lastKmLeft;
	NSInteger m_easyQuestionsPassed;
	NSInteger m_mediumQuestionsPassed;
	NSInteger m_hardQuestionsPassed;
	NSInteger m_barWidth;
	BOOL m_out;
	UIColor *m_color;
	NSString *m_playerSymbol;
//	NSTimer *m_durrationTimer;
	NSInteger m_durration;
	NSTimeInterval startTime;
	NSTimeInterval endTime;
	NSInteger m_lastDistanceFromDestination;
	NSInteger m_totalDistanceFromAllDestinations;
	NSInteger m_kmLeft_infoBar;
	NSString* m_pepTalk;
	NSInteger m_position;
    NSInteger m_hints;
    NSInteger m_passes;
    NSInteger m_currentKmTimeBonus;
	NSInteger m_timeBonusBarWidth;
	NSInteger m_currentTimeMultiplier;
    /*
    NSString* m_userId;
    NSString* m_userFbId;
*/
}
-(id) initWithName:(NSString*) name andColor:(UIColor*) color andPlayerSymbol:(NSString*) playerSymbol;

-(void) SetPlayerState:(NSInteger) questionsPassed GamePoint:(CGPoint) gamePoint KmLeft:(NSInteger) kmLeft
					TimeUsed:(NSInteger) timeUsed TotalDistance:(NSInteger) totalDistance Out:(BOOL) isOut BarWidth:(NSInteger) barWidth;
-(NSString*) GetName;
-(void) SetGamePoint:(CGPoint) gamePoint;
-(CGPoint) GetGamePoint;
-(NSInteger) GetKmLeft;
-(UIColor*) GetColor;
-(void) SetKmLeft:(NSInteger)val;
-(void) DeductKmLeft:(NSInteger) val;
-(void) SetKmLeft_ForInfoBar:(NSInteger) kmLeft;
-(void) SetBarWidth:(NSInteger) width;
-(NSInteger) GetBarWidth;
-(BOOL) IsOut;
-(void) SetOut:(BOOL) outValue;
-(NSString*) GetPlayerSymbol;
-(void) SetPetTalk:(NSInteger) missedDistance;
-(NSString*) GetPepTalk;

/*
-(void) SetUserId:(NSString*) playerId;
-(NSString*) GetPlayerId;
-(void) SetUserFbId:(NSString*) userFbUser;
-(NSString*) GetUserFbId;
*/


-(float)GetLastScale;
-(void)SetLastScale:(float) scale;
-(void) IncreasQuestionsPassed:(Question*) question;
-(long) GetQuestionsPassed;
-(void) SetPositionByScore:(NSInteger) position;

-(void) StartTimer;
-(void) PauseTimer;
-(void) SetLastDistanceFromDestination:(NSInteger)distance;
-(NSInteger) GetLastDistanceFromDestination;
-(void) ResetScore;
-(void) ResetGamePoint;
-(void) ResetPosition;
-(NSInteger) GetPositionByScore;

-(NSInteger) GetSecondsUsed;
-(NSInteger) GetEasyQuestionsPassed;
-(NSInteger) GetMediumQuestionsPassed;
-(NSInteger) GetHardQuestionsPassed;
-(NSInteger) GetKmLeft_ForInfoBar;
-(NSInteger) GetTotalDistanceFromAllDestinations;
-(NSInteger) GetLastKmLeft;

-(void) PassUsed;
-(void) HintUsed;
-(NSInteger) GetPassesLeft;
-(NSInteger) GetHintsLeft;

-(void) SetTimeBonusBarWidth:(NSInteger) width;
-(NSInteger) GetTimeBonusBarWidth;
-(void) SetCurrentKmTimeBonus:(NSInteger) timeBonus;
-(NSInteger) GetCurrentKmTimeBonus;
-(NSString*) GetDistanceTimeBounusString;

-(void) SetCurrentTimeMultiplier:(NSInteger) timeMultiplier;
-(NSInteger) GetCurrentTimeMultiplier;

@end
