//
//  CoordinateHelper.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoordinateHelper : NSObject {

}
+(float) GetDistance:(CGPoint) point1 andPoint2:(CGPoint) point2;
+(NSInteger) GetDistanceInKm:(CGPoint) point1 andPoint2:(CGPoint) point2;
+(float) GetDistanceInPixel:(NSInteger) kmDistance;
@end



