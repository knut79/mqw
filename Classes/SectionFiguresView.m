//
//  SectionFiguresView.m
//  MQNorway
//
//  Created by knut on 03/10/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//

#import "SectionFiguresView.h"
#import "GlobalConstants.h"
#import "WithFiguresView.h"

@implementation SectionFiguresView
@synthesize viewref,location;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        //self.opaque = NO;
    }

    tiledMapViewZoomScale = 25.0;
    tiledMapViewResolutionPercentage =0.7111111;
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    CGContextSaveGState(context);
    WithFiguresView* ref = (WithFiguresView*)[self superview];
    CGRect tilesMapViewBounds = ref.tilesMapViewBounds;
    CGContextTranslateCTM(context, -tilesMapViewBounds.origin.x,-tilesMapViewBounds.origin.y);
    
     
    CGContextSaveGState(context);
	
	CGImageRef mask;
	NSString *maskFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mask_land];
    
	
	UIImage *testUIMaskImage = [UIImage imageWithContentsOfFile:maskFileName];
	CGImageRef maskRef = testUIMaskImage.CGImage;
    
	float val1 = tiledMapViewResolutionPercentage;
	float val2 = tiledMapViewZoomScale;
    
    float testWidth = constMapWidth * (val1/100);
	float testHeight = constMapHeight * (val1/100);
    
	CGRect t_testRect = CGRectMake(0, 0, testWidth * val2, testHeight * val2);
    
    mask = CGImageMaskCreate( constMapWidth /2,constMapHeight / 2,
							 CGImageGetBitsPerComponent(maskRef),
							 CGImageGetBitsPerPixel(maskRef),
							 CGImageGetBytesPerRow(maskRef),
							 CGImageGetDataProvider(maskRef), NULL, false);
    
    
    
	CGContextClipToMask(context, t_testRect, mask);
    CGImageRelease(mask);

    CGContextSetLineWidth(context,0);
    CGContextSetRGBFillColor(context, 0,0, 100, 0.5);

    [self SetRegionsPathsA:location andContextRef:context];

    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    //[self.viewref.layer renderInContext:context];
    [self StrokeUpRegionsA:location andContextRef:context];

    CGContextRestoreGState(context);
}

-(void) StrokeUpRegionsA:(MpLocation*) loc andContextRef:(CGContextRef) context
{

	CGPoint tempPoint;
	//lines for the MAIN region.....  whole line for the preceding regions
	NSArray *tempLinesToDrawArray = [(MpRegion*)loc GetLinesToDraw];
	for (NSArray *tempArray in tempLinesToDrawArray)
	{
		BOOL startPathSat = NO;
		for (NSValue *tempValue2 in tempArray)
		{
			tempPoint = [tempValue2 CGPointValue];
			//at 100 %
			//scale to map
			tempPoint.x = tempPoint.x * (tiledMapViewResolutionPercentage/100);
			tempPoint.y = tempPoint.y * (tiledMapViewResolutionPercentage/100);
			//scale to tile
			tempPoint.x = tempPoint.x * tiledMapViewZoomScale;
			tempPoint.y = tempPoint.y * tiledMapViewZoomScale;
			
			if (startPathSat == NO) {
				//CGContextBeginPath(context);
				CGContextMoveToPoint(context, tempPoint.x, tempPoint.y);
				startPathSat = YES;
			}
			else
			{
				CGContextAddLineToPoint( context, tempPoint.x,tempPoint.y);
			}

		}
		CGContextStrokePath(context);
	}
	
	BOOL skippedFirst = NO;
	NSMutableArray *coordinatesArrayInArray = [(MpRegion*)loc GetCoordinates];
	for (NSArray * coordinatesArray in coordinatesArrayInArray)
	{
		if (skippedFirst == YES) {
			BOOL startPathSat = NO;
			for (NSValue *tempValue2 in coordinatesArray)
			{
				tempPoint = [tempValue2 CGPointValue];
				//at 100 %
				//scale to map
				tempPoint.x = tempPoint.x * (tiledMapViewResolutionPercentage/100);
				tempPoint.y = tempPoint.y * (tiledMapViewResolutionPercentage/100);
				//scale to tile
				tempPoint.x = tempPoint.x * tiledMapViewZoomScale;
				tempPoint.y = tempPoint.y * tiledMapViewZoomScale;
				
				if (startPathSat == NO) {
					//CGContextBeginPath(context);
					CGContextMoveToPoint(context, tempPoint.x, tempPoint.y);
					startPathSat = YES;
				}
				else
				{
					CGContextAddLineToPoint( context, tempPoint.x,tempPoint.y);
				}

			}
			CGContextStrokePath(context);
		}
		skippedFirst = YES;
	}

}

-(void) SetRegionsPathsA:(MpLocation*) loc andContextRef:(CGContextRef) context
{
	NSMutableArray *coordinatesArrayInArray = [(MpRegion*)loc GetCoordinates];
	for (NSArray * coordinatesArray in coordinatesArrayInArray)
	{
		BOOL startPathSat = NO;
		CGContextBeginPath(context);
		for (NSValue *tempValue in coordinatesArray)
		{
			CGPoint tempPoint;
			tempPoint = [tempValue CGPointValue];
			//at 100 %
			//scale to map
			tempPoint.x = tempPoint.x * (tiledMapViewResolutionPercentage/100);
			tempPoint.y = tempPoint.y * (tiledMapViewResolutionPercentage/100);
			//scale to tile
			tempPoint.x = tempPoint.x * tiledMapViewZoomScale;
			tempPoint.y = tempPoint.y * tiledMapViewZoomScale;
			
			if (startPathSat == NO) {
				CGContextMoveToPoint(context, tempPoint.x, tempPoint.y);
				startPathSat = YES;
			}
			else
			{
				CGContextAddLineToPoint( context, tempPoint.x,tempPoint.y);
			}

		}
		
		CGContextClosePath(context);
		
		[self SetExludedRegionsPaths:loc andContextRef:context];
		
		CGContextEOFillPath(context);
	}

}

-(void) SetExludedRegionsPaths:(MpLocation*) loc andContextRef:(CGContextRef) context
{

	NSArray *excludedRegionsArray = [(MpRegion*)loc GetExcludedRegions];
	for (NSArray * excludedRegionArray in excludedRegionsArray) {
		BOOL startPathSat = NO;
		//CGContextBeginPath(context);
		for (NSValue *tempValue in excludedRegionArray)
		{
			CGPoint tempPoint;
			tempPoint = [tempValue CGPointValue];
			//at 100 %
			//scale to map
			tempPoint.x = tempPoint.x * (tiledMapViewResolutionPercentage/100);
			tempPoint.y = tempPoint.y * (tiledMapViewResolutionPercentage/100);
			//scale to tile
			tempPoint.x = tempPoint.x * tiledMapViewZoomScale;
			tempPoint.y = tempPoint.y * tiledMapViewZoomScale;
			
			if (startPathSat == NO) {
				CGContextMoveToPoint(context, tempPoint.x, tempPoint.y);
				startPathSat = YES;
			}
			else
			{
				CGContextAddLineToPoint( context, tempPoint.x,tempPoint.y);
			}
			
		}
		CGContextClosePath(context);
	}
}


@end
