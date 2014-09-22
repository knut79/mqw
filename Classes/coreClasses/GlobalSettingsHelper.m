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

-(void) SetDistance:(DistanceMeasurement) dist 
{
	m_currentDistance = dist;
}

-(DistanceMeasurement) GetDistance
{
	return m_currentDistance;
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
	if (selfLanguage == norwegian) {
		index = 1;
	}
	NSDictionary *imageDict = [imageData objectAtIndex:index];

	NSString *strValue = [imageDict valueForKey:str];
	if (strValue == nil) {
		strValue = str;
	}

	return strValue;
}



@end
