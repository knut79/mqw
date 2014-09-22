//
//  GameEndHelper.h
//  MQNorway
//
//  Created by knut dullum on 09/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GlobalHelper.h"

/*@protocol SetScoreDelegate;
@interface SetScoreBridge : NSObject<NSXMLParserDelegate>*/
@protocol SoapHelperDelegate;
@interface SoapHelper : NSObject<NSXMLParserDelegate>

{
    id <SoapHelperDelegate> delegate;

    NSMutableData *webData;
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
	BOOL recordPosition;
	BOOL recordUserMessage;
    
    
    NSString* m_position;
    NSString* m_userMessage;

}
@property (nonatomic, assign) id <SoapHelperDelegate> delegate;
-(void) setScore ;
-(NSString*) getUserMessage;
-(void) sendDeviceToken;
@end


@protocol SoapHelperDelegate <NSObject>

@optional
-(void) gotScoreResult;
-(void) noScoreResultConnection;
@end