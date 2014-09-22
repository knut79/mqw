//
//  PauseView.h
//  MQNorway
//
//  Created by knut dullum on 19/06/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "Game.h"

@protocol PauseViewDelegate;

@interface PauseView : UIView {
	id <PauseViewDelegate> delegate;
	UIButton *buttonMainMenu;
	UIButton *buttonResume;
	SkyView *m_skyView;
	
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
-(void) RicochetAvgDifference;
-(void) SetGameRef:(Game*) game;

@property (nonatomic, assign) id <PauseViewDelegate> delegate;

@end


@protocol PauseViewDelegate <NSObject>

@optional
- (void)DisplayMainMenu;
@end