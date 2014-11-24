#import "TapDetectingView.h"
#import <QuartzCore/QuartzCore.h>
#import "TiledScrollView.h"
#define DEFAULT_TILE_SIZE 100

#define ANNOTATE_TILES YES

@interface TiledScrollView ()
- (void)annotateTile:(UIView *)tile;
- (void)updateResolution;
@end

@implementation TiledScrollView
//@synthesize delegate;
@synthesize tileSize;
@synthesize tileContainerView;
@synthesize dataSource;
@dynamic minimumResolution;
@dynamic maximumResolution;


- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        
        // we will recycle tiles by removing them from the view and storing them here
        reusableTiles = [[NSMutableSet alloc] init];
        
        // we need a tile container view to hold all the tiles. This is the view that is returned
        // in the -viewForZoomingInScrollView: delegate method, and it also detects taps.
        tileContainerView = [[TapDetectingView alloc] initWithFrame:CGRectZero];
        [tileContainerView setBackgroundColor:[UIColor blueColor]];
        [self addSubview:tileContainerView];
	
        //[self setTileSize:CGSizeMake(DEFAULT_TILE_SIZE, DEFAULT_TILE_SIZE)];
        [self setTileSize:CGSizeMake(100.0, 100.0)];

        // no rows or columns are visible at first; note this by making the firsts very high and the lasts very low
        _firstVisibleRow = _firstVisibleColumn = NSIntegerMax;
        _lastVisibleRow  = _lastVisibleColumn  = NSIntegerMin;

		xOffset = 0;
		yOffset = 0;
		//3780, 5228
		scaleOffset = 0;
		resolutionOffset = -2;//25%
        // the TiledScrollView is its own UIScrollViewDelegate, so we can handle our own zooming.
        // We need to return our tileContainerView as the view for zooming, and we also need to receive
        // the scrollViewDidEndZooming: delegate callback so we can update our resolution.
		[super setDelegate:self];
    }
    return self;
}

- (void)dealloc {
	[self removeFromSuperview];
    [reusableTiles release];
    [tileContainerView release];
    [super dealloc];
}

// we don't synthesize our minimum/maximum resolution accessor methods because we want to police the values of these ivars
- (int)minimumResolution { return minimumResolution; }
- (int)maximumResolution { return maximumResolution; }
- (void)setMinimumResolution:(int)res { minimumResolution = MIN(res, 0); } // you can't have a minimum resolution greater than 0
- (void)setMaximumResolution:(int)res { maximumResolution = MAX(res, 0); } // you can't have a maximum resolution less than 0

- (UIView *)dequeueReusableTile {
    UIView *tile = [reusableTiles anyObject];
    if (tile) {
        // the only object retaining the tile is our reusableTiles set, so we have to retain/autorelease it
        // before returning it so that it's not immediately deallocated when we remove it from the set
        [[tile retain] autorelease];
        [reusableTiles removeObject:tile];
    }
    return tile;
}

- (void)reloadData {
    // recycle all tiles so that every tile will be replaced in the next layoutSubviews
    for (UIView *view in [tileContainerView subviews]) {
        [reusableTiles addObject:view];
        [view removeFromSuperview];
    }
	

    
    // no rows or columns are now visible; note this by making the firsts very high and the lasts very low
    _firstVisibleRow = _firstVisibleColumn = NSIntegerMax;
    _lastVisibleRow  = _lastVisibleColumn  = NSIntegerMin;
    
    [self setNeedsLayout];
}

