//
//  Region.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface MpRegion : MpLocation {
	
	NSMutableArray *m_polygon;
	NSMutableArray *m_linesToDraw_first;
	NSMutableArray *m_linesToDraw_second;
	NSInteger m_maxLengthBetweenPoints;
	CGPoint m_shortestPoint_first;
	CGPoint m_shortestPoint_second;
	CGPoint m_middlePoint;

}
-(id) initWithName:(NSString *)name andCounty:(NSString *)county andState:(NSString *)state andPolygon:(NSMutableArray*) polygon
	andLinesToDraw:(NSMutableArray*) linesToDraw andArmsOfCoat:(NSString*) aoc andAdditionalQuestions:(NSMutableArray *)additionalQuestions 
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty;
-(void) UpdatePolygon;
-(NSMutableArray*) GetCoordinates;
-(NSMutableArray*) GetLinesToDraw;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(CGPoint) GetCenterPoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;
-(BOOL) InsertMidwayPoints;
-(BOOL) PointInPolygon:(CGPoint) p andPolygon:(NSMutableArray*) poly ;

@end
