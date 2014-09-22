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
#import "MagnifierView.h"


@implementation WithFiguresView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        
		tiledMapViewZoomScale = 1;
		tiledMapViewResolutionPercentage = 25;
		
		answerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 440, 320, 40)];
		answerLabel.hidden = YES;
		[self addSubview:answerLabel];

		tiledMapViewZoomScale = 0.7111111;
		tiledMapViewResolutionPercentage = (float)25;
		tiledMapViewTileWidth = 256;
    }
    return self;
}


-(void)setGameRef:(Game*) game{
	m_gameRef = [game retain];
}


-(void) setDataForWitFiguresDrawing_DEP: (CGRect) isvBounds andZoomScale:(float)isvZoomScale andResolutionPerc:(float) resPercentage
{
	tiledMapViewZoomScale = isvZoomScale;
	tilesMapViewBounds = isvBounds;
	tiledMapViewResolutionPercentage = resPercentage;
}


-(void) setTiledMapViewTileWidth_DEP:(int) width
{
	tiledMapViewTileWidth = width;
}


-(void) SetTilesMapViewBounds
{
	//get center of destination
	Question *question = [[m_gameRef GetQuestion]retain];
	MpLocation *loc = [[question GetLocation] retain];

	CGPoint centerPoint; 
	centerPoint = [loc GetCenterPoint];
	centerPoint.y = centerPoint.y * 0.25 * tiledMapViewZoomScale;
    centerPoint.x = centerPoint.x * 0.25 * tiledMapViewZoomScale;

    UIScreen *screen = [[UIScreen mainScreen] retain];
	CGRect testRect = CGRectMake(0, 0, [screen applicationFrame].size.width, [screen applicationFrame].size.height);
 
    
    testRect.origin.x += (centerPoint.x - ([screen applicationFrame].size.width/2));
    testRect.origin.y += (centerPoint.y - ([screen applicationFrame].size.height/2));
    
    
	//1800 4500
    //german width 3780
    
    //world width 4444
    //world height 3040

    
    CGFloat mapWidth =(4444 * 0.25)*tiledMapViewZoomScale;
	if (testRect.origin.x >  mapWidth - 320)
	{
		testRect.origin.x = mapWidth - 320;
	}
	else if(testRect.origin.x < 0)
	{
		testRect.origin.x = 0;
	}
    CGFloat mapHeight = (3040 * 0.25)*tiledMapViewZoomScale;
    if (testRect.origin.y > (mapHeight - 480))
	{
		testRect.origin.y = mapHeight - 480;
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
				
				float colvar2 = (tilesMapViewBounds.origin.x/scaledTileWidth) ;
				float colVar3 = (320.0/scaledTileWidth);
				int maxCol = (int)(colvar2 + colVar3 + 0.5);
				
				float rowVar2 = (tilesMapViewBounds.origin.y/scaledTileWidth) ;
				float rowVar3 = (480.0/scaledTileWidth);
				//float rowVar1 = (mapSize.height/256);
				int maxRow = (int)(rowVar2 + rowVar3  + 0.5);

				//dont draw the map upside down
				CGContextScaleCTM(context, 1.0, -1.0);
				int tileStandardHeight = 0;
				int tileStandardWidth = 0;
				NSString *imageName;
				NSString* imageFileName;
				CGDataProviderRef provider;
				CGImageRef image;
				float scaledTileWidthDynamic;
				float scaledTileHeightDynamic;
				int currentScaledWidth,currentScaledHeight,endOfColValue; 

				for (int row = minRow; row <= maxRow; row++) {
					for (int col = minCol; col <= maxCol; col++) {

						imageName = [NSString stringWithFormat:@"world_%d_%d_%d.jpg",(int)tiledMapViewResolutionPercentage, col, row];
						imageFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:imageName] ;
						provider = CGDataProviderCreateWithFilename([imageFileName UTF8String]);
						//image = CGImageCreateWithPNGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
						image = CGImageCreateWithJPEGDataProvider(provider, NULL, true, kCGRenderingIntentDefault);
						image = [self CreateScaledCGImageFromCGImage:image andScale:tiledMapViewZoomScale];
						

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
			
			//_? change in NMQ
			NSMutableArray *players = [[m_gameRef GetPlayers] retain];
			
			//at 100 %
			Question *question = [[m_gameRef GetQuestion] retain];
			MpLocation *loc = [[question GetLocation] retain];
			//check if region or place
			NSInteger distanceBetweenPoints;
			
			
			for (Player *player in players) 
			{
				if (([player IsOut] == NO) && [player HasGivenUp] == NO) {
					CGPoint gamePoint = [player GetGamePoint];
					UIColor *playerColor = [[player GetColor] retain];
					NSString *playerSymbolString = [[player GetPlayerSymbol] retain];
					NSInteger currentKmLeft = [player GetKmLeft];
					
					if ([loc isKindOfClass:[MpPlace class]] == YES) 
					{
						distanceBetweenPoints = [self DrawLineToPlace:loc andContextRef:context andGamePoint:gamePoint  andLineColor:playerColor andPlayerSymbol:playerSymbolString];
					}
					else if([loc isKindOfClass:[MpRegion class]] == YES)
					{
						distanceBetweenPoints = [self DrawLineToRegion:loc andContextRef:context andGamePoint:gamePoint  andLineColor:playerColor andPlayerSymbol:playerSymbolString];
					}
					
					//[m_gameRef UpdateAvgDistanceForQuest:distanceBetweenPoints];
					
					[player SetLastDistanceFromDestination:distanceBetweenPoints];
					
					[player SetPetTalk:distanceBetweenPoints];
					
					if (m_shouldUpdateGameData == YES) {
						[m_gameRef UpdateAvgDistanceForQuest:distanceBetweenPoints];
						if ([m_gameRef IsTrainingMode] == NO) {
							[player SetKmLeft:(currentKmLeft - distanceBetweenPoints)];
						}
						
					}
					else {
						m_shouldUpdateGameData = YES;
					}
					
					[playerSymbolString release];
					[playerColor release];
				}
                
                if ([player HasGivenUp] == YES) {
                    [player SetKmLeft:-999];
                }
			}
			
			
			if ([loc isKindOfClass:[MpPlace class]] == YES) 
			{
				[self DrawPlace:loc andContextRef:context];
			}
			else if([loc isKindOfClass:[MpRegion class]] == YES)
			{
				[self DrawRegion:loc andContextRef:context ];
			}
			
			
			//_? change in NMQ
			//drawn twice because it ends either outside mask or underneath coloring
            bool playersymbolOutsideBoundsOfDevice = false;
			for (Player *player in players) 
			{
				if ([player IsOut] == NO) {
					CGPoint gamePoint = [player GetGamePoint];
					
					NSString *playerSymbolString = [[player GetPlayerSymbol] retain];
					
					//NSLog(@"playersymbol %@ x:%d y:%d",playerSymbolString,gamePoint.x,gamePoint.y);
					[self DrawPlayerSymbol:playerSymbolString andContextRef:context andGamePoint:gamePoint];

                    if ([players count] < 2) {
                        playersymbolOutsideBoundsOfDevice = [self PlayerSymbolInsideBounds: gamePoint resultMapBounds:tilesMapViewBounds];
                        //_? TODO
                        if (playersymbolOutsideBoundsOfDevice) {
                            //draw miniwindow with playersymbol location

                            MagnifierView *testloop = [[MagnifierView alloc] initWithFrame:self.bounds];
                            testloop.viewref = self;
                            [testloop setAlpha:1];
                            [self  addSubview:testloop];
                            [testloop setNeedsDisplay];
                        }
                    }
                    
                    
					[playerSymbolString release];
				}
			}
			
			// like Processing popMatrix
			CGContextRestoreGState(context);
			
			
			[players release];
			[loc release];
			[question release];
			

            
			if ([delegate respondsToSelector:@selector(finishedDrawingResultMap)])
				[delegate finishedDrawingResultMap];
			
		}
		m_shouldDrawResult = NO;
	}
	@catch (NSException * e) {
		NSLog(@"failed in draw withFiguresView: %@",e);
	}
}

