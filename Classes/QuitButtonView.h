//
//  QuitButtonView.h
//  MQNorway
//
//  Created by knut dullum on 02/10/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QuitButtonViewDelegate;

@interface QuitButtonView : UIView {
	id <QuitButtonViewDelegate> delegate;
	UIAlertView *alert;
    BOOL m_multiplayer;
}
@property (nonatomic, assign) id <QuitButtonViewDelegate> delegate;
-(void) IsMultiplayer:(BOOL) value;

@end

@protocol QuitButtonViewDelegate <NSObject>

@optional
- (void)QuitGame;
@end
