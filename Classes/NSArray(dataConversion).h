//
//  NSArray(dataConversion).h
//  MQNorway
//
//  Created by knut dullum on 28/03/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(dataConversion)
- (NSData*) convertToData;
+ (NSArray*) arrayWithData:(NSData*) data;

@end
