//
//  GameEndedView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "SkyView.h"
#import "Game.h"
#import "iAd/ADBannerView.h"
#import "SoapHelper.h"
#import "ChallengeViewController.h"

@protocol GameEndedViewDelegate;

@interface GameEndedView : UIView<ADBannerViewDelegate,SoapHelperDelegate,ChallengeViewControllerDelegate> {
	id <GameEndedViewDelegate> delegate;
	NSMutableArray *m_playerNameLabelsArray;
	NSMutableArray *m_playerDistanceLabelsArray;
	NSMutableArray *m_linesArray;
	UILabel *m_tapWhenReadyLabel;
	UIImageView* m_headerImageView;
	UILabel *m_questionsPassedLabel;
	UILabel *m_scoreLabel;
	UILabel *m_localHighscoreLabel;
    UILabel *m_globalHighscoreLabel;
	UIImageView* m_highscoreImageView;	
	UILabel *m_dynamicLabel;
	UILabel *m_secondsUsedLabel;
    UILabel *m_localHeaderLabel;
    UILabel *m_globalHeaderLabel;
	NSInteger m_labelsXoffset;
	NSInteger m_labelsYoffset;
	NSInteger m_playerIndexToAnimate;
	NSInteger m_numberOfPlayersToAnimate;
	Player *m_playerRef;
	SkyView *m_skyView;
    
    SoapHelper* ssb;
    UIButton* challengeButton;
    UIButton* exitButton;
    Game* m_gameRef;
    ChallengeViewController* challengeViewController;
    
    ADBannerView* adBannerView;
    BOOL adBannerViewIsVisible;
}
@property (nonatomic, assign) id <GameEndedViewDelegate> delegate;
-(void)SetHeader:(Game*) gameRef;
-(void) FadeIn;
-(void) FadeOut;
-(void) AnimateLastElements;
-(void) AnimateElementsIn:(NSInteger) numberOfPlayers;
-(void) AnimatePlayerIn;
-(void) SetAlphaIn;
- (void)createAdBannerView;
-(void) showAdBar;
-(void) setUpSinglePlayer:(Game*) gameRef;
-(void) setUpMultiplayerLastStandingGame:(Game*) gameRef;
-(void) setUpMultiplayerMostPointsGame:(Game*) gameRef;
@end

@protocol GameEndedViewDelegate <NSObject>

@optional
-(void) GameOver;
-(void) showAdBar;
@end