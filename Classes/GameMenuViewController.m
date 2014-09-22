//
//  GameMenuView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "GameMenuViewController.h"
#import "MainMenuView.h";
#import "StartGameMenu.h";


@implementation GameMenuViewController

@synthesize delegate;

- (void)loadView {
    [super loadView];
	
	mainMenuView = [[MainMenuView alloc] initWithFrame:CGRectMake(0,0,500,500)];
	[mainMenuView setDelegate:self];
	UIScreen *screen = [UIScreen mainScreen];
    //self.view = mainMenuView;
	[self.view setFrame:[screen applicationFrame]];
	[[self view] addSubview:mainMenuView];

}

- (void)viewDidLoad
{
}

-(void) FadeInView
{
	[mainMenuView FadeIn];
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark MainMenuViewDelegate

- (void)switchToMapViewAndStart:(Game*)gameRef {
	//pass throug to rootviewcontroller
	if ([delegate respondsToSelector:@selector(StartNewGame:)])
        [delegate StartNewGame:gameRef];
}




@end
