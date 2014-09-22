//
//  EnterBackgroundMenuView.h
//  MQNorway
//
//  Created by knut dullum on 18/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"

@interface EnterBackgroundMenuView : UIView {
	SkyView *m_skyView;
	UIButton *buttonResume;
}
-(void) FadeOut;
-(void) FadeIn;

@end
