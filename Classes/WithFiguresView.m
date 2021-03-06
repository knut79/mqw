//
//  WithFiguresView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "WithFiguresView.h"
#import <math.h>
#import "CoordinateHelper.h"
#import "MpRegion.h"
#import "MpPlace.h"
#import "Question.h"
#import "NSArray(dataConversion).h"
#import "GlobalConstants.h"
#import "PlayerSymbolMiniWindowView.h"


@implementation WithFiguresView

@synthesize delegate, tilesMapViewBounds,boundsOfRegion;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
        UIScreen *screen = [[UIScreen mainScreen] retain];
		answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, [screen applicationFrame].size.height -40, [screen applicationFrame].size.width, 40)];
        [screen release];
		answerLabel.hidden = YES;
		[self addSubview:answerLabel];

        /*
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.autoresizingMask = (UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth);*/
        //TODO : set these values based on how big the resulting area is
		/*
        tiledMapViewZoomScale = 0.7111111;
		tiledMapViewResolutionPercentage = (float)25;
         */
        
        [self ResetZoomAndResolution];
        
        [self ResetRegionBoundValues];
        
        _sectionFiguresView = [[SectionFiguresView alloc] initWithFrame:frame andResolution:tiledMapViewResolutionPercentage];
        [self addSubview:_sectionFiguresView];
    }
    return self;
}

-(void) ResetRegionBoundValues
{
    minX = 9999;
    maxX = -9999;
    minY = 9999;
    maxY = -9999;
}

-(void) ResetZoomAndResolution
{
    tiledMapViewZoomScale = 1;
    tiledMapViewResolutionPercentage = (float)25;
    tiledMapViewTileWidth = 256;
}


-(void)setGameRef:(Game*) game{
	m_gameRef = [game retain];
}

//test
-(void) AnimateResult
{
    tiledMapViewResolutionPercentage = 25.0;
    m_shouldDrawResult = YES;
    m_shouldUpdateGameData = NO;
    [self setClipsToBounds:YES];
    [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    [self setNeedsDisplay];
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animatingResultStep2)];
	[self setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
	[UIView commitAnimations];
}

