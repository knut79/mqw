//
//  UnDefWaterRegion.m
//  MQNorway
//
//  Created by knut on 24/10/14.
//  Copyright (c) 2014 lemmus. All rights reserved.
//

#import "UnDefWaterRegion.h"

@implementation UnDefWaterRegion

-(NSString*) GetBorderString
{
	NSString *returnString;
	switch ([[GlobalSettingsHelper Instance] GetLanguage]) {
		case english:
			returnString = @"border";
			break;
		case norwegian:
			returnString = @"gensa";
			break;
			returnString = @"border";
		default:
			break;
	}
	return returnString;
}
@end

