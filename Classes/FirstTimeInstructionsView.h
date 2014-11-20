//
//  FirstTimeInstructionsView.h
//  MQNorway
//
//  Created by knut dullum on 05/05/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FirstTimeInstructionsDelegate;

@interface FirstTimeInstructionsView : UIView {
	id <FirstTimeInstructionsDelegate> delegate;
	UIButton *buttonDontShowAgain;
	UIButton *buttonShowAgain;
	UILabel *headerLabel;
	UILabel *zoomOutLabel;
	UILabel *zoomInLabel;
	UILabel *tapToMoveLabel;
	UILabel *dragToMoveLabel;
	NSString *m_playerName;
}
@property (nonatomic, assign) id <FirstTimeInstructionsDelegate> delegate;
- (id)initWithFrame:(CGRect)frame;
-(void) SetPlayer:(NSString*) playername;
-(void) FadeOut;
-(BOOL) FadeIn;
@end


@protocol FirstTimeInstructionsDelegate <NSObject>

@optional
- (void)PrepareNewGame;
@end
