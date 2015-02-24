//
//  StartGameMenu.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Game.h"

#define const_sliderGameTypeSwichValue 2.0

@protocol StartGameMenuViewDelegate;

@interface StartGameMenu : UIView <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	

	
	UIPickerView *difPicker;
	NSMutableArray *pickerArray;
	
	IBOutlet UISlider *slideDifficultyPicker;
	IBOutlet UISlider *slideGameTypePicker;
	IBOutlet UISlider *slideNumberOfQuestionsPicker;
	UILabel *difficultyLabel;
	UILabel *headerLabel;
	//UILabel *infoOrGlobalIDLabel;
	
	//UITextField *playerOneTextField;

	UIButton *buttonBack;
	UIButton *buttonStart;
	
	Game *m_game;
	id <StartGameMenuViewDelegate> delegate;
	Player *m_player;
	
	NSInteger sliderXOffset;
	NSInteger sliderYOffset;
	
	NSInteger playersXOffset;
	NSInteger playersYOffset;
	
	NSInteger switchXOffset;
	NSInteger switchYOffset;

	UILabel *miniLabel;
	
    /*
	UISwitch *modeSwitch;
	UILabel *modeLabel;
    */
    
    UISwitch *borderSwitch;
	UILabel *borderLabel;
	
	BOOL m_finishedLoadingGameObjects;
	NSTimer *m_timerCheckLoadingGameObjects;
	UIActivityIndicatorView *m_activityIndicator;
	UILabel *m_loadingLabel;
}
@property (nonatomic,retain) Game* m_game;
@property (nonatomic,assign) NSInteger numberOfPlayers;
@property (nonatomic,retain) IBOutlet UIPickerView *difPicker;
@property (nonatomic, assign) id <StartGameMenuViewDelegate> delegate;

-(void) FadeIn;
-(void) FadeOut;
-(void) UpdateLabels;
-(void) UpdateSliderDifficultyValue;
-(void) UpdateSliderGameTypeValue;
-(void) SetFinishedLoadingGameObjects;
-(void) initStartGameElements;
-(void) ShowLoadingGameObjects;
@end


@protocol StartGameMenuViewDelegate <NSObject>

@optional
- (void)cleanUpStartGameMenuAndStart:(Game *)gameRef;
-(void) cleanUpStartGameMenu;

@end
