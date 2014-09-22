//
//  InAppPurchaseManager.h
//  MQNorway
//
//  Created by knut dullum on 14/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <StoreKit/StoreKit.h>
#import "SKProduct(LocalizedPrice).h"

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

@interface InAppPurchaseManager : NSObject <SKProductsRequestDelegate>
{
    SKProduct *proUpgradeProduct;
    SKProductsRequest *productsRequest;
}
+ (id)sharedManager;
- (void)requestProUpgradeProductData;
@end