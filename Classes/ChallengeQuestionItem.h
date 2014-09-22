//
//  ChallengeQuestionItem.h
//  MQNorway
//
//  Created by knut dullum on 13/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChallengeQuestionItem : NSObject
{
    NSString* qid;
    int kmLeft;
    int kmTimeBonus;
    int answered;
}
@property (nonatomic, assign) NSString* qid;
@property (nonatomic, assign) int kmLeft;
@property (nonatomic, assign) int kmTimeBonus;
@property (nonatomic, assign) int answered;
@end
