//
//  PassButtonView.h
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassButtonViewDelegate;
@interface PassButtonView : UIView {
	id <PassButtonViewDelegate> delegate;
	UILabel* timesLeftLabel;
    NSInteger timesLeft;
    UIAlertView *alert;

}
@property (nonatomic, assign) id <PassButtonViewDelegate> delegate;
-(void) SetTimesLeft:(NSInteger) value;
@end


@protocol PassButtonViewDelegate <NSObject>

@optional
- (void)PassQuestion;
@end