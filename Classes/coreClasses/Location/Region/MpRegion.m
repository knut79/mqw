//
//  Region.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "MpRegion.h"
#import "CoordinateHelper.h"


@implementation MpRegion

-(id) initWithName:(NSString *)name andCounty:(NSString *)county andState:(NSString *)state andPolygon:(NSMutableArray*) polygon
	andLinesToDraw:(NSMutableArray*) linesToDraw andArmsOfCoat:(NSString*) aoc andAdditionalQuestions:(NSMutableArray *)additionalQuestions andAdditionalInfo:(NSString*) addInfo
	andQuestDifficulty:(Difficulty)questDifficulty
{
	self = [super initWithName:name andCounty:county andState:state andAdditionalQuestions:additionalQuestions andAdditionalInfo:addInfo andQuestDifficulty:questDifficulty andAOC:aoc];
	
	m_maxLengthBetweenPoints = 50;
	m_polygon = [polygon retain];

	[self UpdatePolygon];
	m_linesToDraw_first = [linesToDraw retain];
			
	return self;
}

-(void) UpdatePolygon
{
	BOOL foundNewPoints = NO;
	do {
		foundNewPoints = [self InsertMidwayPoints];
	} while (foundNewPoints);
}

-(BOOL) InsertMidwayPoints
{
	BOOL foundNewPoints = NO;
	NSMutableArray *listOfNewPoints = [[NSMutableArray alloc] init];
	NSMutableArray *listOfNewPointsIndexes = [[NSMutableArray alloc] init];
	CGPoint newPointMiddlePoint;
	
	NSValue *tempNSValue1;
	NSValue *tempNSValue2;
	CGPoint tempPoint1;
	CGPoint tempPoint2;
	
	for (int i =0; i< [m_polygon count]; i++) 
	{
		tempNSValue1 = [m_polygon objectAtIndex:i];
		tempPoint1 = [tempNSValue1 CGPointValue];
		tempNSValue2 = [m_polygon objectAtIndex:(i+1) % [m_polygon count]];
		tempPoint2 = [tempNSValue2 CGPointValue];
		if( [CoordinateHelper GetDistanceInMeasureUnit:tempPoint1 andPoint2:tempPoint2] > m_maxLengthBetweenPoints)
		{
			newPointMiddlePoint.x = (tempPoint1.x + tempPoint2.x) / 2;
			newPointMiddlePoint.y = (tempPoint1.y + tempPoint2.y) / 2;
			[listOfNewPoints addObject:[NSValue valueWithCGPoint:newPointMiddlePoint]];
			NSNumber *indexX = [[NSNumber alloc] initWithInt:i + 1];
			[listOfNewPointsIndexes addObject:indexX];
			foundNewPoints = YES;
			break;
		}
	}
	
	if (foundNewPoints == YES) 
	{
		NSInteger addedToIndex = 0;
		for (int i = 0; i < [listOfNewPoints count]; i++) {
			//insert between the two indexes above i and i+1 is pressed inbetween
			tempNSValue1 = [listOfNewPoints objectAtIndex:i];
			int vIndex = [[listOfNewPointsIndexes objectAtIndex:i] integerValue];
			[m_polygon insertObject:tempNSValue1 atIndex:vIndex + addedToIndex];
			addedToIndex++;
		}
	}
	
	return foundNewPoints;
}


-(NSMutableArray*) GetCoordinates
{
	//_? do retain outside
	return [m_polygon retain];
}

-(NSMutableArray*) GetLinesToDraw
{
	return m_linesToDraw_first;
}

