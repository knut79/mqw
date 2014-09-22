//
//  GameMenuView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainMenuView.h"


@protocol GameMenuDelegate;

@interface GameMenuViewController : UIViewController <MainMenuViewDelegate> {
	id <GameMenuDelegate> delegate;
	MainMenuView *mainMenuView;
}
-(void) FadeInView;
@property (nonatomic, assign) id <GameMenuDelegate> delegate;

@end


@protocol GameMenuDelegate <NSObject>

@optional
- (void)switchToMapViewAndStart:(Game *)gameRef;
- (void)StartNewGame:(Game*) gameRef;

@end