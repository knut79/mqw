/*
 *  EnumDefs.h
 *  Tiling
 *
 *  Created by knut dullum on 27/02/2011.
 *  Copyright 2011 Lemmus. All rights reserved.
 *
 */


typedef enum
{
    level5 = 5,
	level4 = 4,
	level3 = 3,
	level2 = 2,
	level1 = 1,
	noDifficulty = 6,
	notUsed = 7
}Difficulty;

typedef enum
{
	km ,
	mile
}DistanceMeasurement;

typedef enum
{
	english = 1,
	norwegian = 2,
	spanish = 3,
	french = 4,
	german = 5
}Language;


typedef enum
{
	ktsmall = 1000,
	ktmedium = 2000,
	ktlarge = 3000
}KmTolerance;

typedef enum
{
	psnothing = 1,
	pstiny = 2,
	pssmall = 4,
	psmedium = 8,
	psbig = 15,
	pshuge = 20
}PlaceSize;

typedef enum
{
	placeType,
	regionType,
	lakeType,
	islandType,
	peninsulaType,
	stateType,
	cityType,
	mountainType
}LocationType;


typedef enum
{
	showResult,
	inGame,
	outOfGame
}GameState;