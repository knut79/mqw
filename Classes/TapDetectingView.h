//#import "DirectionsTouchImageView.h"

@protocol TapDetectingViewDelegate;


@interface TapDetectingView : UIView {
    id <TapDetectingViewDelegate> delegate;
//    DirectionsTouchImageView *directionsTouchView;
    // Touch detection
    CGPoint tapLocation;         // Needed to record location of single tap, which will only be registered after delayed perform.
    BOOL multipleTouches;        // YES if a touch event contains more than one touch; reset when all fingers are lifted.
    BOOL twoFingerTapIsPossible; // Set to NO when 2-finger tap can be ruled out (e.g. 3rd finger down, fingers touch down too far apart, etc).
}

@property (nonatomic, assign) id <TapDetectingViewDelegate> delegate;
-(void) positionPlayerSymbolPassThrough:(CGPoint)thePoint zoomOffsetScale:(float) zoomOffsetScale;

@end



@protocol TapDetectingViewDelegate <NSObject>

@optional
- (void)tapDetectingView:(TapDetectingView *)view gotSingleTapAtPoint:(CGPoint)tapPoint;
- (void) positionPlayerSymbol:(CGPoint)thePoint zoomOffsetScale:(float) zoomOffsetScale;
//- (void)positionPlayerSymbol:(CGPoint) thePoint;
@end
