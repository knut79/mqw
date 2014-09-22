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
	
	NSMutableArray *m_polygons;
	NSArray *m_linesToDraw;
	NSInteger m_maxLengthBetweenPoints;
	CGPoint m_shortestPoint_first;
	CGPoint m_shortestPoint_second;
	CGPoint m_middlePoint;
	NSMutableArray *m_excludedRegions;

}
-(id) initWithName:(NSString *)name andID:(NSString *)loactionID andCounty:(NSString *)county andState:(NSString *)state andPolygons:(NSMutableArray*) polygons
	andLinesToDraw:(NSArray*) linesToDraw
	andAdditionalInfo:(NSString*) addInfo
	andExcludedRegions:(NSMutableArray*) excludedRegions;
-(void) UpdatePolygon:(NSArray *) currentPolygon;
-(NSMutableArray*) GetCoordinates;
-(NSArray*) GetLinesToDraw;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(CGPoint) GetCenterPoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;
-(BOOL) InsertMidwayPoints:(NSMutableArray *) currentPolygon;
-(BOOL) PointInPolygon:(CGPoint) p andPolygons:(NSMutableArray*) polygons ;
-(void) DevideAndFindNearerPoint:(CGPoint) source;
-(CGPoint) GetNearestPointInPolygonFromSourcePoint:(CGPoint) sourcePoint andPolygons:(NSArray *) currentPolygons;
-(NSArray*) GetExcludedRegions;

@end
