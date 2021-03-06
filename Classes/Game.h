//
//  Game.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"
#import "Question.h"
#import "City.h"
#import "State.h"
#import "Lake.h"
#import "UnDefWaterRegion.h"
#import "Island.h"
#import "Peninsula.h"
#import "Mountain.h"
#import "UnDefPlace.h"
#import "UnDefRegion.h"
#import "CoordinateHelper.h"
#import "EnumDefs.h"
#import "Highscore.h"
#import "Challenge.h"

@interface Game : NSObject {
	
	Player *m_nextTurn;
	Difficulty m_difficulty;
	Difficulty m_initialDifficulty;
	NSInteger m_currentQuestionIndex;
	Highscore *m_highscores;
	NSInteger m_gameQuestionsPassed;
	Question* m_currentQuestion;
	GameState m_gameState;
	Player* m_player;
	gameMode m_gameMode;
    BOOL m_borders;
	NSMutableDictionary *training_oldResultDictionary;
	NSMutableDictionary *training_newResultDictionary;
	NSMutableArray *training_placesArray;
    NSMutableArray * passedQuestions;
    BOOL m_gameEnded;
    
    Challenge* challenge;
    

}
@property (nonatomic, assign) Challenge* challenge;

-(void) SetPlayer:(Player*) player andDifficulty:(Difficulty) difficulty;
-(void) SetGameState_QuestionID:(NSString*) questionID Difficulty:(Difficulty) diff currentPlayerByName:(NSString*) playerName questionsPassed:(NSInteger) questionsPassed;
-(Question*) GetQuestion;
-(Player*) GetPlayer;
-(void) SetNextQuestion;
-(BOOL) IsMoreQuestions;
-(void) ResetGameData;
-(Difficulty) GetGameDifficulty;
-(void) ResetPlayerData;
-(void) IncreasQuestionsPassed;
-(NSInteger) GetQuestionsPassed;
-(NSMutableArray*) GetPassedQuestions;
-(NSInteger) GetCorrectAnswersAndSetScore:(NSInteger) score;
-(Highscore*) GetHighscore;

-(void) UpdateAvgDistanceForQuest:(NSInteger) distanceBetweenPoints;
-(void) SaveGame;
-(void) SetGameState:(GameState) gs;

-(void) SetGameMode:(gameMode) mode;
-(void) SetMapBorder:(BOOL) value;
-(BOOL) IsTrainingMode;
-(BOOL) isChallenge;
-(BOOL) UsingBorders;
-(BOOL) HasGameEnded;
-(void) ResetTrainingValues;
-(void) Training_AddOldResult:(NSString*) place avgValue:(NSInteger) value;
-(void) Training_AddNewResult:(NSString*) place avgValue:(NSInteger) value;
-(NSArray*) Training_GetPlaces;
-(NSDictionary*) Training_GetOldResults;
-(NSDictionary*) Training_GetNewResults;

-(gameMode) GetGameMode;


@end
