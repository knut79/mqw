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
#define const_mostPointsGameNumberOfQuestions 2

@interface GlobalSettingsHelper : NSObject {

	Language m_currentLanguage;
	DistanceMeasurement m_currentDistance;
	NSString *m_documentsDir;
}

+(GlobalSettingsHelper*) Instance;

-(Language) GetLanguage;
-(NSString*) GetDocumentsDirectory;
-(DistanceMeasurement) GetDistance;
-(NSInteger) ConvertToRightDistance:(NSInteger) kmDistance;
-(NSString*) GetStringByLanguage:(NSString*)str;
-(void) SetLanguage:(Language) lang;
-(void) SetDistance:(DistanceMeasurement) dist;
-(void) SetDocumentsDirectory;

@end
