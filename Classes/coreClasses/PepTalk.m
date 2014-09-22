//
//  PepTalk.m
//  MQNorway
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "PepTalk.h"
#import "GlobalSettingsHelper.h"


@implementation PepTalk
+(PepTalk*) Instance 
{
	static PepTalk *Instance;
	
	@synchronized(self) {
		if(!Instance)
		{
			Instance = [[PepTalk alloc] init];
		}
	}
	return Instance;
}

-(id) init
{
	if (self = [super init]) {
		m_pepTalkListOne = [[NSMutableArray alloc] init];	
		[m_pepTalkListOne addObject:@"Super!"];
		[m_pepTalkListOne addObject:@"Way to go"];
		[m_pepTalkListOne addObject:@"No closer"];
		[m_pepTalkListOne addObject:@"On the spot"];
		[m_pepTalkListOne addObject:@"Correct!"];
		[m_pepTalkListOne addObject:@"On the button"];
		
		m_pepTalkListTwo= [[NSMutableArray alloc] init];	
		[m_pepTalkListTwo addObject:@"So close"];
		[m_pepTalkListTwo addObject:@"Almost"];
		[m_pepTalkListTwo addObject:@"Very close"];
		[m_pepTalkListTwo addObject:@"Good"];
		[m_pepTalkListTwo addObject:@"Good enough"];
		[m_pepTalkListTwo addObject:@"Not by far"];
		[m_pepTalkListTwo addObject:@"In the area"];

		m_pepTalkListThree= [[NSMutableArray alloc] init];
		[m_pepTalkListThree addObject:@"Next time"];
		[m_pepTalkListThree addObject:@"Unlucky"];
		[m_pepTalkListThree addObject:@"Another time"];
		[m_pepTalkListThree addObject:@"Bad luck"];
		[m_pepTalkListThree addObject:@"Not to bad"];
		
		m_pepTalkListFour= [[NSMutableArray alloc] init];
		[m_pepTalkListFour addObject:@"Could do better"];
		[m_pepTalkListFour addObject:@"Some distance"];
		[m_pepTalkListFour addObject:@"Too hard?"];
		[m_pepTalkListFour addObject:@"Not correct"];
		[m_pepTalkListFour addObject:@"Not near"];
		[m_pepTalkListFour addObject:@"Off target"];
		
		m_pepTalkListFive= [[NSMutableArray alloc] init];
		[m_pepTalkListFive addObject:@"Wrong!"];
		[m_pepTalkListFive addObject:@"Way off"];
		[m_pepTalkListFive addObject:@"Not even close"];
		[m_pepTalkListFive addObject:@"Too bad"];
		[m_pepTalkListFive addObject:@"Long distance!"];
		
		m_pepTalkListSix= [[NSMutableArray alloc] init];
		[m_pepTalkListSix addObject:@"Just wrong"];
		[m_pepTalkListSix addObject:@"No!"];
		[m_pepTalkListSix addObject:@"What?"];
		[m_pepTalkListSix addObject:@"Way off"];
		[m_pepTalkListSix addObject:@"Far off"]; 
		[m_pepTalkListSix addObject:@"Are you kidding?"];
		[m_pepTalkListSix addObject:@"No! Not there"];

	}
	return self;
}

-(NSString *) GetPepTalk:(NSInteger) missedDistance
{
	int index;

	if(missedDistance > 210){
		index = arc4random() % [m_pepTalkListSix count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListSix objectAtIndex:index]];
	}
	else if(missedDistance > 170){
		index = arc4random() % [m_pepTalkListFive count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListFive objectAtIndex:index]];
	}
	else if(missedDistance > 120){
		index = arc4random() % [m_pepTalkListFour count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListFour objectAtIndex:index]];
	}
	else if(missedDistance > 80){
		index = arc4random() % [m_pepTalkListThree count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListThree objectAtIndex:index]];
	}
	else if(missedDistance > 0){
		index = arc4random() % [m_pepTalkListTwo count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListTwo objectAtIndex:index]];
	}
	else {
		index = arc4random() % [m_pepTalkListOne count];
		return [[GlobalSettingsHelper Instance] GetStringByLanguage:[m_pepTalkListOne objectAtIndex:index]];
	}
}


@end
