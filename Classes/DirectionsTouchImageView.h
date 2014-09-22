//
//  DirectionsTouchImageView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DirectionsTouchImageView : UIImageView {
    CGAffineTransform originalTransform;
    CFMutableDictionaryRef touchBeginPoints;
}
-(void)animateFirstTouchAtPoint;
-(void)animateView:(UIView *)theView toPosition:(CGPoint)thePosition;
@end
