//
//  Question.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#import "MpPlace.h"
#import "MpRegion.h"
#import "State.h"
#import "Lake.h"
#import "Fjord.h"
#import "Island.h"
#import "Peninsula.h"
#import "City.h"
#import "Mountain.h"
#import "Answer.h"


@interface Question : NSObject {

	NSMutableArray *m_questionArray;

	LocationType m_locationType;
	Difficulty m_difficulty;
	BOOL m_useAoc;
	NSString *m_name;
	bool m_watingForAnswer;
	Answer *m_answer;
	NSInteger m_used;

}
-(id) initWithLanguage:(Language) language andLocation:(MpLocation*) loc;
-(id) initWithLanguage:(Language) language andLocation:(MpLocation*) loc andQuestionString:(NSString*) questionString;
-(Answer*) GetAnswer;
-(NSString*) GetQuestionString;
-(BOOL) GetUseAoc;
-(Difficulty) GetDifficulty;
-(void) IncreaseUsed;
-(NSInteger) GetUsedCount;
-(NSString*) GetName;

@end
