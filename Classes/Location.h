//
//  Location.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#import "GlobalSettingsHelper.h"


@interface MpLocation : NSObject {

	NSMutableDictionary *m_nameDictionary;
	NSString *m_id;
	NSString *m_county;
	NSString *m_state;
	LocationType m_locationType;
	NSMutableArray *m_additionalQuestions;
	NSMutableArray *m_additionalInfoArray;
	
}
-(id) initWithName:(NSString*) name andID:(NSString*) loactionID andCounty:(NSString*) county andState:(NSString*) state
	andAdditionalInfo:(NSString*) addInfo;

-(NSString*) GetName;
-(NSString*) GetID;
-(LocationType) GetLocationType;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;
-(CGPoint) GetCenterPoint;
-(NSString*) GetAdditionalInfo;

@end
