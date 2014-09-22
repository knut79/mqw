//
//  City.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "City.h"



@implementation City 

-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(KmTolerance) kmTolerance andArmsOfCoat:(NSString*) aoc andPopulation:(NSInteger) population andAdditionalQuestions:(NSMutableArray*) additionalQuestions
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty
{
	self = [super initWithName:name andCounty: county andState:state andPoint:point
				andKmTolerance:kmTolerance andArmsOfCoat:aoc andAdditionalQuestions:additionalQuestions andAdditionalInfo:addInfo andQuestDifficulty:questDifficulty];
	
	m_population = population;
	if (m_population < 100)
	{
		m_size = psnothing;
	}
	else if (m_population < 50000)
	{
		m_size = pstiny;
	}
	else if (m_population < 200000)
	{
		m_size = pssmall;
	}
	else if (m_population < 400000)
	{
		m_size = psmedium;
	}
	else if (m_population < 800000)
	{
		m_size = psbig;
	}
	else
	{
		m_size = pshuge;
	}
	
	return self;
}
@end
