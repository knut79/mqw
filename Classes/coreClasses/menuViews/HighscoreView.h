//
//  HighscoreView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "EnumDefs.h"


@interface HighscoreView : UIView {

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
	CGPoint startTouchPosition;
}
-(void) ReadHighscoresIntoArrays;
-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;
-(void) ReadHighScoresAtDifficulty:(Difficulty) difficulty;
-(void) changeLevel;

@end
