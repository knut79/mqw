//
//  CoordinateHelper.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "CoordinateHelper.h"
//#import "GlobalConstants_FSJ.h"
#import "GlobalConstants.h"
#import <float.h>
#import <math.h>


@implementation CoordinateHelper

+(float) GetDistance:(CGPoint) point1 andPoint2:(CGPoint) point2
{
	//pythagoras theorem c^2 = a^2 + b^2
	//thus c = square root(a^2 + b^2)
	float a = point2.x - point1.x;
	float b = point2.y - point1.y;
	
    float returnValue = sqrt(a * a + b * b);
	return returnValue;
}

+(NSInteger) GetDistanceInKm:(CGPoint) point1 andPoint2:(CGPoint) point2
{
    //float distance = [self GetDistance:point1 andPoint2:point2] ;
    
    CGPoint convertedPoint1 = [self ConvertPointToLatLong:point1];
    CGPoint convertedPoint2 = [self ConvertPointToLatLong:point2];
    
    //haversine
    float distance = [self HaversineCalulationDistance:convertedPoint1 andPost2:convertedPoint2];
	/*
     test
    CGPoint oslo = CGPointMake(10.75,59.95);
    CGPoint washington = CGPointMake(-77.033333,38.883333);
    float distanceTest = [self HaversineCalulationDistance:washington andPost2:oslo];
    */
    
    return lrintf(distance);
}

+(float) HaversineCalulationDistance:(CGPoint) pos1 andPost2:(CGPoint) pos2
{
    float R = 6371; //km
    //float R = (type == DistanceType.Miles) ? 3960 : 6371;
    
    float temp1 = pos2.y - pos1.y;
    float dLat = [self toRadian:temp1 ];
    float temp2 = pos2.x - pos1.x;
    float dLon = [self toRadian:temp2];
    
    float a = sin(dLat / 2) * sinf(dLat / 2) + cosf([self toRadian:pos1.y]) *cosf([self toRadian:pos2.y]) *  sinf(dLon / 2) * sinf(dLon / 2);
    //Math.Min
    float c = 2 * asinf(fminf(1, sqrtf(a)));
    float d = R * c;
    return d;
}

+(float) toRadian:(float) val
{
    return (M_PI / 180) * val;
}


+(CGPoint) ConvertPointToLatLong:(CGPoint) point
{
    point.x = [self ConvertToLong:point.x];
    point.y = [self ConvertToLat:point.y];
    return point;
}

+(float) ConvertToLat:(float) yCoordinate
{
    //
    //float yCoordinateWithOffset = yCoordinate;//119.35;
    //float factor = 2944.0/180.0;
    //float factor = 2944.0/(84.0 + 64.0);
    //
    float mapHeightIfCoversAllDegrees = (constMapHeight*180)/148;
    float factor = mapHeightIfCoversAllDegrees/180.0;
    
    float latValue = yCoordinate/factor;
    latValue -= 90.0;
    float latOffset = -22.6;
    latValue = latValue + latOffset;
    latValue = latValue *-1;
    
    return latValue;
}

+(float) ConvertToLong:(float) xCoordinate
{
    
    float factor = constMapWidth/360.0;
    float longValue = xCoordinate/factor;
    longValue -= 180.0;
    float logitudeOffset = 9;
    longValue = longValue + logitudeOffset ;
    
    return longValue;
}


@end



