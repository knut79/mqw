//
//  ClockView.h
//  MQNorway
//
//  Created by knut dullum on 21/08/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClockDelegate;

@interface ClockView : UIView {
	id <ClockDelegate> delegate;
	UIImageView *watchHandView;
	NSTimer *timer;
	NSTimer *masterTimer;
	float angle;
	float red;
	float green;
	
	UILabel *timesTimeLabel;
	
	int timeMultiplier;
    BOOL m_clockRunning;
	
}

-(void) StartClock;
-(void) stop;
-(void) FadeIn;
-(void) FadeOut;
-(NSInteger) GetMultiplier;

@property (nonatomic, assign) id <ClockDelegate> delegate;

@end


@protocol ClockDelegate <NSObject>
@optional
-(void) DeductPoint;
@end