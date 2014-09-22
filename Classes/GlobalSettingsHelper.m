//
//  LanguageHelper.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "GlobalSettingsHelper.h"


@implementation GlobalSettingsHelper

+(GlobalSettingsHelper*) Instance 
{
	static GlobalSettingsHelper *Instance;
	
	@synchronized(self) {
		if(!Instance)
		{
			Instance = [[GlobalSettingsHelper alloc] init];
		}
	}
	return Instance;
}

-(void) SetLanguage:(Language) lang
{
	m_currentLanguage = lang;
}

-(Language) GetLanguage
{
	return m_currentLanguage;
}

-(void) SetLanguageList:(NSArray*) languageList
{
	m_languageListIndex = 0;
	m_languageList = languageList;
}

-(void) SetNextLanguage
{
	m_languageListIndex = (m_languageListIndex + 1)%m_languageList.count;
	if ([[m_languageList objectAtIndex:m_languageListIndex] isEqualToString:@"english"] ) {
		m_currentLanguage = english;
	}
	else if([[m_languageList objectAtIndex:m_languageListIndex] isEqualToString:@"norwegian"] ) {
		m_currentLanguage = norwegian;
	}
	else if([[m_languageList objectAtIndex:m_languageListIndex] isEqualToString:@"german"] ) {
		m_currentLanguage = german;
	}
}

-(void) SetDistanceMeasurement:(DistanceMeasurement) dist 
{
	m_currentDistance = dist;
}

-(DistanceMeasurement) GetDistanceMeasurement
{
	return m_currentDistance;
}

-(NSString*) GetDistanceMeasurementString
{
    if (m_currentDistance == mile) 
        return [self GetStringByLanguage:@"miles"];
    else
        return [self GetStringByLanguage:@"km"];
}


-(NSInteger) ConvertToRightDistance:(NSInteger) kmDistance
{
	NSInteger newDistance;
	if (m_currentDistance == mile) {
		newDistance = kmDistance * 0.62137; 
	}
	else {
		newDistance = kmDistance;
	}
	return newDistance;
}


-(void) SetDocumentsDirectory
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	m_documentsDir = [paths objectAtIndex:0];
}

-(NSString*) GetDocumentsDirectory
{
	return m_documentsDir;
}

-(NSString*) GetPlayerID
{
    return m_playerID;
}

-(void) SetPlayerID:(NSString*) playerID
{
    m_playerID = [playerID retain];
}

-(NSString*) GetStringByLanguage:(NSString*)str
{
	
	Language selfLanguage = [self GetLanguage];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"LanguageData" ofType:@"plist"];
    NSData *plistData = [NSData dataWithContentsOfFile:path];
    NSString *error; NSPropertyListFormat format;
    NSArray *imageData = [NSPropertyListSerialization propertyListFromData:plistData
                                                          mutabilityOption:NSPropertyListImmutable
                                                                    format:&format
                                                          errorDescription:&error];
    if (!imageData) {
        NSLog(@"Failed to read language file. Error: %@", error);
        [error release];
    }
	NSInteger index = 0;
	if (selfLanguage != english) {
		index = 1;
	}


	NSDictionary *imageDict = [imageData objectAtIndex:index];
	NSString *strValue = @"";
	if ([[imageDict valueForKey:str] isKindOfClass:[NSString class]] == YES) 
	{
		strValue = [imageDict valueForKey:str];
	}
	else  if([[imageDict valueForKey:str] isKindOfClass:[NSDictionary class]] == YES) {
		

		NSDictionary *languageArray = [imageDict valueForKey:str];
		
		if (selfLanguage == norwegian) {
			strValue = [languageArray valueForKey:@"norwegian"];
		}
		else if (selfLanguage == german) {
			strValue = [languageArray valueForKey:@"german"];
		}
	}
    else if(selfLanguage != english)
        NSLog(@"Could not find translation for: %@", str);


	if (strValue == nil || [strValue isEqualToString:@""]) {

		strValue = str;
	}	

	return strValue;
}

-(NSString*) uuid
{
	CFUUIDRef puuid = CFUUIDCreate( nil );
	CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
	NSString * result = (NSString *)CFStringCreateCopy( NULL, uuidString);
	CFRelease(puuid);
	CFRelease(uuidString);
	return [result autorelease];
}



@end
