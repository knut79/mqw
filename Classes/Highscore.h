//
//  Highscore.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"


@interface Highscore : NSObject {
	
	NSMutableArray *m_highscoreListEasy;
	NSString *pathEasy;
	NSMutableArray *m_highscoreListMedium;
	NSString *pathMedium;
	NSMutableArray *m_highscoreListHard;
	NSString *pathHard;
}
-(NSInteger) CheckIfNewHighScore:(Player*) player difficultyLevel:(Difficulty) diffLevel;

@end
