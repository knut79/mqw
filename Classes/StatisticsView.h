//
//  StatisticsView.h
//  MQNorway
//
//  Created by knut dullum on 02/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"

@protocol StatisticsViewDelegate;
@interface StatisticsView : UIView <UIWebViewDelegate>{ 
        id <StatisticsViewDelegate> delegate;
	SkyView *m_skyView;
	UILabel *headerLabel;
	UILabel *destinationHeader;
	UILabel *placeHeader;
	UILabel *questionsAnswHeader;
	UILabel *avgDistanceHeader;
	UILabel *touchForMoreInfoHeader;
	BOOL showingInfo;
	
	UILabel *nameLabel;
	
	UILabel *questionsAnsweredLabel1;
	UILabel *questionsAnsweredLabel2;
	
	UILabel *averageDistanceLabel1;
	UILabel *averageDistanceLabel2;
	
	UIButton *buttonBack;
	NSString *m_engTextFromFile;
	NSString *m_norTextFromFile;
	UIWebView *m_webView;
	UILabel *loadingLabel;
	UIActivityIndicatorView *m_activityIndicator;
}
@property (nonatomic, assign) id <StatisticsViewDelegate> delegate;
-(void) ReloadHtml;
-(void) UpdateText;
-(void) FadeIn;
-(void) FadeOut;


@end

@protocol StatisticsViewDelegate <NSObject>

@optional
-(void) cleanUpStatisticsView;
@end
