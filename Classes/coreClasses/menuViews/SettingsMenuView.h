//
//  SettingsMenuView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "StoreView.h"

@protocol SettingsMenuViewDelegate;

@interface SettingsMenuView : UIView {
	id <SettingsMenuViewDelegate> delegate;
	UIButton *buttonLanguage;
	UIButton *buttonDistance;
	UIButton *buttonBack;
	UIButton *buttonStore;
	CGPoint buttonLanguageCenter;
	CGPoint buttonDistanceCenter;
	CGPoint buttonBackCenter;
	UILabel *headerLabel;
	CGPoint headerLabelCenter;
	SkyView *m_skyView;
	StoreView *storeView;
	
}
@property (nonatomic, assign) id <SettingsMenuViewDelegate> delegate;

-(CGImageRef) CreateStrechedCGImageFromCGImage:(CGImageRef) image  andWidth:(NSInteger) width andHeight:(NSInteger) height ;
-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;

@end

@protocol SettingsMenuViewDelegate <NSObject>

@optional
- (void)SettingsMenuViewHiding;
@end
