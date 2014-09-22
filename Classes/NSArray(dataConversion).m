//
//  NSArray(dataConversion).m
//  MQNorway
//
//  Created by knut dullum on 28/03/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "NSArray(dataConversion).h"


@implementation NSArray(dataConversion)

/** Convert to NSData, NOT encoding the including objects (only pointers) */
- (NSData*) convertToData {
	unsigned n= [self count];
	NSMutableData* data = [NSMutableData dataWithLength: sizeof(unsigned)+
						   sizeof(id) *n];
	unsigned* p = [data mutableBytes];
	*p++= n;
	[self getObjects:(void*)p];
	return data;
}

/** Reciprocal of convertToData */
+ (NSArray*) arrayWithData:(NSData*) data {
	unsigned* p = (unsigned*)[data bytes];
	unsigned n = *p++;
	return [NSArray arrayWithObjects:(id*)p count:n];
}

@end