-(void) animatingResultStep2
{
    m_shouldDrawResult = YES;
    m_shouldUpdateGameData = NO;
    [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    tiledMapViewResolutionPercentage = 50.0;

    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
        [self setNeedsDisplay];
    //[UIView setAnimationRepeatCount:2];
    //[UIView setAnimationRepeatAutoreverses:YES];
    //tiledMapViewResolutionPercentage = 100.0;
	[UIView setAnimationDidStopSelector:@selector(animatingResultStep3)];
	[self setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
	[UIView commitAnimations];
}

-(void) animatingResultStep3
{
    m_shouldDrawResult = YES;
    m_shouldUpdateGameData = NO;
    [self setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
    tiledMapViewResolutionPercentage = 100.0;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:2.0];
	[UIView setAnimationDelegate:self];
    [self setNeedsDisplay];
    //[UIView setAnimationRepeatCount:10];
    //[UIView setAnimationRepeatAutoreverses:YES];
	[UIView setAnimationDidStopSelector:@selector(doneAnimatingResult)];
	[self setTransform:CGAffineTransformMakeScale(1.3, 1.3)];
	[UIView commitAnimations];
}

-(void) doneAnimatingResult
{
    //[self setTransform:CGAffineTransformMakeScale(1, 1)];
    tiledMapViewResolutionPercentage = 25.0;
    /*
    if ([delegate respondsToSelector:@selector(finishedDrawingResultMap)])
        [delegate finishedDrawingResultMap];*/
}
//end test

-(void) SetTilesMapViewBounds
{
	//get center of destination
	Question *question = [[m_gameRef GetQuestion]retain];
	MpLocation *loc = [[question GetLocation] retain];

	CGPoint centerPoint; 
	centerPoint = [loc GetCenterPoint];
	centerPoint.y = centerPoint.y * (tiledMapViewResolutionPercentage/100.0) * tiledMapViewZoomScale;
    centerPoint.x = centerPoint.x * (tiledMapViewResolutionPercentage/100.0) * tiledMapViewZoomScale;

    UIScreen *screen = [[UIScreen mainScreen] retain];
	CGRect testRect = CGRectMake(0, 0, [screen applicationFrame].size.width, [screen applicationFrame].size.height);
 
    
    testRect.origin.x += (centerPoint.x - ([screen applicationFrame].size.width/2));
    testRect.origin.y += (centerPoint.y - ([screen applicationFrame].size.height/2));
    
    CGFloat mapWidth =(constMapWidth * (tiledMapViewResolutionPercentage/100.0))*tiledMapViewZoomScale;
	if (testRect.origin.x >  mapWidth - [screen applicationFrame].size.width)
	{
		testRect.origin.x = mapWidth - [screen applicationFrame].size.width;
	}
	else if(testRect.origin.x < 0)
	{
		testRect.origin.x = 0;
	}
    CGFloat mapHeight = (constMapHeight * (tiledMapViewResolutionPercentage/100.0))*tiledMapViewZoomScale;
    if (testRect.origin.y > (mapHeight - [screen applicationFrame].size.height))
	{
		testRect.origin.y = mapHeight - [screen applicationFrame].size.height;
	}
	else if(testRect.origin.y < 0)
	{
		testRect.origin.y = 0;
	}
    
    [screen release];

	tilesMapViewBounds = testRect;
	
	[loc release];
	[question release];
}

-(void) drawResult_UpdateGameData:(BOOL) updateGameData
{
	m_shouldUpdateGameData = updateGameData;
	m_shouldDrawResult = YES;
	[self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
	@try {
		if ((m_gameRef != nil) && (m_shouldDrawResult == YES)) {
			self.userInteractionEnabled = NO;
			[self SetTilesMapViewBounds];

			// Grab the drawing context
			CGContextRef context = UIGraphicsGetCurrentContext();
			// like Processing pushMatrix
			CGContextSaveGState(context);
			
			CGContextTranslateCTM(context, -tilesMapViewBounds.origin.x, -tilesMapViewBounds.origin.y);

			// calculate which rows and columns are visible by doing a bunch of math.
            
            [self drawTiles:context];
			
						
			Player *player = [[m_gameRef GetPlayer] retain];
			
			//at 100 %
			Question *question = [[m_gameRef GetQuestion] retain];
			MpLocation *loc = [[question GetLocation] retain];
			//check if region or place
			NSInteger distanceBetweenPoints;
			
			
            //if (([player IsOut] == NO) && [player HasGivenUp] == NO) {
                CGPoint gamePoint = [player GetGamePoint];
                UIColor *playerColor = [[player GetColor] retain];
                NSString *playerSymbolString = [[player GetPlayerSymbol] retain];
                //NSInteger currentKmLeft = [player GetKmLeft];
                
                if ([loc isKindOfClass:[MpPlace class]] == YES) 
                {
                    distanceBetweenPoints = [self DrawLineToPlace:loc andContextRef:context andGamePoint:gamePoint  andLineColor:playerColor];
                }
                else if([loc isKindOfClass:[MpRegion class]] == YES)
                {
                    distanceBetweenPoints = [self DrawLineToRegion:loc andContextRef:context andGamePoint:gamePoint  andLineColor:playerColor];
                }
                
                if ([loc isKindOfClass:[MpPlace class]] == YES)
                {
                    [self DrawPlace:loc];
                }
                else if([loc isKindOfClass:[MpRegion class]] == YES)
                {
                    [self DrawRegion:loc];
                }
                
                [self DrawPlayerSymbol:playerSymbolString andContextRef:context andGamePoint:gamePoint];
                
                if (m_shouldUpdateGameData == YES) {
                    
                    [player SetLastDistanceFromDestination:distanceBetweenPoints];
                
                    [player SetPetTalk:distanceBetweenPoints];
                
                
                    [m_gameRef UpdateAvgDistanceForQuest:distanceBetweenPoints];
                    if ([m_gameRef IsTrainingMode] == NO) {
                        [player DeductKmLeft:distanceBetweenPoints];
                    }
                    
                }
                /*
                else {
                    m_shouldUpdateGameData = YES;
                }*/
                
                [playerSymbolString release];
                [playerColor release];
            //}
			
			
			//_? change in NMQ
			//drawn twice because it ends either outside mask or underneath coloring
            bool playersymbolOutsideBoundsOfDevice = false;

            
            if ([player IsOut] == NO) {
                CGPoint gamePoint = [player GetGamePoint];
                
                //NSString *playerSymbolString = [[player GetPlayerSymbol] retain];
                
                //NSLog(@"playersymbol %@ x:%d y:%d",playerSymbolString,gamePoint.x,gamePoint.y);
               // [self DrawPlayerSymbol:playerSymbolString andContextRef:context andGamePoint:gamePoint];
                //[player IncreasQuestionsPassed:question];

                
                if(_playerSymbolMiniWindowView != nil)
                {
                    [_playerSymbolMiniWindowView setAlpha:0];
                }

                playersymbolOutsideBoundsOfDevice = [self PlayerSymbolInsideBounds: gamePoint resultMapBounds:tilesMapViewBounds];
                
                if (playersymbolOutsideBoundsOfDevice) {
                    //draw miniwindow with playersymbol location
                    
                    if (_playerSymbolMiniWindowView == nil) {
                        _playerSymbolMiniWindowView = [[PlayerSymbolMiniWindowView alloc] initWithFrame:self.bounds] ;
                    }
                    
                    _playerSymbolMiniWindowView.gamePoint =  [player GetGamePoint];
                    
                    MpLocation *loc = [[question GetLocation] retain];
                    CGPoint nearestPoint = [loc GetNearestPoint:[player GetGamePoint]];
                    [loc release];
                    _playerSymbolMiniWindowView.placePoint  = CGPointMake(nearestPoint.x * (tiledMapViewResolutionPercentage/100.0),nearestPoint.y * (tiledMapViewResolutionPercentage/100.0));
                    
                    _playerSymbolMiniWindowView.viewref = self;
                    [_playerSymbolMiniWindowView setAlpha:1];
                    
                    [_playerSymbolMiniWindowView setNeedsDisplay];
                }
                
                //[playerSymbolString release];
            }
			
			
            
            
			
			[player release];
			[loc release];
			[question release];
			
            // like Processing popMatrix
			CGContextRestoreGState(context);

            if (m_shouldUpdateGameData == YES) {
                if ([delegate respondsToSelector:@selector(finishedDrawingResultMap)])
                    [delegate finishedDrawingResultMap];
            }
			
			
		}
		m_shouldDrawResult = NO;
	}
	@catch (NSException * e) {
		NSLog(@"failed in draw withFiguresView: %@",e);
	}
}

-(void) drawTiles:(CGContextRef) context
{
    float tZoomScale = tiledMapViewZoomScale;
    int tSizeWidth = tiledMapViewTileWidth;
    float scaledTileWidth  = tSizeWidth * tZoomScale;
    float scaledTileHeight = tSizeWidth * tZoomScale;
    
    if (tiledMapViewTileWidth != 0)
    {
        //set up lastNeededRow and firstneededrow .. column  osv. så det ikke gjøres unødvendig tegning
        //maxrow og maxcol må settes i forhold til hvilken prosent scale man er i
        
        int minCol = tilesMapViewBounds.origin.x/256 - 0.5; //round down
        int minRow = tilesMapViewBounds.origin.y/256 - 0.5;
        
        UIScreen *screen = [[UIScreen mainScreen] retain];
        float colvar2 = (tilesMapViewBounds.origin.x/scaledTileWidth) ;
        float colVar3 = ([screen applicationFrame].size.width/scaledTileWidth);
        int maxCol = (int)(colvar2 + colVar3 + 0.5);
        
        float rowVar2 = (tilesMapViewBounds.origin.y/scaledTileHeight) ;
        float rowVar3 = ([screen applicationFrame].size.height/scaledTileHeight);
        [screen release];
        //float rowVar1 = (mapSize.height/256);
        int maxRow = (int)(rowVar2 + rowVar3  + 0.5);
        
        
        //hack
        if (tiledMapViewResolutionPercentage == 25) {
            maxRow = maxRow > 2 ? 2 : maxRow;
            maxCol = maxCol > 3 ? 3 : maxCol;
        }
        if (tiledMapViewResolutionPercentage == 50) {
            maxRow = maxRow > 5 ? 5 : maxRow;
            maxCol = maxCol > 7 ? 7 : maxCol;
        }
        if (tiledMapViewResolutionPercentage == 100) {
            maxRow = maxRow > 11 ? 11 : maxRow;
            maxCol = maxCol > 15 ? 15 : maxCol;
        }
        
        //dont draw the map upside down
        CGContextScaleCTM(context, 1.0, -1.0);
        long tileStandardHeight = 0;
        long tileStandardWidth = 0;
        NSString *imageName;
        NSString* imageFileName;
        CGDataProviderRef provider;
        CGImageRef image;
        float scaledTileWidthDynamic;
        float scaledTileHeightDynamic;
        long currentScaledWidth,currentScaledHeight,endOfColValue;
        
        for (int row = minRow; row <= maxRow; row++) {
            for (int col = minCol; col <= maxCol; col++) {
                
                if ([m_gameRef UsingBorders]==YES) {
                    imageName = [NSString stringWithFormat:@"world_%d_border_%d_%d.jpg",(int)tiledMapViewResolutionPercentage, col, row];
                }
                else{
                    imageName = [NSString stringWithFormat:@"world_%d_%d_%d.jpg",(int)tiledMapViewResolutionPercentage, col, row];
                }
                
                imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName] ;
                provider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
                
                image = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
                if (image == nil) {
                    continue;
                }
                image = [self CreateScaledCGImageFromCGImage:image andScale:tiledMapViewZoomScale];
                if (image == nil) {
                    int a = 1;
                    a++;
                }
                
                currentScaledWidth = CGImageGetWidth(image);
                currentScaledHeight = CGImageGetHeight(image) ;
                endOfColValue = 0;
                //set standard size at first pass
                if (row == minRow && col == minCol) {
                    tileStandardWidth = currentScaledWidth;
                    tileStandardHeight = currentScaledHeight;
                }
                
                scaledTileWidthDynamic = scaledTileWidth;
                scaledTileHeightDynamic = scaledTileHeight;
                if (tileStandardHeight > currentScaledHeight) {
                    endOfColValue = tileStandardWidth - currentScaledHeight;
                    scaledTileHeightDynamic = currentScaledHeight;
                    
                }
                if (tileStandardWidth > currentScaledWidth) {
                    scaledTileWidthDynamic = currentScaledWidth;
                }
                //close the gap
                scaledTileWidthDynamic ++;
                scaledTileHeightDynamic++;
                CGFloat x = scaledTileWidth * col;
                CGFloat y = -scaledTileHeight * row + (-scaledTileHeight) + endOfColValue;
                CGContextDrawImage(context, CGRectMake(x,y,scaledTileWidthDynamic,scaledTileHeightDynamic), image);
                CGImageRelease(image);
            }
        }
    }
    CGContextScaleCTM(context, 1.0, -1.0);
}

-(NSInteger) DrawLineToRegion:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor
{
	NSInteger distanceBetweenPoints =0;
	
	//	//draw line to nearest point 
	//	CGPoint nearestPoint = [loc GetNearestPoint:realMapGamePoint];
	//	distanceBetweenPoints = [CoordinateHelper GetDistanceInKm:realMapGamePoint andPoint2:nearestPoint];
	
	//scale gamepoint 
	CGPoint scaledGamePoint;
	scaledGamePoint.x = realMapGamePoint.x * (tiledMapViewResolutionPercentage/100);
	scaledGamePoint.y = realMapGamePoint.y * (tiledMapViewResolutionPercentage/100);
	//scale to tile
	scaledGamePoint.x = scaledGamePoint.x * tiledMapViewZoomScale;
	scaledGamePoint.y = scaledGamePoint.y * tiledMapViewZoomScale;
	
	if ([loc WithinBounds:realMapGamePoint] == YES) {
		distanceBetweenPoints = 0;
	}
	else 
	{
		//draw line to nearest point 
		CGPoint nearestPoint = [loc GetNearestPoint:realMapGamePoint];
        

        distanceBetweenPoints = [CoordinateHelper GetDistanceInKm:realMapGamePoint andPoint2:nearestPoint];
	
        //_? only for world map
        CGPoint realMapGamePointManipulate1 = realMapGamePoint;
        realMapGamePointManipulate1.x = realMapGamePointManipulate1.x + constMapWidth;
        
        NSInteger distanceBetweenPointsTry1 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate1 andPoint2:nearestPoint];
        if (distanceBetweenPoints > distanceBetweenPointsTry1) {
            distanceBetweenPoints = distanceBetweenPointsTry1;
            scaledGamePoint.x = realMapGamePointManipulate1.x * (tiledMapViewResolutionPercentage/100);
            scaledGamePoint.x = scaledGamePoint.x * tiledMapViewZoomScale;
        }
        CGPoint realMapGamePointManipulate2 = realMapGamePoint;
        realMapGamePointManipulate2.x = realMapGamePointManipulate2.x - constMapWidth;
        NSInteger distanceBetweenPointsTry2 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate2 andPoint2:nearestPoint];
        if (distanceBetweenPoints > distanceBetweenPointsTry2) {
            distanceBetweenPoints = distanceBetweenPointsTry2;
            scaledGamePoint.x = realMapGamePointManipulate2.x * (tiledMapViewResolutionPercentage/100);
            scaledGamePoint.x = scaledGamePoint.x * tiledMapViewZoomScale;
        }
        
        
        
		
		//at 100 %
		//scale to map
		nearestPoint.x = nearestPoint.x * (tiledMapViewResolutionPercentage/100);
		nearestPoint.y = nearestPoint.y * (tiledMapViewResolutionPercentage/100);
		//scale to tile
		nearestPoint.x = nearestPoint.x * tiledMapViewZoomScale;
		nearestPoint.y = nearestPoint.y * tiledMapViewZoomScale;
		
		UIColor *uicolor = [playerColor retain];
		CGColorRef color = [uicolor CGColor];
		long numComponents = CGColorGetNumberOfComponents(color);
		if (numComponents == 4)
		{
			const CGFloat *components = CGColorGetComponents(color);
			CGFloat red = components[0];
			CGFloat green = components[1];
			CGFloat blue = components[2];
			CGFloat alpha = components[3];
			CGContextSetRGBStrokeColor(context, red, green, blue, alpha); 
		}
		else {
			CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1); 
		}
		[uicolor release];
		
        CGContextSetLineWidth(context, 2.0);
        CGFloat dash[] = {0.0, 3.0};
        CGContextSetLineCap(context, kCGLineCapButt);
        CGContextSetLineDash(context, 0.0, dash, 2);
		CGContextMoveToPoint(context, nearestPoint.x, nearestPoint.y);
		CGContextAddLineToPoint( context, scaledGamePoint.x,scaledGamePoint.y);
		CGContextStrokePath(context);
        
        //reset line draw attributest
        CGContextSetLineWidth(context, 1.0);
        CGContextSetLineDash(context, 0, NULL, 0);
        
	}
	
	return distanceBetweenPoints;
}

