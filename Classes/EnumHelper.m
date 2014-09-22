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
	Difficulty returnValue = easy;
	if ([difficultyString isEqualToString:@"veryhardDif"]) {
		returnValue = veryhardDif;
	}
	else if ([difficultyString isEqualToString:@"hardDif"]) {
		returnValue = hardDif;
	}
	else if ([difficultyString isEqualToString:@"medium"]) {
		returnValue = medium;
	}
	
	return returnValue;
}

+(NSString*) difficultyToString:(Difficulty) diff
{
	NSString *returnValue = @"easy";
	if (diff == veryhardDif) {
		returnValue = @"veryhardDif";
	}
	else if (diff == hardDif) {
		returnValue = @"hardDif";
	}
	else if (diff == medium) {
		returnValue = @"medium";
	}
	
	return returnValue;
}

+(NSString*) difficultyToNiceString:(Difficulty) diff
{
	NSString *returnValue = @"easy";
	if (diff == veryhardDif) {
		returnValue = @"veryhard";
	}
	else if (diff == hardDif) {
		returnValue = @"hard";
	}
	else if (diff == medium) {
		returnValue = @"medium";
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

+(GameType) stringToGametype:(NSString*) gametypeString
{
	GameType returnValue = lastStanding;
	if ([gametypeString isEqualToString:@"mostPoints"]) {
		returnValue = mostPoints;
	}
	return returnValue;
}

+(NSString*) gametypeToString:(GameType) gametypeValue
{
	NSString *returnValue = @"lastStanding";
	if (gametypeValue == mostPoints) {
		returnValue = @"mostPoints";
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
