//
//  Challenge.h
//  MQNorway
//
//  Created by knut dullum on 13/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#import "ChallengeQuestionItem.h"

@interface Challenge : NSObject
{
    NSMutableArray *questions;
    
    Difficulty difficulty;
    NSString* creator;
    //NSString* target;
    int kmToUse;
}
-(void) addQuestion:(ChallengeQuestionItem*) item;
-(NSString*) getQuestionIDs;
@property (nonatomic, assign) Difficulty difficulty;
@property (nonatomic, assign) NSString* creator;
//@property (nonatomic, assign) NSString* target;
@property (nonatomic, assign) int kmToUse;

@property (nonatomic, assign) NSArray* questions;
@end
