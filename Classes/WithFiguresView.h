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
}

@property (nonatomic, assign) id <WithFiguresViewDelegate> delegate;
-(void)setGameRef:(Game*) game;
-(CGImageRef) CreateScaledCGImageFromCGImage:(CGImageRef) image  andScale:(float) scale;
-(NSInteger) DrawLineToPlace:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor andPlayerSymbol:(NSString*) playerSymbol;
-(NSInteger) DrawLineToRegion:(MpLocation*) loc andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint andLineColor:(UIColor*)playerColor
			  andPlayerSymbol:(NSString*) playerSymbol;
-(void) DrawPlace:(MpLocation*) loc andContextRef:(CGContextRef) context;
-(void) DrawRegion:(MpLocation*) loc andContextRef:(CGContextRef) context ;
-(void) DrawPlayerSymbol:(NSString*) playerSymbol andContextRef:(CGContextRef) context andGamePoint:(CGPoint) realMapGamePoint;

-(void) SetExludedRegionsPaths:(MpLocation*) loc andContextRef:(CGContextRef) context; 
-(void) SetRegionsPaths:(MpLocation*) loc andContextRef:(CGContextRef) context ;
-(void) StrokeUpRegions:(MpLocation*) loc andContextRef:(CGContextRef) context ;
-(void) StrokeUpExludedRegions:(MpLocation*) loc andContextRef:(CGContextRef) context ;

-(void) drawResult_UpdateGameData:(BOOL) updateGameData;
@end


@protocol WithFiguresViewDelegate <NSObject>

@optional
- (void)finishedDrawingResultMap;

@end






