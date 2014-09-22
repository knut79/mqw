//
//  Island.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Island.h"


@implementation Island
-(NSString*) GetBorderString:(Language) language
{
	NSString *returnString;
	switch (language) {
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
