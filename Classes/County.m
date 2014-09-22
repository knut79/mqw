//
//  County.m
//  MQNorway
//
//  Created by knut dullum on 29/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "County.h"

@implementation County


//dont need a init method , this will be done by super class maby


-(NSString*) GetBorderString
{
	NSString *returnString;
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			returnString = @"county border";
			break;
		case norwegian:
			returnString = @"fylkesgrensa";
			break;
			returnString = @"county border";
		default:
			break;
	}
	return returnString;
}

@end