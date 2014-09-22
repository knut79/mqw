//
//  Answer.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Answer : NSObject {
	NSArray *m_answerStringArray;
}
-(id) initWithStringArray:(NSArray*) array; 
-(NSString*) GetAnswerString;
@end
