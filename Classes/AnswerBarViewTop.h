//
//  AnswerBarViewTop.h
//  MQNorway
//
//  Created by knut dullum on 03/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"
#import "Game.h"

@interface AnswerBarViewTop : UIView {
	
	UIImageView *m_imageView;
	UIImageView *m_lineImageView;
	UILabel *m_label;
	UILabel *m_resultLabel;
	UILabel *m_tapToEnlarge;
	CGRect m_initialRect;
}

-(void) SetResult:(Game*) gameRef;
-(void) FadeIn;
-(void) FadeOut;

@end



