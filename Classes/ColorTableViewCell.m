//
//  ColorTableViewCell.m
//  MQNorway
//
//  Created by knut dullum on 24/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "ColorTableViewCell.h"

@implementation ColorTableViewCell

- (void) setCellColor: (UIColor*)color
{
    cellColor = color;
}

- (void) spreadBackgroundColor: (UIView*)that withColor: (UIColor*)bkColor
{
    NSEnumerator *enumerator = [that.subviews objectEnumerator];
    id anObject;
    
    while (anObject = [enumerator nextObject]) {
        if( [anObject isKindOfClass: [ UIView class] ] )
        {
            ((UIView*)anObject).backgroundColor = bkColor;
            [ self spreadBackgroundColor:anObject withColor:bkColor];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if( !self.selected && NULL != cellColor)
    {
        [ self spreadBackgroundColor:self withColor:cellColor ];
    }
}

@end