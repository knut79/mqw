//
//  TestView.h
//  MQNorway
//
//  Created by knut dullum on 19/08/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SkyView.h"
#import <QuartzCore/QuartzCore.h>
#import "GlobalSettingsHelper.h"
#import "ClockView.h"
#import "SoapHelper.h"
#import "ChallengeViewController.h"
#import "AddExPlrViewCtrl.h"

@protocol TestViewDelegate;

@interface TestView : UIView <NSXMLParserDelegate,UIWebViewDelegate,ClockDelegate,SoapHelperDelegate,AddExPlrViewCtrlDelegate> {
	id <TestViewDelegate> delegate;
	SkyView *m_skyView;
	UILabel *headerLabel;
	UIWebView *m_webView;
	UIButton *buttonBack;
	UIButton *buttonTest;
	
	ClockView *clockView;
	UILabel *pointLabel;
	
	
	IBOutlet UITextField *nameInput;
	IBOutlet UILabel *greeting;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	BOOL *recordResults;
    
    ChallengeViewController* challengeViewController;
    AddExPlrViewCtrl* addExistingPlayerViewController;
}

- (void) ReloadHtml;
-(void) FadeIn;

@property (nonatomic, assign) id <TestViewDelegate> delegate;
@property(nonatomic, retain) IBOutlet UITextField *nameInput;
@property(nonatomic, retain) IBOutlet UILabel *greeting;
@property(nonatomic, retain) NSMutableData *webData;
@property(nonatomic, retain) NSMutableString *soapResults;
@property(nonatomic, retain) NSXMLParser *xmlParser;

@end

@protocol TestViewDelegate <NSObject>

@optional
- (void)CloseTestView;
@end
