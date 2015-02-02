//
//  ChallengeStatusView.h
//  MQNorway
//
//  Created by knut on 02/02/15.
//  Copyright (c) 2015 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChallengeStatusViewDelegate;
@interface ChallengeStatusView : UIView
{
    id <ChallengeStatusViewDelegate> delegate;
    UIButton *buttonBack;
    UIWebView *webViewRecentChallenges;
    UIWebView *webViewUserVsUser;
    
    NSMutableString *pageStartToLoadRecentChallenges;
    NSMutableString *pageMiddleToLoadRecentChallenges;
    NSMutableString *pageEndToLoadRecentChallenges;
    
    NSMutableString *pageStartToLoadUserVsUser;
    NSMutableString *pageMiddleToLoadUserVsUser;
    NSMutableString *pageEndToLoadUserVsUser;
    
    UIActivityIndicatorView *activityIndicatorRecentChallenges;
    UIActivityIndicatorView *activityIndicatorUserVsUser;
    
    int getChallengesResultsRetry;
    int getUserVsUserResultsRetry;
    
    UILabel* headerRecentChallengeResult;
    UILabel* headerUserVsUserResult;
}
@property (nonatomic, assign) id <ChallengeStatusViewDelegate> delegate;
-(void) FadeIn;

@end

@protocol ChallengeStatusViewDelegate <NSObject>
@optional
-(void) cleanUpChallengeStatusView;
@end
