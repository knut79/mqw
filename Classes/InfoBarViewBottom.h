//
//  InfoBarView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Game.h"
//#import <QuartzCore/QuartzCore.h>

@protocol InfoBarViewBottomDelegate;

@interface InfoBarViewBottom : UIView {
	id <InfoBarViewBottomDelegate> delegate;
	//test
	//UILabel *aLabel;
	//UIImageView *animatedIconView;
	//end test
	Game* m_gameRef;
	NSTimer * m_distanceBarsTimer;
	NSInteger m_barWidth1;
	int m_kmLeft1;
	NSInteger m_barWidth2;
	int m_kmLeft2;
	NSInteger m_barWidth3;
	int m_kmLeft3;
	NSInteger m_barWidth4;
	int m_kmLeft4;
	float m_barWidthStart;
	NSMutableArray *m_kmLeftArray;
	NSMutableArray *m_barWidthArray;
	NSInteger m_numberOfPlayersLeft;
	NSInteger m_timerNumerator;
	
	UIButton *m_setPositionButton;
	BOOL m_finishedAnimating;
	BOOL m_drawUpdatedScore;
	NSMutableArray* m_labelPool;
//	CAKeyframeAnimation *animatedIconAnimation;
	UILabel *m_trainingLabel;
	UILabel *m_trainingLabel2;
	UILabel *m_diffAvg;
	UIButton *m_pauseButton;
	int m_training_oldAvg;

}

@property (nonatomic, assign) id <InfoBarViewBottomDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void) SetGameRef:(Game*) gameRef;
-(void) doSetPosition:(id)Sender;
-(void) AnimateBars;
-(void) UpdateBars;
-(void) SetBars;
-(void) ResetPlayersLeft;
-(void) drawScoreForTwoPlayers:(CGContextRef) context drawUpdatedScore:(BOOL) drawUpdatedScore;
-(void) drawScoreForThreePlayers:(CGContextRef) context drawUpdatedScore:(BOOL) drawUpdatedScore;
-(void) drawScoreForFourPlayers:(CGContextRef) context drawUpdatedScore:(BOOL) drawUpdatedScore;
-(void) drawScoreForPlayer:(CGContextRef) context player:(Player*) player textX:(NSInteger) textX textY:(NSInteger) textY fontSize:(NSInteger) fontSize scoreYOffset:(NSInteger) scoreYOffset barRect:(CGRect) barRect drawUpdatedScore:(BOOL) drawUpdatedScore;
-(void) UpdatePoints;
-(void) EnableSetPositionButton;
-(void) drawForOnePlayer:(CGContextRef) context;
-(void) drawForTwoPlayers:(CGContextRef) context;
-(void) drawForThreePlayers:(CGContextRef) context;
-(void) drawForFourPlayers:(CGContextRef) context;
-(void) FadeIn;
-(void) FadeOut;
-(void) SetTrainingText;
-(void) UpdateTrainingText;
-(void) HideTrainingElements;
-(void) PauseGame;
-(void) DrawBarsOnce;

@end

@protocol InfoBarViewBottomDelegate <NSObject>

@optional
- (void)FinishedAnimating;
- (void)finishedShowingResultMap;
-(void)SetPositionDone;
-(void) PauseTraining;
@end



