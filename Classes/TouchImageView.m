//
//  TouchImageView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "TouchImageView.h"
#import "TouchImageView_Private.h"
#include <execinfo.h>
#include <stdio.h>


@implementation TouchImageView

@synthesize delegate;
@synthesize touchTimer;
//@synthesize mapView;

- (id)initWithFrame:(CGRect)frame {

	if ([super initWithFrame:frame] == nil) {
        return nil;
    }
	
	originalTransform = CGAffineTransformIdentity;
    touchBeginPoints = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    self.userInteractionEnabled = YES;
    self.multipleTouchEnabled = YES;
    self.exclusiveTouch = YES;
	
	[self setAlpha:0];
	
	touchTimer = nil;
//	loop = nil;
	
	firstCallDone = NO;
	questionBarHidden = NO;
	infoBarHidden = NO;
	quitButtonHidden = NO;
	
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {

        [self updateOriginalTransformForTouches:currentTouches];
        [self cacheBeginPointForTouches:currentTouches];
    }

	[self animateFirstTouchAtPoint];

    [self cacheBeginPointForTouches:touches];
	


	touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
												  target:self
												selector:@selector( handleAction: )
												userInfo:touches
												 repeats:NO];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];

	self.center = currentPoint;
	UIScreen *screen = [[UIScreen mainScreen] retain];

	if (currentPoint.y > ([screen applicationFrame].size.height - 80)) {
		if (infoBarHidden == NO) {
			infoBarHidden = YES;
			if ([delegate respondsToSelector:@selector(hideInfoBar)])
				[delegate hideInfoBar];
		}
	}
	else {
		if (infoBarHidden == YES) {
			infoBarHidden = NO;
			if ([delegate respondsToSelector:@selector(showInfoBar)])
				[delegate showInfoBar];
		}
	}
	
    [screen release];
	
	if (currentPoint.y < 80) {
		if (questionBarHidden == NO) {
			questionBarHidden = YES;
			if ([delegate respondsToSelector:@selector(hideQuestionBar)])
				[delegate hideQuestionBar];
		}
	}
	else {
		if (questionBarHidden == YES) {
			questionBarHidden = NO;
			if ([delegate respondsToSelector:@selector(showQuestionBar)])
				[delegate showQuestionBar];
		}
	}
	
	
	//(5, 200, 30, 30)
	if ((currentPoint.x < 55) && (currentPoint.y > 200 -20) && (currentPoint.y < 230 +20)) {
		if (quitButtonHidden == NO) {
			quitButtonHidden = YES;
			if ([delegate respondsToSelector:@selector(hideQuitButton)])
				[delegate hideQuitButton];
		}
	}
	else {
		if (quitButtonHidden == YES) {
			quitButtonHidden = NO;
			if ([delegate respondsToSelector:@selector(showQuitButton)])
				[delegate showQuitButton];
		}
	}
	
	//(5, 240, 30, 30)
	if ((currentPoint.x < 55) && (currentPoint.y > 240 -20) && (currentPoint.y < 270 +20)) {
		if (hintButtonHidden == NO) {
			hintButtonHidden = YES;
			if ([delegate respondsToSelector:@selector(hideHintButton)])
				[delegate hideHintButton];
		}
	}
	else {
		if (hintButtonHidden == YES) {
			hintButtonHidden = NO;
			if ([delegate respondsToSelector:@selector(showHintButton)])
				[delegate showHintButton];
		}
	}
	
	//(5, 280, 30, 30)
	if ((currentPoint.x < 55) && (currentPoint.y > 280 -20) && (currentPoint.y < 310 +20)) {
		if (passButtonHidden == NO) {
			passButtonHidden = YES;
			if ([delegate respondsToSelector:@selector(hidePassButton)])
				[delegate hidePassButton];
		}
	}
	else {
		if (passButtonHidden == YES) {
			passButtonHidden = NO;
			if ([delegate respondsToSelector:@selector(showPassButton)])
				[delegate showPassButton];
		}
	}
	

	
	if (firstCallDone == YES) {
		[self handleAction:touches];	
	}


}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

	self.transform = CGAffineTransformIdentity;
	
	if (infoBarHidden == YES) {
		infoBarHidden = NO;
		if ([delegate respondsToSelector:@selector(showInfoBar)])
			[delegate showInfoBar];
	}

	if (questionBarHidden == YES) {
		questionBarHidden = NO;
		if ([delegate respondsToSelector:@selector(showQuestionBar)])
			[delegate showQuestionBar];
	}
	
	if (quitButtonHidden == YES) {
		quitButtonHidden = NO;
		if ([delegate respondsToSelector:@selector(showQuitButton)])
			[delegate showQuitButton];
	}
	
	if (hintButtonHidden == YES) {
		hintButtonHidden = NO;
		if ([delegate respondsToSelector:@selector(showHintButton)])
			[delegate showHintButton];
	}
	
	if (passButtonHidden == YES) {
		passButtonHidden = NO;
		if ([delegate respondsToSelector:@selector(showPassButton)])
			[delegate showPassButton];
	}	

	if ([delegate respondsToSelector:@selector(closeLoope)])
		[delegate closeLoope];
	
	
	[touchTimer invalidate];
	touchTimer = nil;
	
	
	firstCallDone = NO;
//	[loop removeFromSuperview];
//	[loop release];
//	loop = nil;
}



- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
}


- (void) handleAction:(id)timerObj {
	NSSet *touches;
	if([timerObj isKindOfClass:[NSSet class]]){
		touches = [timerObj retain];
	}else{
		touches = [[timerObj userInfo] retain];
	}
	if(touchTimer != nil){
		[touchTimer invalidate];
		touchTimer = nil;
	}
	
	
	if (firstCallDone == NO) {
        if ([delegate respondsToSelector:@selector(fadeInLoop)])
            [delegate fadeInLoop];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(updateLoope)])
            [delegate updateLoope];
    }

    firstCallDone = YES;
    
}

// Scales up a view slightly which makes the piece slightly larger, as if it is being picked up by the user.
-(void)animateFirstTouchAtPoint
{
	// Pulse the view by scaling up, then move the view to under the finger.
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.15];
	self.transform = CGAffineTransformMakeScale(1.3, 1.3);
	[UIView commitAnimations];
}

// Scales down the view and moves it to the new position. 
-(void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.15];
	// Set the center to the final postion
	theView.center = thePosition;
	// Set the transform back to the identity, thus undoing the previous scaling effect.
	theView.transform = CGAffineTransformIdentity;
	[UIView commitAnimations];	
}

- (void)dealloc
{
    CFRelease(touchBeginPoints);
    
    [super dealloc];
}


@end