-(CGPoint) GetCenterPoint
{
	CGPoint tempPoint;
	int leftMostValue;
	int rightMostValue;
	int upperMostValue;
	int bottomMostValue;
	
	BOOL setValuesFirstTime = NO;
	for (NSValue *tempValue in m_polygon) 
	{
		
		tempPoint = [tempValue CGPointValue];
		if (setValuesFirstTime == NO) {
			leftMostValue = tempPoint.x;
			rightMostValue = tempPoint.x;
			upperMostValue = tempPoint.y;
			bottomMostValue = tempPoint.y;
			setValuesFirstTime = YES;
		}
		
		if (tempPoint.x < leftMostValue) {
			leftMostValue = tempPoint.x;
		}
		if (tempPoint.x > rightMostValue) {
			rightMostValue = tempPoint.x;
		}
		if (tempPoint.y < upperMostValue) {
			upperMostValue = tempPoint.y;
		}
		if (tempPoint.y > bottomMostValue) {
			bottomMostValue = tempPoint.y;
		}
	}
	
	int middleValueVertical;
	middleValueVertical = (upperMostValue + bottomMostValue) /2;

	
	int middleValueHorizontal;
	middleValueHorizontal = (rightMostValue + leftMostValue) / 2;

	
	CGPoint centerPoint;
	centerPoint.x = middleValueHorizontal;
	centerPoint.y = middleValueVertical;
	
	return centerPoint;
	
}

-(BOOL) WithinBounds:(CGPoint) sourcePoint
{
	BOOL isWithin = NO;
	if ([self PointInPolygon:sourcePoint andPolygon:m_polygon] == YES ) 
		isWithin = YES;
	
	return isWithin;
}

-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint
{
	NSMutableArray *twoNearestPoints = [[NSMutableArray alloc] init];
	CGPoint nearestRegionPoint = CGPointMake(0, 0);
	
	
	//if not within region
	if ([self PointInPolygon:sourcePoint andPolygon:m_polygon] == NO ) 
	{
		NSValue *tempNSValue1;
		NSValue *tempNSValue2;
		CGPoint tempPoint1;
		CGPoint tempPoint2;
		//find point in region nearest source
		float distance;
		
		NSValue *polyVal_0 = [m_polygon objectAtIndex:0];
		CGPoint polyPoint_0 = [polyVal_0 CGPointValue];
		float shortestDistance_first = [CoordinateHelper GetDistance:sourcePoint andPoint2:polyPoint_0];
		NSInteger indexOfShortestPoint_first = 0;
		m_shortestPoint_first = polyPoint_0;
		
		NSValue *polyVal_1 = [m_polygon objectAtIndex:1];
		CGPoint polyPoint_1 = [polyVal_1 CGPointValue];
		float shortestDistance_second = [CoordinateHelper GetDistance:sourcePoint andPoint2:polyPoint_1];
		NSInteger indexOfShortestPoint_second = 1;
		m_shortestPoint_second = polyPoint_1;
		
		for (int i = 1; i < [m_polygon count] ; i++) 
		{
			tempNSValue1 = [m_polygon objectAtIndex:i];
			tempPoint1 = [tempNSValue1 CGPointValue];
			distance = [CoordinateHelper GetDistance:sourcePoint andPoint2:tempPoint1];
			if (distance < shortestDistance_first) {
				shortestDistance_first = distance;
				indexOfShortestPoint_first = i;
				m_shortestPoint_first = tempPoint1;
			}
		}
		//second nearest, must be either to the left or right of the shortest point
		NSInteger newIndexDeclined = (indexOfShortestPoint_first - 1) % [m_polygon count];
		if(newIndexDeclined < 0)
		{
			newIndexDeclined = (newIndexDeclined + [m_polygon count]) % [m_polygon count];
		}
		
		tempNSValue1 = [m_polygon objectAtIndex:(indexOfShortestPoint_first + 1) % [m_polygon count]];
		tempPoint1 = [tempNSValue1 CGPointValue];
		
		tempNSValue2 = [m_polygon objectAtIndex:newIndexDeclined];
		tempPoint2 = [tempNSValue2 CGPointValue];
		if ([CoordinateHelper GetDistance:sourcePoint andPoint2:tempPoint1] < [CoordinateHelper GetDistance:sourcePoint andPoint2:tempPoint2] )
		{
			m_shortestPoint_second = tempPoint1;
			indexOfShortestPoint_second = (indexOfShortestPoint_first + 1) % [m_polygon count];
			
		}
		else 
		{
			m_shortestPoint_second = tempPoint2;
			indexOfShortestPoint_second = newIndexDeclined;
		}
	
		CGPoint originalShortestPoint = m_shortestPoint_first;
		
		for (int i = 0; i < 5; i++) 
		{
			//check if points are returned _???
			[self DevideAndFindNearerPoint:sourcePoint];
		}
		
		if ((originalShortestPoint.x == m_shortestPoint_first.x) && (originalShortestPoint.y == m_shortestPoint_first.y)) {

			if ((indexOfShortestPoint_first - indexOfShortestPoint_second) < 0) {
				indexOfShortestPoint_second = indexOfShortestPoint_first - 1;
				if(indexOfShortestPoint_second < 0){
					indexOfShortestPoint_second = [m_polygon count] -1;
				}
			}
			else {
				indexOfShortestPoint_second = indexOfShortestPoint_first + 1;
				if (indexOfShortestPoint_second >= [m_polygon count]) {
					indexOfShortestPoint_second = 0;
				}
			}
			
			tempNSValue1 = [m_polygon objectAtIndex:indexOfShortestPoint_second];
			tempPoint1 = [tempNSValue1 CGPointValue];
			m_shortestPoint_second = tempPoint1;
			
			for (int i = 0; i < 5; i ++) {
				[self DevideAndFindNearerPoint:sourcePoint];
			}

		}
		
		if ([CoordinateHelper GetDistance:sourcePoint andPoint2:m_shortestPoint_first] < 
			[CoordinateHelper GetDistance:sourcePoint andPoint2:m_shortestPoint_second]) {
			nearestRegionPoint = m_shortestPoint_first;
		}
		else {
			nearestRegionPoint = m_shortestPoint_second;
		}
	}
	return nearestRegionPoint;
}
		 
