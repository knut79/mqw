//
//  SettingsMenuView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "StoreView.h"
#import "TestView.h"

@protocol SettingsMenuViewDelegate;

@interface SettingsMenuView : UIView <TestViewDelegate> {
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
	
	UIButton *buttonTest;
	TestView *testView;
	
}
@property (nonatomic, assign) id <SettingsMenuViewDelegate> delegate;

-(CGImageRef) CreateStrechedCGImageFromCGImage:(CGImageRef) image  andWidth:(NSInteger) width andHeight:(NSInteger) height ;
-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;

@end

@protocol SettingsMenuViewDelegate <NSObject>

@optional
- (void) cleanUpSettingsMenuView;
@end
