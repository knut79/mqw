//
//  MainMenuView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartGameMenu.h"
#import "OtherInfoView.h"
#import "TakeChallenge.h"

@protocol MainMenuViewDelegate;

@interface MainMenuView : UIView <StartGameMenuViewDelegate,OtherInfoViewDelegate,TakeChallengeViewCtrlDelegate,HighscoreGlobalViewDelegate> {
	StartGameMenu *startGameMenu;
	//OtherInfoView* otherInfoView;
    HighscoreGlobalView *highscoreGlobalView;
	id <MainMenuViewDelegate> delegate;
	UILabel *loadingLabel;
	
	UIButton *buttonStartMenu;
	//UIButton *buttonOtherInfoMenu;
	UIButton *buttonRestart;
    UIButton *buttonChallengesMenu;
    UIButton * buttonHighscoreMenu;
    TakeChallenge* takeChallengeViewCtrl;
    
    UIActivityIndicatorView *activityIndicatorCollectingId;
}
-(void) ShowChallengeButton;
- (void)SettingsMenuViewHiding;
-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;

@property (nonatomic, assign) id <MainMenuViewDelegate> delegate;

@end


@protocol MainMenuViewDelegate <NSObject>

@optional

- (void)PreStartNewGame:(Game*) gameRef ;
@end