- (void)reloadDataWithNewContentSize:(CGSize)size {
    
    // since we may have changed resolutions, which changes our maximum and minimum zoom scales, we need to 
    // reset all those values. After calling this method, the caller should change the maximum/minimum zoom scales
    // if it wishes to permit zooming.
    
    [self setZoomScale:1.0];
    [self setMinimumZoomScale:1.0];
    [self setMaximumZoomScale:1.0];
    resolution = 0;
    
    // now that we've reset our zoom scale and resolution, we can safely set our contentSize. 
    [self setContentSize:size];
    
    // we also need to change the frame of the tileContainerView so its size matches the contentSize
    [tileContainerView setFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [self reloadData];
}

/***********************************************************************************/
/* Most of the work of tiling is done in layoutSubviews, which we override here.   */
/* We recycle the tiles that are no longer in the visible bounds of the scrollView */
/* and we add any tiles that should now be present but are missing.                */
/***********************************************************************************/
- (void)layoutSubviews {
   
	//NSLog(@"layout tiles");
	
	[super layoutSubviews];
    
    CGRect visibleBounds =  self.bounds;

    //visibleBounds = CGRectMake(0, 0, visibleBounds.size.width, visibleBounds.size.height);
    // first recycle all tiles that are no longer visible
    for (UIView *tile in [tileContainerView subviews]) {
        
        // We want to see if the tiles intersect our (i.e. the scrollView's) bounds, so we need to convert their
        // frames to our own coordinate system
        CGRect scaledTileFrame = [tileContainerView convertRect:[tile frame] toView:self];

        // If the tile doesn't intersect, it's not visible, so we can recycle it
        if (! CGRectIntersectsRect(scaledTileFrame, visibleBounds)) {
            [reusableTiles addObject:tile];
            [tile removeFromSuperview];
        }
    }

    // calculate which rows and columns are visible by doing a bunch of math.
    float scaledTileWidth  = [self tileSize].width  * [self zoomScale];
    float scaledTileHeight = [self tileSize].height * [self zoomScale];
    int maxRow = floorf([tileContainerView frame].size.height / scaledTileHeight); // this is the maximum possible row
    int maxCol = floorf([tileContainerView frame].size.width  / scaledTileWidth);  // and the maximum possible column
    int firstNeededRow = MAX(0, floorf(visibleBounds.origin.y / scaledTileHeight));
    int firstNeededCol = MAX(0, floorf(visibleBounds.origin.x / scaledTileWidth));
    int lastNeededRow  = MIN(maxRow, floorf(CGRectGetMaxY(visibleBounds) / scaledTileHeight));
    int lastNeededCol  = MIN(maxCol, floorf(CGRectGetMaxX(visibleBounds) / scaledTileWidth));
        
    // iterate through needed rows and columns, adding any tiles that are missing
    for (int row = firstNeededRow; row <= lastNeededRow; row++) {
        for (int col = firstNeededCol; col <= lastNeededCol; col++) {

            BOOL tileIsMissing = (_firstVisibleRow > row || _firstVisibleColumn > col ||
                                  _lastVisibleRow  < row || _lastVisibleColumn  < col);
            
            if (tileIsMissing) {

                UIView *tile = [dataSource tiledScrollView:self tileForRow:row column:col resolution:resolution];
                         
                // set the tile's frame so we insert it at the correct position
                CGRect frame = CGRectMake([self tileSize].width * col, [self tileSize].height * row, [self tileSize].width +10, [self tileSize].height + 10);
                [tile setFrame:frame];
                [tileContainerView addSubview:tile];

                // annotateTile draws green lines and tile numbers on the tiles for illustration purposes. 
                //[self annotateTile:tile];
                
            }
        }
    }

    // update our record of which rows/cols are visible
    _firstVisibleRow = firstNeededRow; _firstVisibleColumn = firstNeededCol;
    _lastVisibleRow  = lastNeededRow;  _lastVisibleColumn  = lastNeededCol;

     
	float xValue = .0f;
	if(visibleBounds.origin.x > xOffset)
		xValue = (xValue +(visibleBounds.origin.x - xOffset));
	else if(visibleBounds.origin.x < xOffset)
		xValue = (xValue - (xOffset - visibleBounds.origin.x));

    
	float yValue = .0f;
	if(visibleBounds.origin.y > yOffset)
		yValue = (yValue + (visibleBounds.origin.y - yOffset));
	else if(visibleBounds.origin.y < yOffset)
		yValue = (yValue - (yOffset - visibleBounds.origin.y));
	


	float zoomOffset = 0.0f;
	//check if we are zooming
	if (scaleOffset != [self zoomScale]) {
		zoomOffset = [self zoomScale] - scaleOffset;
	}

	
	xOffset = visibleBounds.origin.x;
	yOffset = visibleBounds.origin.y;
    
	scaleOffset = [self zoomScale];
	resolutionOffset = resolution;
	
	[tileContainerView positionPlayerSymbolPassThrough:CGPointMake(xValue, yValue) zoomOffsetScale:zoomOffset];
}


/*****************************************************************************************/
/* The following method handles changing the resolution of our tiles when our zoomScale  */
/* gets below 50% or above 100%. When we fall below 50%, we lower the resolution 1 step, */
/* and when we get above 100% we raise it 1 step. The resolution is stored as a power of */
/* 2, so -1 represents 50%, and 0 represents 100%, and so on.                            */
/*****************************************************************************************/
- (void)updateResolution {
    

    // delta will store the number of steps we should change our resolution by. If we've fallen below
    // a 25% zoom scale, for example, we should lower our resolution by 2 steps so delta will equal -2.
    // (Provided that lowering our resolution 2 steps stays within the limit imposed by minimumResolution.)
    int delta = 0;
    
    // check if we should decrease our resolution
    for (int thisResolution = minimumResolution; thisResolution < resolution; thisResolution++) {
        int thisDelta = thisResolution - resolution;
        // we decrease resolution by 1 step if the zoom scale is <= 0.5 (= 2^-1); by 2 steps if <= 0.25 (= 2^-2), and so on
        float scaleCutoff = pow(2, thisDelta); 
        if ([self zoomScale] <= scaleCutoff) {
            delta = thisDelta;
            break;
        } 
    }
    
    // if we didn't decide to decrease the resolution, see if we should increase it
    if (delta == 0) {
        for (int thisResolution = maximumResolution; thisResolution > resolution; thisResolution--) {
            int thisDelta = thisResolution - resolution;
            // we increase by 1 step if the zoom scale is > 1 (= 2^0); by 2 steps if > 2 (= 2^1), and so on
            float scaleCutoff = pow(2, thisDelta - 1); 
            if ([self zoomScale] > scaleCutoff) {
                delta = thisDelta;
                break;
            } 
        }
    }
		
	
    if (delta != 0) {
        resolution += delta;
        
        // if we're increasing resolution by 1 step we'll multiply our zoomScale by 0.5; up 2 steps multiply by 0.25, etc
        // if we're decreasing resolution by 1 step we'll multiply our zoomScale by 2.0; down 2 steps by 4.0, etc
        float zoomFactor = pow(2, delta * -1); 
        
        // save content offset, content size, and tileContainer size so we can restore them when we're done
        // (contentSize is not equal to containerSize when the container is smaller than the frame of the scrollView.)
        CGPoint contentOffset = [self contentOffset];   
        CGSize  contentSize   = [self contentSize];
        CGSize  containerSize = [tileContainerView frame].size;
        
        // adjust all zoom values (they double as we cut resolution in half)
        [self setMaximumZoomScale:[self maximumZoomScale] * zoomFactor];
        [self setMinimumZoomScale:[self minimumZoomScale] * zoomFactor];
        [super setZoomScale:[self zoomScale] * zoomFactor];
        
        // restore content offset, content size, and container size
        [self setContentOffset:contentOffset];
        [self setContentSize:contentSize];
        [tileContainerView setFrame:CGRectMake(0, 0, containerSize.width, containerSize.height)];    
        
        // throw out all tiles so they'll reload at the new resolution
        [self reloadData];        
    }  

}

- (int) getFirstVisibleRow
{
	return _firstVisibleRow;
}

- (int) getLastVisibleRow
{
	return _lastVisibleRow;
}

- (int) getFirstVisibleColumn
{
	return _firstVisibleColumn;
}

- (int) getLastVisibleColumn
{
	return _lastVisibleColumn;
}

- (int) getTileWidth
{
	return [self tileSize].width;
}

        
#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return tileContainerView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if (scrollView == self) {
        
		
		
        // the following two lines are a bug workaround that will no longer be needed after OS 3.0.
        //[super setZoomScale:scale+0.01 animated:NO];
        //[super setZoomScale:scale animated:NO];
        
        // after a zoom, check to see if we should change the resolution of our tiles
        [self updateResolution];
		
		
		//test on USA
		/*if (resolution == -2 && scale < .36) {
			NSLog(@"zooming");
		}*/
    }
}


