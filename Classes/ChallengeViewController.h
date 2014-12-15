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
#import <FacebookSDK/FacebookSDK.h>
#import "UserService.h"


@protocol ChallengeViewControllerDelegate;
@interface ChallengeViewController : UIViewController<UITextFieldDelegate,AddExPlrViewCtrlDelegate,FBFriendPickerDelegate>
{
    id <ChallengeViewControllerDelegate> delegate;
    NSMutableString *pageStartToLoad;
    NSMutableString *pageEndToLoad;
    NSMutableString *pageAddressesToLoad;
    AddExPlrViewCtrl* addExistingPlayerViewController;
    NSMutableArray* assureNoDuplicatesEmails;
    NSMutableArray* assureNoDuplicatesPlayerIDs;
    Challenge* challenge;
    NSMutableArray* playersToChallenge;
}
@property (retain, nonatomic) FBFriendPickerViewController *friendPickerController;
@property (nonatomic, assign) id <ChallengeViewControllerDelegate> delegate;
-(void) setChallenge:(Challenge*) pChallenge;
@property (retain, nonatomic) IBOutlet UIButton *buttonAddContact;
- (IBAction)addFriendPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *buttonAddRandomUser;
@property (retain, nonatomic) IBOutlet UIButton *buttonGoBack;
@property (retain, nonatomic) IBOutlet UIButton *buttonSendChallenge;
@property (retain, nonatomic) IBOutlet UIButton *buttonRemovePlayer;
- (IBAction)removePlayerPushed:(id)sender;

- (IBAction)buttonGoBackPushed:(id)sender;
- (IBAction)addRandomPlayerPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
- (void) ReloadHtml;

@end

@protocol ChallengeViewControllerDelegate <NSObject>

@optional
-(void) cleanUpChallengView;
@end