-(void) DrawRegion:(MpLocation*) loc
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGImageRef mask;
	NSString *maskFileName;

	if ([loc isKindOfClass:[Lake class]] || [loc isKindOfClass:[UnDefWaterRegion class]])
	{
		maskFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dMaskWater.png", (int)tiledMapViewResolutionPercentage]] ;
	}
	else
	{
		maskFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%dMaskLand.png", (int)tiledMapViewResolutionPercentage]] ;
	}
	
	UIImage *testUIMaskImage = [UIImage imageWithContentsOfFile:maskFileName];
	CGImageRef maskRef = testUIMaskImage.CGImage;
    
	float val1 = tiledMapViewResolutionPercentage;
	float val2 = tiledMapViewZoomScale;
    
    float testWidth = constMapWidth * (val1/100);
	float testHeight = constMapHeight * (val1/100);

	CGRect t_testRect = CGRectMake(0, 0, testWidth * val2, testHeight * val2);


    mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    
    
	CGContextClipToMask(context, t_testRect, mask);
	CGImageRelease(mask);
    
	CGContextSetRGBFillColor(context, 0, 200, 0, 0.5);
    
	[self SetRegionsPaths:loc];
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.75);
	//[self StrokeUpRegions:loc andContextRef:context];
	//[self StrokeUpExludedRegions:loc andContextRef:context];
	CGContextRestoreGState(context);
    
    boundsOfRegion = CGRectMake(minX, minY, maxX - minX, maxY-minY);
    boundsOfRegion = CGRectOffset(boundsOfRegion, -tilesMapViewBounds.origin.x,-tilesMapViewBounds.origin.y);
    
    self.sectionFiguresView.viewref = self;
    self.sectionFiguresView.location = loc;
    [self.sectionFiguresView setNeedsDisplay];
}

