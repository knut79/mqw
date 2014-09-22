//
//  SKProduct(LocalizedPrice).h
//  MQNorway
//
//  Created by knut dullum on 14/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface SKProduct (LocalizedPrice)

@property (nonatomic, readonly) NSString *localizedPrice;

@end
