//
//  Location.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefs.h"



@interface MpLocation : NSObject {

	NSString *m_name;
	NSString *m_county;
	NSString *m_state;
	Difficulty m_difficulty;
	LocationType m_locationType;
	UIImage *m_coatOfArms;
	NSMutableArray *m_additionalQuestions;
	NSMutableArray *m_additionalInfoArray;
	
}
-(id) initWithName:(NSString*) name andCounty:(NSString*) county andState:(NSString*) state andAdditionalQuestions:(NSMutableArray*) additionalQuestions
	andAdditionalInfo:(NSString*) addInfo andQuestDifficulty:(Difficulty)questDifficulty andAOC:(NSString*) aoc;
-(NSMutableArray*) GetAdditionalQuestions;
-(NSString*) GetName;
-(LocationType) GetLocationType;
-(CGPoint) GetNearestPoint:(CGPoint) sourcePoint;
-(BOOL) WithinBounds:(CGPoint) sourcePoint;
-(UIImage*) GetCoa;
-(Difficulty) GetQuestDifficulty;
-(CGPoint) GetCenterPoint;
-(NSString*) GetAdditionalInfo;

@end
