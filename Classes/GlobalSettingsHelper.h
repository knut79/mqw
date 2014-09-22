//
//  LanguageHelper.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#define const_startKmDistance 500
#define const_timeBonusKm 20
#define const_mostPointsGameNumberOfQuestions 2

@interface GlobalSettingsHelper : NSObject {

	Language m_currentLanguage;
	DistanceMeasurement m_currentDistance;
	NSString *m_documentsDir;
	NSArray* m_languageList;
	NSInteger m_languageListIndex;
    NSString* m_playerID;
}

+(GlobalSettingsHelper*) Instance;

-(void) SetLanguageList:(NSArray*) languageList;
-(void) SetNextLanguage;
-(Language) GetLanguage;
-(NSString*) GetDocumentsDirectory;
-(DistanceMeasurement) GetDistanceMeasurement;
-(NSString*) GetDistanceMeasurementString;
-(NSString*) GetPlayerID;
-(NSInteger) ConvertToRightDistance:(NSInteger) kmDistance;
-(NSString*) GetStringByLanguage:(NSString*)str;
-(void) SetLanguage:(Language) lang;
-(void) SetDistanceMeasurement:(DistanceMeasurement) dist;
-(void) SetDocumentsDirectory;
-(void) SetPlayerID:(NSString*) playerID;
-(NSString*) uuid;

@end
