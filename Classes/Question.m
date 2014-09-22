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


-(id) initWithLocation:(MpLocation*) loc andID:(NSString*) qID andQuestionString:(NSString*) questionString andPicture:(NSString*) picture andAnswer:(Answer*) answer andDifficulty:(NSString*) diff  andHint:(NSString*) hint
{
	if (self = [super init]) 
	{
		m_id = [qID retain];
		
        NSLog(@"id = %@",m_id);
		
		if ([m_id hasPrefix:@"qs00_"] == YES) 
			m_isStandard = YES;
		else
			m_isStandard = NO;
		
		
		m_location = [loc retain];
		
		if ([diff isEqualToString:@"medium"]) 
			m_difficulty = medium;					
		else if([diff isEqualToString:@"hard"]) 
			m_difficulty = hardDif;
		else if([diff isEqualToString:@"veryhard"]) 
			m_difficulty = veryhardDif;
		else
			m_difficulty = easy;

		NSMutableArray *questionComponentsArray = [[NSMutableArray alloc] init];
		[questionComponentsArray setArray:[questionString componentsSeparatedByString:@"#"]];
		if( questionComponentsArray.count == 5)
		{
			m_questionArray = [[NSMutableArray alloc] init];

			[m_questionArray addObject:[questionComponentsArray objectAtIndex:0]]; 
			[m_questionArray addObject:[questionComponentsArray objectAtIndex:1]]; 
			[m_questionArray addObject:[questionComponentsArray objectAtIndex:2]]; 
			[m_questionArray addObject:[questionComponentsArray objectAtIndex:3]]; 
			[m_questionArray addObject:[questionComponentsArray objectAtIndex:4]]; 
			
			
			if ([picture isEqualToString:@""]) 
			{
				m_usePicture = NO;
			}
			else
			{
				m_picture = [[UIImage imageNamed:picture] retain]; 
				m_usePicture = YES;
			}
		}
		else {
			NSLog(@"Question format for location %@ has wrong format. Split questionstring on # gave %d , should be 5", [m_location GetName],questionComponentsArray.count);
		}
		
		NSMutableArray *hintsComponentsArray = [[NSMutableArray alloc] init];
		[hintsComponentsArray setArray:[hint componentsSeparatedByString:@"#"]];
		if( hintsComponentsArray.count == 2)
		{
			m_hintArray = [[NSMutableArray alloc] init];
			
			[m_hintArray addObject:[hintsComponentsArray objectAtIndex:0]]; 
			[m_hintArray addObject:[hintsComponentsArray objectAtIndex:1]]; 
		}
		else {
			NSLog(@"Question format for location %@ has wrong format. Split hint on # gave %d , should be 2", [m_location GetName],hintsComponentsArray.count);
		}

		m_answer = answer;
		
	}
	return self;
}

-(NSString*) GetID
{
	return m_id;	
}


-(Answer*) GetAnswer
{
	return m_answer;
}


-(NSString*) GetQuestionString
{
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			return [m_questionArray objectAtIndex:0];
			break;
		case norwegian:
			return [m_questionArray objectAtIndex:1];
			break;
		case spanish:
			return [m_questionArray objectAtIndex:2];
			break;
		case french:
			return [m_questionArray objectAtIndex:3];
			break;
		case german:
			return [m_questionArray objectAtIndex:4];
			break;
		default:
			return @"No question: Wrong language";
			break;
	}
}

-(NSString*) GetHintString
{
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			return [m_hintArray objectAtIndex:0];
			break;
		case norwegian:
		case spanish:
		case french:
		case german:
			return [m_hintArray objectAtIndex:1];
			break;
		default:
			return @"No hint: Wrong language";
			break;
	}
}

-(BOOL) IsStandardQuestion
{
	return m_isStandard;
}

-(BOOL) UsingPicture
{
	return m_usePicture;
}

-(UIImage*) GetPicture
{
	return m_picture;
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
	return [m_location GetName];
}

-(void) IncreaseUsed
{
	m_used++;
}

- (void)dealloc 
{
}

-(MpLocation*) GetLocation
{
	return m_location;
}

@end
