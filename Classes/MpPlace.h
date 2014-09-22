//
//  Place.h
//  Tiling
//
//  Created by knut dullum on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "Location.h"
//#import "Game.h"
#import "EnumDefs.h"




@interface MpPlace : MpLocation {

	NSMutableArray *m_point;
	NSInteger m_kmTolerance;
}

-(id) initWithName:(NSString*) name andID:(NSString *)loactionID andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(NSInteger) kmTolerance
	andAdditionalInfo:(NSString*) addInfo;
-(NSMutableArray*) GetCoordinates;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(CGPoint) GetCenterPoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;
-(NSInteger) GetKmTolerance;

@end
