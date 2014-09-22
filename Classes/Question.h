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
	NSMutableArray *m_hintArray;
	
	LocationType m_locationType;
	Difficulty m_difficulty;
	BOOL m_usePicture;
	UIImage *m_picture;
	bool m_watingForAnswer;
	Answer *m_answer;
	NSInteger m_used;
	MpLocation *m_location;
	NSString* m_id;
	BOOL m_isStandard;

}

-(id) initWithLocation:(MpLocation*) loc andID:(NSString*) qID andQuestionString:(NSString*) questionString andPicture:(NSString*) picture andAnswer:(Answer*) answer andDifficulty:(NSString*) diff andHint:(NSString*) hint;
-(Answer*) GetAnswer;
-(NSString*) GetQuestionString;
-(BOOL) UsingPicture;
-(Difficulty) GetDifficulty;
-(void) IncreaseUsed;
-(NSInteger) GetUsedCount;
-(NSString*) GetName;
-(MpLocation*) GetLocation;
-(NSString*) GetID;
-(BOOL) IsStandardQuestion;
-(UIImage*) GetPicture;
-(NSString*) GetHintString;

@end
