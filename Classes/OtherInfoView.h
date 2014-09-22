//
//  OtherInfoView.h
//  MQNorway
//
//  Created by knut dullum on 03/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighscoreTopLevelMenu.h"
#import "InstructionsView.h"
#import "StatisticsView.h"
#import "PlayerStats.h"
//#import "StatisticsViewController.h"

@protocol OtherInfoViewDelegate;
@interface OtherInfoView : UIView<HighscoreTopLevelMenuDelegate,StatisticsViewDelegate,InstructionsViewDelegate> {
    id <OtherInfoViewDelegate> delegate;
    
	
	UILabel *headerLabel;
	HighscoreTopLevelMenu *highscoreView;
	InstructionsView *instructionsView;
	StatisticsView *statisticsView;
//	StatisticsViewController *statisticsViewController;
	UIButton *buttonInstructionsMenu;
	UIButton *buttonStatisticsMenu;
	UIButton *buttonHighscoreMenu;
    UIButton *buttonPlayerStatsMenu;
	UIButton *buttonBack;
	SkyView *m_skyView;
    PlayerStats* playerstatsViewCtrl;
}
@property (nonatomic, assign) id <OtherInfoViewDelegate> delegate;
-(void) UpdateLabels;
-(void) FadeIn;
-(void) FadeOut;
-(void) playerStatsMenu:(id)Sender;
-(void) highscoreMenu:(id)Sender;
-(void) instructionsMenu:(id)Sender;
-(void) statisticsMenu:(id)Sender;
-(void) UpdateLabels;
-(void) TellParentToCleanUp;

-(void) cleanUpPlayerStatsViewCtrl;
-(void) cleanUpHighscoreTopLevelMenu;
-(void) cleanUpStatisticsView;
-(void) cleanUpInstructionsView;
@end



@protocol OtherInfoViewDelegate <NSObject>

@optional
-(void) cleanUpOtherInfoView;
@end