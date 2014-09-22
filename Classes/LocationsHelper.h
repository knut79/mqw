//
//  Locations.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
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
#import "County.h"
#import "Question.h"
#import "GlobalSettingsHelper.h"

@interface LocationsHelper : NSObject {

//	NSMutableArray *m_locationsList;
	NSMutableDictionary *m_questionsByCategory;
	NSMutableDictionary *m_trainingQuestionsByCategory;
	NSMutableArray *m_questionsList;
}
+(LocationsHelper*) Instance;
-(void) ReadLocationsFromFileToDatabase:(NSString*) fileName;
-(void) ReadQuestionsFromFileToDatabase:(NSString*) fileName;
-(void) InitQuestions;
-(NSString *) ReadLineAsNSString:(FILE *) file;
-(NSMutableArray*) CollectQuestionsOnCategory:(Difficulty) category;
-(void) ShuffleQuestions;
-(void) OrderQuestionsForTraining:(Difficulty) category;
-(NSMutableArray *)ShuffleArray:(NSMutableArray*) arrayToShuffle;
-(NSMutableArray *) GetQuestionsOnDifficulty:(Difficulty) difficulty trainingMode:(BOOL) training;
-(NSArray*) StringOfCoordinatesToArray:(NSString*) stringOfCoordinates;
-(NSString*) CoordinateArrayToString:(NSArray*) coordinateArray;
-(void) CategorizeQuestions;
-(void) CategorizeQuestionsForTraining;
-(void) ReInitQuestions;
-(NSMutableArray*) CollectQuestionsOnCategoryForTraining:(Difficulty) category;


@end
