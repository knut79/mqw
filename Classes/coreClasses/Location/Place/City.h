//
//  City.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "MpPlace.h"
#import "EnumDefs.h"


@interface City : MpPlace 
{

	NSInteger m_population;
	PlaceSize m_size;
}

-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(KmTolerance) kmTolerance andArmsOfCoat:(NSString*) aoc andPopulation:(NSInteger) population andAdditionalQuestions:(NSMutableArray*) additionalQuestions
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty;

@end
