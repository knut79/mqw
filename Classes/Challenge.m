//
//  Challenge.m
//  MQNorway
//
//  Created by knut dullum on 13/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "Challenge.h"

@implementation Challenge

@synthesize difficulty;
@synthesize creator;
//@synthesize target;
@synthesize kmToUse;
@synthesize questions;


-(id) init
{
    if ((self = [super init])) 
    {
        
    }
    questions = [[NSMutableArray alloc] init];
    return self;
}

-(void) addQuestion:(ChallengeQuestionItem*) item
{
    [questions addObject:item];
}

-(NSString*) getQuestionIDs
{
    NSMutableString* stringOfIds = [[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i<[questions count]; i++) {
        [stringOfIds appendFormat:[NSString stringWithFormat:@"%@;",((ChallengeQuestionItem*)[questions objectAtIndex:i]).qid]];
    }
    return stringOfIds;
}

@end
