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


}
-(id) initWithPlayers:(NSMutableArray *) players andDifficulty:(Difficulty) difficulty andMultiplayers:(BOOL) multiplayers andGameType:(GameType) gameType 
 andNumberOfQuestions:(NSInteger) numberOfQuestions;
-(Question*) GetQuestion;
-(NSMutableArray*) GetPlayers;
-(BOOL) IsMultiplayer;
-(void) SetNextPlayer;
-(NSInteger) GetNextPlayerIndex;
-(Player*) GetPlayer;
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
-(NSArray *) GetSortedPlayersForRound;


@end