-(void) SetRegionsPaths:(MpLocation*) loc
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	NSMutableArray *coordinatesArrayInArray = [(MpRegion*)loc GetCoordinates];
    BOOL mainRegion = YES;
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
            if (mainRegion == YES) {
                minX = minX > tempPoint.x ? tempPoint.x : minX;
                minY = minY > tempPoint.y ? tempPoint.y : minY;
                maxX = maxX < tempPoint.x ? tempPoint.x : maxX;
                maxY = maxY < tempPoint.y ? tempPoint.y : maxY;
            }
            
			
		}
        mainRegion = NO;
		
		CGContextClosePath(context);
		
		[self SetExludedRegionsPaths:loc];
		
		CGContextEOFillPath(context);
	}
}


-(void) SetExludedRegionsPaths:(MpLocation*) loc
{
    CGContextRef context = UIGraphicsGetCurrentContext();
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


-(void) StrokeUpRegions:(MpLocation*) loc andContextRef:(CGContextRef) context 
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
            
            minX = minX > tempPoint.x ? tempPoint.x : minX;
            minY = minY > tempPoint.y ? tempPoint.y : minY;
            maxX = maxX < tempPoint.x ? tempPoint.x : maxX;
            maxY = maxY < tempPoint.y ? tempPoint.y : maxY;
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
                /*
                minX = minX > tempPoint.x ? tempPoint.x : minX;
                minY = minY > tempPoint.y ? tempPoint.y : minY;
                maxX = maxX < tempPoint.x ? tempPoint.x : maxX;
                maxY = maxY < tempPoint.y ? tempPoint.y : maxY;*/
			}
			CGContextStrokePath(context);
		}
		skippedFirst = YES;
	}
}


