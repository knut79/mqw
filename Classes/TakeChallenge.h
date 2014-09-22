//
//  TakeChallenge.h
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorTableViewCell.h"
@protocol TakeChallengeViewCtrlDelegate;
@interface TakeChallenge : UIViewController<UITableViewDelegate, UITableViewDataSource,NSXMLParserDelegate>
{
    id <TakeChallengeViewCtrlDelegate> delegate;
    NSMutableArray* datasourceArray;
    
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
    
    NSMutableString *pageStartToLoad;
    NSMutableString *pageMiddleToLoad;
    NSMutableString *pageEndToLoad;
    
    NSString* currentCollectedStatus;
    NSString* currentCollectedCreationTime;
    NSString* currentCollectedDifficulty;
    NSString* currentCollectedTargetQuestionsAnswered;
    NSString* currentCollectedTargetSumKmExceded;
    NSString* currentCollectedCreatorQuestionsAnswered;
    NSString* currentCollectedCreatorSumKmExceded;
}
- (void) ReloadHtml;
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) IBOutlet UITableView *challengesTableView;
@property (retain, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonPushed:(id)sender;
@property (nonatomic, assign) id <TakeChallengeViewCtrlDelegate> delegate;
@end

@protocol TakeChallengeViewCtrlDelegate <NSObject>

@optional
-(void) cleanUpTakeChallengeViewCtrl;
@end
