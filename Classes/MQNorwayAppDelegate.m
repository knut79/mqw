//
//  MQNorwayAppDelegate.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "MQNorwayAppDelegate.h"
#import "MQNorwayViewController.h"
#import "GameMenuViewController.h"
#import "LocationsHelper.h"
#import "GlobalSettingsHelper.h"
#import "InAppPurchaseManager.h"
#import "SqliteHelper.h"
#import "GlobalHelper.h"

@implementation MQNorwayAppDelegate

@synthesize window;
@synthesize viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    


	NSMutableArray *languageList = [[NSMutableArray alloc] init];
	[languageList addObject:@"english"];
	[languageList addObject:@"norwegian"];
	
	//initiate locations , questions and globalsettings
	[[GlobalSettingsHelper Instance] SetLanguage:english];
	[[GlobalSettingsHelper Instance] SetLanguageList:languageList];
	
	
    
    NSLog(@"Registering for push notifications...");    
    [[UIApplication sharedApplication] 
     registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeAlert | 
      UIRemoteNotificationTypeBadge | 
      UIRemoteNotificationTypeSound)];
    
    
    //getting push notification payload, if we got one while not running app
    NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    /*for (id key in userInfo) {
     NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
     } */
    
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if (apsInfo != nil) {
        if ([apsInfo objectForKey:@"badge"] != nil) {
            [[GlobalHelper Instance] setBadgeNumber:[[apsInfo objectForKey:@"badge"] intValue]];
        }
    }
    

    // Add the view controller's view to the window and display.
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];

    return YES;
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken { 
    //bitstring ??
    //NSString *deviceTokenString = [[NSString alloc] initWithData:deviceToken encoding:NSASCIIStringEncoding];
    
    NSString *deviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceTokenStr = [deviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    //NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceTokenTrimmed];
    
    [[GlobalHelper Instance]  setDeviceToken:deviceTokenStr];
    NSLog(@"Device Token=%@",deviceTokenStr);
    
    
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@", str);    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //jumps in here when recieving when app is running
    
    /*
     for (id key in userInfo) {
     NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
     }   */
    
    NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
    if (apsInfo != nil) {
        if ([apsInfo objectForKey:@"badge"] != nil) {
            [[GlobalHelper Instance] setBadgeNumber:[[apsInfo objectForKey:@"badge"] intValue]];
        }
    }
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
	//free all views ... save game
	//[viewController closeAllViews];

	/*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	//NSLog(@"applicationWillResignActive: called");
	
	//exit(0);
	//[[NSThread mainThread] exit];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
   
	[viewController SaveGameData];
	
	/*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	//NSLog(@"applicationDidEnterBackground: called");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	//set up the menu
	
	[viewController LoadGameAndResume];
	
	
	//NSLog(@"applicationWillEnterForeground: called");
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
//	NSArray *results = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM savestate;"];
//	if ([results count] > 0) {
//		//ask user if we should resume from last game
//		[viewController resumeGame];
//	}
//	[[SqliteHelper Instance]  executeNonQuery:@"DELETE FROM savestate;"];
//	[results release];
	
	//NSLog(@"applicationDidBecomeActive: called");
}


- (void)applicationWillTerminate:(UIApplication *)application {
	

	
	//save data , so we can resume when application is relaunshed
	//set flag in db to load saved data when restart
	
//	[[SqliteHelper Instance] executeNonQuery:@"INSERT INTO savestate VALUES (?, ?);", 
//	 @"bogus ID", @"true"];
	
	/*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
	//will give about 4 seconds before shutting down
	//NSLog(@"applicationWillTerminate: called");
	
//	[NSThread sleepForTimeInterval:5];
	
//	exit(0);
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	//NSLog(@"applicationDidReceiveMemoryWarning: called");
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
