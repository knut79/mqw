//
//  PlayerStats.h
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PlayerStatsViewCtrlDelegate;
@interface PlayerStats : UIViewController<NSXMLParserDelegate>
{
    id <PlayerStatsViewCtrlDelegate> delegate;
    NSMutableString *pageStartToLoad;
    NSMutableString *pageEndToLoad;
    
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    int index;
    BOOL recordName;
    BOOL recordWins;
    BOOL recordLosses;
    NSMutableArray* arrayNames;
    NSMutableArray* arrayWins;
    NSMutableArray* arrayLosses;

}
@property (nonatomic, assign) id <PlayerStatsViewCtrlDelegate> delegate;
@property (retain, nonatomic) IBOutlet UILabel *labelHeader;
@property (retain, nonatomic) IBOutlet UIButton *buttonBack;
- (IBAction)buttonBackPushed:(id)sender;
@property (retain, nonatomic) IBOutlet UIWebView *webViewStats;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void) ReloadHtml;
-(void) GetFriends;
@end

@protocol PlayerStatsViewCtrlDelegate <NSObject>

@optional
-(void) cleanUpPlayerStatsViewCtrl;
@end
