//
//  GlobalHelper.h
//  MQNorway
//
//  Created by knut on 5/20/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalHelper : NSObject
{
    NSString* deviceToken;
    int startFlag;
}
+(GlobalHelper*) Instance;

-(void) setStartFlag:(int) start;
-(int) getStartFlag;

-(NSString*) ReadPlayerID;
-(BOOL) readFlagForAddFree;

-(int) getBadgeNumber;
-(void) setBadgeNumber:(int) par;
-(void) setDeviceToken:(NSString*) token;
-(NSString*) getDeviceToken;
-(int) getPostingQuestionPoint;
-(int) getFacebookPostingPoint;
-(int) getSecondsBetweenFBPostPoint;

@end