//
//  Locations.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "LocationsHelper.h"
#import "SqliteHelper.h"
#import "NSArray(dataConversion).h"
#import "EnumHelper.h"



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
		m_questionsList = [[NSMutableArray alloc] init];
     
		FMResultSet *existsResult = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM question;"];
        if ([[SqliteHelper Instance] hadError]) {
            NSLog(@"Err %d: %@", [[SqliteHelper Instance] lastErrorCode], [[SqliteHelper Instance] lastErrorMessage]);
        }
        [existsResult next];
        if([existsResult hasAnotherRow] == NO)
		{

			//ReadQuestionsFromFileToDatabase must be read after all locations are put into the database as
			//they refere to locations
          [self ReadLocationsFromFileToDatabase:@"test"];
//            [self ReadLocationsFromFileToDatabase:@"statesAfrica"];
//            [self ReadLocationsFromFileToDatabase:@"statesEastAsia"];
//            [self ReadLocationsFromFileToDatabase:@"statesSouthAmerica"];
//            [self ReadLocationsFromFileToDatabase:@"statesNorthAmerica"];
//            [self ReadLocationsFromFileToDatabase:@"statesOceania"];
//            [self ReadLocationsFromFileToDatabase:@"states"];
//			[self ReadLocationsFromFileToDatabase:@"cities"];
//			[self ReadLocationsFromFileToDatabase:@"lakes"];
//			[self ReadLocationsFromFileToDatabase:@"fjords"];
//			[self ReadLocationsFromFileToDatabase:@"islands"];
//			[self ReadLocationsFromFileToDatabase:@"places"];

				
//			[self ReadLocationsFromFileToDatabase:@"armsOfCoat"];
//			[self ReadQuestionsFromFileToDatabase:@"pictureQuestions"];
		}
		[existsResult close];
		[self InitQuestions];
		[self CategorizeQuestions];

	}
	return self;
}

-(void) ReInitQuestions
{
	[m_questionsByCategory removeAllObjects];
	[m_questionsList removeAllObjects];
	
	[self InitQuestions];
	[self CategorizeQuestions];
}

//-(void) ReadLocationsFromFileToDatabase:(NSString*) fileName
-(void) ReadQuestionsFromFileToDatabase:(NSString*) fileName
{
	NSMutableArray *data = [[NSMutableArray alloc] init];
	//NSInteger index =0;

	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"];

	//UTF8String into fopen
	FILE *file = fopen([filePath cStringUsingEncoding:1], "r");
	if (file == NULL) NSLog(@"%@", [filePath stringByAppendingString:@" not found"]);
    [[SqliteHelper Instance] beginTransaction];
	while(!feof(file))
	{
		NSString *input = [self ReadLineAsNSString:file];
		
		[data setArray:[input componentsSeparatedByString:@";"]];
		NSString *dataObj0 = [data objectAtIndex:0];
		if([dataObj0 isEqualToString:@"eof"]) 
		{
			break;
		}

        if([dataObj0 isEqualToString:@"qst"]) 
		{
			NSString *refToLocation = [[NSString alloc] init];
			NSString *hint1 = [[NSString alloc] init];
			NSString *hint2 = [[NSString alloc] init];
            NSString *questionID = [[NSString alloc] init];
			
			NSMutableArray *additionalQuestionComponentsArray = [[NSMutableArray alloc] init];
 
			[additionalQuestionComponentsArray setArray:[[data objectAtIndex:1] componentsSeparatedByString:@"#"]];
			if (additionalQuestionComponentsArray.count == 11) {

				questionID = [NSString stringWithFormat:@"%@",[additionalQuestionComponentsArray objectAtIndex:0]];
				refToLocation = [additionalQuestionComponentsArray objectAtIndex:1];
				
                FMResultSet *resultsCoordinates = [[SqliteHelper Instance] executeQuery:@"SELECT count(*) AS count FROM location WHERE locationID =?;",refToLocation];
				[resultsCoordinates next];
                if([resultsCoordinates intForColumn:@"count"] == 0){
                    [NSException raise:@"Invalid question reference" format:@"Could not find reference %@ for question %@",refToLocation,questionID];
				}
                NSLog(@"reference %@ for question %@",refToLocation,questionID);
                
                [resultsCoordinates close];

				hint1 = [additionalQuestionComponentsArray objectAtIndex:9];
				if ([hint1 isEqualToString:@""]) {
					hint1 = @"fix this";//[[resultsCoordinates objectAtIndex:0] objectForKey:@"locationtype"];
				}
				hint2 = [additionalQuestionComponentsArray objectAtIndex:10];
				if ([hint2 isEqualToString:@""]) {
					hint2 = hint1;
				}
                
                
				//DB->id,locRef,diff,pic,eng.....
				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO question VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?,?);",
				 questionID,
				 refToLocation,
				 [additionalQuestionComponentsArray objectAtIndex:2],
				 [additionalQuestionComponentsArray objectAtIndex:3],
				 hint1,hint2,
				 [additionalQuestionComponentsArray objectAtIndex:4],
				 [additionalQuestionComponentsArray objectAtIndex:5],
				 [additionalQuestionComponentsArray objectAtIndex:6],
				 [additionalQuestionComponentsArray objectAtIndex:7],
				 [additionalQuestionComponentsArray objectAtIndex:8]];
				
			}
			else {
                [NSException raise:@"Invalid values" format:@"Could not insert values into question table for %@. %d values, should be 11", questionID,additionalQuestionComponentsArray.count];
			}
            
		}
	}
    [[SqliteHelper Instance] commit];
	fclose(file);

}

