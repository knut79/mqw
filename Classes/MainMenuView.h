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

@interface MainMenuView : UIView <StartGameMenuViewDelegate,OtherInfoViewDelegate,TakeChallengeViewCtrlDelegate> {
	StartGameMenu *startGameMenu;
	OtherInfoView* otherInfoView;
	id <MainMenuViewDelegate> delegate;
	//SkyView *m_skyView;
	UILabel *loadingLabel;
	
	UIButton *buttonStartMenu;
	UIButton *buttonOtherInfoMenu;
	UIButton *buttonRestart;
    UIButton *buttonChallengesMenu;
    TakeChallenge* takeChallengeViewCtrl;
	
}
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