-(void) StrokeUpExludedRegions:(MpLocation*) loc andContextRef:(CGContextRef) context 
{
	CGPoint tempPoint;
	NSArray *excludedRegionsArray = [(MpRegion*)loc GetExcludedRegions];
	for (NSArray * tempArray in excludedRegionsArray) 
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
	
}


//_? change in NMQ
-(NSInteger) DrawLineToPlace:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor
{
	NSInteger distanceBetweenPoints = 0;
	NSMutableArray *vCoordinate = [(MpPlace*)loc GetCoordinates];
	NSValue *tempval = [vCoordinate objectAtIndex:0];
	CGPoint placeGamePoint = [tempval CGPointValue];
	//at 100 %
	if (placeGamePoint.x != 0 && placeGamePoint.y != 0) 
	{
		
		if ([loc WithinBounds:realMapGamePoint] == YES) {
			distanceBetweenPoints = 0;
			
		}
		else 
		{
			
			//measurement done in map 100% scale 1800*4500
			distanceBetweenPoints = [CoordinateHelper GetDistanceInKm:realMapGamePoint andPoint2:placeGamePoint];
			
            
            //_? only for world map
            CGPoint realMapGamePointManipulate1 = realMapGamePoint;
            realMapGamePointManipulate1.x = realMapGamePointManipulate1.x + constMapWidth;
            NSInteger distanceBetweenPointsTry1 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate1 andPoint2:placeGamePoint];
            if (distanceBetweenPoints > distanceBetweenPointsTry1) {
                distanceBetweenPoints = distanceBetweenPointsTry1;
                realMapGamePoint.x = realMapGamePointManipulate1.x;
            }
            CGPoint realMapGamePointManipulate2 = realMapGamePoint;
            realMapGamePointManipulate2.x = realMapGamePointManipulate2.x - constMapWidth;
            NSInteger distanceBetweenPointsTry2 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate2 andPoint2:placeGamePoint];
            if (distanceBetweenPoints > distanceBetweenPointsTry2) {
                distanceBetweenPoints = distanceBetweenPointsTry2;
                realMapGamePoint.x = realMapGamePointManipulate2.x;
            }
            
			distanceBetweenPoints = distanceBetweenPoints - [(MpPlace*)loc GetKmTolerance];
			
			//scale to map
			placeGamePoint.x = placeGamePoint.x * (tiledMapViewResolutionPercentage/100);
			placeGamePoint.y = placeGamePoint.y * (tiledMapViewResolutionPercentage/100);
			//scale to tile
			placeGamePoint.x = placeGamePoint.x * tiledMapViewZoomScale;
			placeGamePoint.y = placeGamePoint.y * tiledMapViewZoomScale;
			
            
            
			realMapGamePoint.x = realMapGamePoint.x * (tiledMapViewResolutionPercentage/100);
			realMapGamePoint.y = realMapGamePoint.y * (tiledMapViewResolutionPercentage/100);
			//scale to tile
			realMapGamePoint.x = realMapGamePoint.x * tiledMapViewZoomScale;
			realMapGamePoint.y = realMapGamePoint.y * tiledMapViewZoomScale;
			
			UIColor *uicolor = [playerColor retain];
			CGColorRef color = [uicolor CGColor];
			long numComponents = CGColorGetNumberOfComponents(color);
			if (numComponents == 4)
			{
				const CGFloat *components = CGColorGetComponents(color);
				CGFloat red = components[0];
				CGFloat green = components[1];
				CGFloat blue = components[2];
				CGFloat alpha = components[3];
				CGContextSetRGBStrokeColor(context, red, green, blue, alpha); 
			}
			else {
				CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1); 
			}
			[uicolor release];
			
            CGContextSetLineWidth(context, 2.0);
            CGFloat dash[] = {0.0, 3.0};
            CGContextSetLineCap(context, kCGLineCapButt);
            CGContextSetLineDash(context, 0.0, dash, 2);

			CGContextMoveToPoint(context, realMapGamePoint.x, realMapGamePoint.y);
			CGContextAddLineToPoint( context, placeGamePoint.x,placeGamePoint.y);
			
			CGContextClosePath(context);
			CGContextStrokePath(context);
            
            //reset line draw attributest
            CGContextSetLineWidth(context, 1.0);
            CGContextSetLineDash(context, 0, NULL, 0);
		}
	}
	return distanceBetweenPoints;
}

