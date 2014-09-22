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

-(id) initWithStringArray:(NSArray*) array 
{
	if (self = [super init]) 
	{
		m_answerStringArray = [array retain];
	}
	return self;
}

-(NSString*) GetAnswerString
{
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			return [m_answerStringArray objectAtIndex:0];
			break;
		case norwegian:
			return [m_answerStringArray objectAtIndex:1];
			break;
		case spanish:
			return [m_answerStringArray objectAtIndex:2];
			break;
		case french:
			return [m_answerStringArray objectAtIndex:3];
			break;
		case german:
			return [m_answerStringArray objectAtIndex:4];
			break;
		default:
			return @"nothing for question";
			break;
	}
}

@end
