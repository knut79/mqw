//
//  Mountain.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Mountain.h"


@implementation Mountain

-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(KmTolerance) kmTolerance andArmsOfCoat:(NSString*) aoc andPopulation:(NSInteger) population andAdditionalQuestions:(NSMutableArray*) additionalQuestions
 andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty
{
	self = [super initWithName:name andCounty: county andState:state andPoint:point
				andKmTolerance:kmTolerance andArmsOfCoat:aoc andAdditionalQuestions:additionalQuestions andAdditionalInfo:addInfo andQuestDifficulty:questDifficulty];
	
	m_population = population;
	m_size = psnothing;

	return self;
}
@end
