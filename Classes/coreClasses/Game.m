//
//  Game.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Game.h"
#import "GlobalSettingsHelper.h"
#import "LocationsHelper.h"



@implementation Game


-(id) init
{
	if (self = [super init]) {
		
		m_players = [[NSMutableArray alloc] init];
		m_difficulty = easy;
		m_initialDifficulty = easy;
		m_currentQuestionIndex = 0;
		m_gameQuestionsPassed = 0;
	}
	return self;
}

-(id) initWithPlayers:(NSMutableArray *) players andDifficulty:(Difficulty) difficulty andMultiplayers:(BOOL) multiplayers andGameType:(GameType) gameType
andNumberOfQuestions:(NSInteger) numberOfQuestions
{
	if (self = [super init]) {
		m_multiplayer = multiplayers;
		m_players =  [players mutableCopy];
		m_difficulty = difficulty;
		m_initialDifficulty = difficulty;
		m_currentQuestionIndex = 0;
		m_highscores = [[Highscore alloc] init];
		m_gameType = gameType;
		m_gameQuestionsPassed = 0;
		m_mostPointsGame_NumberOfQuestions = numberOfQuestions;

		[[LocationsHelper Instance] ShuffleQuestions];
	}
	return self;
}


-(void) ResetGameData
{
	m_gameQuestionsPassed = 0;
	m_difficulty = m_initialDifficulty;
}


-(Difficulty) GetGameDifficulty
{
	return m_initialDifficulty;
}

-(GameType) GetGameType
{
	return m_gameType;
}

-(Question*) GetQuestion
{
	NSMutableArray *qOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty];
	Question* returnQuestion = [qOnType objectAtIndex:m_currentQuestionIndex] ;
	return returnQuestion;
}


-(BOOL) SetNextQuestion
{
	BOOL moreQuestions = YES;
	
	NSArray *questionsOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty];

	m_currentQuestionIndex ++;
	
	if (m_currentQuestionIndex >= [questionsOnType count]) {
		if (m_difficulty == easy) {
			m_difficulty = medium;
			m_currentQuestionIndex = 0;
		}
		else if (m_difficulty == medium) {
			m_difficulty = hardDif;
			m_currentQuestionIndex = 0;
		}
		else if (m_difficulty == hardDif) {
			m_difficulty = veryhardDif;
			m_currentQuestionIndex = 0;
		}
		else if (m_difficulty == veryhardDif) {
			m_difficulty = easy;
			m_currentQuestionIndex = 0;
		}
	}

	return moreQuestions;
}

-(Highscore*) GetHighscore
{
	return m_highscores;
}


-(Player*) GetPlayer
{
	return [m_players objectAtIndex:m_currentPlayerIndex] ;//_? retain inside
}

-(NSMutableArray*) GetPlayers
{
	return m_players;
}


-(void) SetNextPlayer
{
	BOOL allPlayersOut = YES;
	for (int i = 0;i < [m_players count]; i++) 
	{
		if ([[m_players objectAtIndex:i] IsOut] == NO) {
			allPlayersOut = NO;
			break;
		}
	}
	
	if (allPlayersOut == YES) {
		m_currentPlayerIndex = 0;
	}
	else {
		[self GetNextPlayerIndex];	
	}
}

-(NSInteger) GetNextPlayerIndex
{
	m_currentPlayerIndex = (m_currentPlayerIndex + 1) % [m_players count];
	if ([[m_players objectAtIndex:m_currentPlayerIndex] IsOut] == YES) {
		m_currentPlayerIndex = [self GetNextPlayerIndex];
	}

	return m_currentPlayerIndex;
}

-(BOOL) IsMultiplayer
{
	return m_multiplayer;
}


-(BOOL) CurrentPlayerIsLast
{
	BOOL isLastPlayer = YES;
	if ((m_currentPlayerIndex + 1) < [m_players count]) 
	{
		for (int i = m_currentPlayerIndex +1; i < [m_players count]; i++) {
			if ([[m_players objectAtIndex:i] IsOut] == NO) {
				isLastPlayer = NO;
			}
		}
	}
	return isLastPlayer;
}


//Method writes a string to a text file
-(void) writeToTextFile{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt", 
						  documentsDirectory];
	//create content - four lines of text
	NSString *content = @"One\nTwo\nThree\nFour\nFive";
	//save content to the documents directory
	[content writeToFile:fileName 
			  atomically:NO 
				encoding:NSStringEncodingConversionAllowLossy 
				   error:nil];
	
}

//Method retrieves content from documents directory and
//displays it in an alert
-(void) displayContent{
	//get the documents directory:
	NSArray *paths = NSSearchPathForDirectoriesInDomains
	(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	
	//make a file name to write the data to using the documents directory:
	NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt", 
						  documentsDirectory];
	NSString *content = [[NSString alloc] initWithContentsOfFile:fileName
													usedEncoding:nil
														   error:nil];
	[content release];
}


-(void) ResetPlayerData
{
	for (Player *player in m_players) {
		[player ResetScore];
		[player ResetGamePoint];
		[player ResetPosition];
	}
}

-(Player*) GetBestScoredPlayer
{
	Player *topPlayer = [[m_players objectAtIndex:0] retain];
	for (Player *player in m_players) {
		if ([topPlayer GetScore] < [player GetScore]) {
			[topPlayer release];
			topPlayer = [player retain];
		}
	}
	return topPlayer;
}

