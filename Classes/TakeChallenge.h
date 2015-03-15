//
//  TakeChallenge.h
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorTableViewCell.h"
#import "Game.h"
#import "ChallengeStatusView.h"

@protocol TakeChallengeViewCtrlDelegate;
@interface TakeChallenge : UIViewController<UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate,ChallengeStatusViewDelegate>
{
    id <TakeChallengeViewCtrlDelegate> delegate;
    NSMutableArray* datasourceStaticArray;
    NSMutableArray* datasourceDynamicArray;
    
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    int index;
    BOOL recordStatus;
    BOOL recordCreationTime;
    BOOL recordDifficulty;
    BOOL readTargetValues;    
    BOOL readCreatorValues;
    BOOL recordQuestionsAnswered;
    BOOL recordSumKmExceded;
    
    
    NSString* currentCollectedStatus;
    NSString* currentCollectedCreationTime;
    NSString* currentCollectedDifficulty;
    NSString* currentCollectedTargetQuestionsAnswered;
    NSString* currentCollectedTargetSumKmExceded;
    NSString* currentCollectedCreatorQuestionsAnswered;
    NSString* currentCollectedCreatorSumKmExceded;
    IBOutlet UIActivityIndicatorView *activityIndicatorStaticChallenges;
    IBOutlet UIActivityIndicatorView *activityIndicatorDynamicChallenge;
    
    UIAlertView *alertStaticChallenge;
    UIAlertView *alertDynamicChallenge;
    
    ChallengeStatusView* challengeStatusView;
    
    NSMutableDictionary* staticChallengeDataCache;
    NSMutableDictionary* dynamicChallengeDataCache;
    NSMutableArray *currentQuestonIds;
    BOOL currentBorderValue;
    BOOL currentCompletedValue;
    BOOL isStaticChallengeMode;
    Game *m_game;

}
-(void) FadeIn;

@property (retain, nonatomic) IBOutlet UIButton *retryButton;
- (IBAction)retryButtonPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UILabel *staticChallengesHeader;
@property (retain, nonatomic) IBOutlet UILabel *dynamicChallengesHeader;
@property (retain, nonatomic) IBOutlet UIButton *statusButton;
- (IBAction)statusButtonPushed:(id)sender;
@property (nonatomic,retain) Game* m_game;

@property (retain, nonatomic) IBOutlet UITableView *staticChallengesTableView;
@property (retain, nonatomic) IBOutlet UITableView *dynamicChallengesTableView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonPushed:(id)sender;
@property (nonatomic, assign) id <TakeChallengeViewCtrlDelegate> delegate;
@end

@protocol TakeChallengeViewCtrlDelegate <NSObject>

@optional
- (void)cleanUpStartGameMenuAndStart:(Game *)gameRef;
-(void) cleanUpTakeChallengeViewCtrl;
@end
