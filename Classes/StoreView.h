//
//  StoreView.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"

@interface StoreView : UIView {
	SkyView *m_skyView;
	UIButton *buttonBack;
}
-(void) FadeOut;
-(void) FadeIn;

@end
