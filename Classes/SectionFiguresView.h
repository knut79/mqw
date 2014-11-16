//
//  SectionFiguresView.h
//  MQNorway
//
//  Created by knut on 03/10/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "MpRegion.h"
@interface SectionFiguresView : UIView{
 UIView *viewref;
    MpLocation* location;
    float tiledMapViewZoomScale;
    float tiledMapViewResolutionPercentage;

}
- (id)initWithFrame:(CGRect)frame andResolution:(float) resolution;
@property(nonatomic, retain) UIView *viewref;
@property(nonatomic, retain) MpLocation *location;
-(void) StrokeUpRegionsA:(MpLocation*) loc andContextRef:(CGContextRef) context;
-(void) SetRegionsPathsA:(MpLocation*) loc andContextRef:(CGContextRef) context;
@end
