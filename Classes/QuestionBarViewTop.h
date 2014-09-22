//
//  QuestionView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "Game.h"
#import "RoundedRectView.h"

@protocol QuestionBarViewTopDelegate;

@interface QuestionBarViewTop : UIView {

	id <QuestionBarViewTopDelegate> delegate;
	UIImageView *m_imageView;
	UILabel *m_label;
	UILabel *m_tapToEnlarge;
	BOOL m_touchEnabled;
	UIImageView *m_lineImageView;
	UIImage *m_image;
	
}
@property (nonatomic, assign) id <QuestionBarViewTopDelegate> delegate;
-(void) SetQuestion:(NSString *) currentPlayerName gameRef:(Game*) gameRef;
-(void) FadeIn;
-(void) FadeOut;
@end

@protocol QuestionBarViewTopDelegate <NSObject>

@optional
- (void)HideGameIcons;
-(void)ShowGameIcons;
@end
