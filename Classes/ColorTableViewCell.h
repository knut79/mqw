//
//  ColorTableViewCell.h
//  MQNorway
//
//  Created by knut dullum on 24/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorTableViewCell : UITableViewCell{
UIColor*    cellColor;
}
- (void) setCellColor: (UIColor*)color;

@end
