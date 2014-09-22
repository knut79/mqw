//
//  MQNorwayAppDelegate.h
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//
#import <Foundation/Foundation.h>

@class MQNorwayViewController;

@interface MQNorwayAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MQNorwayViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MQNorwayViewController *viewController;

@end

