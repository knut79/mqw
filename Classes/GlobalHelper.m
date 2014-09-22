//
//  GlobalHelper.m
//  MQNorway
//
//  Created by knut on 5/20/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "GlobalHelper.h"
@implementation GlobalHelper

+(GlobalHelper*) Instance 
{
	static GlobalHelper *Instance;
	
	@synchronized(self) {
		if(!Instance)
		{
			Instance = [[GlobalHelper alloc] init];
		}
	}
	return Instance;
}

-(void) setStartFlag:(int) start
{
    startFlag = start;
}

-(int) getStartFlag
{
    return startFlag;
}


/*
 NSArray *existsResult = [[SqliteHelper Instance] executeQuery:@"SELECT playerID FROM globalID;"];
 if([existsResult count] == 0)
 {
 //start CreateIDView
 m_createIDView = [[CreateIDView alloc] initWithFrame:[self bounds]];
 [self addSubview:m_createIDView];
 }
 else
 {
 for (NSDictionary *dictionary in existsResult) {
 for (NSString *key in [dictionary keyEnumerator])
 [[GlobalSettingsHelper Instance] SetPlayerID:[NSString stringWithFormat:@"%@",[dictionary objectForKey:@"playerID"]]];
 } 
 }
 */
-(NSString*) ReadPlayerID
{
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
    {
        NSString *boundle = [[NSBundle mainBundle] pathForResource:@"LocalData" ofType:@"plist"];
        [fileManager removeItemAtPath:pathPlist error:&error];
        [fileManager copyItemAtPath:boundle toPath:pathPlist error:&error];
    }
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    //load from savedStock example int value
    
    NSString* value = [tempDictionary objectForKey:@"playerID"];
    
    
    NSLog(@"value is %@",value);
    
    
    
    return value;
    
}

-(int) getBadgeNumber
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
    {
        NSString *boundle = [[NSBundle mainBundle] pathForResource:@"LocalData" ofType:@"plist"];
        [fileManager removeItemAtPath:pathPlist error:&error];
        [fileManager copyItemAtPath:boundle toPath:pathPlist error:&error];
    }
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    //load from savedStock example int value
    
    NSString* value = [tempDictionary objectForKey:@"badgeNumber"];
    if (value == nil) 
        return 0;
    if ([value isEqualToString:@""]) 
        return 0;
    
    return [value intValue];
}

-(void) setBadgeNumber:(int) par
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
        NSLog(@"Failed writing to file LocalData.plist, file does not exist");
    
    //write data
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    [data setObject:[NSString stringWithFormat:@"%d",par] forKey:@"badgeNumber"];
    
    [data writeToFile: pathPlist atomically:YES];
}


-(BOOL) readFlagForAddFree
{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
    {
        NSString *boundle = [[NSBundle mainBundle] pathForResource:@"LocalData" ofType:@"plist"];
        [fileManager removeItemAtPath:pathPlist error:&error];
        [fileManager copyItemAtPath:boundle toPath:pathPlist error:&error];
    }
    
    NSMutableDictionary *tempDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    //load from savedStock example int value
    
    NSString* value = [tempDictionary objectForKey:@"flagAddFree"];
    if ([value isEqualToString:@"1"])
        return TRUE;
    else
        return FALSE;
}

-(void) setDeviceToken:(NSString*) token
{
    deviceToken = token;
}

-(NSString*) getDeviceToken
{
    return deviceToken;
}



-(int) getFacebookPostingPoint
{
    return 5;
}

-(int) getPostingQuestionPoint
{
    return 1;
}

-(int) getSecondsBetweenFBPostPoint
{
    //12 hours
    //return 60 * 60 * 1;
    return 14;
}


@end










