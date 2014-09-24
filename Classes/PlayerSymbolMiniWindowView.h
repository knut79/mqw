//
//  PlayerSymbolMiniWindowView.h
//  MQNorway
//
//  Created by knut on 22/09/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerSymbolMiniWindowView : UIView
{
UIView *viewref;
CGPoint touchPoint;
UIImage *cachedImage;
CGPoint loopLocation;
CGPoint lastPosition;
UIImageView *playerSymbolOverlay;
    int xSelfPosition;
    int ySelfPosition;


}
@property(nonatomic, retain) UIView *viewref;
@property(assign) CGPoint gamePoint;
@property(assign) CGPoint placePoint;
@property(assign) CGPoint touchPoint;
@property(assign) BOOL isPositionedLeft;
@property(assign) CGPoint loopLocation;
@property(assign) CGPoint lastPosition;

-(void) setPlacement;
-(void) releaseCachedImage;

@end