-(NSInteger) DrawLineToRegion:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor
			  andPlayerSymbol:(NSString*) playerSymbol
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
        realMapGamePointManipulate1.x = realMapGamePointManipulate1.x + 4444;
        
        NSInteger distanceBetweenPointsTry1 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate1 andPoint2:nearestPoint];
        if (distanceBetweenPoints > distanceBetweenPointsTry1) {
            distanceBetweenPoints = distanceBetweenPointsTry1;
            scaledGamePoint.x = realMapGamePointManipulate1.x * (tiledMapViewResolutionPercentage/100);
            scaledGamePoint.x = scaledGamePoint.x * tiledMapViewZoomScale;
        }
        CGPoint realMapGamePointManipulate2 = realMapGamePoint;
        realMapGamePointManipulate2.x = realMapGamePointManipulate2.x - 4444;
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
		int numComponents = CGColorGetNumberOfComponents(color);
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
        CGContextSetLineDash(context, 0.0, dash, 4);
		CGContextMoveToPoint(context, nearestPoint.x, nearestPoint.y);
		CGContextAddLineToPoint( context, scaledGamePoint.x,scaledGamePoint.y);
		CGContextStrokePath(context);
        
        //reset line draw attributest
        CGContextSetLineWidth(context, 1.0);
        CGContextSetLineDash(context, 0, NULL, 0);
        
	}
	//draw player symbol
	NSString *playerSymbolFileName = [[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:playerSymbol] retain];
	UIImage *playerSymbolUIImage = [[UIImage imageWithContentsOfFile:playerSymbolFileName] retain];
	CGImageRef playerSymbolRef = playerSymbolUIImage.CGImage;
	CGContextDrawImage (context,CGRectMake(scaledGamePoint.x - 15, scaledGamePoint.y - 15, 30, 30),playerSymbolRef);
	[playerSymbolFileName release];
	[playerSymbolUIImage release];
	
	return distanceBetweenPoints;
}