-(void) DrawPlayerSymbol:(NSString*) playerSymbol andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint
{
    CGPoint devicePoint;
	devicePoint.x = realMapGamePoint.x * (tiledMapViewResolutionPercentage/100);
	devicePoint.y = realMapGamePoint.y * (tiledMapViewResolutionPercentage/100);
	//scale to tile
	devicePoint.x = devicePoint.x * tiledMapViewZoomScale;
	devicePoint.y = devicePoint.y * tiledMapViewZoomScale;
	
    
	
	NSString *playerSymbolFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:playerSymbol];
	CGDataProviderRef provider = CGDataProviderCreateWithFilename([playerSymbolFileName UTF8String]);
	CGImageRef playerSymbolRef = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(provider);
	CGContextDrawImage (context,CGRectMake(devicePoint.x - 15, devicePoint.y - 15, 30, 30),playerSymbolRef);
	CGImageRelease(playerSymbolRef);
}

-(bool) PlayerSymbolInsideBounds:(CGPoint) realMapGamePoint resultMapBounds:(CGRect) resultMapBounds
{
    CGPoint devicePoint;
	devicePoint.x = realMapGamePoint.x * (tiledMapViewResolutionPercentage/100);
	devicePoint.y = realMapGamePoint.y * (tiledMapViewResolutionPercentage/100);
	//scale to tile
	devicePoint.x = devicePoint.x * tiledMapViewZoomScale;
	devicePoint.y = devicePoint.y * tiledMapViewZoomScale;

    
    bool outsideBounds = false;
    if (!CGRectContainsPoint(resultMapBounds,devicePoint)) {
        outsideBounds = true;
    }
    return outsideBounds;
}

