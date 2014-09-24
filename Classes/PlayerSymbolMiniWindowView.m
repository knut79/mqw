//
//  PlayerSymbolMiniWindowView.m
//  MQNorway
//
//  Created by knut on 22/09/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//

#import "WithFiguresView.h"

@implementation PlayerSymbolMiniWindowView

@synthesize viewref, touchPoint, loopLocation, isPositionedLeft, lastPosition;

- (id)initWithFrame:(CGRect)frame{
	
	if (self = [super initWithFrame:CGRectMake(0, 0, 80, 80)]) {
		// make the circle-shape outline with a nice border.
		self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
		self.layer.borderWidth = 3;
		self.layer.cornerRadius = 4;
		self.layer.masksToBounds = YES;
        xSelfPosition = 40;
        ySelfPosition = 90;
		self.center = CGPointMake(xSelfPosition, ySelfPosition);
        
	}
	return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSMutableSet *currentTouches = [[[event touchesForView:self] mutableCopy] autorelease];
    [currentTouches minusSet:touches];
    if ([currentTouches count] > 0) {
		
    }
	
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
	
	self.center = currentPoint;
	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	
	CGPoint currentPoint = [[touches anyObject] locationInView:self.superview];
	
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self touchesEnded:touches withEvent:event];
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


- (void)drawRect:(CGRect)rect {

    _gamePoint.y = _gamePoint.y * 0.25;// * tiledMapViewZoomScale;
    _gamePoint.x = _gamePoint.x * 0.25;// * tiledMapViewZoomScale;
    
	if (isPositionedLeft == YES) {
		if (touchPoint.x < 100 && touchPoint.y < 170 ) {
			self.center = CGPointMake(270, 90);
			isPositionedLeft = NO;
		}
	}
	else {
		if (touchPoint.x > 220 && touchPoint.y < 170 ) {
			self.center = CGPointMake(50, 90);
			isPositionedLeft = YES;
		}
	}
    
    float devideFactor = 4;
    float xOffset = (_gamePoint.x/devideFactor) -40;
    float yOffset = (_gamePoint.y/devideFactor) -40;
    float rowIncFactor = 256 / devideFactor;
    float colIncFactor = 256 / devideFactor;
    
    UIGraphicsPushContext(UIGraphicsGetCurrentContext());
    int mapHeight = 0;
    int mapWidth = 0;
    
    
    CGPoint calculatedPlacePoint = CGPointMake((_placePoint.x / devideFactor),
                                               (_placePoint.y/devideFactor));
    CGPoint placePointDiff = CGPointMake(calculatedPlacePoint.x - (_gamePoint.x/devideFactor), calculatedPlacePoint.y - (_gamePoint.y/devideFactor));
    
    bool outOfBoundsTop = yOffset < 0 ? true: false;
    int outOfBoundsOffset = outOfBoundsTop ? 40 : 0;
    float xValueForLastCols = 0;
    //first cols may be dirty if outofboundsbottom becomes true
    for (int row = 0; row <= 2; row++) {
        int col = 4;
            
            UIImage *imageFirstTwoCols = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world_25_%d_%d.jpg", col, row]]];
            float imageWidth =imageFirstTwoCols.size.width/devideFactor;
            float imageHeight = imageFirstTwoCols.size.height/devideFactor;
            xValueForLastCols = (-1 *colIncFactor) - xOffset +(colIncFactor -imageWidth);
            CGRect imageRect = CGRectMake(xValueForLastCols,(row*rowIncFactor) - yOffset - outOfBoundsOffset, imageWidth, imageHeight);
            mapHeight += imageHeight;
            [imageFirstTwoCols drawInRect:imageRect];
    }
    
    bool outOfBoundsBottom = yOffset + 80 > mapHeight ? true:false;
    outOfBoundsOffset = outOfBoundsBottom ? -40 : outOfBoundsOffset;
    xValueForLastCols = xValueForLastCols - colIncFactor;
    for (int row = 0; row <= 2; row++) {
        int col = 3;
        
        UIImage *imageFirstTwoCols = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world_25_%d_%d.jpg", col, row]]];
        float imageWidth =imageFirstTwoCols.size.width/devideFactor;
        float imageHeight = imageFirstTwoCols.size.height/devideFactor;
        CGRect imageRect = CGRectMake(xValueForLastCols,(row*rowIncFactor) - yOffset - outOfBoundsOffset, imageWidth, imageHeight);
        
        [imageFirstTwoCols drawInRect:imageRect];
    }
    
    
    float xValueForRepeatOfFirstColumn = 0;
    for (int row = 0; row <= 2; row++) {
        mapWidth = 0;
        for (int col = 0; col <= 4; col++) {
        
            
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world_25_%d_%d.jpg", col, row]]];
            float imageWidth =image.size.width/devideFactor;
            float imageHeight = image.size.height/devideFactor;
            CGRect imageRect = CGRectMake((col *colIncFactor) - xOffset ,(row*rowIncFactor) - yOffset - outOfBoundsOffset, imageWidth, imageHeight);
            mapWidth += imageWidth;
            xValueForRepeatOfFirstColumn =imageRect.origin.x + imageRect.size.width;
            [image drawInRect:imageRect];
            
        }
        
    }
    
    for (int row = 0; row <= 2; row++) {
        int col = 0;
        
        UIImage *imageLastCol = [[UIImage alloc] initWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"world_25_%d_%d.jpg", col, row]]];
        float imageWidth =imageLastCol.size.width/devideFactor;
        float imageHeight = imageLastCol.size.height/devideFactor;
        CGRect imageRect = CGRectMake(xValueForRepeatOfFirstColumn ,(row*rowIncFactor) - yOffset - outOfBoundsOffset, imageWidth, imageHeight);
        [imageLastCol drawInRect:imageRect];

        
    }
    UIGraphicsPopContext();
    
    //check witch way to draw
    int placePointManipulateX = 0;
    if(((_gamePoint.x/devideFactor) - calculatedPlacePoint.x ) * -1 > (mapWidth/2))
    {
        placePointManipulateX = placePointManipulateX - mapWidth;
    }
    else if((_gamePoint.x/devideFactor) - calculatedPlacePoint.x > (mapWidth/2))
    {
        placePointManipulateX = placePointManipulateX + mapWidth;
    }
    
    int playerSymbolYCoordinate = 40;
    if (outOfBoundsTop) {
        playerSymbolYCoordinate = 0;
    }
    else if(outOfBoundsBottom)
    {
        playerSymbolYCoordinate = 80;
    }
    CGPoint playerSymbolLocation = CGPointMake(40,playerSymbolYCoordinate);
    //draw line
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context, 1.0, 0, 0, 1);
    
    /*
    CGContextSetLineWidth(context, 2.0);
    CGFloat dash[] = {0.0, 3.0};
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetLineDash(context, 0.0, dash, 4);*/
    int placeXToDrawAgainst = playerSymbolLocation.x + placePointDiff.x + placePointManipulateX;
    int placeYToDrawAgainst = playerSymbolLocation.y + placePointDiff.y;
    CGContextMoveToPoint(context, playerSymbolLocation.x, playerSymbolLocation.y);
    CGContextAddLineToPoint( context, placeXToDrawAgainst, placeYToDrawAgainst);
    
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    //reset line draw attributest
    /*
    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineDash(context, 0, NULL, 0);
    */
    
    xSelfPosition = placeXToDrawAgainst < 40 ? (320-40) : 40;
    ySelfPosition = placeYToDrawAgainst < 40 ? (480 -90) : 90;
    self.center = CGPointMake(xSelfPosition, ySelfPosition);
    
    playerSymbolOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    playerSymbolOverlay.center = playerSymbolLocation;
    playerSymbolOverlay.image = [UIImage imageNamed:@"ArrowRed.png"];
    [self addSubview:playerSymbolOverlay];
    

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
