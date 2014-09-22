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
	
	return sqrt(a * a + b * b);
}


//Karasjok trheim 945 kilometer
//Oslo og Karasjok 1 268 kilometer.
//Lillehammer og Eidsvoll 98 kilometer.

//measurementFactor = 55.77;
//oslo trheim factor
//measurementFactor = 0.4916621;
//oslo karasjok factor
//measurementFactor = 0.437598983;
//trheim karasjok factor
//measurementFactor = 0.410863459429112;
//measurementFactor = 0.50988445087;

	//tr.heim oslo 392 km, 397 pix   = faktor 98,23

+(NSInteger) GetDistanceInKm:(CGPoint) point1 andPoint2:(CGPoint) point2
{
	float measurementFactor = 0; //km

	float distance = [self GetDistance:point1 andPoint2:point2] ;
	
	if (distance < 200.0f) 
	{
		//NSLog(@"using factor for 200 %f with distance %f",measurementFactor_200,distance);
		measurementFactor = measurementFactor_200;//0.50988445087;
	}
	else if(distance < 400.0f){
		//NSLog(@"using factor for 800 %f with distance %f",measurementFactor_400,distance);
		measurementFactor = measurementFactor_400;//0.49;
	}
	else if(distance < 600.0f){
		//NSLog(@"using factor for 800 %f with distance %f",measurementFactor_800,distance);
		measurementFactor = measurementFactor_600;//0.49;
	}
	else if(distance < 800.0f){
		//NSLog(@"using factor for 800 %f with distance %f",[measurementFactor_800 floatValue],distance);
		measurementFactor = measurementFactor_800;//0.49;
	}
	else if(distance < 1200.0f){
		//NSLog(@"using factor for 1200 %f with distance %f",[measurementFactor_1200 floatValue],distance);
		measurementFactor = measurementFactor_1200;//0.44;
	}
	else if(distance < 2300.0f){
		//NSLog(@"using factor for 2300 %f with distance %f",[measurementFactor_2300 floatValue],distance);
		measurementFactor = measurementFactor_2300;//0.41;
	}
	else{
		//NSLog(@"using default factor %f with distance %f",[measurementFactor_default floatValue],distance);
		measurementFactor = measurementFactor_default;//0.40;
	}

	distance = distance * measurementFactor;
	
//	NSLog(@"measurement factor is %f",measurementFactor);
	NSNumber *tempNumber = [NSNumber numberWithDouble:(distance+0.5)];
	return [tempNumber intValue];
}

+(float) GetDistanceInPixel:(NSInteger) kmDistance
{
	return kmDistance/measurementFactor_200;
}

@end



