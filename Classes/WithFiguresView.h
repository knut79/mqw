//
//  WithFiguresView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Answer.h"
#import "Game.h"
#import "PlayerSymbolMiniWindowView.h"
#import "SectionFiguresView.h"


@protocol WithFiguresViewDelegate;

@interface WithFiguresView : UIView{
	id <WithFiguresViewDelegate> delegate;
	float tiledMapViewZoomScale;
	float tiledMapViewResolutionPercentage;
	CGRect tilesMapViewBounds;
	int tiledMapViewTileWidth;
	Game *m_gameRef;
	UILabel *answerLabel;
	BOOL m_shouldDrawResult;
	BOOL m_shouldUpdateGameData;
    
    int minX;
    int maxX;
    int minY;
    int maxY;
    CGRect boundsOfRegion;

}
@property(nonatomic) CGRect boundsOfRegion;
@property(nonatomic) CGRect tilesMapViewBounds;
@property(nonatomic) CGPoint lastCenterPoint;
@property(nonatomic, retain) PlayerSymbolMiniWindowView *playerSymbolMiniWindowView;
@property(nonatomic, retain) SectionFiguresView *sectionFiguresView;
@property (nonatomic, assign) id <WithFiguresViewDelegate> delegate;
-(void)setGameRef:(Game*) game;
-(CGImageRef) CreateScaledCGImageFromCGImage:(CGImageRef) image  andScale:(float) scale;
-(NSInteger) DrawLineToPlace:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor;
-(NSInteger) DrawLineToRegion:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor;
-(void) DrawPlace:(MpLocation*) loc;
-(void) DrawRegion:(MpLocation*) loc;
-(void) DrawPlayerSymbol:(NSString*) playerSymbol andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint;
-(bool) PlayerSymbolInsideBounds:(CGPoint) realMapGamePoint resultMapBounds:(CGRect) resultMapBounds;
-(void) SetExludedRegionsPaths:(MpLocation*) loc; 
-(void) SetRegionsPaths:(MpLocation*) loc;
-(void) StrokeUpRegions:(MpLocation*) loc andContextRef:(CGContextRef) context ;
-(void) StrokeUpExludedRegions:(MpLocation*) loc andContextRef:(CGContextRef) context ;
-(void) ResetRegionBoundValues;
-(void) ResetZoomAndResolution;
-(void) drawResult_UpdateGameData:(BOOL) updateGameData;
-(void) AnimateResult;
@end


@protocol WithFiguresViewDelegate <NSObject>

@optional
- (void)finishedDrawingResultMap;

@end






