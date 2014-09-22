//
//  CreateIDView.h
//  MQNorway
//
//  Created by knut dullum on 18/11/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import "SkyView.h"
#import "GlobalSettingsHelper.h"
#import "SqliteHelper.h"

@protocol CreateIDViewDelegate;
@interface CreateIDView : UIView <NSXMLParserDelegate,UITextFieldDelegate>{

    id <CreateIDViewDelegate> delegate;
	UILabel *headerLabel;
	SkyView *m_skyView;
	
	UIButton *buttonCreateID;
	UITextField *emailTextField;
	UITextField *globalIDTextField;
    UILabel *errorGlobalIDLabel;
    UILabel *errorEmailLabel;
	UIAlertView *alertNotUnique;
	NSMutableData *webData;
	NSMutableString *soapResults;
	NSXMLParser *xmlParser;
	
	BOOL recordUniqueID;
	BOOL recordProposal;
    BOOL recordEmail;
	BOOL noConnection;
    
    BOOL itsAProposal;
    BOOL uniqueEmail;
    BOOL readyToCreate;
	
	NSString *collectedID;
	
	UIActivityIndicatorView *m_activityIndicator;
}
@property (nonatomic, assign) id <CreateIDViewDelegate> delegate;
-(void) FadeOut;

@end

@protocol CreateIDViewDelegate <NSObject>

@optional
-(void) cleanUpCreateIDView;
@end
