//
//  AnimateTextView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimateTextViewDelegate;

@interface AnimateTextView : UIView {
	id <AnimateTextViewDelegate> delegate;
	NSString *m_textForAnimation;
	UILabel *m_messageLabel;
	UIImageView *m_tapMessageImageView;
	NSInteger m_timerNumerator;
	NSTimer * m_animationTimer;
	
	NSInteger m_animateTapTimerNumerator;
	NSTimer * m_animateTapMessageTimer;
	
	int m_imageWidth;
	int m_imageHeight;
	float m_tapImageAlpha;
	
	float m_fontSize;
	float m_textAlpha;
	NSInteger m_textY;
	NSInteger m_textX;
	
	BOOL m_animatingText;
	BOOL m_animatingTapImage;
	int m_animateTapImageSwitch;
	
	NSString *m_imageName;
	int m_imageX;
	int m_imageY;
	
	int m_limitTapMessages;
	BOOL m_animateTapMessageTimerInvalidated;
}

@property (nonatomic, assign) id <AnimateTextViewDelegate> delegate;
-(void) setText:(NSString*) text;
-(void) startTextAnimation;
-(void) startTapMessage;
-(void) fadeOut;
-(void) startTapMessageAnimation;
@end


@protocol AnimateTextViewDelegate <NSObject>

@optional
- (void)finishedShowingResultMap;
@end