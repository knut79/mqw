//
//  HighscoreGlobalView.h
//  MQNorway
//
//  Created by knut dullum on 01/11/2011.
//  Copyright 2011 lemmus. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "EnumDefs.h"
	
@protocol HighscoreGlobalViewDelegate;

	@interface HighscoreGlobalView : UIView<NSXMLParserDelegate> {
			id <HighscoreGlobalViewDelegate> delegate;
		SkyView *m_skyView;
		NSString *pathEasy;
		NSString *pathMedium;
		NSString *pathHard;
		NSMutableArray *nameLabels;
		NSMutableArray *nameLabelsCenter;
		NSMutableArray *easyQLabels;
		NSMutableArray *qLabelsCenter;
		NSMutableArray *timeLabels;
		NSMutableArray *timeLabelsCenter;
		NSMutableArray *pointsLabels;
		NSMutableArray *pointsLabelsCenter;
		UIButton *buttonBack;
		UILabel *headerLabel;
		CGPoint touchLocation;
		UILabel *headerScore;
		UILabel *subheaderLabel;
		CGPoint subheaderLabelCenter;
		NSArray *easyScoreArray;
		NSArray *mediumScoreArray;
		NSArray *hardScoreArray;
		Difficulty m_showingLevel;
		NSInteger m_centerX;
		NSInteger m_centerY;
		UIButton *button_levelDown;
		UIButton *button_levelUp;
		CGPoint button_levelUpCenter;
		CGPoint button_levelDownCenter;
		UIButton *switchShowButton;
		CGPoint startTouchPosition;
		
		NSMutableData *webData;
		NSMutableString *soapResults;
		NSXMLParser *xmlParser;
		BOOL recordName;
		BOOL recordScore;
		BOOL recordTime;
        BOOL recordPlace;
        BOOL recordQuestions;
		BOOL showTopTen;
		
		int index;
		
		UIActivityIndicatorView *m_activityIndicator;
	}
	@property (nonatomic, assign) id <HighscoreGlobalViewDelegate> delegate;
	-(void) FadeIn;
	-(void) FadeOut;
	-(void) UpdateLabels;
	-(void) changeLevel;
	
	@end


@protocol HighscoreGlobalViewDelegate <NSObject>

@optional
-(void) cleanUpHigscoreGlobalView;
@end