-(void) ReadLocationsFromFileToDatabase:(NSString*) fileName
{
	NSMutableArray *region_points = [[NSMutableArray alloc] init];
	BOOL firstCoordinateEntry = YES;
	
	NSMutableArray *oneLine = [[NSMutableArray alloc] init];
	NSMutableArray *multipleLines = [[NSMutableArray alloc] init];
	
	BOOL firstLineEntry = YES;
	
	
	NSMutableArray *data = [[NSMutableArray alloc] init];
	NSMutableDictionary *placeNameDictionary = [[NSMutableDictionary alloc] init];
	NSString *placeId;
	NSString *coordinateLabel;
	Difficulty questDifficulty;
	NSMutableArray *additionalQuestions = nil;
	NSString *additionalQuestionString;
	NSString *additionalInfo = [[NSString alloc] init];
	NSString *defaultHint = [[NSString alloc] init];
	NSString *overridingHint = [[NSString alloc] init];
	NSString *defaultHint2 = [[NSString alloc] init];
	NSString *overridingHint2 = [[NSString alloc] init];
	NSString *excludedRegions = [[NSString alloc] init];
	NSString *includedRegions = [[NSString alloc] init];
	BOOL shouldBeDrawn = NO;
	BOOL collectLine = NO;
	NSInteger kmTolerance = 0;
	NSInteger x,y;
	
	NSString* questDifficultyAsString;

	NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"txt"]; 
	//UTF8String into fopen
	FILE *file = fopen([filePath cStringUsingEncoding:1], "r");
	if (file == NULL) NSLog(@"%@", [filePath stringByAppendingString:@" not found"]);
    [[SqliteHelper Instance] beginTransaction];
	while(!feof(file))
	{
        
		NSString *input = [self ReadLineAsNSString:file];
		
		[data setArray:[input componentsSeparatedByString:@";"]];
		NSString *dataObj0 = [data objectAtIndex:0];
		if([dataObj0 isEqualToString:@"eof"]) 
		{
			break;
		}
		
		if([dataObj0 isEqualToString:@"inf"]) 
		{
			NSMutableArray *placeIDandNameComponentsArray = [[NSMutableArray alloc] init];
			[placeIDandNameComponentsArray setArray:[[data objectAtIndex:2] componentsSeparatedByString:@"#"]];
			
			//placeName = [data objectAtIndex:2];
			if (placeIDandNameComponentsArray.count > 1) {
				NSMutableArray *placeNameArray = [[NSMutableArray alloc] init];
				[placeNameArray setArray:[[placeIDandNameComponentsArray objectAtIndex:1] componentsSeparatedByString:@"$"]];
				
				if(placeNameArray.count == 5)
				{
					[placeNameDictionary setObject:[placeNameArray objectAtIndex:0] forKey:@"english"];
					[placeNameDictionary setObject:[placeNameArray objectAtIndex:1] forKey:@"norwegian"];
					[placeNameDictionary setObject:[placeNameArray objectAtIndex:2] forKey:@"spanish"];
					[placeNameDictionary setObject:[placeNameArray objectAtIndex:3] forKey:@"french"];
					[placeNameDictionary setObject:[placeNameArray objectAtIndex:4] forKey:@"german"];
				}
				else {
					[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:1] forKey:@"english"];
					[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:1] forKey:@"norwegian"];
					[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:1] forKey:@"spanish"];
					[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:1] forKey:@"french"];
					[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:1] forKey:@"german"];
				}

				//placeName = [placeIDandNameComponentsArray objectAtIndex:1];
			}
			else {
				[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:0] forKey:@"english"];
				[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:0] forKey:@"norwegian"];
				[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:0] forKey:@"spanish"];
				[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:0] forKey:@"french"];
				[placeNameDictionary setObject:[placeIDandNameComponentsArray objectAtIndex:0] forKey:@"german"];
				//placeName = [placeIDandNameComponentsArray objectAtIndex:0];
			}
			//NSLog(@"--- value for english : %@",[placeNameDictionary objectForKey:@"english"]);
			
			
			placeId = [placeIDandNameComponentsArray objectAtIndex:0];

			
			questDifficulty = easy; 
			questDifficultyAsString = @"easy";
			
			if (data.count > 3) {
				kmTolerance = [[data objectAtIndex:3] integerValue];
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
//				else {
//					NSLog(@"questDifficulty for %@ is apparently %@",placeId,[data objectAtIndex:4]);				}

				questDifficultyAsString = [data objectAtIndex:4];
				
			}
