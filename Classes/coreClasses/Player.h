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
	NSInteger m_score;
	NSInteger m_lastRoundScore;
	NSInteger m_easyQuestionsPassed;
	NSInteger m_mediumQuestionsPassed;
	NSInteger m_hardQuestionsPassed;
	NSInteger m_barWidth;
	BOOL m_out;
	UIColor *m_color;
	NSString *m_playerSymbol;
	NSTimer *m_durrationTimer;
	NSInteger m_durration;
	NSInteger m_lastDistanceFromDestination;
	NSInteger m_totalDistanceFromAllDestinations;
	NSInteger m_kmLeft_infoBar;
	NSString* m_pepTalk;
	NSInteger m_position;
	
	

}
-(id) initWithName:(NSString*) name andColor:(UIColor*) color andPlayerSymbol:(NSString*) playerSymbol;
-(NSString*) GetName;
-(void) SetGamePoint:(CGPoint) gamePoint;
-(CGPoint) GetGamePoint;
-(NSInteger) GetKmLeft;
-(UIColor*) GetColor;
-(void) SetKmLeft:(NSInteger)val;
-(void) SetBarWidth:(NSInteger) width;
-(NSInteger) GetBarWidth;
-(BOOL) IsOut;
-(void) SetOut:(BOOL) outValue;
-(NSString*) GetPlayerSymbol;
-(void) SetPetTalk:(NSInteger) missedDistance;
-(NSString*) GetPepTalk;


-(float)GetLastScale;
-(void)SetLastScale:(float) scale;
-(void) IncreasQuestionsPassedAndScore:(Question*) question;
-(void) IncreasQuestionsPassed:(Question*) question;
-(void) IncreaseScoreBy:(NSInteger) value;
-(NSInteger) GetQuestionsPassed;
-(NSInteger) GetLastRoundScore;
-(void) SetPositionByScore:(NSInteger) position;

-(void) StartTimer;
-(void) PauseTimer;
-(void) SetLastDistanceFromDestination:(NSInteger)distance;
-(NSInteger) GetLastDistanceFromDestination;
-(void) ResetScore;
-(void) ResetGamePoint;
-(void) ResetPosition;
-(NSInteger) GetPositionByScore;
-(NSInteger) GetScore;

-(NSInteger) GetSecondsUsed;
-(NSInteger) GetEasyQuestionsPassed;
-(NSInteger) GetMediumQuestionsPassed;
-(NSInteger) GetHardQuestionsPassed;
-(NSInteger) GetKmLeft_ForInfoBar;
-(NSInteger) GetTotalDistanceFromAllDestinations;
-(NSInteger) GetLastKmLeft;


@end