-(void) DrawPlace:(MpLocation*) loc
{
    CGContextRef context = UIGraphicsGetCurrentContext();
	NSMutableArray *vCoordinate = [(MpPlace*)loc GetCoordinates];
	NSValue *tempval = [vCoordinate objectAtIndex:0];
	CGPoint placePoint = [tempval CGPointValue];
	CGPoint mapCoordinatePoint;
	mapCoordinatePoint.x = placePoint.x * (tiledMapViewResolutionPercentage/100);
	mapCoordinatePoint.y = placePoint.y * (tiledMapViewResolutionPercentage/100);
	//scale to tile
	mapCoordinatePoint.x = mapCoordinatePoint.x * tiledMapViewZoomScale;
	mapCoordinatePoint.y = mapCoordinatePoint.y * tiledMapViewZoomScale;
	
	//draw a circle around place depending on city big medium small
	CGContextRef contextRef = UIGraphicsGetCurrentContext();
	
	CGContextSetRGBFillColor(contextRef, 0, 0, 255, 0.1);
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.6);
	//CGContextSetRGBStrokeColor(contextRef, 0, 0, 255, 0.5);
	
	float circleDiameter = 5;
	float circleRadius = circleDiameter / 2; 
	// Draw a circle (filled)
	CGContextFillEllipseInRect(contextRef, CGRectMake(mapCoordinatePoint.x - circleRadius, mapCoordinatePoint.y - circleRadius, circleDiameter, circleDiameter));
	
	// Draw a circle (border only)
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(mapCoordinatePoint.x - circleRadius, mapCoordinatePoint.y - circleRadius, circleDiameter, circleDiameter));
	
	circleDiameter = 10;
	circleRadius = circleDiameter / 2; 
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.5);
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(mapCoordinatePoint.x - circleRadius, mapCoordinatePoint.y - circleRadius, circleDiameter, circleDiameter));
	
	circleDiameter = 15;
	circleRadius = circleDiameter / 2; 
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.3);
	CGContextStrokeEllipseInRect(contextRef, CGRectMake(mapCoordinatePoint.x - circleRadius, mapCoordinatePoint.y - circleRadius, circleDiameter, circleDiameter));
}


