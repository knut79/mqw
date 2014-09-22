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
#import "EnumHelper.h"

@implementation MpLocation


-(id) initWithName:(NSString*) name andID:(NSString*) loactionID andCounty:(NSString*) county andState:(NSString*) state 
	andAdditionalInfo:(NSString*) addInfo
{
	self = [super init];
	
	if([self isKindOfClass: [MpPlace class]] == YES)
		m_locationType = placeType;
	else if([self isKindOfClass:[MpRegion class]] == YES)
		m_locationType = regionType;
	else {
		m_locationType = regionType;
	}

	m_id = [loactionID retain];
	//m_name = [name retain];
	
	NSMutableArray* tempNameComponentsArray = [[NSMutableArray alloc] init];
	[tempNameComponentsArray setArray:[name componentsSeparatedByString:@"#"]];
	
	m_nameDictionary = [[NSMutableDictionary alloc] init];
	if(tempNameComponentsArray.count == 5){
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"english"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:1] forKey:@"norwegian"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:2] forKey:@"spanish"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:3] forKey:@"french"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:4] forKey:@"german"];
	}
	else {
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"english"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"norwegian"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"spanish"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"french"];
		[m_nameDictionary setObject:[tempNameComponentsArray objectAtIndex:0] forKey:@"german"];
	}

	
	m_state = state;
	m_county = county;
	
	m_additionalInfoArray = [[NSMutableArray alloc] init];
	NSMutableArray *additionalInfoComponentsArray = [[NSMutableArray alloc] init];
	[additionalInfoComponentsArray setArray:[addInfo componentsSeparatedByString:@"#"]];
	for (NSString *infoString in additionalInfoComponentsArray) {
		[m_additionalInfoArray addObject:infoString]; 
	}

	return self;
}

-(NSString*) GetName
{
	return [m_nameDictionary objectForKey:[EnumHelper languageToString:[[GlobalSettingsHelper Instance] GetLanguage]]];
}

-(NSString*) GetID
{
	return m_id;
}

-(LocationType) GetLocationType
{
	return m_locationType; 	
}


-(NSString*) GetAdditionalInfo
{
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) 
	{
		case english:
			return [m_additionalInfoArray objectAtIndex:0];
			break;
		case norwegian:
			return [m_additionalInfoArray objectAtIndex:1];
			break;
		case spanish:
			return [m_additionalInfoArray objectAtIndex:2];
			break;
		case french:
			return [m_additionalInfoArray objectAtIndex:3];
			break;
		case german:
			return [m_additionalInfoArray objectAtIndex:4];
			break;
		default:
			return @"nothing";
			break;
	}
}

@end