#pragma mark UIScrollView overrides

// the scrollViewDidEndZooming: delegate method is only called after an *animated* zoom. We also need to update our 
// resolution for non-animated zooms. So we also override the new setZoomScale:animated: method on UIScrollView
- (void)setZoomScale:(CGFloat)scale animated:(BOOL)animated {
	
	//NSLog(@"scaleFactor %f scaleOffset %f",scaleFactor , scaleOffset);
	//NSLog(@"zooming %f",scale);

    [super setZoomScale:scale animated:animated];
    
    // the delegate callback will catch the animated case, so just cover the non-animated case
    if (!animated) {
        [self updateResolution];
    }
}


//-(void)setBoundsOrigin
//{
//	CGRect orgBounds = [self bounds];
//	orgBounds.origin.x = orgBounds.origin.x + 10; 
////	orgBounds.size.width = orgBounds.size.width - 10; 
////	orgBounds.size.height = orgBounds.size.height - 10; 
//	[self setBounds:orgBounds];
//}


// We override the setDelegate: method because we can't manage resolution changes unless we are our own delegate.
- (void)setDelegate:(id)delegate {
    //[NSException raise:@"Invalid delegate" format:@"You can't set the delegate of a TiledZoomableScrollView. It is its own delegate."];
    NSLog(@"You can't set the delegate of a TiledZoomableScrollView. It is its own delegate.");
}


#pragma mark
#define LABEL_TAG 3

- (void)annotateTile:(UIView *)tile {
    static int totalTiles = 0;
    
    UILabel *label = (UILabel *)[tile viewWithTag:LABEL_TAG];
    if (!label) {  
        totalTiles++;  // if we haven't already added a label to this tile, it's a new tile
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 80, 50)];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTag:LABEL_TAG];
        [label setTextColor:[UIColor greenColor]];
        [label setShadowColor:[UIColor blackColor]];
        [label setShadowOffset:CGSizeMake(1.0, 1.0)];
        [label setFont:[UIFont boldSystemFontOfSize:40]];
        [label setText:[NSString stringWithFormat:@"%d", totalTiles]];
        [tile addSubview:label];
        [label release];
        [[tile layer] setBorderWidth:2];
        [[tile layer] setBorderColor:[[UIColor greenColor] CGColor]];

    }
    
    [tile bringSubviewToFront:label];
}

-(void)SetResolution:(int) res
{
	resolution = res;
}

-(int)GetResolution
{
	return resolution;
}


@end
