@class TapDetectingView;

@protocol TiledScrollViewDataSource;
//@protocol TiledScrollViewDelegate;

@interface TiledScrollView : UIScrollView <UIScrollViewDelegate> {
    id <TiledScrollViewDataSource>  dataSource;
//	id <TiledScrollViewDelegate> delegate;
	
    CGSize                          tileSize;
    NSMutableSet                    *reusableTiles;    

    int                              resolution;
    int                              maximumResolution;
    int                              minimumResolution;
	float xOffset;
	float yOffset;
	float scaleOffset;
	int  resolutionOffset;
	
   
    // we use the following ivars to keep track of which rows and columns are visible
	int _firstVisibleRow, _firstVisibleColumn, _lastVisibleRow, _lastVisibleColumn;
}

@property (nonatomic, assign) id <TiledScrollViewDataSource> dataSource;
//@property (nonatomic, assign) id <TiledScrollViewDelegate> delegate;
@property (nonatomic, assign) CGSize tileSize;
@property (nonatomic, readonly) TapDetectingView *tileContainerView;
@property (nonatomic, assign) int minimumResolution;
@property (nonatomic, assign) int maximumResolution;
@property (nonatomic, assign) int firstVisibleRow;
@property (nonatomic, readonly) int firstVisibleColumn;
@property (nonatomic, readonly) int lastVisibleRow;
@property (nonatomic, readonly) int lastVisibleColumn;

- (UIView *)dequeueReusableTile;  // Used by the delegate to acquire an already allocated tile, in lieu of allocating a new one.
- (void)reloadData;
- (void)reloadDataWithNewContentSize:(CGSize)size;

-(void)SetResolution:(int) res;
-(int)GetResolution;
- (void)updateResolution;
@end


@protocol TiledScrollViewDataSource <NSObject>
- (UIView *)tiledScrollView:(TiledScrollView *)scrollView tileForRow:(int)row column:(int)column resolution:(int)resolution;
@end

//@protocol TiledScrollViewDelegate <NSObject>
//@optional
//- (void)positionPlayerSymbol;
//@end


