//
//  SkyView.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SkyView : UIView {
	UIImageView *m_imageView;
}

-(void) setBackgroundFile:(NSString*) filename;

@end
