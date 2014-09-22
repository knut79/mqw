//
//  CoordinateHelper.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "CoordinateHelper.h"


@implementation CoordinateHelper

+(float) GetDistance:(CGPoint) point1 andPoint2:(CGPoint) point2
{
	//pythagoras theorem c^2 = a^2 + b^2
	//thus c = square root(a^2 + b^2)
	float a = point2.x - point1.x;
	float b = point2.y - point1.y;
	
	return sqrt(a * a + b * b);
}


+(NSInteger) GetDistanceInMeasureUnit:(CGPoint) point1 andPoint2:(CGPoint) point2
{
	 //Karasjok trheim 945 kilometer
	//Oslo og Karasjok 1 268 kilometer.
	//Lillehammer og Eidsvoll 98 kilometer.

	float measurementFactor = 0; //km
	//measurementFactor = 55.77;
	//oslo trheim factor
	//measurementFactor = 0.4916621;
	//oslo karasjok factor
	//measurementFactor = 0.437598983;
	//trheim karasjok factor
	//measurementFactor = 0.410863459429112;
	measurementFactor = 0.50988445087;

	//tr.heim oslo 392 km, 397 pix   = faktor 98,23
	float distance = [self GetDistance:point1 andPoint2:point2] ;
	if (distance < 200) {
		measurementFactor = 0.50988445087;
	}
	else if(distance < 800){
		measurementFactor = 0.49;
	}
	else if(distance < 1200){
		measurementFactor = 0.44;
	}
	else if(distance < 2300){
		measurementFactor = 0.41;
	}
	else{
		measurementFactor = 0.40;
	}

	distance = distance * measurementFactor;
	

	NSNumber *tempNumber = [NSNumber numberWithDouble:(distance+0.5)];
	return [tempNumber intValue];
}

@end