//			else {
//				NSLog(@"Datacount lower than 4 for %@",placeId);
//			}

			
			additionalInfo = @"";
			if (data.count > 5) {
				additionalInfo = [data objectAtIndex:5];
			}
			defaultHint = @"";
			defaultHint2 = @"";
			if (data.count > 6) {
				NSMutableArray *defaultHintComponentsArray = [[NSMutableArray alloc] init];
				[defaultHintComponentsArray setArray:[[data objectAtIndex:6] componentsSeparatedByString:@"#"]];
				defaultHint = [defaultHintComponentsArray objectAtIndex:0];
				if (defaultHintComponentsArray.count > 1) 
					defaultHint2 = [defaultHintComponentsArray objectAtIndex:1];
				else 
					defaultHint2  = defaultHint;
			}

			excludedRegions = @"";
			if (data.count > 7) {
				excludedRegions = [data objectAtIndex:7];
			}
			includedRegions = @"";
			if (data.count > 8) {
				includedRegions = [data objectAtIndex:8];
			}
			
			
			NSString *dataObj1 = [data objectAtIndex:1];
			
			if ([defaultHint isEqualToString:@""]) {
				defaultHint = dataObj1;
			}
			if ([defaultHint2 isEqualToString:@""]) {
				defaultHint2 = defaultHint;
			}
			
			if ([dataObj1 isEqualToString:@"State"] || [dataObj1 isEqualToString:@"County"] || [dataObj1 isEqualToString:@"Lake"] || [dataObj1 isEqualToString:@"Fjord"] || [dataObj1 isEqualToString:@"Island"] || 
				[dataObj1 isEqualToString:@"Peninsula"] || [dataObj1 isEqualToString:@"UnDefRegion"]) {
				
				
				NSMutableDictionary *defaultAnswerDictionary = [[NSMutableDictionary alloc] init];
				NSMutableDictionary *defaultQuestionDictionary = [[NSMutableDictionary alloc] init];
				
				if ([dataObj1 isEqualToString:@"State"]) {
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@ state border",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra staten %@s grense",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is the state %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger staten %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist der Staat %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}
				else if ([dataObj1 isEqualToString:@"County"]){
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@ county border",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra %@ fylkesgrense",[placeNameDictionary objectForKey:@"english"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is the county %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger %@ fylke",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist der Landkreis %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}
				else if ([dataObj1 isEqualToString:@"Lake"]){
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@s waterfront",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra %@s vannkant",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger innsjøen %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist der See gelegen %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
					
				}
				else if ([dataObj1 isEqualToString:@"Fjord"]){
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@s waterfront",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra %@s vannkant",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is the fjord %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist der Fjord gelegen %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}
				else{
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"unna %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist %@ gelegen",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}

				
				//draw the line from start point to end point of region _bugfix
				NSValue *tempFirstPointValue = [region_points objectAtIndex:0];
				CGPoint tempFirstPoint = [tempFirstPointValue CGPointValue];
				NSValue *tempLastPointValue = [region_points objectAtIndex:region_points.count -1];
				CGPoint tempLastPoint = [tempLastPointValue CGPointValue];
				
				NSMutableArray *aTempLine = [[NSMutableArray alloc] init];
				[aTempLine addObject:[NSValue valueWithCGPoint:tempFirstPoint]];
				[aTempLine addObject:[NSValue valueWithCGPoint:tempLastPoint]];
				
				[multipleLines addObject:aTempLine];
	
				NSMutableArray *additionalInfoComponentsArray = [[NSMutableArray alloc] init];
				
                
				[additionalInfoComponentsArray setArray:[additionalInfo componentsSeparatedByString:@"#"]];
				if (additionalInfoComponentsArray.count == 5) {
					[[SqliteHelper Instance] executeUpdate:@"INSERT INTO additionalInfo VALUES (?, ?, ?, ?, ?, ?);",
					 [NSString stringWithFormat:@"info00_%@",placeId],
					 [additionalInfoComponentsArray objectAtIndex:0],
					 [additionalInfoComponentsArray objectAtIndex:0],
					 [additionalInfoComponentsArray objectAtIndex:2],
					 [additionalInfoComponentsArray objectAtIndex:3],
					 [additionalInfoComponentsArray objectAtIndex:4]];
				}
				else {
                    [NSException raise:@"Invalid values" format:@"Could not insert values into additionalInfo table for %@. %d values, should be 5", [placeNameDictionary objectForKey:@"english"],additionalInfoComponentsArray.count];
					
				}
				[additionalInfoComponentsArray dealloc];


				NSMutableString *lineRefs = [[NSMutableString alloc] init];
				NSInteger lineIndex = 0;
				for(NSArray * array in multipleLines)
				{
					//[wrappedMultipleLinesArray addObject:[array convertToData]];
					[lineRefs appendFormat:@"%@_%d;",placeId,lineIndex];
					
					[[SqliteHelper Instance] executeUpdate:@"INSERT INTO line VALUES (?, ?);",
					 [NSString stringWithFormat:@"%@_%d",placeId,lineIndex],
					 [self CoordinateArrayToString:array]];
					
					lineIndex++;
				}

				//NSLog(@"--- Km tolerance : %d",kmTolerance);

				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO coordinates VALUES (?, ?, ?, ?, ?,?,?);",[NSString stringWithFormat:@"cor_%@0",placeId]
				 ,[NSNull null], [NSNumber numberWithInt:kmTolerance], 
				 [self CoordinateArrayToString:region_points],lineRefs,
				 [NSNumber numberWithInt:6000],
				 [NSString stringWithFormat:@"info00_%@",placeId]];
				[lineRefs release];
				
				
//				NSMutableArray *excludedRegionsArray = [[NSMutableArray alloc] init];
//				[excludedRegionsArray setArray:[excludedRegions componentsSeparatedByString:@"#"]];

				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO location VALUES (?,?,?,?,?, ?,?, ?, ?, ?, ?, ?,?,?,?);",placeId,
				 [NSString stringWithFormat:@"%@#%@#%@#%@#%@",[placeNameDictionary objectForKey:@"english"],
				  [placeNameDictionary objectForKey:@"norwegian"],
				  [placeNameDictionary objectForKey:@"spanish"],
				  [placeNameDictionary objectForKey:@"french"],
				  [placeNameDictionary objectForKey:@"german"]],
				 [placeNameDictionary objectForKey:@"english"],[placeNameDictionary objectForKey:@"norwegian"],
				 [placeNameDictionary objectForKey:@"spanish"],[placeNameDictionary objectForKey:@"french"],
				 [placeNameDictionary objectForKey:@"german"],
				 dataObj1,
				 [NSNumber numberWithInt:100],
				 [NSNumber numberWithFloat:0.0],
				 [NSNumber numberWithFloat:-1.0],
				 [NSString stringWithFormat:@"cor_%@0",placeId],
				 [NSString stringWithFormat:@"as00_%@",placeId],
				 excludedRegions,
				 includedRegions]; 
				
				
				//NSLog(@"insert into answers : %@",[NSString stringWithFormat:@"as00_%@",placeId]);
				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO answer VALUES (?,?, ?, ?, ?, ?, ?);",
				 [NSString stringWithFormat:@"as00_%@",placeId],
				 [NSNull null],
				 [defaultAnswerDictionary valueForKey:@"english"],
				 [defaultAnswerDictionary valueForKey:@"norwegian"],
				 [NSNull null],[NSNull null],[NSNull null]];
				

				
				if (questDifficulty != notUsed) {
					//init questions with ID first , then send the additional questions into location/state object as a array of objects not as string
					[[SqliteHelper Instance] executeUpdate:@"INSERT INTO question VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?,?,?);",
					 [NSString stringWithFormat:@"qs00_%@",placeId],
					 placeId,
					 questDifficultyAsString,
					 @"", defaultHint,defaultHint2,
					 [defaultQuestionDictionary valueForKey:@"english"],
					 [defaultQuestionDictionary valueForKey:@"norwegian"],
					 [NSNull null],[NSNull null],[defaultQuestionDictionary valueForKey:@"german"]];
				}

				

                
                NSString *refToLocation = [[NSString alloc] init];
                NSString *questionID = [[NSString alloc] init];

				NSMutableArray *additionalQuestionComponentsArray = [[NSMutableArray alloc] init];
				for (NSString *additionalQuestion in additionalQuestions) {
					[additionalQuestionComponentsArray setArray:[additionalQuestion componentsSeparatedByString:@"#"]];
					if (additionalQuestionComponentsArray.count == 11) {
                        
                        questionID = [additionalQuestionComponentsArray objectAtIndex:0];
                        refToLocation = [additionalQuestionComponentsArray objectAtIndex:1];
						if ([refToLocation isEqualToString:@""]) {
							refToLocation = placeId;
						}
						overridingHint = [additionalQuestionComponentsArray objectAtIndex:9];
						if ([overridingHint isEqualToString:@""]) {
							overridingHint = defaultHint;
						}
						overridingHint2 = [additionalQuestionComponentsArray objectAtIndex:10];
						if ([overridingHint2 isEqualToString:@""]) {
							overridingHint2 = defaultHint2;
						}
						
						//DB->id,locRef,diff,pic,eng.....
						[[SqliteHelper Instance] executeUpdate:@"INSERT INTO question VALUES (?,?, ?, ?, ?, ?, ?, ?, ?,?,?);",
						 questionID,
						 refToLocation,
						 [additionalQuestionComponentsArray objectAtIndex:2],
						 [additionalQuestionComponentsArray objectAtIndex:3],
						 overridingHint,overridingHint2,
						 [additionalQuestionComponentsArray objectAtIndex:4],
						 [additionalQuestionComponentsArray objectAtIndex:5],
						 [additionalQuestionComponentsArray objectAtIndex:6],
						 [additionalQuestionComponentsArray objectAtIndex:7],
						 [additionalQuestionComponentsArray objectAtIndex:8]];
                        
					}
					else {
                        [NSException raise:@"Invalid values" format:@"Could not insert values into question table for %@. %d values, should be 10", [placeNameDictionary objectForKey:@"english"],additionalQuestionComponentsArray.count];
					}
				}

				firstLineEntry = YES;
				firstCoordinateEntry = YES;
				questDifficulty = noDifficulty;
				[region_points release];
				//[multipleLines release];
				[multipleLines removeAllObjects];
				additionalQuestions = nil;
			}
			else if ([dataObj1 isEqualToString:@"City"] || [dataObj1 isEqualToString:@"Mountain"] || [dataObj1 isEqualToString:@"UnDefPlace"])
			{
				
				NSMutableDictionary *defaultAnswerDictionary = [[NSMutableDictionary alloc] init];
				NSMutableDictionary *defaultQuestionDictionary = [[NSMutableDictionary alloc] init];
				
				if ([dataObj1 isEqualToString:@"City"]) {
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is the city %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger byen %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist die Stadt %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
					
				}
				else if ([dataObj1 isEqualToString:@"Mountain"]){
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"fra %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is the mountain %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger fjellet %@",[placeNameDictionary objectForKey:@"english"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist der Berg gelegen %@",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}
				else{
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"from %@",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultAnswerDictionary setValue:[NSString stringWithFormat:@"unna %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Where is %@ located",[placeNameDictionary objectForKey:@"english"]] forKey:@"english"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Hvor ligger %@",[placeNameDictionary objectForKey:@"norwegian"]] forKey:@"norwegian"];
					[defaultQuestionDictionary setValue:[NSString stringWithFormat:@"Wo ist %@ befindet",[placeNameDictionary objectForKey:@"german"]] forKey:@"german"];
				}
				

				NSMutableArray *additionalInfoComponentsArray = [[NSMutableArray alloc] init];
				
				[additionalInfoComponentsArray setArray:[additionalInfo componentsSeparatedByString:@"#"]];
				if (additionalInfoComponentsArray.count == 5) {
					[[SqliteHelper Instance] executeUpdate:@"INSERT INTO additionalInfo VALUES (?, ?, ?, ?, ?, ?);",
					 [NSString stringWithFormat:@"info00_%@",placeId],
					 [additionalInfoComponentsArray objectAtIndex:0],
					 [additionalInfoComponentsArray objectAtIndex:0],
					 [additionalInfoComponentsArray objectAtIndex:2],
					 [additionalInfoComponentsArray objectAtIndex:3],
					 [additionalInfoComponentsArray objectAtIndex:4]];
				}
				else {
                    [NSException raise:@"Invalid values" format:@"Could not insert values into additionalInfo table for %@. %d values, should be 5", [placeNameDictionary objectForKey:@"english"],additionalInfoComponentsArray.count];
				}
				[additionalInfoComponentsArray dealloc];
				
//				kmTolerance =20;
                
                if ([[SqliteHelper Instance] hadError]) {
                    NSLog(@"Err %d: %@", [[SqliteHelper Instance] lastErrorCode], [[SqliteHelper Instance] lastErrorMessage]);
                }
                
				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO coordinates VALUES (?, ?, ?, ?, ?,?,?);",[NSString stringWithFormat:@"cor_%@0",placeId]
				 ,[NSNull null], [NSNumber numberWithInt:kmTolerance], 
				 [self CoordinateArrayToString:region_points],[NSNull null],
				 [NSNumber numberWithInt:6000],
				 [NSString stringWithFormat:@"info00_%@",placeId]];

                if ([[SqliteHelper Instance] hadError]) {
                    NSLog(@"Err %d: %@", [[SqliteHelper Instance] lastErrorCode], [[SqliteHelper Instance] lastErrorMessage]);
                }
                
				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO location VALUES (?,?,?,?,?,  ?,?,?, ?, ?, ?, ?, ?,?,?);",
				 placeId,
				 [NSString stringWithFormat:@"%@#%@#%@#%@#%@",[placeNameDictionary objectForKey:@"english"],
						[placeNameDictionary objectForKey:@"norwegian"],
						[placeNameDictionary objectForKey:@"spanish"],
						[placeNameDictionary objectForKey:@"french"],
						[placeNameDictionary objectForKey:@"german"]],
				 [placeNameDictionary objectForKey:@"english"],[placeNameDictionary objectForKey:@"norwegian"],
				 [placeNameDictionary objectForKey:@"spanish"],[placeNameDictionary objectForKey:@"french"],
				 [placeNameDictionary objectForKey:@"german"],
				 dataObj1,
				 [NSNumber numberWithInt:100],
				 [NSNumber numberWithFloat:0.0],
				 [NSNumber numberWithFloat:-1.0],
				 [NSString stringWithFormat:@"cor_%@0",placeId],
				 [NSString stringWithFormat:@"as00_%@",placeId],
				 [NSNull null],
				 [NSNull null]];
                
				if ([[SqliteHelper Instance] hadError]) {
                    NSLog(@"Err %d: %@", [[SqliteHelper Instance] lastErrorCode], [[SqliteHelper Instance] lastErrorMessage]);
                }
				
				//NSLog(@"insert into answers (place)  : %@",[NSString stringWithFormat:@"as00_%@",placeId]);
				[[SqliteHelper Instance] executeUpdate:@"INSERT INTO answer VALUES (?,?, ?, ?, ?, ?, ?);",
				 [NSString stringWithFormat:@"as00_%@",placeId],
				 [NSNull null],
				 [defaultAnswerDictionary valueForKey:@"english"],
				 [defaultAnswerDictionary valueForKey:@"norwegian"],
				 [NSNull null],[NSNull null],[NSNull null]];
				
				if (questDifficulty != notUsed) {
					//init questions with ID first , then send the additional questions into location/state object as a array of objects not as string
					[[SqliteHelper Instance] executeUpdate:@"INSERT INTO question VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?,?);",
					 [NSString stringWithFormat:@"qs00_%@",placeId],
					 placeId,
					 questDifficultyAsString,
					 @"", defaultHint,defaultHint2,
					 [defaultQuestionDictionary valueForKey:@"english"],
					 [defaultQuestionDictionary valueForKey:@"norwegian"],
					 [NSNull null],[NSNull null],[defaultQuestionDictionary valueForKey:@"german"]];
				}
				
				NSString *refToLocation = [[NSString alloc] init];
                NSString *questionID = [[NSString alloc] init];

				NSMutableArray *additionalQuestionComponentsArray = [[NSMutableArray alloc] init];
				for (NSString *additionalQuestion in additionalQuestions) {
					[additionalQuestionComponentsArray setArray:[additionalQuestion componentsSeparatedByString:@"#"]];
					if (additionalQuestionComponentsArray.count == 11) {
                        questionID = [additionalQuestionComponentsArray objectAtIndex:0];
						refToLocation = [additionalQuestionComponentsArray objectAtIndex:1];
						if ([refToLocation isEqualToString:@""]) {
							refToLocation = placeId;
						}
						overridingHint = [additionalQuestionComponentsArray objectAtIndex:9];
						if ([overridingHint isEqualToString:@""]) {
							overridingHint = defaultHint;
						}
						overridingHint2 = [additionalQuestionComponentsArray objectAtIndex:10];
						if ([overridingHint2 isEqualToString:@""]) {
							overridingHint2 = defaultHint2;
						}
						//DB->id,locRef,diff,pic,eng.....
						[[SqliteHelper Instance] executeUpdate:@"INSERT INTO question VALUES (?, ?, ?, ?, ?, ?, ?, ?,?,?,?);",
						 questionID,
						 refToLocation,
						 [additionalQuestionComponentsArray objectAtIndex:2],
						 [additionalQuestionComponentsArray objectAtIndex:3],
						 overridingHint,overridingHint2,
						 [additionalQuestionComponentsArray objectAtIndex:4],
						 [additionalQuestionComponentsArray objectAtIndex:5],
						 [additionalQuestionComponentsArray objectAtIndex:6],
						 [additionalQuestionComponentsArray objectAtIndex:7],
						 [additionalQuestionComponentsArray objectAtIndex:8]];
					}
					else {
                        [NSException raise:@"Invalid values" format:@"Could not insert values into question table for %@. %d values, should be 11", [placeNameDictionary objectForKey:@"english"],additionalQuestionComponentsArray.count];
					}
                    
				}


				firstLineEntry = YES;
				firstCoordinateEntry = YES;
				additionalQuestions = nil;
			}
			
			questDifficulty = noDifficulty;
			kmTolerance = 0;
			
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
    [[SqliteHelper Instance] commit];
}