-(void) SetPlayerPositionsByScore
{
	NSMutableArray *sortedPlayerArray = [[m_players mutableCopy]retain];
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetLastDistanceFromDestination]  >  [[sortedPlayerArray objectAtIndex:j] GetLastDistanceFromDestination])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}	
	for (int i = 0; i<[sortedPlayerArray count]; i++) {
		Player *player = [[sortedPlayerArray objectAtIndex:i] retain];
		[player SetPositionByScore:(i + 1)];
		[player release];
	}
}

//finds out if one player has the unique right for the top spot , SCORE wise 
-(BOOL) IsOnePlayerAtTop
{
	BOOL onePlayerAtTop = YES;
	NSMutableArray *sortedPlayerArray = [[m_players mutableCopy] retain];
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetScore]  <  [[sortedPlayerArray objectAtIndex:j] GetScore])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}	
	
	if([[sortedPlayerArray objectAtIndex:0] GetScore] == [[sortedPlayerArray objectAtIndex:1] GetScore])
		onePlayerAtTop = NO;
	
	[sortedPlayerArray release];
	
	return onePlayerAtTop;
}

-(NSInteger) GetCorrectAnswersAndSetScore:(NSInteger) score
{
	NSInteger numOfCorrectAnsweredPlayers = 0;
	for(int i = 0; i < [m_players count]; i++ )
	{
		if([[m_players objectAtIndex:i] GetLastDistanceFromDestination] == 0)
		{
			numOfCorrectAnsweredPlayers++;
			[[m_players objectAtIndex:i] IncreaseScoreBy:score];
		}
	}
	return numOfCorrectAnsweredPlayers;
}

-(void) FirstPlaceSetScore:(NSInteger) score
{
	Player *topPlayer = [[m_players objectAtIndex:0] retain];
	for (Player *player in m_players) {
		if ([topPlayer GetLastDistanceFromDestination] > [player GetLastDistanceFromDestination]) {
			[topPlayer release];
			topPlayer = [player retain];
		}
	}
	[topPlayer IncreaseScoreBy:score];
	[topPlayer release];
}	

-(void) SecondPlaceSetScore:(NSInteger) score
{
	NSMutableArray *sortedPlayerArray = [[m_players mutableCopy]retain];
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetLastDistanceFromDestination]  >  [[sortedPlayerArray objectAtIndex:j] GetLastDistanceFromDestination])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}	
	
	Player *secondBestPlayer = [[sortedPlayerArray objectAtIndex:1] retain];
	[secondBestPlayer IncreaseScoreBy:score];
	[secondBestPlayer release];
	[sortedPlayerArray release];
}

-(void) ThirdPlaceSetScore:(NSInteger) score
{
	NSMutableArray *sortedPlayerArray = [[m_players mutableCopy] retain];
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetLastDistanceFromDestination]  >  [[sortedPlayerArray objectAtIndex:j] GetLastDistanceFromDestination])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}	
	
	Player *thirdBestPlayer = [[sortedPlayerArray objectAtIndex:2] retain];
	[thirdBestPlayer IncreaseScoreBy:score];
	[thirdBestPlayer release];
	[sortedPlayerArray release];
}

-(void) FourthPlaceSetScore:(NSInteger) score
{
	NSMutableArray *sortedPlayerArray = [[m_players mutableCopy] retain];
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetLastDistanceFromDestination]  >  [[sortedPlayerArray objectAtIndex:j] GetLastDistanceFromDestination])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}	
	
	Player *fourthBestPlayer = [[sortedPlayerArray objectAtIndex:3] retain];
	[fourthBestPlayer IncreaseScoreBy:score];
	[fourthBestPlayer release];
	[sortedPlayerArray release];
}


-(NSArray *) GetSortedPlayersForRound
{
	NSMutableArray *sortedPlayerArray = [m_players mutableCopy];
	
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetLastDistanceFromDestination]  >  [[sortedPlayerArray objectAtIndex:j] GetLastDistanceFromDestination])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}

	return sortedPlayerArray;
}

-(NSArray *) GetSortedPlayersForGame
{
	NSMutableArray *sortedPlayerArray = [m_players mutableCopy];

	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetScore]  <  [[sortedPlayerArray objectAtIndex:j] GetScore])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}
	return sortedPlayerArray;
}

//made especially for drawing bars
-(NSArray *) GetSortedPlayersForBars
{
	NSMutableArray *sortedPlayerArray = [m_players mutableCopy];
	
	//bubblesort
	Player *temp;
	BOOL swapped;
	for(int i = ([sortedPlayerArray count] - 1); i >= 0; i-- )
	{
		swapped = NO;
		for(int j = 1; j <= i; j++ )
		{
			if(([[sortedPlayerArray objectAtIndex:(j-1)] IsOut] == YES) &&  ([[sortedPlayerArray objectAtIndex:j] IsOut] == NO))
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
		}
		if (swapped == NO) {
			break;
		}
	}
	return sortedPlayerArray;
}


-(void) IncreasQuestionsPassed
{
	m_gameQuestionsPassed ++;
}

-(NSInteger) GetQuestionsPassed
{
	return m_gameQuestionsPassed;
}

-(NSInteger) GetNumberOfQuestions
{
	return m_mostPointsGame_NumberOfQuestions;
}

-(void) SetPlayersLeft:(NSInteger) playersLeft
{
	m_playersLeft = playersLeft;
}

-(NSInteger) GetPlayersLeft
{
	return m_playersLeft;
}

-(void)dealloc
{
	[m_players release];
	[super dealloc];
}

@end
