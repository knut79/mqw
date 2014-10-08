@class TapDetectingView;

@protocol TiledScrollViewDataSource;

@interface TiledScrollView : UIScrollView <UIScrollViewDelegate> {
    id <TiledScrollViewDataSource>  dataSource;
	
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
	long _firstVisibleRow, _firstVisibleColumn, _lastVisibleRow, _lastVisibleColumn;
}

@property (nonatomic, assign) id <TiledScrollViewDataSource> dataSource;
//@property (nonatomic, assign) id <TiledScrollViewDelegate> delegate;
@property (nonatomic, assign) CGSize tileSize;
@property (nonatomic, readonly) TapDetectingView *tileContainerView;
@property (nonatomic, assign) int minimumResolution;
@property (nonatomic, assign) int maximumResolution;
@property (nonatomic, assign) long firstVisibleRow;
@property (nonatomic, readonly) long firstVisibleColumn;
@property (nonatomic, readonly) long lastVisibleRow;
@property (nonatomic, readonly) long lastVisibleColumn;

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


