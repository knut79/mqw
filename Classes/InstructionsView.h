//
//  InstructionsView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"


@protocol InstructionsViewDelegate;
@interface InstructionsView : UIView{
    id <InstructionsViewDelegate> delegate;
	SkyView *m_skyView;
	UILabel *headerLabel;
	UIButton *buttonBack;
	NSString *m_engTextFromFile;
	NSString *m_norTextFromFile;
	UIWebView *m_webView;
}
@property (nonatomic, assign) id <InstructionsViewDelegate> delegate;
-(void) ReloadHtml;
-(void) UpdateText;
-(void) FadeIn;
-(void) FadeOut;

@end

@protocol InstructionsViewDelegate <NSObject>

@optional
-(void) cleanUpInstructionsView;
@end
