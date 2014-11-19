//
//  HintButtonView.h
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HintButtonViewDelegate;

@interface HintButtonView : UIView {
	id <HintButtonViewDelegate> delegate;
	UIAlertView *hitBox;
	UILabel* timesLeftLabel;
	NSInteger timesLeft;
    NSArray* m_hints;
}
@property (nonatomic, assign) id <HintButtonViewDelegate> delegate;
-(void) SetTimesLeft:(NSInteger) value;
-(void) SetHint:(NSArray*) hints;
-(long) CostOfHint;
@end

@protocol HintButtonViewDelegate <NSObject>

@optional
- (void)UseHint;
@end