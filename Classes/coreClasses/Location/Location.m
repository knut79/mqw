//
//  Location.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Location.h"
#import "MpPlace.h"
#import "MpRegion.h"
#import "GlobalSettingsHelper.h"

@implementation MpLocation


-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andAdditionalQuestions:(NSMutableArray*) additionalQuestions
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty andAOC:(NSString*) aoc
{
	self = [super init];

	m_additionalQuestions = [additionalQuestions retain];
	
	if([self isKindOfClass: [MpPlace class]] == YES)
		m_locationType = placeType;
	else if([self isKindOfClass:[MpRegion class]] == YES)
		m_locationType = regionType;
	else {
		m_locationType = regionType;
	}

	m_difficulty = questDifficulty;

	m_name = name;
	m_state = state;
	m_county = county;
	
	m_coatOfArms = [[UIImage imageNamed:aoc] retain]; 
	
	
	m_additionalInfoArray = [[NSMutableArray alloc] init];
	NSMutableArray *additionalInfoComponentsArray = [[NSMutableArray alloc] init];
	[additionalInfoComponentsArray setArray:[addInfo componentsSeparatedByString:@"#"]];
	if( additionalInfoComponentsArray.count > 1){
		[m_additionalInfoArray addObject:[additionalInfoComponentsArray objectAtIndex:0]]; 
		[m_additionalInfoArray addObject:[additionalInfoComponentsArray objectAtIndex:1]]; 
	}
	else {
		[m_additionalInfoArray addObject:[additionalInfoComponentsArray objectAtIndex:0]]; 
		[m_additionalInfoArray addObject:[additionalInfoComponentsArray objectAtIndex:0]]; 
	}

	return self;
}

-(NSMutableArray*) GetAdditionalQuestions
{
	return m_additionalQuestions;
}

-(NSString*) GetName
{
	return m_name;
}

-(LocationType) GetLocationType
{
	return m_locationType; 	
}

-(Difficulty) GetQuestDifficulty
{
	return m_difficulty;
}

-(UIImage*) GetCoa
{
	return m_coatOfArms;
}

-(NSString*) GetAdditionalInfo
{
	if ([[GlobalSettingsHelper Instance] GetLanguage] == norwegian) {
		return [m_additionalInfoArray objectAtIndex:1];
	}
	else {
		return [m_additionalInfoArray objectAtIndex:0];
	}
}

@end
