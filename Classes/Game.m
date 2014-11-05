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
		
		m_difficulty = level1;
		m_initialDifficulty = level1;
		m_currentQuestionIndex = 0;
		m_gameQuestionsPassed = 0;
		m_gameState = outOfGame;
        challenge = [[Challenge alloc] init];
	}
	return self;
}

-(void) SetPlayer:(Player *) player andDifficulty:(Difficulty) difficulty
{
    m_player = [player retain];
	m_difficulty = difficulty;
	m_initialDifficulty = difficulty;
	m_currentQuestionIndex = 0;
	m_highscores = [[Highscore alloc] init];
	m_gameQuestionsPassed = 0;
	//[[LocationsHelper Instance] ShuffleQuestions];
}

-(void) SetTrainingMode:(BOOL) training
{
	m_training = training;
}

-(void) SetMapBorder:(BOOL) value
{
    m_borders = value;
}

-(BOOL) IsTrainingMode
{
	return m_training;
}

-(BOOL) UsingBorders
{
    return m_borders;
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

}

-(void) SaveGame
{
	[[SqliteHelper Instance] executeUpdate:@"DELETE FROM savestate;"];
	[[SqliteHelper Instance] executeUpdate:@"DELETE FROM player;"];
	
	[[SqliteHelper Instance] executeUpdate:@"INSERT INTO savestate VALUES (?, ?, ?, ?, ?, ?,?,?,?,?,?);",
	 @"ID01",@"1",@"per",@"no game type",[m_player GetName],
	 [EnumHelper languageToString:[[GlobalSettingsHelper Instance] GetLanguage]],@"drawResult",[[self GetQuestion] GetID],
	 0, [EnumHelper gamestateToString:m_gameState],[NSNumber numberWithInt:m_gameQuestionsPassed]];


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

-(Question*) GetQuestion
{
	NSMutableArray *qOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training];
	Question* returnQuestion = [qOnType objectAtIndex:m_currentQuestionIndex] ;
	return returnQuestion;
}

-(BOOL) IsMoreQuestionsForTraining
{
    BOOL moreQuestionsForTraining = YES;
    if (m_training == YES) {
        if (m_currentQuestionIndex >= [[[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training] count])
        {
            moreQuestionsForTraining = NO;
        }
    }
    return moreQuestionsForTraining;
}

-(void) SetNextQuestion
{
	
	NSArray *questionsOnType = [[LocationsHelper Instance] GetQuestionsOnDifficulty:m_difficulty trainingMode:m_training];

	m_currentQuestionIndex ++;
	
	if (m_training == NO) {
        //reset currentQuestionIndex if all questions for a difficulty level is used
		if (m_currentQuestionIndex >= [questionsOnType count]) {
			if (m_difficulty == level1) {
				m_difficulty = level2;
				m_currentQuestionIndex = 0;
			}
			else if (m_difficulty == level2) {
				m_difficulty = level3;
				m_currentQuestionIndex = 0;
			}
			else if (m_difficulty == level3) {
				m_difficulty = level4;
				m_currentQuestionIndex = 0;
			}
			else if (m_difficulty == level4) {
				m_difficulty = level5;
				m_currentQuestionIndex = 0;
			}
			else if (m_difficulty == level5) {
				m_difficulty = level5;
				m_currentQuestionIndex = 0;
                [NSException raise:@"No more questions" format:@"No more questions. All questions on level5 used."];
			}
		}
	}
	else //Training mode 
	{
		if (m_currentQuestionIndex >= [questionsOnType count])
		{
			[[LocationsHelper Instance] CategorizeQuestionsForTraining];
			//do this for next game
			m_currentQuestionIndex = 0;
		}
	}
}

-(Highscore*) GetHighscore
{
	return m_highscores;
}


-(Player*) GetPlayer
{
	return m_player ;//_? retain inside
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
    [m_player ResetScore];
    [m_player ResetGamePoint];
    [m_player ResetPosition];
}


-(void) UpdateAvgDistanceForQuest:(NSInteger) distanceBetweenPoints
{

    Question *tempQuestion = [[self GetQuestion] retain];
    MpLocation *tempLocation = [[tempQuestion GetLocation] retain];
    
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
    int numerOfTimesAnswered = 0;

    //read out times question answered
    FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT sumAnswers FROM location WHERE locationID = ?;",[tempLocation GetID]];
    while([results next]) {
        numerOfTimesAnswered = [results intForColumn:@"sumAnswers"];
    }
    [results close];
    
    int averageDistanceFromTarget;
    //read out average distance 
    results = [[SqliteHelper Instance] executeQuery:@"SELECT avgDistance FROM location WHERE locationID = ?;", [tempLocation GetID]];
    while([results next]) {
            averageDistanceFromTarget =[results intForColumn:@"avgDistance"];
    }
    [results close];

    NSLog(@"%i",numerOfTimesAnswered);
    //calculate new average distance
    NSInteger newAvgDistance = 0;
    if (numerOfTimesAnswered == 0) {
        newAvgDistance = distanceBetweenPoints;
    }
    else {
        if (averageDistanceFromTarget >= 0) {
            newAvgDistance = ( (averageDistanceFromTarget * numerOfTimesAnswered)+ distanceBetweenPoints )/(numerOfTimesAnswered + 1);
            //newAvgDistance = ((distanceBetweenPoints + [averageDistanceFromTarget intValue]) / (1 + [numerOfTimesAnswered intValue]));
        }
    }


    

    //update quest with new values for "times question answered" and "average distance"
    [[SqliteHelper Instance] executeUpdate:@"UPDATE location SET avgDistance= ? , sumAnswers = ? WHERE locationID = ?;",
     [NSNumber numberWithFloat:newAvgDistance],
     [NSNumber numberWithInt:(numerOfTimesAnswered+ 1)],
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

-(void) IncreasQuestionsPassed
{
	m_gameQuestionsPassed ++;
}

-(NSInteger) GetQuestionsPassed
{
	return m_gameQuestionsPassed;
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
	[m_player release];
	[super dealloc];
}

@end
