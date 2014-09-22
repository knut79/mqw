//
//  Locations.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"
#import "City.h"
#import "State.h"
#import "Lake.h"
#import "Fjord.h"
#import "Island.h"
#import "Peninsula.h"
#import "Mountain.h"
#import "UnDefPlace.h"
#import "UnDefRegion.h"
#import "Question.h"
#import "GlobalSettingsHelper.h"

@interface LocationsHelper : NSObject {

	NSMutableArray *m_locationsList;
	NSMutableDictionary *m_questionsByCategory;
	NSMutableArray *m_questionsRaw;
}
+(LocationsHelper*) Instance;
-(void) InitLocations:(NSString*) fileName;
-(void) InitQuestions;
-(NSString *) ReadLineAsNSString:(FILE *) file;
-(NSMutableArray*) CollectQuestionsOnCategory:(Difficulty) category;
-(void) ShuffleQuestions;
-(NSArray *)ShuffleArray:(NSMutableArray*) arrayToShuffle;
-(NSMutableArray *) GetQuestionsOnDifficulty:(Difficulty) difficulty;

@end
