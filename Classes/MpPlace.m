//
//  Place.m
//  Tiling
//
//  Created by knut dullum on 15/10/2010.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MpPlace.h"
#import "CoordinateHelper.h"


@implementation MpPlace

-(id) initWithName:(NSString*) name andID:(NSString *)loactionID andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(NSInteger) kmTolerance andAdditionalInfo:(NSString*) addInfo
{
	self = [super initWithName:name andID:loactionID andCounty:county andState: state andAdditionalInfo:addInfo];
	
	m_point = [[NSMutableArray alloc] init];
	[m_point addObject:[NSValue valueWithCGPoint:point]];	
	
	m_kmTolerance = kmTolerance;
	
	return self;
}


//overriding 
-(NSMutableArray*) GetCoordinates
{
	return m_point;
}

-(CGPoint) GetCenterPoint
{
	NSValue *tempval = [m_point objectAtIndex:0];
	return [tempval CGPointValue];
}



-(BOOL) WithinBounds:(CGPoint) sourcePoint
{
	BOOL isWithin = NO;
	NSValue *tempval = [m_point objectAtIndex:0];
	if ([CoordinateHelper GetDistanceInKm:sourcePoint andPoint2:[tempval CGPointValue]] <= m_kmTolerance)
		isWithin = YES;
	return isWithin;
}

-(NSInteger) GetKmTolerance
{
	return m_kmTolerance;
}


//override
-(NSString*) GetBorderString
{
	NSString *returnString;
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			returnString = @"destination";
			break;
		case norwegian:
			returnString = @"målet";
			break;
		default:
			returnString = @"destionation";
			break;
	}
	return returnString;
}

-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint
{
	NSValue *tempval = [m_point objectAtIndex:0];
	return [tempval CGPointValue];
}

@end