-(NSString*) CoordinateArrayToString:(NSArray*) coordinateArray
{
	NSMutableString *coordinateString = [[NSMutableString alloc] init];
	for (NSValue *val in coordinateArray) {
		[coordinateString appendFormat:@"%@;", NSStringFromCGPoint([val CGPointValue])];
	}	
	return [coordinateString autorelease];
}


-(NSArray*) StringOfCoordinatesToArray:(NSString*) stringOfCoordinates
{
	NSMutableArray *arrayOfCoordinates = [[NSMutableArray alloc] init];
	NSMutableArray *intermediateStringArray = [[NSMutableArray alloc] init];
	[intermediateStringArray setArray:[stringOfCoordinates componentsSeparatedByString:@";"]];
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"{}"];
	for(NSString *tempString in intermediateStringArray)
	{
		tempString = [tempString stringByTrimmingCharactersInSet:characterSet];
		NSArray *simpleSplitArray = [tempString componentsSeparatedByString:@","];
		if (simpleSplitArray.count == 2) {
			[arrayOfCoordinates addObject:[NSValue valueWithCGPoint:
										   CGPointMake([[simpleSplitArray objectAtIndex:0] intValue], [[simpleSplitArray objectAtIndex:1] intValue])]];
		}
		//[simpleSplitArray release];
	}
	//[characterSet release];
	[intermediateStringArray release];
	
	return [arrayOfCoordinates autorelease];
}

