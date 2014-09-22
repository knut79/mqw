//
//  DirectionsTouchImageView.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "DirectionsTouchImageView.h"
#import "DirectionsTouchImageView_Private.h"
#include <execinfo.h>
#include <stdio.h>

@implementation DirectionsTouchImageView

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
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
	
	self.center = currentPoint;
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
	
	UIScreen *screen = [[UIScreen mainScreen] retain];
	
	if ([screen applicationFrame].size.width > 320 )
	{
		
	}
	else {
		//for old iphone
		if (currentPoint.x < 32) {
			currentPoint.x = 32;
		}
		if (currentPoint.x > 293) {
			currentPoint.x = 293;
		}
		if (currentPoint.y < 68) {
			currentPoint.y = 68;
		}
		if (currentPoint.y > 411) {
			currentPoint.y = 411;
		}
	}
	
	[screen release];
	[self animateView:self toPosition: currentPoint];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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
