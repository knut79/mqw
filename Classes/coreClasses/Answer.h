//
//  Answer.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface Answer : NSObject {
	NSString *m_name;
	NSString *m_answerString;
	MpLocation *m_location;
	NSString* m_additionalInfo;
}
-(id) initWithLanguage:(Language)language andLocation:(MpLocation*) location;
-(NSString*) GetAnswerString;
-(MpLocation*) GetLocation;
-(NSString*) GetAdditionalInfo;

@end
