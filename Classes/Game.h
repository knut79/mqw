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
#import "Fjord.h"
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
	

	
	NSMutableArray *m_players;
	Player *m_nextTurn;
	Difficulty m_difficulty;
	Difficulty m_initialDifficulty;
	NSInteger m_currentQuestionIndex;
	NSInteger m_currentPlayerIndex;
	BOOL m_multiplayer;
	Highscore *m_highscores;
	GameType m_gameType;
	NSInteger m_gameQuestionsPassed;
	Question* m_currentQuestion;
	NSInteger m_playersLeft;
	NSInteger m_mostPointsGame_NumberOfQuestions;
	GameState m_gameState;
	
	BOOL m_training;
	NSMutableDictionary *training_oldResultDictionary;
	NSMutableDictionary *training_newResultDictionary;
	NSMutableArray *training_placesArray;
    
    Challenge* challenge;
    

}
@property (nonatomic, assign) Challenge* challenge;

-(void) SetPlayers:(NSMutableArray *) players andDifficulty:(Difficulty) difficulty andMultiplayers:(BOOL) multiplayers andGameType:(GameType) gameType
andNumberOfQuestions:(NSInteger) numberOfQuestions;
-(void) SetGameState_QuestionID:(NSString*) questionID Difficulty:(Difficulty) diff currentPlayerByName:(NSString*) playerName questionsPassed:(NSInteger) questionsPassed;
-(Question*) GetQuestion;
-(NSMutableArray*) GetPlayers;
-(BOOL) IsMultiplayer;
-(void) SetNextPlayer;
-(NSInteger) GetNextPlayerIndex;
-(Player*) GetPlayer;
-(Player*) GetPlayerByName:(NSString*) name;
-(BOOL) CurrentPlayerIsLast;
-(BOOL) SetNextQuestion;
-(void) ResetGameData;
-(Difficulty) GetGameDifficulty;
-(GameType) GetGameType;
-(void) ResetPlayerData;
-(void) IncreasQuestionsPassed;
-(NSInteger) GetQuestionsPassed;
-(void) SetPlayersLeft:(NSInteger) playersLeft;
-(NSInteger) GetPlayersLeft;
-(void) FirstPlaceSetScore:(NSInteger) score;
-(void) SecondPlaceSetScore:(NSInteger) score;
-(void) ThirdPlaceSetScore:(NSInteger) score;
-(void) FourthPlaceSetScore:(NSInteger) score;
-(NSInteger) GetNumberOfQuestions;
-(BOOL) IsOnePlayerAtTop;
-(void) SetPlayerPositionsByScore;
-(NSInteger) GetCorrectAnswersAndSetScore:(NSInteger) score;
-(Highscore*) GetHighscore;
-(NSArray *) GetSortedPlayersForBars;
-(NSArray *) GetSortedPlayersForGame;
-(NSArray *) GetSortedPlayersForGame_LastStanding;
-(NSArray *) GetSortedPlayersForRound;
-(void) UpdateAvgDistanceForQuest:(NSInteger) distanceBetweenPoints;
-(void) SaveGame;
-(void) SetGameState:(GameState) gs;

-(void) SetTrainingMode:(BOOL) training;
-(BOOL) IsTrainingMode;
-(void) ResetTrainingValues;
-(void) Training_AddOldResult:(NSString*) place avgValue:(NSInteger) value;
-(void) Training_AddNewResult:(NSString*) place avgValue:(NSInteger) value;
-(NSArray*) Training_GetPlaces;
-(NSDictionary*) Training_GetOldResults;
-(NSDictionary*) Training_GetNewResults;

-(void) SetTimeBonusPoints;
-(void) IncreaseScoresWithRoundScores;

@end
