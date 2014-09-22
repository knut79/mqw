//
//  PepTalk.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PepTalk : NSObject {
	NSMutableArray * m_pepTalkListOne;
	NSMutableArray * m_pepTalkListTwo;
	NSMutableArray * m_pepTalkListThree;
	NSMutableArray * m_pepTalkListFour;
	NSMutableArray * m_pepTalkListFive;
	NSMutableArray * m_pepTalkListSix;
}

+(PepTalk*) Instance ;
-(NSString *) GetPepTalk:(NSInteger) missedDistance;

@end
