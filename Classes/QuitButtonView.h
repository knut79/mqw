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
}
@property (nonatomic, assign) id <QuitButtonViewDelegate> delegate;

@end

@protocol QuitButtonViewDelegate <NSObject>

@optional
- (void)QuitGame;
@end
