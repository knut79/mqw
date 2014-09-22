//
//  SqliteHelper.m
//  MQNorway
//
//  Created by knut dullum on 20/03/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "SqliteHelper.h"

#import <Foundation/Foundation.h>
#import "FMDB.h"

#define FMDBQuickCheck(SomeBool) { if (!(SomeBool)) { NSLog(@"Failure on line %d", __LINE__); abort(); } }

@implementation SqliteHelper

+(FMDatabase*) Instance
{
	static FMDatabase *Instance;
	
	@synchronized(self) {
		if(!Instance)
		{
            
            NSString *dbPath = @"/tmp/tmp.db";
            //NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"SQLiteTest.db"]
            
            // delete the old db.
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:dbPath error:nil];
            
            Instance = [[FMDatabase databaseWithPath:dbPath] retain];
            
            NSLog(@"Is SQLite compiled with it's thread safe options turned on? %@!", [FMDatabase isSQLiteThreadSafe] ? @"Yes" : @"No");
            
            {
                // -------------------------------------------------------------------------------
                // Un-opened database check.
                FMDBQuickCheck([Instance executeQuery:@"select * from table"] == nil);
                NSLog(@"%d: %@", [Instance lastErrorCode], [Instance lastErrorMessage]);
            }
            if (![Instance open]) {
                NSLog(@"Could not open db.");
                
                return 0;
            }
            
            
            FMResultSet *existsResult = [Instance executeQuery:@"SELECT name FROM sqlite_master WHERE type='table' AND name='bogusThree';"];
            [existsResult next];
			if([existsResult hasAnotherRow] == NO)
			{
                [Instance beginTransaction];
				[Instance executeUpdate:@"PRAGMA foreign_keys =off;"];
                FMDBQuickCheck(![Instance hadError]);
				
      			[Instance executeUpdate:@"DROP TABLE question"];
				[Instance executeUpdate:@"CREATE TABLE question ("
				 "questionID VARCHAR(25) PRIMARY KEY,locationRef VARCHAR(25),difficulty VARCHAR(25),"
				 "picture VARCHAR(25), hint VARCHAR(25),hintOrgLan VARCHAR(25),  english TEXT(25), norwegian TEXT(25), spanish TEXT(25),french TEXT(25),german TEXT(25));"];
                //"FOREIGN KEY(locationRef) REFERENCES location(locationID));"];
				
				//primary key failes
				[Instance executeUpdate:@"DROP TABLE answer"];
				[Instance executeUpdate:@"CREATE TABLE answer ("
				 "answerID VARCHAR(25) PRIMARY KEY, picture VARCHAR(25), middleFixEnglish TEXT, middleFixNorwegian TEXT, middleFixSpanish TEXT,"
				 "middleFixFrench TEXT,middleFixGerman TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE additionalInfo"];
				[Instance executeUpdate:@"CREATE TABLE additionalInfo ("
				 "infoID VARCHAR(25) PRIMARY KEY, infoEnglish TEXT, infoNorwegian TEXT, infoSpanish TEXT,"
				 "infoFrench TEXT,infoGerman TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE coordinates"];
				[Instance executeUpdate:@"CREATE TABLE coordinates ("
				 "coordinateID VARCHAR(25) PRIMARY KEY, withincoordinateID VARCHAR(25), kmtolerance NUMERIC NOT NULL, coordinates TEXT,"
				 "lineRefs TEXT,population NUMERIC, infoRef VARCHAR(25));"];
                //"FOREIGN KEY(infoRef) REFERENCES additionalInfo(infoID),"
                //"FOREIGN KEY(withincoordinateID) REFERENCES coordinates(coordinateID));"];
				
				//no real coupling between coordinates and line. Coordinate has a commaseparated list of line ids (lineRefs)
				[Instance executeUpdate:@"DROP TABLE line"];
				[Instance executeUpdate:@"CREATE TABLE line ("
				 "lineID TEXT PRIMARY KEY, coordinates TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE location"];
				[Instance executeUpdate:@"CREATE TABLE location ("
				 "locationID VARCHAR(25) PRIMARY KEY, locationNames TEXT,"
				 "locationNameEng TEXT, locationNameNor TEXT, locationNameSpn TEXT, locationNameFra TEXT, locationNameGer TEXT,"
				 "locationtype VARCHAR(25),"
				 "selectionChance NUMERIC NOT NULL, sumAnswers NUMERIC NOT NULL, avgDistance REAL,"
				 "coordianteRef VARCHAR(25),answerRef VARCHAR(25),"
				 "excludedCoordinatesRefs TEXT,"
				 "includedCoordinatesRefs TEXT);"];
                //"FOREIGN KEY(coordianteRef) REFERENCES coordinates(coordianteID),"
                //"FOREIGN KEY(answerRef) REFERENCES answer(answerID));"];
				
				
				[Instance executeUpdate:@"DROP TABLE savestate"];
				[Instance executeUpdate:@"CREATE TABLE savestate ("
				 "savestateID VARCHAR(25) PRIMARY KEY,shouldRestoreFlag VARCHAR(25),"
				 "playersRefs TEXT,gameType TEXT,playerRefTurn TEXT,language TEXT, currentView TEXT, questionID TEXT,"
				 "numberOfQuestions NUMERIC, gameState TEXT,gameQuestionsPassed NUMERIC);"];
				
				
				[Instance executeUpdate:@"DROP TABLE player"];
				[Instance executeUpdate:@"CREATE TABLE player ("
				 "playerID VARCHAR(25) ,name TEXT PRIMARY KEY,gamemarkerPoint TEXT,secondsUsed NUMERIC,"
				 "questionsPassed NUMERIC,distanceLeft NUMERIC,score NUMERIC,"
				 "totalDistance NUMERIC, barWidth NUMERIC, isOut BOOL,symbol TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE firstinstructions"];
				[Instance executeUpdate:@"CREATE TABLE firstinstructions ("
				 "playername TEXT, datestamp TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE globalID"];
				[Instance executeUpdate:@"CREATE TABLE globalID ("
				 "playerID TEXT, nationality TEXT, playerGuid TEXT);"];
				
				[Instance executeUpdate:@"DROP TABLE bogusThree"];
				[Instance executeUpdate:@"CREATE TABLE bogusThree ("
				 "bogusname TEXT);"];
				
                
				[Instance executeUpdate:@"DELETE FROM savestate;"];
				[Instance executeUpdate:@"DELETE FROM player;"];
				[Instance executeUpdate:@"DELETE FROM line;"];
				[Instance executeUpdate:@"DELETE FROM location;"];
				[Instance executeUpdate:@"DELETE FROM question;"];
				[Instance executeUpdate:@"DELETE FROM answer;"];
				[Instance executeUpdate:@"DELETE FROM coordinates;"];
				[Instance executeUpdate:@"DELETE FROM additionalInfo;"];
                [Instance commit];
			}
            [existsResult close];
			
		}
	}
	return Instance;
}


//-(void) releaseSqlite
//{
//	[Instance close];
//	[Instance release];
//}
@end
