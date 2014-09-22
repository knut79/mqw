//
//  Locations.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "LocationsHelper.h"


@implementation LocationsHelper

+(LocationsHelper*) Instance 
{
	static LocationsHelper *Instance;
	
	@synchronized(self) {
		if(!Instance)
		{
			Instance = [[LocationsHelper alloc] init];

		}
	}
	return Instance;
}

-(id) init
{
	if (self = [super init]) {
		m_locationsList = [[NSMutableArray alloc] init];
		
		[self InitLocations:@"states"];
		[self InitLocations:@"cities"];
		[self InitLocations:@"lakes"];
		[self InitLocations:@"fjords"];
		[self InitLocations:@"islands"];
		[self InitLocations:@"places"];
		[self InitQuestions];
	}
	return self;
}


-(void) InitLocations:(NSString*) fileName
{
	NSMutableArray *region_points = [[NSMutableArray alloc] init];
	BOOL firstCoordinateEntry = YES;
	
	NSMutableArray *oneLine = [[NSMutableArray alloc] init];
	NSMutableArray *multipleLines = [[NSMutableArray alloc] init];
	
	BOOL firstLineEntry = YES;
	
	
	NSMutableArray *data = [[NSMutableArray alloc] init];
	NSString *placeName;
	NSString *coordinateLabel;
	Difficulty questDifficulty;
	NSString *aocFileName =@"";
	NSMutableArray *additionalQuestions = nil;
	NSString *additionalQuestionString;
	NSString *additionalInfo = [[NSString alloc] init];
	BOOL shouldBeDrawn = NO;
	BOOL collectLine = NO;
	NSInteger population = 0;
	NSInteger x,y;
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]; 
	//UTF8String into fopen
	FILE *file = fopen([filePath cStringUsingEncoding:1], "r");
	if (file == NULL) NSLog([filePath stringByAppendingString:@" not found"]);
	while(!feof(file))
	{
		NSString *input = [self ReadLineAsNSString:file];
		
		//NSLog(@"regionName is %@", regionName);
		// do stuff with line; line is autoreleased, so you should NOT release it (unless you also retain it beforehand)
		//		data = input.Split(',');
		[data setArray:[input componentsSeparatedByString:@","]];
		NSString *dataObj0 = [data objectAtIndex:0];
		if([dataObj0 isEqualToString:@"eof"]) 
		{
			break;
		}
		
		if([dataObj0 isEqualToString:@"inf"]) 
		{
			placeName = [data objectAtIndex:2];
			questDifficulty = easy; 
			
			if (data.count > 3) {
				population = [[data objectAtIndex:3] integerValue];
			}
			
			if (data.count > 4) {
				if ([[data objectAtIndex:4] isEqualToString:@"medium"]) {
					questDifficulty = medium;					
				}
				else if([[data objectAtIndex:4] isEqualToString:@"hard"]) {
					questDifficulty = hardDif;
				}
				else if([[data objectAtIndex:4] isEqualToString:@"veryhard"]) {
					questDifficulty = veryhardDif;
				}
				else if([[data objectAtIndex:4] isEqualToString:@"notUsed"]){
					questDifficulty = notUsed;
				}
				
			}
			
			additionalInfo = @"";
			if (data.count > 5) {
				additionalInfo = [data objectAtIndex:5];
			}
			
			
			NSString *dataObj1 = [data objectAtIndex:1];
			if ([dataObj1 isEqualToString:@"State"] || [dataObj1 isEqualToString:@"Lake"] || [dataObj1 isEqualToString:@"Fjord"] || [dataObj1 isEqualToString:@"Island"] || 
				[dataObj1 isEqualToString:@"Peninsula"] || [dataObj1 isEqualToString:@"UnDefRegion"]) {
				
				//draw the line from start point to end point of region _bugfix
				NSValue *tempFirstPointValue = [region_points objectAtIndex:0];
				CGPoint tempFirstPoint = [tempFirstPointValue CGPointValue];
				NSValue *tempLastPointValue = [region_points objectAtIndex:region_points.count -1];
				CGPoint tempLastPoint = [tempLastPointValue CGPointValue];
				
				NSMutableArray *aTempLine = [[NSMutableArray alloc] init];
				[aTempLine addObject:[NSValue valueWithCGPoint:tempFirstPoint]];
				[aTempLine addObject:[NSValue valueWithCGPoint:tempLastPoint]];
				
				[multipleLines addObject:aTempLine];
				
				NSMutableArray *vPolygon = [[NSMutableArray alloc] init];
				[vPolygon addObject:[NSValue valueWithCGPoint:CGPointMake(5.5, 6.6)]];
				[vPolygon addObject:[NSValue valueWithCGPoint:CGPointMake(6.5, 7.6)]];
				
				if ([dataObj1 isEqualToString:@"State"])
				{
					State *tempState = [[State alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
													andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
												 andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempState];
					
				}
				else if ([dataObj1 isEqualToString:@"Lake"]){
					Lake *tempLake = [[Lake alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
												 andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
											  andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempLake];
				}
				else if ([dataObj1 isEqualToString:@"Fjord"]){
					Fjord *tempFjord = [[Fjord alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
													andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
												 andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempFjord];
				}
				else if ([dataObj1 isEqualToString:@"Island"]){
					Island *tempIsland = [[Island alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
													   andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
													andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempIsland];
				}
				else if ([dataObj1 isEqualToString:@"Peninsula"]){
					Peninsula *tempPeninsula = [[Peninsula alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
																andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
															 andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempPeninsula];
				}
				else {
					UnDefRegion *tempUnDefRegion = [[UnDefRegion alloc] initWithName:placeName andCounty:@"" andState:@"" andPolygon:region_points 
																	  andLinesToDraw:multipleLines andArmsOfCoat:aocFileName andAdditionalQuestions:additionalQuestions 
																   andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty]; 
					[m_locationsList addObject:tempUnDefRegion];
				}
				
				
				
				firstLineEntry = YES;
				firstCoordinateEntry = YES;
				questDifficulty = noDifficulty;
				[region_points release];
				[multipleLines release];
				//[multipleLines removeAllObjects];
				additionalQuestions = nil;
				aocFileName = @"";
			}
			else if ([dataObj1 isEqualToString:@"City"] || [dataObj1 isEqualToString:@"Mountain"] || [dataObj1 isEqualToString:@"UnDefPlace"])
			{
				
				NSValue *tempPointValue = [region_points objectAtIndex:0];
				CGPoint tempPoint = [tempPointValue CGPointValue];
				
				if ([dataObj1 isEqualToString:@"City"])
				{
					City *tempCity = [[City alloc] initWithName:placeName andCounty:@"" andState:@"" andPoint:tempPoint
												 andKmTolerance:ktlarge andArmsOfCoat:aocFileName andPopulation:population andAdditionalQuestions:additionalQuestions 
											  andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty];
					[m_locationsList addObject:tempCity];
				}
				else if ([dataObj1 isEqualToString:@"Mountain"]){
					Mountain *tempMountain = [[Mountain alloc] initWithName:placeName andCounty:@"" andState:@"" andPoint:tempPoint
															 andKmTolerance:ktlarge andArmsOfCoat:aocFileName andPopulation:population andAdditionalQuestions:additionalQuestions 
														  andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty];
					[m_locationsList addObject:tempMountain];
				}
				else {
					UnDefPlace *tempUnDefPlace = [[UnDefPlace alloc] initWithName:placeName andCounty:@"" andState:@"" andPoint:tempPoint
																   andKmTolerance:ktlarge andArmsOfCoat:aocFileName andPopulation:population andAdditionalQuestions:additionalQuestions 
																andAdditionalInfo:additionalInfo andQuestDifficulty:questDifficulty];
					[m_locationsList addObject:tempUnDefPlace];
				}
				
				
				firstLineEntry = YES;
				firstCoordinateEntry = YES;
				additionalQuestions = nil;
				aocFileName = @"";
			}
			
			questDifficulty = noDifficulty;
			population = 0;
			
		}
		else if([dataObj0 isEqualToString:@"aoc"]){
			aocFileName = [data objectAtIndex:1];
		}
		else if([dataObj0 isEqualToString:@"qst"]){
			if (additionalQuestions == nil) {
				additionalQuestions = [[NSMutableArray alloc] init];
			}
			
			additionalQuestionString = [[data objectAtIndex:1] retain];
			
			[additionalQuestions addObject:additionalQuestionString];
			[additionalQuestionString release];
		}
		else 
		{
			if (firstCoordinateEntry == YES) {
				region_points = [[NSMutableArray alloc] init];
				firstCoordinateEntry = NO;
			}
			//fetch coordinates
			x = [[data objectAtIndex:0] integerValue];
			y = [[data objectAtIndex:1] integerValue];
			
			if (data.count > 2) {
				coordinateLabel = [data objectAtIndex:2];
				if([coordinateLabel isEqualToString:@"st"])
				{
					shouldBeDrawn = YES;
				}
				else if([coordinateLabel isEqualToString:@"sl"])
				{
					collectLine = YES;
				}
			}
			
			if (shouldBeDrawn == YES) 
			{
				[oneLine addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
				if (collectLine) {
					shouldBeDrawn = NO;
					collectLine = NO;
					
					if (firstLineEntry == YES) {
						multipleLines = [[NSMutableArray alloc] init];
						firstLineEntry = NO;
					}
					[multipleLines addObject:oneLine];

					[oneLine release];
					oneLine =  [[NSMutableArray alloc] init];
					
				}
			}
			
			
			[region_points addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
		}
		
		
	}
	fclose(file);
}


-(void) InitQuestions
{
	m_questionsRaw = [[NSMutableArray alloc] init];
	
	Question *quest;
	NSMutableArray *additionalQuestions;
	for (MpLocation *loc in m_locationsList) 
	{
		//make one question for each of the additional questions with the same location
		additionalQuestions = [[loc GetAdditionalQuestions] retain];
		for (NSString *additionalQuestion in additionalQuestions) {
			quest = [[[Question alloc] initWithLanguage:[[GlobalSettingsHelper Instance] GetLanguage] andLocation:loc andQuestionString:additionalQuestion] retain];
			[m_questionsRaw addObject:quest];
			[quest retain];
		}
		quest = [[[Question alloc] initWithLanguage:[[GlobalSettingsHelper Instance] GetLanguage] andLocation:loc] retain];
		
		[m_questionsRaw addObject:quest];
		[quest release];
		[additionalQuestions release];
	}
	
	//categorize the questions
	m_questionsByCategory = [[NSMutableDictionary alloc] initWithCapacity:3];
	
	NSMutableArray *veryhardArray = [self CollectQuestionsOnCategory:veryhardDif];
	[m_questionsByCategory setObject:veryhardArray forKey:@"veryhardDif"];
	
	NSMutableArray *hardArray = [self CollectQuestionsOnCategory:hardDif];
	[m_questionsByCategory setObject:hardArray forKey:@"hardDif"];
	
	NSMutableArray *easyArray = [self CollectQuestionsOnCategory:easy];
	[m_questionsByCategory setObject:easyArray  forKey:@"easy"];
	
	NSMutableArray *mediumArray = [self CollectQuestionsOnCategory:medium];
	[m_questionsByCategory setObject:mediumArray forKey:@"medium"];
	
	[self ShuffleQuestions];
}

-(NSMutableArray*) CollectQuestionsOnCategory:(Difficulty) category
{
	NSMutableArray *collectedQuestons = [[NSMutableArray alloc] init];
	for (Question *quest in m_questionsRaw){
		if ([quest GetDifficulty] == category ) {
			[collectedQuestons addObject:quest];
		}
	}
	return [collectedQuestons autorelease];
}

//is done once pr game
//shuffle the questions,then organising with the least used first
-(void) ShuffleQuestions
{
	NSMutableArray *questionsOnType = nil;
	NSString *difficultyKey;
	for (int diff = 0;diff < 3; diff ++) 
	{
		if (diff == 3) {
			difficultyKey = @"veryhardDif";
		}
		if (diff == 2) {
			difficultyKey = @"hardDif";
		}
		else if(diff == 1){
			difficultyKey = @"medium";
		}
		else if(diff == 0){
			difficultyKey = @"easy";
		}
		
		
		questionsOnType = [m_questionsByCategory objectForKey:difficultyKey];
		questionsOnType = [self ShuffleArray:questionsOnType];
		
		//bubblesort
		Question *temp;
		BOOL swapped;
		for(int i = ([questionsOnType count] - 1); i >= 0; i-- )
		{
			swapped = NO;
			for(int j = 1; j <= i; j++ )
			{
				if( [[questionsOnType objectAtIndex:(j-1)] GetUsedCount]  >  [[questionsOnType objectAtIndex:j] GetUsedCount])
				{
					temp = [questionsOnType objectAtIndex:(j-1)];
					[questionsOnType replaceObjectAtIndex:(j-1) withObject:[questionsOnType objectAtIndex:j]];
					[questionsOnType replaceObjectAtIndex:j withObject:temp];
					swapped = YES;
				}
			}
			if (swapped == NO) {
				break;
			}
		}
		
		[m_questionsByCategory setObject:questionsOnType forKey:difficultyKey];
		//[questionsOnType release];
	}
}

-(NSArray *)ShuffleArray:(NSMutableArray*) arrayToShuffle
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[arrayToShuffle count]];
	NSMutableArray *copy = [arrayToShuffle mutableCopy];
	while ([copy count] > 0)
	{
		int index = arc4random() % [copy count];
		id objectToMove = [copy objectAtIndex:index];
		[array addObject:objectToMove];
		[copy removeObjectAtIndex:index];
	}
	[copy release];
	return array;
}

-(NSString *) ReadLineAsNSString:(FILE *) file
{
    char buffer[4096];
	
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
 	NSMutableString *result = [NSMutableString stringWithCapacity:256];
	
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
		{
            [result appendFormat:@"%@", [NSString stringWithUTF8String:buffer]];
			//[result appendFormat:@"%s", buffer];
		}
        else
            break;
    } while(charsRead == 4095);
	
    return result;
}

-(NSMutableArray *) GetQuestionsOnDifficulty:(Difficulty) difficulty
{
	NSMutableArray *qOnType = nil;	
	switch (difficulty) {
		case veryhardDif:
			qOnType = [m_questionsByCategory objectForKey:@"veryhardDif"];
			break;
		case hardDif:
			qOnType = [m_questionsByCategory objectForKey:@"hardDif"];
			break;
		case easy:
			qOnType = [m_questionsByCategory objectForKey:@"easy"];
			break;
		case medium:
			qOnType = [m_questionsByCategory objectForKey:@"medium"];
			break;
		default:
			break;
	}
	return qOnType;
}



@end
