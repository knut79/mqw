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
	KmTolerance m_kmTolerance;
}

-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(KmTolerance) kmTolerance andArmsOfCoat:(NSString*) aoc andAdditionalQuestions:(NSMutableArray*) additionalQuestions 
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty;
-(NSMutableArray*) GetCoordinates;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(CGPoint) GetCenterPoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;

@end