-(CGPoint) StringCoordinateToCgPoint:(NSString*) cgPointAsString
{
	NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"{};"];
	cgPointAsString = [cgPointAsString stringByTrimmingCharactersInSet:characterSet];
	NSArray *simpleSplitArray = [cgPointAsString componentsSeparatedByString:@","];
	if (simpleSplitArray.count == 2) {
		return CGPointMake([[simpleSplitArray objectAtIndex:0] intValue], [[simpleSplitArray objectAtIndex:1] intValue]) ;
	}
	else {
		return CGPointMake(0, 0);
	}
}


-(void) InitQuestions
{
	FMResultSet *resultsAdditionalInfo;
	FMResultSet *resultsCoordinates;
	FMResultSet *resultsExcludedCoordinates;
	FMResultSet *resultsIncludedCoordinates;
	FMResultSet *resultsAnswer;
	FMResultSet *resultsLine;
	MpLocation *tempLocation;

	FMResultSet *resultsLocation = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM location;"];

	while ([resultsLocation next]) {
			
		resultsCoordinates = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM coordinates WHERE coordinateID =?;",[resultsLocation stringForColumn:@"coordianteRef"]];
        [resultsCoordinates next];

		
		resultsAdditionalInfo = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM additionalInfo WHERE infoID =?;",[resultsCoordinates stringForColumn:@"infoRef"]];
		[resultsAdditionalInfo next];
		
		resultsAnswer = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM answer WHERE answerID =?;",[resultsLocation stringForColumn:@"answerRef"]];
		[resultsAnswer next];
		
        
        NSMutableArray *answerArray = [[NSMutableArray alloc] init];
		[answerArray addObject:[resultsAnswer stringForColumn:@"middleFixEnglish"] == NULL ? @"":[resultsAnswer stringForColumn:@"middleFixEnglish"]];
		[answerArray addObject:[resultsAnswer stringForColumn:@"middleFixNorwegian"] == NULL ? @"":[resultsAnswer stringForColumn:@"middleFixNorwegian"]];
		[answerArray addObject:[resultsAnswer stringForColumn:@"middleFixSpanish"] == NULL ? @"":[resultsAnswer stringForColumn:@"middleFixSpanish"]];
		[answerArray addObject:[resultsAnswer stringForColumn:@"middleFixFrench"] == NULL? @"":[resultsAnswer stringForColumn:@"middleFixFrench"]];
		[answerArray addObject:[resultsAnswer stringForColumn:@"middleFixGerman"] == NULL ? @"":[resultsAnswer stringForColumn:@"middleFixGerman"]];
        [resultsAnswer close];
		Answer * answer = [[Answer alloc] initWithStringArray:answerArray];
			
		//fetch the lines to draw
		//_? should more effectivly only be done by Region objects
		NSMutableArray *multipleLinesArray = [[NSMutableArray alloc] init];
		NSMutableArray *arrayOfLineRefs = [[NSMutableArray alloc] init];
		//NSString *arrayOfLineRefsString = [resultsCoordinates objectForKey:@"lineRefs"];
        
        NSLog(@"%@",[resultsCoordinates stringForColumn:@"lineRefs"]);
        if ([resultsCoordinates stringForColumn:@"lineRefs"] != NULL) {
			[arrayOfLineRefs setArray:[[resultsCoordinates stringForColumn:@"lineRefs"] componentsSeparatedByString:@";"]];
			for (NSString *lineRef in arrayOfLineRefs) {
                
                FMResultSet *resultsLineCount = [[SqliteHelper Instance] executeQuery:@"SELECT count(*) as count FROM line WHERE lineID =?;",lineRef];
                [resultsLineCount next];
                NSLog(@"why is count %i",[resultsLineCount intForColumn:@"count"]);
                if ([resultsLineCount intForColumn:@"count"] == 1) {
                    resultsLine = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM line WHERE lineID =?;",lineRef];
                    
                    //_? check this. Why is values always nil while count is 1
                    
                   /* NSLog(@"why :: %i value for lineID %i",[resultsLine intForColumn:@"coordinates"],[resultsLine intForColumn:@"lineID"]);*/
                    //dictionaryLine = [resultsLine objectAtIndex:0];
					[multipleLinesArray addObject:[self StringOfCoordinatesToArray:[resultsLine stringForColumn:@"coordinates"]]];
                    
                    [resultsLine close];
                }
                [resultsLineCount close];
                /*
				resultsLine = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM line WHERE lineID =?;",lineRef];
                [resultsLine next];
                if ([resultsLine hasAnotherRow]) {
                    NSLog(@"%@",[resultsLine stringForColumn:@"coordinates"]);
                    //dictionaryLine = [resultsLine objectAtIndex:0];
					[multipleLinesArray addObject:[self StringOfCoordinatesToArray:[resultsLine stringForColumn:@"coordinates"]]];
                }
                 */
               
                
			}
		}
		[arrayOfLineRefs release];

		NSMutableArray *arrayOfArrayOfRegions = [[NSMutableArray alloc] init];
		[arrayOfArrayOfRegions addObject:[self StringOfCoordinatesToArray:[resultsCoordinates stringForColumn:@"coordinates"]] ];
		
//		NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
//		[f setNumberStyle:NSNumberFormatterDecimalStyle];
//		NSLog(@"avg dist number %f",[[f numberFromString:[NSString stringWithFormat:@"%@",[resultsLocation objectForKey:@"avgDistance"]]]  intValue] );
//		[f release];
//		
//		NSLog(@"avg dist %@",[resultsLocation objectForKey:@"avgDistance"] );
		if ([[resultsLocation stringForColumn:@"locationtype"]  isEqualToString:@"State"])
		{
			
			//included regions
			
			NSMutableArray *includedCoordinatesRefsArray = [[NSMutableArray alloc] init];
			[includedCoordinatesRefsArray setArray:[[resultsLocation stringForColumn:@"includedCoordinatesRefs"] componentsSeparatedByString:@"#"]];
            
			for (NSString *coordinatesRef in includedCoordinatesRefsArray){
				
				resultsIncludedCoordinates = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM coordinates WHERE coordinateID =?;",[NSString stringWithFormat:@"cor_%@0",coordinatesRef]];
				while ([resultsIncludedCoordinates next])
				{
					[arrayOfArrayOfRegions addObject:[self StringOfCoordinatesToArray:[resultsIncludedCoordinates stringForColumn:@"coordinates"]]];
					
				}
			}
			
			//excluded regions
			NSMutableArray *arrayOfArrayOfExcludedCoordinates = [[NSMutableArray alloc] init];
			NSMutableArray *excludedCoordinatesRefsArray = [[NSMutableArray alloc] init];
			[excludedCoordinatesRefsArray setArray:[[resultsLocation stringForColumn:@"excludedCoordinatesRefs"] componentsSeparatedByString:@"#"]];
			
			for (NSString *coordinatesRef in excludedCoordinatesRefsArray){
				
				resultsExcludedCoordinates = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM coordinates WHERE coordinateID =?;",[NSString stringWithFormat:@"cor_%@0",coordinatesRef]];
				while([resultsExcludedCoordinates next])
				{
					[arrayOfArrayOfExcludedCoordinates addObject:[self StringOfCoordinatesToArray:[resultsExcludedCoordinates stringForColumn:@"coordinates"]]];
					
				}
			}
			
			
			
			tempLocation = [[State alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@""
											andPolygons:arrayOfArrayOfRegions
										andLinesToDraw:multipleLinesArray 
									 andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
														[[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
														[[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
									andExcludedRegions:arrayOfArrayOfExcludedCoordinates];
            
           
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"County"]){
			tempLocation = [[County alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
										  andPolygons:arrayOfArrayOfRegions
									   andLinesToDraw:multipleLinesArray 
									andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
													   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                       [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
								   andExcludedRegions:nil]; 
			
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"Lake"]){
			tempLocation = [[Lake alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
										   andPolygons:arrayOfArrayOfRegions
									   andLinesToDraw:multipleLinesArray 
									andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
													   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                       [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
													andExcludedRegions:nil]; 
							
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"Fjord"]){
			tempLocation = [[Fjord alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											andPolygons:arrayOfArrayOfRegions
										andLinesToDraw:multipleLinesArray 
									 andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
														[[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
														[[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
													andExcludedRegions:nil]; 
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"Island"]){
			tempLocation = [[Island alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											 andPolygons:arrayOfArrayOfRegions
										 andLinesToDraw:multipleLinesArray 
									  andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
														 [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                         [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                         [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                         [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                         [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
													andExcludedRegions:nil]; 
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"Peninsula"]){
			tempLocation = [[Peninsula alloc]initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											   andPolygons:arrayOfArrayOfRegions
										   andLinesToDraw:multipleLinesArray 
										andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
														   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                           [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                           [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                           [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                           [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
													andExcludedRegions:nil]; 
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"UnDefRegion"]){
			tempLocation =  [[UnDefRegion alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
												   andPolygons:arrayOfArrayOfRegions
											   andLinesToDraw:multipleLinesArray 
											andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
                                                               [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                               [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                               [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                               [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                               [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]
													andExcludedRegions:nil]; 
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"Mountain"]){
			tempLocation = [[Mountain alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											 andPoint:[self StringCoordinateToCgPoint:[resultsCoordinates stringForColumn:@"coordinates"]]
									   andKmTolerance:[[resultsCoordinates stringForColumn:@"kmtolerance"] integerValue] andPopulation:1000 
									andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
													   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
														[[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
														[[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]];
		}
		else if ([[resultsLocation stringForColumn:@"locationtype"] isEqualToString:@"UnDefPlace"]){
			tempLocation = [[UnDefPlace alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											 andPoint:[self StringCoordinateToCgPoint:[resultsCoordinates stringForColumn:@"coordinates"]]
									   andKmTolerance:[[resultsCoordinates stringForColumn:@"kmtolerance"] integerValue] andPopulation:1000 
									andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
													   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                       [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]];
		}
		else {
			//city
			tempLocation = [[City alloc] initWithName:[resultsLocation stringForColumn:@"locationNames"] andID:[resultsLocation stringForColumn:@"locationID"] andCounty:@"" andState:@"" 
											 andPoint:[self StringCoordinateToCgPoint:[resultsCoordinates stringForColumn:@"coordinates"]]
									   andKmTolerance:[[resultsCoordinates stringForColumn:@"kmtolerance"] integerValue] andPopulation:1000 
									andAdditionalInfo:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",
													   [[resultsAdditionalInfo stringForColumn:@"infoEnglish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"] ,
                                                       [[resultsAdditionalInfo stringForColumn:@"infoNorwegian"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoSpanish"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoFrench"] stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"],
                                                       [[resultsAdditionalInfo stringForColumn:@"infoGerman"]stringByReplacingOccurrencesOfString:@"km2" withString:@"km²"]]];
		}


		[multipleLinesArray release];
		

        FMResultSet *resultsQuestion = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM question WHERE locationRef = ?;",[resultsLocation stringForColumn:@"locationID"]];
        while ([resultsQuestion next]) {
				Question *quest = [[[Question alloc] initWithLocation:tempLocation andID:[resultsQuestion stringForColumn:@"questionID"]
												andQuestionString:[NSString stringWithFormat:@"%@#%@#%@#%@#%@",[resultsQuestion stringForColumn:@"english"],
																   [resultsQuestion stringForColumn:@"norwegian"],[resultsQuestion stringForColumn:@"spanish"],
																   [resultsQuestion stringForColumn:@"french"],[resultsQuestion stringForColumn:@"german"]]
												andPicture:[resultsQuestion stringForColumn:@"picture"]
												andAnswer:answer andDifficulty:[resultsQuestion stringForColumn:@"difficulty"]
												andHint: [NSString stringWithFormat:@"%@#%@",
														  [resultsQuestion stringForColumn:@"hint"],
														  [resultsQuestion stringForColumn:@"hintOrgLan"]]
													]retain];

			
                [m_questionsList addObject:quest];
                [quest release];
        }
		[resultsQuestion close];
        [resultsCoordinates close];
        [resultsAdditionalInfo close];
		
	}
	[resultsLocation close];
	
	
}



-(void) CategorizeQuestions
{
	//categorize the questions
	m_questionsByCategory = [[NSMutableDictionary alloc] initWithCapacity:4];
	
	NSMutableArray *veryhardArray = [self CollectQuestionsOnCategory:veryhardDif];
	[m_questionsByCategory setObject:veryhardArray forKey:@"veryhardDif"];
	
	NSMutableArray *hardArray = [self CollectQuestionsOnCategory:hardDif];
	[m_questionsByCategory setObject:hardArray forKey:@"hardDif"];
	
	NSMutableArray *easyArray = [self CollectQuestionsOnCategory:easy];
	[m_questionsByCategory setObject:easyArray  forKey:@"easy"];
	
	NSMutableArray *mediumArray = [self CollectQuestionsOnCategory:medium];
	[m_questionsByCategory setObject:mediumArray forKey:@"medium"];
	
	//[self ShuffleQuestions];
	
	[self CategorizeQuestionsForTraining];
}

-(void) CategorizeQuestionsForTraining
{
	if (m_trainingQuestionsByCategory == nil) 
		m_trainingQuestionsByCategory = [[NSMutableDictionary alloc] initWithCapacity:3];	

	NSMutableArray *trainingHardArray = [self CollectQuestionsOnCategoryForTraining:hardDif];
	[m_trainingQuestionsByCategory setObject:trainingHardArray forKey:@"hardDif"];
	NSMutableArray *trainingEasyArray = [self CollectQuestionsOnCategoryForTraining:easy];
	[m_trainingQuestionsByCategory setObject:trainingEasyArray  forKey:@"easy"];
	NSMutableArray *trainingMediumArray = [self CollectQuestionsOnCategoryForTraining:medium];
	[m_trainingQuestionsByCategory setObject:trainingMediumArray forKey:@"medium"];	
}


-(NSMutableArray*) CollectQuestionsOnCategory:(Difficulty) category
{
	NSMutableArray *collectedQuestons = [[NSMutableArray alloc] init];
	for (Question *quest in m_questionsList){
		if ([quest GetDifficulty] == category ) {
			[collectedQuestons addObject:quest];
		}
	}
	return [collectedQuestons autorelease];
}


-(NSMutableArray*) CollectQuestionsOnCategoryForTraining:(Difficulty) category
{
	Difficulty secondCategory = category;
	if (category == hardDif) {
		secondCategory = veryhardDif;
	}
	NSMutableArray *collectedQuestons = [[NSMutableArray alloc] init];
	for (Question *quest in m_questionsList){
		if ([quest IsStandardQuestion] == YES) {
			if ([quest GetDifficulty] == category || [quest GetDifficulty] == secondCategory) {
				[collectedQuestons addObject:quest];
			}
		}
	}
	
	return [collectedQuestons autorelease];
}

//is done once pr started training session
//no need to order for more than one difficulty level as one session only covers one difficulty
-(void) OrderQuestionsForTraining:(Difficulty) category
{

	NSMutableArray * questionsOnType = [m_trainingQuestionsByCategory objectForKey:[EnumHelper difficultyToString:category]];
	
	NSMutableArray *sortedQuestons = [[NSMutableArray alloc] init];

	FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT locationID,avgDistance,locationNameEng FROM location WHERE sumAnswers < 1"];
	//"ORDER BY ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationName"]];
	while ([results next])
	{
		for (Question *qst in questionsOnType) {
			if ([[[qst GetLocation] GetID] isEqualToString:[results stringForColumn:@"locationID"]] ) {
				[sortedQuestons addObject:qst];
			}
		}
	}
    [results close];
	//[SortAcendAvgDistance:collectedQuestons];
	results = [[SqliteHelper Instance] executeQuery:@"SELECT locationID,avgDistance,locationNameEng FROM location WHERE sumAnswers > 0 " 
			   "ORDER BY avgDistance DESC"];//DESC
	//, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
	while([results next])
	{
		for (Question *qst in questionsOnType) {
			if ([[[qst GetLocation] GetID] isEqualToString:[results stringForColumn:@"locationID"]] ) {
				[sortedQuestons addObject:qst];
			}
		}
	}
    [results close];
	
	[m_trainingQuestionsByCategory setObject:sortedQuestons forKey:[EnumHelper difficultyToString:category]];	
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

-(NSMutableArray *)ShuffleArray:(NSMutableArray*) arrayToShuffle
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

-(NSMutableArray *) GetQuestionsOnDifficulty:(Difficulty) difficulty trainingMode:(BOOL) training
{
	NSMutableArray *qOnType = nil;	
	if(training == NO)
	{
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
	}
	else 
	{
		switch (difficulty) {
			case veryhardDif:
			case hardDif:
				qOnType = [m_trainingQuestionsByCategory objectForKey:@"hardDif"];
				break;
			case easy:
				qOnType = [m_trainingQuestionsByCategory objectForKey:@"easy"];
				break;
			case medium:
				qOnType = [m_trainingQuestionsByCategory objectForKey:@"medium"];
				break;
			default:
				break;
		}
	}

	return qOnType;
}



@end
