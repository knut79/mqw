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
#import "Location.h"
#import "SqliteHelper.h"
#import "EnumHelper.h"


@implementation Game

@synthesize challenge;

-(id) init
{
	if (self = [super init]) {
		
		m_players = [[NSMutableArray alloc] init];
		m_difficulty = easy;
		m_initialDifficulty = easy;
		m_currentQuestionIndex = 0;
		m_gameQuestionsPassed = 0;
		m_gameState = outOfGame;
        challenge = [[Challenge alloc] init];
	}
	return self;
}

-(void) SetPlayers:(NSMutableArray *) players andDifficulty:(Difficulty) difficulty andMultiplayers:(BOOL) multiplayers andGameType:(GameType) gameType
andNumberOfQuestions:(NSInteger) numberOfQuestions
{
	m_multiplayer = multiplayers;
	m_players =  [players mutableCopy];
	m_difficulty = difficulty;
	m_initialDifficulty = difficulty;
	m_currentQuestionIndex = 0;
	m_highscores = [[Highscore alloc] init];
	m_gameType = gameType;
	m_gameQuestionsPassed = 0;
	m_mostPointsGame_NumberOfQuestions = numberOfQuestions;

	//[[LocationsHelper Instance] ShuffleQuestions];

	
}

-(void) SetTrainingMode:(BOOL) training
{
	m_training = training;
}

-(BOOL) IsTrainingMode
{
	return m_training;
}

-(void) SetGameState_QuestionID:(NSString*) questionID Difficulty:(Difficulty) diff currentPlayerByName:(NSString*) playerName questionsPassed:(NSInteger) questionsPassed
{
	m_initialDifficulty = diff;
	m_difficulty = m_initialDifficulty;
	m_gameQuestionsPassed = questionsPassed;
	NSArray *questionsOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training];
	for (int i = 0;i < questionsOnType.count; i++) 
	{
		if ([[[questionsOnType objectAtIndex:i] GetID] isEqualToString:questionID]) 
		{
			m_currentQuestionIndex = i;
			break;
		}
	}
	
	for (int playerIndex = 0; playerIndex< m_players.count;playerIndex++) {
		if([[[m_players objectAtIndex:playerIndex] GetName] isEqualToString:playerName])
		{
			m_currentPlayerIndex = playerIndex;
		}
	}
}

-(void) SaveGame
{
	[[SqliteHelper Instance] executeUpdate:@"DELETE FROM savestate;"];
	[[SqliteHelper Instance] executeUpdate:@"DELETE FROM player;"];
	
	[[SqliteHelper Instance] executeUpdate:@"INSERT INTO savestate VALUES (?, ?, ?, ?, ?, ?,?,?,?,?,?);",
	 @"ID01",@"1",@"per",[EnumHelper gametypeToString:m_gameType],[[m_players objectAtIndex:m_currentPlayerIndex] GetName],
	 [EnumHelper languageToString:[[GlobalSettingsHelper Instance] GetLanguage]],@"drawResult",[[self GetQuestion] GetID],
	 [NSNumber numberWithInt: m_mostPointsGame_NumberOfQuestions], [EnumHelper gamestateToString:m_gameState],[NSNumber numberWithInt:m_gameQuestionsPassed]];	

//	for (Player *player in m_players) 
	for (int i = 0;i< m_players.count; i++) {
	
		[[SqliteHelper Instance] executeUpdate:@"INSERT INTO player VALUES (?, ?, ?, ?, ?, ?,?,?,?,?,?);", 
		 [[m_players objectAtIndex:i] GetName],[[m_players objectAtIndex:i] GetName],NSStringFromCGPoint([[m_players objectAtIndex:i] GetGamePoint]),
		 [NSNumber numberWithInt:[[m_players objectAtIndex:i] GetSecondsUsed]],
		 [NSNumber numberWithInt:[[m_players objectAtIndex:i] GetQuestionsPassed]], [NSNumber numberWithInt:[[m_players objectAtIndex:i] GetKmLeft]],[NSNumber numberWithInt:[[m_players objectAtIndex:i] GetScore]],
		 [NSNumber numberWithInt:[[m_players objectAtIndex:i] GetTotalDistanceFromAllDestinations]],
		 [NSNumber numberWithInt:[[m_players objectAtIndex:i] GetBarWidth]],[[m_players objectAtIndex:i] IsOut] ? @"YES" : @"NO",[[m_players objectAtIndex:i] GetPlayerSymbol]];
	}
}

