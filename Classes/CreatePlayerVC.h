//
//  CreatePlayerVC.h
//  MQNorway
//
//  Created by knut on 5/19/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalHelper.h"
#import <QuartzCore/QuartzCore.h>
@protocol CreatePlayerVCDelegate;
@interface CreatePlayerVC : UIViewController<NSXMLParserDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    
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
    
    BOOL alreadyViewUp;

    
    NSString *collectedID;
    id <CreatePlayerVCDelegate> delegate;
}
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *errorPlayerIDLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *playerIDTextfield;
@property (strong, nonatomic) IBOutlet UITextField *emailTextfield;
@property (strong, nonatomic) IBOutlet UIButton *createPlayerButton;
@property (strong, nonatomic) IBOutlet UIView *emailMessageViewLabel;
- (IBAction)createPlayerIDButtonPushed:(id)sender;
- (BOOL) validateEmail: (NSString *) candidate;
- (BOOL) validateName: (NSString *) candidate;
-(void) WritePlayerID:(NSString*) playerID;
-(void) startLocationManager;
-(void) tryCreatePlayer;
-(void) askForLocation;
- (void) emailEnterViewUp;
- (void) emailEndViewDown;
@property (nonatomic, assign) id <CreatePlayerVCDelegate> delegate;
@end

@protocol CreatePlayerVCDelegate <NSObject>
@optional
-(void) cleanUpCreatePlayerVC;
@end