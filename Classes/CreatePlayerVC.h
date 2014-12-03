//
//  CreatePlayerVC.h
//  MQNorway
//
//  Created by knut on 5/19/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import <FacebookSDK/FacebookSDK.h>
@protocol CreatePlayerVCDelegate;
@interface CreatePlayerVC : UIViewController<NSXMLParserDelegate,UITextFieldDelegate,UIAlertViewDelegate,FBLoginViewDelegate>
{
    id <CreatePlayerVCDelegate> delegate;
    BOOL isFirstLoginDone;
}
@property (strong, nonatomic) IBOutlet FBLoginView *loginView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *statusLabel;
@property (retain, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;


-(void) WritePlayerID:(NSString*) playerID andName:(NSString*) firstname;
-(void) WritePlayerToServer:(NSString*) playerID andName:(NSString*) firstname;
-(void) WritePlayerLocally:(NSString*) playerID andName:(NSString*) firstname;

@property (nonatomic, assign) id <CreatePlayerVCDelegate> delegate;
@end

@protocol CreatePlayerVCDelegate <NSObject>
@optional
-(void) cleanUpCreatePlayerVC;
@end