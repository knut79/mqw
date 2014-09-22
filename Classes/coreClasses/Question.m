//
//  Question.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Question.h"
#import "GlobalSettingsHelper.h"

@implementation Question

-(id) initWithLanguage:(Language) language andLocation:(MpLocation*) loc
{
	if (self = [super init]) 
	{
		m_name = [[loc GetName] retain];
		m_difficulty = [loc GetQuestDifficulty];
		m_useAoc = NO;
		
		if([loc isKindOfClass: [State class]] == YES)
			m_locationType = stateType;
		else if([loc isKindOfClass: [Lake class]] == YES)
			m_locationType = lakeType;
		else if([loc isKindOfClass: [Fjord class]] == YES)
			m_locationType = fjordType;
		else if([loc isKindOfClass: [Island class]] == YES)
			m_locationType = islandType;
		else if([loc isKindOfClass: [Peninsula class]] == YES)
			m_locationType = peninsulaType;
		else if([loc isKindOfClass: [City class]] == YES)
			m_locationType = cityType;
		else if([loc isKindOfClass: [Mountain class]] == YES)
			m_locationType = mountainType;

		m_questionArray = [[NSMutableArray alloc] init];
		NSString *firstPart, *secondPart, *thirdPart;
		for (int i =0; i < 2; i++) {
			
			if (i == 1)
				language = norwegian;
			else
				language = english;
			

			switch (m_locationType)
			{
				case (cityType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"byen";
						break;
					case (english):
						secondPart = @"the city";
						break;
					default:
						secondPart = @"the city";
						break;
				}
					break;
				case (lakeType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"innsjøen";
						break;
					case (english):
						secondPart = @"the lake";
						break;
					default:
						secondPart = @"the lake";
						break;
				}
					break;
				case (fjordType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"fjorden";
						break;
					case (english):
						secondPart = @"the fjord";
						break;
					default:
						secondPart = @"the fjord";
						break;
				}
					break;
				case (islandType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"øya";
						break;
					case (english):
						secondPart = @"the island";
						break;
					default:
						secondPart = @"the island";
						break;
				}
					break;
				case (peninsulaType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"halvøya";
						break;
					case (english):
						secondPart = @"the peninsula";
						break;
					default:
						secondPart = @"the peninsula";
						break;
				}
					break;
				case (mountainType):
					switch (language)
				{
					case (norwegian):
						secondPart = @"fjellet";
						break;
					case (english):
						secondPart = @"the mountain";
						break;
					default:
						secondPart = @"the mountain";
						break;
				}
					break;
				default:
					secondPart = @"";
					break;
			}
			
			switch (language)
			{
				case (norwegian):
					thirdPart = @"";
					break;
				case (english):
					thirdPart = @"located";
					break;
				default:
					thirdPart = @"located";
					break;
			}
			
			switch (language)
			{
				case (norwegian):
					firstPart = @"Hvor er";
					break;
				case (english):
					firstPart = @"Where is";
					break;
				default:
					firstPart = @"Where is";
					break;
			}
			
			[m_questionArray addObject:[[NSString alloc]initWithFormat:@"%@ %@ %@ %@?",  firstPart, secondPart, m_name, thirdPart] ];
		}
		
		m_answer = [[Answer alloc] initWithLanguage:language andLocation:loc];

	}
	return self;
	
}

-(id) initWithLanguage:(Language) language andLocation:(MpLocation*) loc andQuestionString:(NSString*) questionString
{
	if (self = [super init]) 
	{
		m_name = [[loc GetName] retain];

		NSMutableArray *questionComponentsArray = [[NSMutableArray alloc] init];
		[questionComponentsArray setArray:[questionString componentsSeparatedByString:@"#"]];
		if( questionComponentsArray.count > 1)
		{
			
			if ([[questionComponentsArray objectAtIndex:0] isEqualToString:@"medium"]) 
				m_difficulty = medium;					
			else if([[questionComponentsArray objectAtIndex:0] isEqualToString:@"hard"]) 
				m_difficulty = hardDif;
			else if([[questionComponentsArray objectAtIndex:0] isEqualToString:@"veryhard"]) 
				m_difficulty = veryhardDif;
			else
				m_difficulty = easy;

			NSInteger indexForEnglish = 1;
			NSInteger indexForSecondLanguage = 2;
			m_useAoc = NO;
			if ([[questionComponentsArray objectAtIndex:1] isEqualToString:@"1"]) {
				m_useAoc = YES;
				indexForEnglish ++;
				indexForSecondLanguage ++;
			};
			
			m_questionArray = [[NSMutableArray alloc] init];
			for (int i =0; i < 2; i++) {
				
				if (i == 1)
					language = norwegian;
				else
					language = english;
				
				switch (language) {
					case english:
						[m_questionArray addObject:[questionComponentsArray objectAtIndex:indexForEnglish]]; 
						break;
					case norwegian:
						[m_questionArray addObject:[questionComponentsArray objectAtIndex:indexForSecondLanguage]];
						break;
						
					default:
						[m_questionArray addObject:[questionComponentsArray objectAtIndex:indexForEnglish]]; 
						break;
				}
			}
		}
		else {
			//_?TODO raise an error here
		}

		m_answer = [[Answer alloc] initWithLanguage:language andLocation:loc];
		
	}
	return self;
}

-(Answer*) GetAnswer
{
	return m_answer;
}


-(NSString*) GetQuestionString
{
	if ([[GlobalSettingsHelper Instance] GetLanguage] == norwegian) {
		return [m_questionArray objectAtIndex:1];
	}
	else {
		return [m_questionArray objectAtIndex:0];
	}
}

-(BOOL) GetUseAoc
{
	return m_useAoc;
}

-(Difficulty) GetDifficulty
{
	return m_difficulty;
}

-(NSInteger) GetUsedCount
{
	return m_used;
}

-(NSString*) GetName
{
	return m_name;
}

-(void) IncreaseUsed
{
	m_used++;
}

- (void)dealloc 
{
	[m_name release];
}

@end