-(void) DrawRegion:(MpLocation*) loc andContextRef:(CGContextRef) context 
{
	
	CGContextSaveGState(context);
	
	CGImageRef mask;
	NSString *maskFileName;

	if ([loc isKindOfClass:[Lake class]] || [loc isKindOfClass:[Fjord class]])
	{
		maskFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mask_water] ;
	}
	else
	{
		maskFileName = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:mask_land] ;
	}
	
	UIImage *testUIMaskImage = [UIImage imageWithContentsOfFile:maskFileName];
	CGImageRef maskRef = testUIMaskImage.CGImage;
	
	float val1 = tiledMapViewResolutionPercentage;
	float val2 = tiledMapViewZoomScale;
    float testWidth = 4444 * (val1/100);
	float testHeight = 3040 * (val1/100);

	CGRect t_testRect = CGRectMake(0, 0, testWidth * val2, testHeight * val2);

    mask = CGImageMaskCreate( 4444 /2,3040 / 2,
							 CGImageGetBitsPerComponent(maskRef),
							 CGImageGetBitsPerPixel(maskRef),
							 CGImageGetBytesPerRow(maskRef),
							 CGImageGetDataProvider(maskRef), NULL, false);
    
	CGContextClipToMask(context, t_testRect, mask);
	
	CGContextSetRGBFillColor(context, 0, 200, 0, 0.5);
	
	[self SetRegionsPaths:loc andContextRef:context];
	
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 0.75);
	[self StrokeUpRegions:loc andContextRef:context];
	
	[self StrokeUpExludedRegions:loc andContextRef:context];
	
	CGContextRestoreGState(context);
}

-(void) SetRegionsPaths:(MpLocation*) loc andContextRef:(CGContextRef) context 
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
			 andPlayerSymbol:(NSString*) playerSymbol
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
            realMapGamePointManipulate1.x = realMapGamePointManipulate1.x + 4444;
            NSInteger distanceBetweenPointsTry1 = [CoordinateHelper GetDistanceInKm:realMapGamePointManipulate1 andPoint2:placeGamePoint];
            if (distanceBetweenPoints > distanceBetweenPointsTry1) {
                distanceBetweenPoints = distanceBetweenPointsTry1;
                realMapGamePoint.x = realMapGamePointManipulate1.x;
            }
            CGPoint realMapGamePointManipulate2 = realMapGamePoint;
            realMapGamePointManipulate2.x = realMapGamePointManipulate2.x - 4444;
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
			int numComponents = CGColorGetNumberOfComponents(color);
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
            CGContextSetLineDash(context, 0.0, dash, 4);

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

-(void) DrawPlace:(MpLocation*) loc andContextRef:(CGContextRef) context
{
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
	CGColorSpaceRelease(colorspace); 
	
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
    [super dealloc];
}


@end