-(CGImageRef) CreateScaledCGImageFromCGImage:(CGImageRef) image  andScale:(float) scale 
{ 
	// Create the bitmap context 
	CGContextRef    context = NULL; 
	void *          bitmapData; 
	int             bitmapByteCount; 
	int             bitmapBytesPerRow; 
	
	// Get image width, height. We'll use the entire image. 
	int width = CGImageGetWidth(image) * scale;// * (percentageScale/100); 
	int height = CGImageGetHeight(image) * scale;// * (percentageScale/100); 
	
	// Declare the number of bytes per row. Each pixel in the bitmap in this 
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and 
	// alpha. 
	bitmapBytesPerRow   = (width * 4); 
	bitmapByteCount     = (bitmapBytesPerRow * height); 
	
	// Allocate memory for image data. This is the destination in memory 
	// where any drawing to the bitmap context will be rendered. 
	bitmapData = malloc( bitmapByteCount ); 
	if (bitmapData == NULL) 
	{ 
		return nil; 
	}

	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format 
	// specified here by CGBitmapContextCreate. 
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image); 
	context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow, 
									 colorspace,kCGImageAlphaNoneSkipFirst); 
	//CGColorSpaceRelease(colorspace);
	
	if (context == NULL) 
		// error creating context 
		return nil; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space. 
	CGContextDrawImage(context, CGRectMake(0,0,width, height), image); 
	
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context); 
	
    CGContextRelease(context);
    
	free(bitmapData);
    
	
	return imgRef; 
}

- (void)dealloc {
    //[_sectionFiguresView removeFromSuperview];
    //[_playerSymbolMiniWindowView removeFromSuperview];
    //[_sectionFiguresView dealloc];
    //[_playerSymbolMiniWindowView dealloc];
    [super dealloc];
}


@end
