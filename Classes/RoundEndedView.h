//
//  RoundEndedView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "Player.h"
#import "SkyView.h"
#import "Game.h"

@protocol RoundEndedViewDelegate;

@interface RoundEndedView : UIView {
	id <RoundEndedViewDelegate> delegate;
	NSMutableArray *m_playerLabelsArray;
	UILabel *m_tapWhenReadyLabel;
	UIImageView* m_headerImageView;
	UILabel *m_questionsLeftLabel;
	NSInteger m_labelsXoffset;
	NSInteger m_labelsYoffset;
	NSInteger m_playerIndexToAnimate;
	NSInteger m_numberOfPlayersToAnimate;
	Player *m_playerRef;
	SkyView *m_skyView;
}
@property (nonatomic, assign) id <RoundEndedViewDelegate> delegate;

-(void)SetRoundResults:(Game*) gameRef;
-(void) FadeIn;
-(void) FadeOut;
-(void) AnimateElementsIn:(NSInteger) numberOfPlayers;
-(void) AnimatePlayerIn;
-(void) FinishedAnimatingPlayer;
-(void) WiggleHeader;
-(void) HeaderAnimateUp;
-(void) HeaderAnimateDown;
-(void) AnimateLastElements;
-(void) SetAlphaIn;
@end

@protocol RoundEndedViewDelegate <NSObject>

@optional
-(void) FinishedShowinRoundEndedView;
@end