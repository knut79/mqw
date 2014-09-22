//
//  StartPlayerView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "SkyView.h"
#import "Game.h"

@protocol StartPlayerViewDelegate;

@interface StartPlayerView : UIView {
	id <StartPlayerViewDelegate> delegate;
	UILabel *m_playerNameLabel;
	UILabel *m_tapWhenReadyLabel;
	UILabel *m_secondsUsedLabel;
	UILabel *m_dynamicLabel1;
	UILabel *m_dynamicLabel2;
	UILabel *m_dynamicLabel3;
	NSInteger m_labelsXoffset;
	NSInteger m_labelsYoffset;
	Player *m_playerRef;
	SkyView *m_skyView;
}
@property (nonatomic, assign) id <StartPlayerViewDelegate> delegate;

-(void)SetPlayerRef:(Player*) playerRef gameRef:(Game*) gameRef;
-(void) FadeIn;
-(void) FadeOut;
-(void) SetAlphaIn;

@end

@protocol StartPlayerViewDelegate <NSObject>

@optional
- (void)StartPlayer;
@end
