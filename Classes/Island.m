//
//  Island.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Island.h"


@implementation Island
-(NSString*) GetBorderString
{
	NSString *returnString;
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			returnString = @"land";
			break;
		case norwegian:
			returnString = @"land";
			break;
			returnString = @"land";
		default:
			break;
	}
	return returnString;
}
@end
