//
//  Highscore.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Highscore.h"

@implementation Highscore

-(id) init
{
	if (self = [super init]) {
		
		NSError *error;
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		pathEasy = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreEasy.plist"]retain];
		NSFileManager *fileManager = [NSFileManager defaultManager];
		if(![fileManager fileExistsAtPath:pathEasy])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreEasy" ofType:@"plist"];
			[fileManager removeItemAtPath:pathEasy error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathEasy error:&error];
		}		
		m_highscoreListEasy = [[NSMutableArray alloc] initWithContentsOfFile:pathEasy];
		
		pathMedium = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreMedium.plist"]retain];
		if(![fileManager fileExistsAtPath:pathMedium])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreMedium" ofType:@"plist"];
			[fileManager removeItemAtPath:pathMedium error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathMedium error:&error];
		}		
		m_highscoreListMedium = [[NSMutableArray alloc] initWithContentsOfFile:pathMedium];
		
		pathHard = [[documentsDirectory stringByAppendingPathComponent:@"HighscoreHard.plist"]retain];
		if(![fileManager fileExistsAtPath:pathHard])
		{
			NSString *boundle = [[NSBundle mainBundle] pathForResource:@"HighscoreHard" ofType:@"plist"];
			[fileManager removeItemAtPath:pathHard error:&error];
			[fileManager copyItemAtPath:boundle toPath:pathHard error:&error];
		}		
		m_highscoreListHard = [[NSMutableArray alloc] initWithContentsOfFile:pathHard];
	}
	return self;
}

-(NSInteger) CheckIfNewHighScore:(Player*) player difficultyLevel:(Difficulty) diffLevel
{
	int placeOnTheList = 99;
	int playerScore = [player GetScore];
	int playerTime = [player GetSecondsUsed];
	int indexFound = 99;
	
	NSMutableArray *tempHighscoreList;
	NSString *tempPath;
	switch (diffLevel) {
		case easy:
			tempHighscoreList = [m_highscoreListEasy retain]; 
			tempPath = [pathEasy retain];
			break;
		case medium:
			tempHighscoreList = [m_highscoreListMedium retain]; 
			tempPath = [pathMedium retain];
			break;
		default:
			tempHighscoreList = [m_highscoreListHard retain]; 
			tempPath = [pathHard retain];
			break;
	}
	
	for (int i = 0; i< 10; i++) {
			NSDictionary *highscorePlayerData = [tempHighscoreList objectAtIndex:i];
			NSInteger points = [[highscorePlayerData objectForKey:@"points"] intValue];
			NSInteger time = [[highscorePlayerData objectForKey:@"time"] intValue];
			if (playerScore >= points) {
				if (playerScore > points) {
					indexFound = i;
					break;
				}
				else if(playerTime <= time) {
					indexFound = i;
					break;
				}
			}
	}
	
	if (indexFound != 99) {
		placeOnTheList = indexFound + 1;
		NSMutableDictionary *newHighscorePlayerData = [[tempHighscoreList objectAtIndex:indexFound] mutableCopy];
		NSString *name = [[player GetName] retain];
		NSInteger easyQ = [player GetEasyQuestionsPassed];
		NSInteger mediumQ = [player GetMediumQuestionsPassed];
		NSInteger hardQ = [player GetHardQuestionsPassed];
		NSInteger time = [player GetSecondsUsed];
		NSInteger points = [player GetScore];
		[newHighscorePlayerData setObject:name forKey:@"name"];
		[name release];
		[newHighscorePlayerData setObject:[NSNumber numberWithInt:easyQ] forKey:@"easyQ"];
		[newHighscorePlayerData setObject:[NSNumber numberWithInt:mediumQ] forKey:@"mediumQ"];
		[newHighscorePlayerData setObject:[NSNumber numberWithInt:hardQ] forKey:@"hardQ"];
		[newHighscorePlayerData setObject:[NSNumber numberWithInt:time] forKey:@"time"];
		[newHighscorePlayerData setObject:[NSNumber numberWithInt:points] forKey:@"points"];
		
		for (int i = 9 ; i > indexFound ; i--) {
			[tempHighscoreList replaceObjectAtIndex:i withObject:[tempHighscoreList objectAtIndex:i-1]];
		}
		[tempHighscoreList replaceObjectAtIndex:indexFound withObject:newHighscorePlayerData];
		
		[tempHighscoreList writeToFile:tempPath atomically:YES];

	}
	[tempHighscoreList release];
	[tempPath release];

	return placeOnTheList;
}


- (void)dealloc {
	[pathEasy release];
	[pathMedium release];
	[pathHard release];
	[m_highscoreListEasy release];
	[m_highscoreListMedium release];
	[m_highscoreListHard release];
    [super dealloc];
}

@end
