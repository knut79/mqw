//
//  TrainingEndedView.h
//  MQNorway
//
//  Created by knut dullum on 22/06/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "Game.h"

@protocol TrainingEndedViewDelegate;

@interface TrainingEndedView : UIView {
	id <TrainingEndedViewDelegate> delegate;
	UIButton *buttonMainMenu;
	UIButton *buttonRestart;
	SkyView *m_skyView;
	UILabel *headerLabel;
	Game *m_gameRef;
	
	//test
	NSDictionary *oldResultDictionary;
	NSDictionary *newResultDictionary;
	NSArray *placesArray;
	int placeIndex;
	NSMutableArray *placeLabels;
	UILabel *newAvgLabel;
}
-(void) FadeIn;
-(void) FadeOut;
-(void) SetGameRef:(Game*) game;

-(void) RicochetAvgDifference;

@property (nonatomic, assign) id <TrainingEndedViewDelegate> delegate;

@end


@protocol TrainingEndedViewDelegate <NSObject>

@optional
- (void)RestartGame;
- (void)DisplayMainMenu;
@end