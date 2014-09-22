//
//  UnDefPlace.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "UnDefPlace.h"


@implementation UnDefPlace

-(id) initWithName:(NSString*) name andID:(NSString *)loactionID andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(NSInteger) kmTolerance andPopulation:(NSInteger) population
 andAdditionalInfo:(NSString*) addInfo
{
	self = [super initWithName:name andID:loactionID andCounty: county andState:state andPoint:point
				andKmTolerance:kmTolerance andAdditionalInfo:addInfo];
	
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