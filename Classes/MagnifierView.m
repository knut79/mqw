//
//  MagnifierView.m
//  MQGermany
//
//  Created by knut dullum on 11/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MagnifierView.h"

@implementation MagnifierView
@synthesize viewref, touchPoint, loopLocation, isPositionedLeft, lastPosition;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = 40;
		self.layer.masksToBounds = YES;
		self.center = CGPointMake(50, 90);
		isPositionedLeft = YES;
        [self positionLeft];
		
		playerSymbolOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		playerSymbolOverlay.center = CGPointMake(40, 40);
		playerSymbolOverlay.image = [UIImage imageNamed:@"ArrowRed.png"];
		[self addSubview:playerSymbolOverlay];
		isPositionedLeft = YES;
		 
	}
	return self;
}

-(void) setClocViewRef:(ClockView*) cvRef
{
	clockViewRef = cvRef;
}

-(void) setPlayerSymbol:(NSString*) playerSymbol
{
	playerSymbolOverlay.image = [UIImage imageNamed:playerSymbol];
}

-(void) positionLeft
{
    self.center = CGPointMake(50, 90);
    loopLocation = CGPointMake(50, 130);
    isPositionedLeft = YES;
}

-(void) setPlacement
{
	if (isPositionedLeft == YES) {
		if (touchPoint.x < 100 && touchPoint.y < 170 ) {
			loopLocation = CGPointMake(270, 130);
			isPositionedLeft = NO;
		}
	}
	else {
		if (touchPoint.x > 220 && touchPoint.y < 170 ) {
			loopLocation = CGPointMake(50, 130);
			isPositionedLeft = YES;
		}
	}
}


- (void)drawRect:(CGRect)rect {

	//_? #device . use device screen values
	if (isPositionedLeft == YES) {
		if (touchPoint.x < 100 && touchPoint.y < 170 ) {
			self.center = CGPointMake(270, 90);
			isPositionedLeft = NO;
			clockViewRef.center = CGPointMake(297.5, 150);
		}
	}
	else {
		if (touchPoint.x > 220 && touchPoint.y < 170 ) {
			self.center = CGPointMake(50, 90);
			isPositionedLeft = YES;
			clockViewRef.center = CGPointMake(22.5, 150);
		}
	}
	
	
    // here we're just doing some transforms on the view we're magnifying,
    // and rendering that view directly into this view,
    // rather than the previous method of copying an image.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context,1*(self.frame.size.width*0.5),1*(self.frame.size.height*0.5));
    CGContextScaleCTM(context, 1.5, 1.5);
    CGContextTranslateCTM(context,-1*(touchPoint.x+viewref.bounds.origin.x),-1*(touchPoint.y+viewref.bounds.origin.y));

	[self.viewref.layer renderInContext:context];


//	CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
//	CGContextMoveToPoint(context, 0, 0);
//	//add a line from 0,0 to the point 100,100
//	CGContextAddLineToPoint( context,80,80);
//	//"stroke" the path
//	CGContextStrokePath(context);

}

-(bool) IsPositionedLeft
{
    return isPositionedLeft == YES ? true:false;
}


- (void)dealloc {
	//[viewref release];
    [super dealloc];
}


@end
