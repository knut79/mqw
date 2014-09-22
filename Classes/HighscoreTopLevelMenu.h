//
//  HighscoreTopLevelMenu.h
//  MQNorway
//
//  Created by knut dullum on 24/09/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighscoreLocalView.h"
#import "HighscoreGlobalView.h"
@protocol HighscoreTopLevelMenuDelegate;
@interface HighscoreTopLevelMenu : UIView<HighscoreGlobalViewDelegate,HighscoreLocalViewDelegate> {
    id <HighscoreTopLevelMenuDelegate> delegate;
	UILabel *headerLabel;
	HighscoreLocalView *highscoreLocalView;
	HighscoreGlobalView *highscoreGlobalView;

	UIButton *buttonHighscoreLocal;
	UIButton *buttonHighscoreGlobal;
	UIButton *buttonBack;
	SkyView *m_skyView;
}
@property (nonatomic, assign) id <HighscoreTopLevelMenuDelegate> delegate;
-(void) UpdateLabels;
-(void) FadeIn;
-(void) FadeOut;
-(void) cleanUpHigscoreGlobalView;
@end

@protocol HighscoreTopLevelMenuDelegate <NSObject>

@optional
-(void) cleanUpHighscoreTopLevelMenu;
@end
