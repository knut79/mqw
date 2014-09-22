//
//  ChallengeViewController.h
//  MQNorway
//
//  Created by knut dullum on 21/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//
#import "AddExPlrViewCtrl.h"
#import "GlobalSettingsHelper.h"
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "Challenge.h"
@protocol ChallengeViewControllerDelegate;
@interface ChallengeViewController : UIViewController<UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,AddExPlrViewCtrlDelegate>
{
    id <ChallengeViewControllerDelegate> delegate;
    NSMutableString *pageStartToLoad;
    NSMutableString *pageEndToLoad;
    NSMutableString *pageAddressesToLoad;
    AddExPlrViewCtrl* addExistingPlayerViewController;
    NSMutableArray* assureNoDuplicatesEmails;
    NSMutableArray* assureNoDuplicatesPlayerIDs;
    Challenge* challenge;
}
@property (nonatomic, assign) id <ChallengeViewControllerDelegate> delegate;
-(void) setChallenge:(Challenge*) pChallenge;
@property (retain, nonatomic) IBOutlet UIButton *buttonAddContact;
- (IBAction)addContactPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *buttonAddUser;
@property (retain, nonatomic) IBOutlet UIButton *buttonAddEmail;
@property (retain, nonatomic) IBOutlet UIButton *buttonGoBack;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendChallenge;
//@property (retain, nonatomic) IBOutlet UITextField *textFieldUser;
- (IBAction)buttonGoBackPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *textFieldEmail;
- (IBAction)addUserPushed:(id)sender;
- (IBAction)addEmailPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
- (void) ReloadHtml;

-(BOOL)validateEmail: (NSString *) candidate ;
-(BOOL)emailExists:(NSString*) email;
-(BOOL)userExists:(NSString*) user;

@end

@protocol ChallengeViewControllerDelegate <NSObject>

@optional
-(void) cleanUpChallengView;
@end
