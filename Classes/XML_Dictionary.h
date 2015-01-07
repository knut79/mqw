//
//  XML_Dictionary.h
//  MapFight1
//
//  Created by knut on 07/12/14.
//  Copyright (c) 2014 MobileServices. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XML_Dictionary : NSObject<NSXMLParserDelegate>
{
    NSMutableDictionary *MainDictionary;
    NSMutableArray *dictArray;
    BOOL foundString;
}
@property(strong)NSString *stringValue;
- (NSDictionary *)objectWithData:(NSData *)data;
+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;
@end

