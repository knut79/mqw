//
//  EnumHelper.h
//  MQNorway
//
//  Created by knut dullum on 11/05/2011.
//  Copyright 2011 lemmus. All rights reserved.
//
#import "EnumDefs.h"

@interface EnumHelper : NSObject {

}
+(NSString*) difficultyToString:(Difficulty) diff;
+(NSString*) difficultyToNiceString:(Difficulty) diff;
+(Difficulty) stringToDifficulty:(NSString*) difficultyString;
+(NSString*) gametypeToString:(GameType) gametypeValue;
+(GameType) stringToGametype:(NSString*) gametypeString;
+(NSString*) languageToString:(Language) languageValue;
+(Language) stringToLanguage:(NSString*) languageString;
+(GameState) stringToGamestate:(NSString*) gamestateString;
+(NSString*) gamestateToString:(GameState) gamestateValue;
@end
