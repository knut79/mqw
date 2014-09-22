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
//    if (self = [super initWithFrame:frame]) {
//        // Initialization code
//		self.backgroundColor = [UIColor clearColor];
//		
//		loopLocation = CGPointMake(50, 130);
//		isPositionedLeft = YES;
//    }
//    return self;
	
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = 40;
		self.layer.masksToBounds = YES;
		self.center = CGPointMake(50, 90);
		isPositionedLeft = YES;
		
		playerSymbolOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
		playerSymbolOverlay.center = CGPointMake(40, 40);
		playerSymbolOverlay.image = [UIImage imageNamed:@"ArrowRed.png"];
		[self addSubview:playerSymbolOverlay];
		
		 
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


//- (void)drawRectOLD:(CGRect)rect {
//
//	if(cachedImage == nil){
//		//NSLog(@"check width!!  %f",self.viewref.bounds.size.width);
//
//		UIImage *testImage = [UIImage imageNamed:@"testB.png"] ;
//		
//		CGImageRef imageRef = CGImageCreateWithImageInRect([testImage CGImage], CGRectMake(viewref.bounds.origin.x, viewref.bounds.origin.y, 320, 480));
//		// or use the UIImage wherever you like
//		cachedImage = [[UIImage imageWithCGImage:imageRef] retain]; 
//		CGImageRelease(imageRef);
//		
//		
//	}
//	CGImageRef imageRef = [cachedImage CGImage];
//	//CGImageRef imageRef = CGImageCreateWithImageInRect([[UIImage imageNamed:@"testB.png"] CGImage], CGRectMake(touchPoint.x, touchPoint.y, 80, 80));
//	CGImageRef maskRef = [[UIImage imageNamed:@"loopmask.png"] CGImage];
//	CGImageRef overlay = [[UIImage imageNamed:@"loop.png"] CGImage];
//	CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef), 
//										CGImageGetHeight(maskRef),
//										CGImageGetBitsPerComponent(maskRef), 
//										CGImageGetBitsPerPixel(maskRef),
//                                        CGImageGetBytesPerRow(maskRef), 
//										CGImageGetDataProvider(maskRef), 
//										NULL, 
//										true);
//	//Create Mask
//	if (isPositionedLeft == YES) {
//		if (touchPoint.x < 100 && touchPoint.y < 170 ) {
//			loopLocation = CGPointMake(270, 130);
//			isPositionedLeft = NO;
//		}
//	}
//	else {
//		if (touchPoint.x > 220 && touchPoint.y < 170 ) {
//			loopLocation = CGPointMake(50, 130);
//			isPositionedLeft = YES;
//		}
//	}
//
//	//CGImageRef subImage = CGImageCreateWithImageInRect(imageRef, CGRectMake((touchPoint.x + viewref.bounds.origin.x)-18, (touchPoint.y + viewref.bounds.origin.y)-18, 36, 36));
//	CGImageRef subImage = CGImageCreateWithImageInRect(imageRef, CGRectMake(touchPoint.x-18, touchPoint.y-18, 36, 36));
//	
//	
//	CGImageRef xMaskedImage = CGImageCreateWithMask(subImage, mask);
//	
//	// Draw the image
//	// Retrieve the graphics context
//	CGContextRef context = UIGraphicsGetCurrentContext();
//	CGAffineTransform xform = CGAffineTransformMake(
//													1.0,  0.0,
//													0.0, -1.0,
//													0.0,  0.0);
//
//	CGContextConcatCTM(context, xform);
//
//	CGRect area = CGRectMake((float)loopLocation.x-42, -loopLocation.y, 85, 85);
//	CGRect area2 = CGRectMake(loopLocation.x-40, -loopLocation.y+2, 80, 80);
//
//	
//	CGContextDrawImage(context, area2, xMaskedImage);
//	CGContextDrawImage(context, area, overlay);
//	
//	CGImageRelease(mask);
//	CGImageRelease(subImage);
//	CGImageRelease(xMaskedImage);
//	
////	[cachedImage release];
////	cachedImage = nil;
//}

- (void)drawRect:(CGRect)rect {
	
	if (isPositionedLeft == YES) {
		if (touchPoint.x < 100 && touchPoint.y < 170 ) {
			//[super initWithFrame:CGRectMake(230, 90, 80, 80)])
			self.center = CGPointMake(270, 90);
			//loopLocation = CGPointMake(270, 130);
			isPositionedLeft = NO;
			clockViewRef.center = CGPointMake(297.5, 150);
		}
	}
	else {
		if (touchPoint.x > 220 && touchPoint.y < 170 ) {
			self.center = CGPointMake(50, 90);
			//loopLocation = CGPointMake(50, 130);
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

-(void) releaseCachedImage
{
	[cachedImage release];
	cachedImage = nil;
}


- (void)dealloc {
	[cachedImage release];
	[viewref release];
    [super dealloc];
}


@end