-(BOOL) PointInPolygon:(CGPoint) p andPolygon:(NSMutableArray*) poly 
{
	CGPoint p1, p2;
	BOOL inside = NO;
	
	if (poly.count < 3) {
		return inside;
	}

	NSValue *tempval = [poly objectAtIndex:(poly.count - 1)];
	CGPoint tempPoint = [tempval CGPointValue];
	CGPoint oldPoint = CGPointMake(tempPoint.x , tempPoint.y);
	for (int i = 0; i < poly.count; i++) 
	{
		tempval = [poly objectAtIndex:i];
		tempPoint = [tempval CGPointValue];
		CGPoint newPoint = CGPointMake(tempPoint.x,tempPoint.y);
		
		if (newPoint.x > oldPoint.x) 
		{
			p1 = oldPoint;
			p2 = newPoint;
		}
		else {
			p1 = newPoint;
			p2 = oldPoint;
		}
		
		if ((newPoint.x < p.x) == (p.x <= oldPoint.x) && (p.y - p1.y) * (p2.x - p1.x) < (p2.y - p1.y) * (p.x - p1.x))
		{
			inside = !inside;
		}
		oldPoint = newPoint;
		
	}
	return inside;
}

-(void) DevideAndFindNearerPoint:(CGPoint) source
{
	m_middlePoint.x = (m_shortestPoint_first.x + m_shortestPoint_second.x) / 2;
	m_middlePoint.y = (m_shortestPoint_first.y + m_shortestPoint_second.y) / 2;
	
	if ([CoordinateHelper GetDistance:source andPoint2:m_shortestPoint_first] < [CoordinateHelper GetDistance:source andPoint2:m_middlePoint]) {
		m_shortestPoint_second = m_middlePoint;
	}
	else
	{
		m_shortestPoint_second = m_shortestPoint_first;
		m_shortestPoint_first = m_middlePoint;
	}
  
}

-(BOOL) IsWithin:(NSInteger) x andY:(NSInteger) y
{
	BOOL within = NO;
	if ([self PointInPolygon:CGPointMake(x, y) andPolygon:m_polygon] == YES) {
		within = YES;
	}
	return within;
}
	 

@end
