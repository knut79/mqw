//
//  MainMenuView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StartGameMenu.h"
#import "SettingsMenuView.h"
#import "HighscoreView.h"
#import "InstructionsView.h"

@protocol MainMenuViewDelegate;

@interface MainMenuView : UIView <StartGameMenuViewDelegate,SettingsMenuViewDelegate> {
	StartGameMenu *startGameMenu;
	SettingsMenuView *settingsMenuView;
	HighscoreView *highscoreView;
	InstructionsView *instructionsView;
	id <MainMenuViewDelegate> delegate;
	SkyView *m_skyView;
	
	UIButton *buttonStartMenu;
	UIButton *buttonSettingsMenu;
	UIButton *buttonHighscoreMenu;
	UIButton *buttonRestart;
	UIButton *buttonInstructionsMenu;
	
}
- (void)SettingsMenuViewHiding;
-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;

@property (nonatomic, assign) id <MainMenuViewDelegate> delegate;

@end


@protocol MainMenuViewDelegate <NSObject>

@optional
- (void)switchToMapViewAndStart:(Game *) gameRef; 
@end
