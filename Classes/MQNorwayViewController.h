//
//  MQNorwayViewController.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TiledScrollView.h"
#import "WithFiguresView.h"
#import "MainMenuView.h"
#import "TouchImageView.h"
#import "DirectionsTouchImageView.h"
#import "Game.h"
#import "QuestionBarViewTop.h"
#import "AnswerBarViewTop.h"
#import "InfoBarViewBottom.h"
#import "StartPlayerView.h"
#import "RoundEndedView.h"
#import "GameEndedView.h"
#import "SkyView.h"
#import "RestartView.h"
#import "AnimateTextView.h"
#import "FirstTimeInstructionsView.h"
#import "TapDetectingView.h"
#import "MagnifierView.h"
#import "PauseView.h"
#import "TrainingEndedView.h"
#import "ClockView.h"
#import "QuitButtonView.h"
#import "PassButtonView.h"
#import "HintButtonView.h"

#import "GlobalHelper.h"
#import "CreatePlayerVC.h"


@interface MQNorwayViewController : UIViewController <TouchImageViewDelegate,TapDetectingViewDelegate, 
TiledScrollViewDataSource,WithFiguresViewDelegate,MainMenuViewDelegate,RestartViewDelegate,
StartPlayerViewDelegate,AnimateTextViewDelegate,RoundEndedViewDelegate,GameEndedViewDelegate,InfoBarViewBottomDelegate,
QuestionBarViewTopDelegate,TrainingEndedViewDelegate,FirstTimeInstructionsDelegate,
QuitButtonViewDelegate,PassButtonViewDelegate,HintButtonViewDelegate,CreatePlayerVCDelegate> {


    CreatePlayerVC* createPlayerVC;
    
    TiledScrollView *playingBoardView;
    WithFiguresView *resultBoardView;
    
    UIScrollView    *thumbScrollView;
    UIView          *slideUpView; // Contains thumbScrollView and a label giving credit for the images.
	TouchImageView *touchImageView;
	DirectionsTouchImageView *directionsTouchView;
	MainMenuView * mainMenuView;
	FirstTimeInstructionsView *firstTimeInstructionsView;
	
	BOOL transitioning;
    BOOL thumbViewShowing;
    NSTimer *autoscrollTimer;  // Timer used for auto-scrolling.
    float autoscrollDistance;  // Distance to scroll the thumb view when auto-scroll timer fires.
	int resolutionPercentage;
	
	Game *m_gameRef;
	UILabel *questionLabel;
	
	QuestionBarViewTop *questionBarTop;
	AnswerBarViewTop *answerBarTop;
	InfoBarViewBottom *infoBarBottom;
	
	StartPlayerView *m_startPlayerView;
	RestartView *m_restartView;
	NSString *documentsDir;
	
	RoundEndedView* m_roundEndedView;
	GameEndedView* m_gameEndedView;
	AnimateTextView *m_animTextView;
	
	BOOL m_restoreGameState;
	
	MagnifierView *loop;
	
	PauseView *m_pauseView;
	TrainingEndedView *m_trainingEndedView;
	
	ClockView *clockView;
	QuitButtonView* quitButton;
	HintButtonView* hintButton;
	PassButtonView* passButton;
    
    UILabel* timePointsLabel;
    
    SoapHelper* ssb;
	
}

-(void) FirstLoad;
-(void)performTransition;
-(void)setZoomScale:(CGSize)size;
-(void) FadeOutGameElements;
-(void) FadeInGameElements;
-(void) DisplayReplayGameMenu;
-(void) ZoomOutMap;
-(void) StartNextRound;
-(void) UnLoadViews;
-(void) LoadSubViews;
-(void) SaveGameData;
-(void) LoadGameAndResume;
-(void) positionPlayerSymbol:(CGPoint)thePoint zoomOffsetScale:(float) zoomOffsetScale;
-(void) releaseLoop;
-(void) SetPlayerButtons;
-(void) SetPlayerClock;
-(void) AnimateAndGiveTimePoints;
-(void) GiveTimePoints;
-(void) PlayerGaveUp;
-(void) RemoveGameBoardAndBars;
-(void) LoadGameBoardAndBars;
@end



