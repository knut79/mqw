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
	
	MainMenuView *mainMenuView = [[MainMenuView alloc] initWithFrame:CGRectMake(0,0,500,500)];
	[mainMenuView setDelegate:self];
    self.view = mainMenuView;
    [mainMenuView release];
}

- (void)viewDidLoad
{
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
