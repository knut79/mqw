//
//  SkyView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "SkyView.h"


@implementation SkyView


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
     
		m_imageView = [[UIImageView alloc] initWithFrame:[self frame]];
		UIImage *aocImage = [UIImage imageNamed:@"clouds.png"];   
		[m_imageView setImage:aocImage];
		[self addSubview:m_imageView];
    }
    return self;
}

-(void) setBackgroundFile:(NSString*) filename
{
	UIImage *uiImage = [UIImage imageNamed:filename];   
	[m_imageView setImage:uiImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
