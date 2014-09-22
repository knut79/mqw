//
//  Answer.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Answer.h"
#import "Game.h"

@implementation Answer

-(id) initWithLanguage:(Language)language andLocation:(MpLocation*) location
{
	if (self = [super init]) 
	{
		m_name = [[location GetName] retain];
		m_location = location;

		NSString* secondPart = [m_location GetBorderString:language];

		
		LocationType tempLocationType = [m_location GetLocationType];
		switch (tempLocationType) 
		{
			case placeType:
				switch (language) {
					case norwegian:
						m_answerString = [[NSString alloc]initWithFormat:@"unna %@", secondPart];
						break;
					case english:
						m_answerString = [[NSString alloc]initWithFormat:@"from %@", secondPart];
						break;
					default:
						m_answerString = [[NSString alloc]initWithFormat:@"from %@", secondPart];
						break;
				}
				break;
			case regionType:
				switch (language) {
					case norwegian:
						m_answerString = [[NSString alloc]initWithFormat:@"fra %@", secondPart];
						break;
					case english:
						m_answerString = [[NSString alloc]initWithFormat:@"from %@", secondPart];
						break;
					default:
						m_answerString = [[NSString alloc]initWithFormat:@"from %@", secondPart];
						break;
				}
				break;

			default:
				break;
		}
		
		m_additionalInfo = [location GetAdditionalInfo];
	}
	return self;
}

-(NSString*) GetAnswerString
{
	return m_answerString;
}

-(MpLocation*) GetLocation
{
	return m_location;
}

-(NSString*) GetAdditionalInfo
{
	return m_additionalInfo;
}

@end
