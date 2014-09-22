//
//  RestartView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"

@protocol RestartViewDelegate;

@interface RestartView : UIView {
	id <RestartViewDelegate> delegate;
	UIButton *buttonMainMenu;
	UIButton *buttonRestart;
	SkyView *m_skyView;
}
-(void) FadeIn;
-(void) FadeOut;

@property (nonatomic, assign) id <RestartViewDelegate> delegate;

@end


@protocol RestartViewDelegate <NSObject>

@optional
- (void)RestartGame;
- (void)DisplayMainMenu;
@end
