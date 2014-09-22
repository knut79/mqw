//
//  DirectionsTouchImageView_Private.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DirectionsTouchImageView.h"

@interface UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj;

@end


@interface DirectionsTouchImageView (Private)

	- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches;
	- (void)updateOriginalTransformForTouches:(NSSet *)touches;
	
	- (void)cacheBeginPointForTouches:(NSSet *)touches;
	- (void)removeTouchesFromCache:(NSSet *)touches;

@end
