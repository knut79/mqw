//
//  StartGameMenu.h
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Game.h";
#import "SkyView.h"

#define const_sliderGameTypeSwichValue 2.0

@protocol StartGameMenuViewDelegate;

@interface StartGameMenu : UIView <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UIPickerView *difPicker;
	NSMutableArray *pickerArray;
	
	IBOutlet UISlider *slideDifficultyPicker;
	IBOutlet UISlider *slideGameTypePicker;
	IBOutlet UISlider *slideNumberOfQuestionsPicker;
	UILabel *difficultyLabel;
	
	UITextField *playerOneTextField;
	UITextField *playerTwoTextField;
	UITextField *playerThreeTextField;
	UITextField *playerFourTextField;

	UIButton *buttonAddPlayer;
	UIButton *buttonRemovePlayer;
	UIButton *buttonBack;
	UIButton *buttonStart;
	NSInteger numberOfPlayers; 
	
	IBOutlet UILabel *multiplayerModeLabel;  
	IBOutlet UILabel *numberOfQuestionsLabel;
	
	Game *m_game;
	id <StartGameMenuViewDelegate> delegate;
	NSMutableArray *m_players;
	
	NSInteger sliderXOffset;
	NSInteger sliderYOffset;
	
	NSInteger playersXOffset;
	NSInteger playersYOffset;
	
	NSInteger switchXOffset;
	NSInteger switchYOffset;
	
	BOOL UpdateSliderGameTypeValue_isMovedDown;
	BOOL UpdateSliderGameTypeValue_isMovedUp;
	
	NSInteger mostPointsGame_NumberOfQuestions;
	
	SkyView *m_skyView;
	UILabel *miniLabel;
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
@end


@protocol StartGameMenuViewDelegate <NSObject>

@optional
- (void)switchToMapViewAndStart:(Game *)gameRef;

@end