-(void) SetGameState:(GameState) gs
{
	m_gameState = gs;
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
	NSMutableArray *qOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training];
	Question* returnQuestion = [qOnType objectAtIndex:m_currentQuestionIndex] ;
	return returnQuestion;
}


-(BOOL) SetNextQuestion
{
	BOOL moreQuestions = YES;
	
	NSArray *questionsOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training];

	m_currentQuestionIndex ++;
	
	if (m_training == NO) {
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
	}
	else //Training mode 
	{
		if (m_currentQuestionIndex >= [questionsOnType count])
		{
			[[LocationsHelper Instance] CategorizeQuestionsForTraining];
			moreQuestions = NO;
			//do this for next game
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


-(Player*) GetPlayerByName:(NSString*) name
{
	for (Player *player in m_players) {
		if([[player GetName] isEqualToString:name])
			return player;
	}
	return [m_players objectAtIndex:0];
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
	if (([[m_players objectAtIndex:m_currentPlayerIndex] IsOut] == YES) || ([[m_players objectAtIndex:m_currentPlayerIndex]  HasGivenUp] == YES)) {
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
			if (([[m_players objectAtIndex:i] IsOut] == NO) && ([[m_players objectAtIndex:i] HasGivenUp] == NO)) {
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
			[[m_players objectAtIndex:i] IncreaseScoreBy:score +[[m_players objectAtIndex:i] GetCurrentTimeMultiplier]];
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
	[topPlayer IncreaseScoreBy:score +[topPlayer GetCurrentTimeMultiplier]];
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
	[secondBestPlayer IncreaseScoreBy:score +[secondBestPlayer GetCurrentTimeMultiplier]];
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
	[thirdBestPlayer IncreaseScoreBy:score +[thirdBestPlayer GetCurrentTimeMultiplier]];
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
	[fourthBestPlayer IncreaseScoreBy:score +[fourthBestPlayer GetCurrentTimeMultiplier]];
	[fourthBestPlayer release];
	[sortedPlayerArray release];
}

-(void) SetTimeBonusPoints
{
   	for (Player *player in m_players) {
		[player IncreaseScoreBy:[player GetCurrentTimeMultiplier]];
	}
}

-(void) IncreaseScoresWithRoundScores 
{
    for (Player *player in m_players) {
		[player IncreaseScoreWithRoundScore];
	}
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

-(NSArray *) GetSortedPlayersForGame_LastStanding
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
			if( [[sortedPlayerArray objectAtIndex:(j-1)] GetQuestionsPassed]  <  [[sortedPlayerArray objectAtIndex:j] GetQuestionsPassed])
			{
				temp = [sortedPlayerArray objectAtIndex:(j-1)];
				[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
				[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
				swapped = YES;
			}
			else if([[sortedPlayerArray objectAtIndex:(j-1)] GetQuestionsPassed]  ==  [[sortedPlayerArray objectAtIndex:j] GetQuestionsPassed])
			{
				if([[sortedPlayerArray objectAtIndex:(j-1)] GetKmLeft]  <  [[sortedPlayerArray objectAtIndex:j] GetKmLeft])
				{
					temp = [sortedPlayerArray objectAtIndex:(j-1)];
					[sortedPlayerArray replaceObjectAtIndex:(j-1) withObject:[sortedPlayerArray objectAtIndex:j]];
					[sortedPlayerArray replaceObjectAtIndex:j withObject:temp];
					swapped = YES;
				}
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

-(void) UpdateAvgDistanceForQuest:(NSInteger) distanceBetweenPoints
{
	if (m_multiplayer == NO) {
		Question *tempQuestion = [[self GetQuestion] retain];
		MpLocation *tempLocation = [[tempQuestion GetLocation] retain];
		
		
		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
		[f setNumberStyle:NSNumberFormatterDecimalStyle];
		
		NSNumber * numerOfTimesAnswered;

		//read out times question answered
		FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT sumAnswers FROM location WHERE locationID = ?;",[tempLocation GetID]];
		while([results next]) {
            numerOfTimesAnswered = [results intForColumn:@"sumAnswers"];
		}
        [results close];
		
		NSNumber * averageDistanceFromTarget;
		//read out average distance 
		results = [[SqliteHelper Instance] executeQuery:@"SELECT avgDistance FROM location WHERE locationID = ?;", [tempLocation GetID]];
		while([results next]) {
				averageDistanceFromTarget =[results intForColumn:@"avgDistance"];
		}
        [results close];

        NSLog(@"%i",[numerOfTimesAnswered intValue]);
		//calculate new average distance
		NSInteger newAvgDistance = 0;
		if ([numerOfTimesAnswered intValue] == 0) {
			newAvgDistance = distanceBetweenPoints;
		}
		else {
			if ([averageDistanceFromTarget intValue] >= 0) {
				newAvgDistance = ( ([averageDistanceFromTarget intValue] * [numerOfTimesAnswered intValue])+ distanceBetweenPoints )/([numerOfTimesAnswered intValue] + 1);
				//newAvgDistance = ((distanceBetweenPoints + [averageDistanceFromTarget intValue]) / (1 + [numerOfTimesAnswered intValue]));
			}
		}


		

		//update quest with new values for "times question answered" and "average distance"
		[[SqliteHelper Instance] executeUpdate:@"UPDATE location SET avgDistance= ? , sumAnswers = ? WHERE locationID = ?;",
		 [NSNumber numberWithFloat:newAvgDistance],
		 [NSNumber numberWithInt:([numerOfTimesAnswered intValue] + 1)],
		 [tempLocation GetID]];
		
		
		//read out average distance 
		results = [[SqliteHelper Instance] executeQuery:@"SELECT avgDistance , sumAnswers FROM location WHERE locationID = ?;", [tempLocation GetID]];
		while ([results next]) {
            NSLog(@"SQLite -> avgDistance: %@", [results stringForColumn:@"avgDistance"]);
            NSLog(@"SQLite -> sumAnswers: %@", [results stringForColumn:@"sumAnswers"]);
		}
        [results close];
		
		[f release];
		[tempLocation release];
		[tempQuestion release];
	}
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

-(void) ResetTrainingValues
{
	[training_oldResultDictionary release];
	training_oldResultDictionary = nil;
	[training_newResultDictionary release];
	training_newResultDictionary = nil;
	[training_placesArray release];
	training_placesArray = nil;
}

-(void) Training_AddOldResult:(NSString*) place avgValue:(NSInteger) value
{
	if (training_oldResultDictionary == nil) {
		training_oldResultDictionary = [[NSMutableDictionary alloc] init];
	}
	[training_oldResultDictionary setObject:[NSNumber numberWithInt:value] forKey:place];
}

-(void) Training_AddNewResult:(NSString*) place avgValue:(NSInteger) value
{
	if (training_placesArray == nil) {
		training_placesArray = [[NSMutableArray alloc] init];
	}
	[training_placesArray addObject:place];
	
	if (training_newResultDictionary == nil) {
		training_newResultDictionary = [[NSMutableDictionary alloc] init];
	}
	[training_newResultDictionary setObject:[NSNumber numberWithInt:value] forKey:place];
}

-(NSArray*) Training_GetPlaces
{
	return training_placesArray;
}

-(NSDictionary*) Training_GetOldResults
{
	return training_oldResultDictionary;
}

-(NSDictionary*) Training_GetNewResults
{
	return training_newResultDictionary;
}


-(void)dealloc
{
	[m_players release];
	[super dealloc];
}

@end
