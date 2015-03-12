//
//  GameEndedView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "Game.h"
#import "iAd/ADBannerView.h"
#import "SoapHelper.h"
#import "ChallengeViewController.h"
#import "HighscoreService.h"

@protocol GameEndedViewDelegate;

@interface GameEndedView : UIView<ADBannerViewDelegate,ChallengeViewControllerDelegate> {
	id <GameEndedViewDelegate> delegate;
	//NSMutableArray *m_playerNameLabelsArray;
	//NSMutableArray *m_playerDistanceLabelsArray;
	//NSMutableArray *m_linesArray;
	UILabel *m_tapWhenReadyLabel;
	UIImageView* m_headerImageView;
    UILabel *m_header;
	UILabel *m_questionsPassedLabel;
    UILabel *m_globalHighscoreLabel;
	UILabel *m_dynamicLabel;
	UILabel *m_secondsUsedLabel;
	NSInteger m_labelsXoffset;
	NSInteger m_labelsYoffset;
	NSInteger m_playerIndexToAnimate;
	NSInteger m_numberOfPlayersToAnimate;
	Player *m_playerRef;
    
    //SoapHelper* ssb;
    UIButton* challengeButton;
    UIButton* exitButton;
    Game* m_gameRef;
    ChallengeViewController* challengeViewController;
    
    ADBannerView* adBannerView;
    BOOL adBannerViewIsVisible;
    
}
@property (nonatomic, assign) id <GameEndedViewDelegate> delegate;
@property (strong, nonatomic) HighscoreService *highscoreService;
//- (id)initWithFrame:(CGRect)frame gameRef:(Game*) gameRef;
-(void) setHeader;
-(void) setGameRef:(Game*) gameRef;
-(void) sendHighscoreToServer;
-(void) setUpSinglePlayer;
-(void) FadeIn;
-(void) FadeOut;
-(void) AnimateLastElements;
-(void) AnimateElementsIn:(NSInteger) numberOfPlayers;
-(void) AnimatePlayerIn;
-(void) SetAlphaIn;
- (void)createAdBannerView;
-(void) showAdBar;

@end

@protocol GameEndedViewDelegate <NSObject>

@optional
-(void) GameOver;
-(void) showAdBar;
@end