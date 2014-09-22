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

-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(KmTolerance) kmTolerance andArmsOfCoat:(NSString*) aoc andAdditionalQuestions:(NSMutableArray*) additionalQuestions andAdditionalInfo:(NSString*) addInfo
	andQuestDifficulty:(Difficulty)questDifficulty
{
	self = [super initWithName:name andCounty:county andState: state andAdditionalQuestions: additionalQuestions andAdditionalInfo:addInfo andQuestDifficulty:questDifficulty andAOC:aoc];
	
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
	if ([CoordinateHelper GetDistanceInMeasureUnit:sourcePoint andPoint2:[tempval CGPointValue]] < m_kmTolerance)
		isWithin = NO;
	return isWithin;
}


//override
-(NSString*) GetBorderString:(Language) language
{
	NSString *returnString;
	switch (language) {
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
