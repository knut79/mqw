//
//  MagnifierView.h
//  MQGermany
//
//  Created by knut dullum on 11/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
//#import "DrawView.h"
#import "ClockView.h"

@interface MagnifierView : UIView {
	UIView *viewref;
	CGPoint touchPoint;
	CGPoint loopLocation;
	BOOL isPositionedLeft;
	CGPoint lastPosition;
	UIImageView *playerSymbolOverlay;
	ClockView *clockViewRef;
	
}
@property(nonatomic, retain) UIView *viewref;
@property(assign) CGPoint touchPoint;
@property(assign) BOOL isPositionedLeft;
@property(assign) CGPoint loopLocation;
@property(assign) CGPoint lastPosition;

-(bool) IsPositionedLeft;
-(void) setPlacement;
-(void) positionLeft;
-(void) setPlayerSymbol:(NSString*) playerSymbol;
-(void) setClocViewRef:(ClockView*) cvRef;
@end
