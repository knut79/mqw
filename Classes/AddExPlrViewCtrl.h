//
//  AddExPlrViewCtrl.h
//  MQNorway
//
//  Created by knut dullum on 21/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorTableViewCell.h"
@protocol AddExPlrViewCtrlDelegate;
@interface AddExPlrViewCtrl : UIViewController<UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate,UITextFieldDelegate>
{
    id <AddExPlrViewCtrlDelegate> delegate;
    IBOutlet UITableView *playersTableView;
    NSMutableArray* datasourceArray;
    
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    int index;
    BOOL recordPlayerStartingWith;
    BOOL recordFriends;
}
@property (nonatomic, assign) id <AddExPlrViewCtrlDelegate> delegate;
@property (retain, nonatomic) IBOutlet UITextField *textFieldUser;
@property (retain, nonatomic) IBOutlet UIButton *btnSearchUser;
@property (retain, nonatomic) IBOutlet UIButton *btnShowFriends;
@property (retain, nonatomic) IBOutlet UIButton *btnBack;
- (IBAction)btnBackPushed:(id)sender;
- (IBAction)btnShowFriendsPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *playersTableView;
- (IBAction)btnSearchPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

-(void) GetPlayersStartingWith;
-(void) GetFriends;

@end

@protocol AddExPlrViewCtrlDelegate <NSObject>

@optional
-(void) cleanUpAddExPlrViewCtrl;
-(void) returnSelectedUserAndCleanUp:(NSString*) user;
@end
