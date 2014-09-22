//
//  Mountain.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Mountain.h"


@implementation Mountain

-(id) initWithName:(NSString*) name andID:(NSString *)loactionID andCounty:(NSString*) county andState:(NSString*) state andPoint:(CGPoint) point
	andKmTolerance:(NSInteger) kmTolerance andPopulation:(NSInteger) population
 andAdditionalInfo:(NSString*) addInfo
{
	self = [super initWithName:name andID:loactionID andCounty: county andState:state andPoint:point
				andKmTolerance:kmTolerance andAdditionalInfo:addInfo];
	
	m_population = population;
	m_size = psnothing;

	return self;
}
@end
