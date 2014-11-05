//
//  EnumHelper.m
//  MQNorway
//
//  Created by knut dullum on 11/05/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "EnumHelper.h"


@implementation EnumHelper

+(Difficulty) stringToDifficulty:(NSString*) difficultyString
{
	Difficulty returnValue = level1;
	if ([difficultyString isEqualToString:@"level2"]) {
		returnValue = level2;
	}
	else if ([difficultyString isEqualToString:@"level3"]) {
		returnValue = level3;
	}
	else if ([difficultyString isEqualToString:@"level4"]) {
		returnValue = level4;
	}
	else if ([difficultyString isEqualToString:@"level5"]) {
		returnValue = level5;
	}
	
	return returnValue;
}

+(NSString*) difficultyToString:(Difficulty) diff
{
	NSString *returnValue = @"level1";
	if (diff == level2) {
		returnValue = @"level2";
	}
	else if (diff == level3) {
		returnValue = @"level3";
	}
	else if (diff == level4) {
		returnValue = @"level4";
	}
	else if (diff == level5) {
		returnValue = @"level5";
	}
	
	return returnValue;
}

+(NSString*) difficultyToNiceString:(Difficulty) diff
{
	NSString *returnValue = @"level 1";
	if (diff == level2) {
		returnValue = @"level 2";
	}
	else if (diff == level3) {
		returnValue = @"level 3";
	}
	else if (diff == level4) {
		returnValue = @"level 4";
	}
	else if (diff == level5) {
		returnValue = @"level 5";
	}
	
	return returnValue;
}

+(Language) stringToLanguage:(NSString*) languageString
{
	Language returnValue = english;
	if ([languageString isEqualToString:@"norwegian"]) {
		returnValue = norwegian;
	}
	else if ([languageString isEqualToString:@"spanish"]) {
		returnValue = spanish;
	}
	else if ([languageString isEqualToString:@"french"]) {
		returnValue = french;
	}
	else if ([languageString isEqualToString:@"german"]) {
		returnValue = german;
	}
	
	return returnValue;
}

+(NSString*) languageToString:(Language) languageValue
{
	NSString *returnValue = @"english";
	if (languageValue == norwegian) {
		returnValue = @"norwegian";
	}
	else if (languageValue == spanish) {
		returnValue = @"spanish";
	}
	else if (languageValue == french) {
		returnValue = @"french";
	}
	else if (languageValue == german) {
		returnValue = @"german";
	}
	
	return returnValue;
}


+(GameState) stringToGamestate:(NSString*) gamestateString
{
	GameState  returnValue = inGame;
	if ([gamestateString isEqualToString:@"showResult"]) {
		returnValue = showResult;
	}
	else if ([gamestateString isEqualToString:@"outOfGame"]) {
		returnValue = outOfGame;
	}
	return returnValue;
}

+(NSString*) gamestateToString:(GameState) gamestateValue
{
	NSString *returnValue = @"inGame";
	if (gamestateValue == showResult) {
		returnValue = @"showResult";
	}
	else if (gamestateValue == outOfGame) {
		returnValue = @"outOfGame";
	}
	
	return returnValue;
}

@end
