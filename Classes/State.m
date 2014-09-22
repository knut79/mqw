//
//  State.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "State.h"


@implementation State


//dont need a init method , this will be done by super class maby


-(NSString*) GetBorderString
{
	NSString *returnString;
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			returnString = @"state border";
			break;
		case norwegian:
			returnString = @"fylkesgrensa";
			break;
			returnString = @"state border";
		default:
			break;
	}
	return returnString;
}

@end
