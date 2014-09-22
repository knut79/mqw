//
//  Lake.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "Lake.h"


@implementation Lake

-(NSString*) GetBorderString:(Language) language
{
	NSString *returnString;
	switch (language) {
		case english:
			returnString = @"water border";
			break;
		case norwegian:
			returnString = @"vannkanten";
			break;
			returnString = @"water border";
		default:
			break;
	}
	return returnString;
}

@end
