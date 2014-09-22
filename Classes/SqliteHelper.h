//
//  SqliteHelper.h
//  MQNorway
//
//  Created by knut dullum on 20/03/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "Sqlite.h"
#import "FMDB.h"

@interface SqliteHelper : NSObject {
	
}

+(FMDatabase*) Instance;

@end