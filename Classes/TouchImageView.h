//
//  TouchImageView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//
#import "MagnifierView.h"
#import <UIKit/UIKit.h>

@protocol TouchImageViewDelegate;

@interface TouchImageView : UIImageView {
	id <TouchImageViewDelegate> delegate;
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
	NSTimer *touchTimer;
//	MagnifierView *loop;
	UIView *mapView;
	BOOL firstCallDone;
	
	BOOL infoBarHidden;
	BOOL questionBarHidden;
	BOOL quitButtonHidden;
	BOOL hintButtonHidden;
	BOOL passButtonHidden;
}
//@property(nonatomic, assign) UIView *mapView;
@property (nonatomic, retain) NSTimer *touchTimer;
@property (nonatomic, assign) id <TouchImageViewDelegate> delegate;
-(void)animateFirstTouchAtPoint;
-(void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition;
-(void) handleAction:(id)timerObj;
//-(void)setMapView:(UIView*) theView;
@end


@protocol TouchImageViewDelegate <NSObject>
@optional
//-(void)openLoope;
-(void)closeLoope;
-(void)updateLoope;
-(void)hideInfoBar;
-(void)showInfoBar;
-(void)hideQuestionBar;
-(void)showQuestionBar;
-(void)hideQuitButton;
-(void)showQuitButton;
-(void)hideHintButton;
-(void)showHintButton;
-(void)hidePassButton;
-(void)showPassButton;

@end
