//
//  UILabelGradient.m
//  MQNorway
//
//  Created by knut dullum on 07/07/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "UILabelUnderline.h"


@implementation UILabelUnderline


- (id)init{
    
    self = [super init];
    if (self) {
        // Initialization code.
		underlineColor = [UIColor blackColor];
    }
    return self;
}

-(void) SetUnderlineColor:(UIColor*) color
{
	underlineColor = color;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();

	CGColorRef color = [underlineColor CGColor];
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		CGFloat red = components[0];
		CGFloat green = components[1];
		CGFloat blue = components[2];
		//CGFloat alpha = components[3];
		
		CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0f); // RGBA
	}

    CGContextSetLineWidth(ctx, 1.0f);
	
    CGContextMoveToPoint(ctx, 0, self.bounds.size.height - 1);
    CGContextAddLineToPoint(ctx, self.bounds.size.width, self.bounds.size.height - 1);
	
    CGContextStrokePath(ctx);
	
    [super drawRect:rect];  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
