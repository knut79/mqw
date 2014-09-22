
#import "TapDetectingView.h"

#define DOUBLE_TAP_DELAY 0.35

//CGPoint midpointBetweenPoints(CGPoint a, CGPoint b);

@interface TapDetectingView()
- (void)handleSingleTap;
@end

@implementation TapDetectingView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
        [self setMultipleTouchEnabled:YES];
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
    return self;
}

-(void) positionPlayerSymbolPassThrough:(CGPoint)thePoint zoomOffsetScale:(float) zoomOffsetScale
{

	if ([delegate respondsToSelector:@selector(positionPlayerSymbol:zoomOffsetScale:)])
        [delegate positionPlayerSymbol:thePoint zoomOffsetScale:zoomOffsetScale];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // cancel any pending handleSingleTap messages 
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleSingleTap) object:nil];
    
    // update our touch state
    if ([[event touchesForView:self] count] > 1)
        multipleTouches = YES;
    if ([[event touchesForView:self] count] > 2)
        twoFingerTapIsPossible = NO;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    BOOL allTouchesEnded = ([touches count] == [[event touchesForView:self] count]);
	
    // first check for plain single/double tap, which is only possible if we haven't seen multiple touches
    if (!multipleTouches) {
        UITouch *touch = [touches anyObject];
		tapLocation = [touch locationInView:self.superview.superview];

        if ([touch tapCount] == 1) {
            [self performSelector:@selector(handleSingleTap) withObject:nil afterDelay:DOUBLE_TAP_DELAY];
        } 
    }    
        
    // if all touches are up, reset touch monitoring state
    if (allTouchesEnded) {
        twoFingerTapIsPossible = YES;
        multipleTouches = NO;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    twoFingerTapIsPossible = YES;
    multipleTouches = NO;
}

#pragma mark Private

- (void)handleSingleTap {
    if ([delegate respondsToSelector:@selector(tapDetectingView:gotSingleTapAtPoint:)])
        [delegate tapDetectingView:self gotSingleTapAtPoint:tapLocation];
}
    
@end

//CGPoint midpointBetweenPoints(CGPoint a, CGPoint b) {
//    CGFloat x = (a.x + b.x) / 2.0;
//    CGFloat y = (a.y + b.y) / 2.0;
//    return CGPointMake(x, y);
//}
                    
