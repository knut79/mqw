//
//  LanguageHelper.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#define const_startKmDistance 5500
#define const_timeBonusKm 200
#define const_mostPointsGameNumberOfQuestions 2

@interface GlobalSettingsHelper : NSObject {

	Language m_currentLanguage;
	DistanceMeasurement m_currentDistance;
	NSString *m_documentsDir;
	NSArray* m_languageList;
	NSInteger m_languageListIndex;
    NSString* m_playerID;
    NSString* m_playerFbID;
    NSString* m_playerName;
}

+(GlobalSettingsHelper*) Instance;

-(void) SetLanguageList:(NSArray*) languageList;
-(void) SetNextLanguage;
-(Language) GetLanguage;
-(NSString*) GetDocumentsDirectory;
-(DistanceMeasurement) GetDistanceMeasurement;
-(NSString*) GetDistanceMeasurementString;
-(NSString*) GetPlayerID;
-(NSString*) GetPlayerFbID;
-(void) SetPlayerFbID:(NSString*) playerFbID;
-(NSString*) GetPlayerName;
-(NSInteger) ConvertToRightDistance:(NSInteger) kmDistance;
-(NSString*) GetStringByLanguage:(NSString*)str;
-(void) SetLanguage:(Language) lang;
-(void) SetDistanceMeasurement:(DistanceMeasurement) dist;
-(void) SetDocumentsDirectory;
-(void) SetPlayerID:(NSString*) playerID;
-(void) SetPlayerName:(NSString*) playerName;
-(NSString*) uuid;

@end
