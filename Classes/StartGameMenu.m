//
//  StartGameMenu.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "StartGameMenu.h"
#import "UISwitch-extended.h"
#import "GlobalSettingsHelper.h"
#import "SqliteHelper.h"

#import "InAppPurchaseManager.h"




@implementation StartGameMenu

@synthesize m_game;
@synthesize difPicker;
@synthesize delegate;
@synthesize numberOfPlayers;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) { 

		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 250, 40)];
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2, 25);
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		[self addSubview:headerLabel];
		[headerLabel release];
		

		[self initStartGameElements];

            
		[screen release];
		
    }
    return self;
}

-(void) initStartGameElements
{
	UIScreen *screen = [[UIScreen mainScreen] retain];
	
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start Game"];
	
	sliderXOffset = 0;
	sliderYOffset = 0;
	
	playersXOffset = 20;
	playersYOffset = 30;
	
	switchXOffset = 0;
	switchYOffset = 80;
	
	m_players = [[NSMutableArray alloc] init];
	

	infoOrGlobalIDLabel = [[UILabel alloc] init];
	[infoOrGlobalIDLabel setFrame:CGRectMake(80, 0, 250, 40)];
	infoOrGlobalIDLabel.textAlignment = NSTextAlignmentCenter;
	infoOrGlobalIDLabel.center = CGPointMake([screen applicationFrame].size.width/2, 60);
	infoOrGlobalIDLabel.backgroundColor = [UIColor clearColor]; 
	infoOrGlobalIDLabel.textColor = [UIColor whiteColor];
	[infoOrGlobalIDLabel setFont:[UIFont boldSystemFontOfSize:20.0f]];
	infoOrGlobalIDLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"ID"],[[GlobalSettingsHelper Instance] GetPlayerID]];
	infoOrGlobalIDLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	infoOrGlobalIDLabel.layer.shadowOpacity = 1.0;
	[self addSubview:infoOrGlobalIDLabel];
	[infoOrGlobalIDLabel release];
	
	miniLabel = [[UILabel alloc] init];
	[miniLabel setFrame:CGRectMake(145, 18, 50, 30)];
	miniLabel.center = CGPointMake(([screen applicationFrame].size.width/2) + 10,35);
	miniLabel.backgroundColor = [UIColor clearColor]; 
	miniLabel.textColor = [UIColor redColor];
	[miniLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
	miniLabel.transform = CGAffineTransformMakeRotation( M_PI/4 );
	miniLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"];
	[self addSubview:miniLabel];
	
	
	difficultyLabel = [[UILabel alloc] init];
	[difficultyLabel setFrame:CGRectMake(60 + sliderXOffset, 90 + sliderYOffset, 250, 20)];
	difficultyLabel.textAlignment = NSTextAlignmentCenter;
	difficultyLabel.center = CGPointMake([screen applicationFrame].size.width/2, 90 + sliderYOffset);
	difficultyLabel.backgroundColor = [UIColor clearColor]; 
	difficultyLabel.textColor = [UIColor whiteColor];
	[difficultyLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	difficultyLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	difficultyLabel.layer.shadowOpacity = 1.0;
	//difficultyLabel.layer.shadowOffset = CGSizeMake(2.0, 2.0);
	difficultyLabel.layer.shadowRadius = 1.5;
	//difficultyLabel.shadowColor = [UIColor blackColor];
	//difficultyLabel.shadowOffset = CGSizeMake(1,1);
	difficultyLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Difficulty"],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"]];
	[self addSubview:difficultyLabel];
	
	slideDifficultyPicker = [[UISlider alloc] init];
	slideDifficultyPicker.frame  = CGRectMake(50 + sliderXOffset,60 + sliderYOffset,120,20);
	slideDifficultyPicker.center = CGPointMake([screen applicationFrame].size.width/2, 120 + sliderYOffset);
	slideDifficultyPicker.minimumValue = 1;
	slideDifficultyPicker.maximumValue = 3;
	slideDifficultyPicker.value = 1;
	[slideDifficultyPicker addTarget:self action:@selector(sliderDifficultyValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slideDifficultyPicker];		
	
	numberOfPlayers = 1;
	
	
	switchLabel = [[UILabel alloc] init];
	[switchLabel setFrame:CGRectMake(0, 0, 200, 30)];
	switchLabel.center = CGPointMake(([screen applicationFrame].size.width/2), 190 + playersYOffset - 15);
	switchLabel.textAlignment = NSTextAlignmentCenter;
	switchLabel.backgroundColor = [UIColor clearColor]; 
	switchLabel.textColor = [UIColor whiteColor];
	[switchLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	switchLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	switchLabel.layer.shadowOpacity = 1.0;
	switchLabel.layer.shadowRadius = 1.5;
	switchLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Training mode:"];
	[self addSubview:switchLabel];		
	
	modeSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
	[modeSwitch addTarget: self action: @selector(flipMode:) forControlEvents:UIControlEventValueChanged];
	// Set the desired frame location of onoff here
	modeSwitch.on = NO; 
	modeSwitch.center = CGPointMake(([screen applicationFrame].size.width/2), 190 + playersYOffset + 15);
	[self addSubview: modeSwitch];
	
	
	buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonStart addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchDown];
	[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
	buttonStart.frame = CGRectMake(60 + playersXOffset, 160 + playersYOffset, 150.0, 40.0);
	//buttonStart.center = CGPointMake([screen applicationFrame].size.width/2, 170 + playersYOffset);
	buttonStart.center = CGPointMake([screen applicationFrame].size.width/2, 265 + playersYOffset);
    m_loadingLabel.center = buttonStart.center;
	[self addSubview:buttonStart];
	
	
	
	buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	buttonBack.frame = CGRectMake(60 + playersXOffset, 160 + playersYOffset, 150.0, 40.0);
	//buttonBack.center = CGPointMake([screen applicationFrame].size.width/2, 240 + playersYOffset);
	buttonBack.center = CGPointMake([screen applicationFrame].size.width/2, 320 + playersYOffset);
	[self addSubview:buttonBack];
	
	
    
	playerOneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + playersXOffset, 100 + playersYOffset, 150, 27)];
	playerOneTextField.center = CGPointMake(([screen applicationFrame].size.width/2) - 10, 130 + playersYOffset);
	playerOneTextField.clearsOnBeginEditing = YES;
	playerOneTextField.tag = 101;
	playerOneTextField.delegate = self;
    [playerOneTextField setAlpha:0.5];
    
//	NSArray *resultsPlayers = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM player"];
//	if (resultsPlayers.count > 0) {
//		NSDictionary *resultsLanguageDictionary = [resultsPlayers objectAtIndex:0];
//		playerOneTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:[resultsLanguageDictionary objectForKey:@"name"]];
//		playerOneTextField.text = playerOneTextField.placeholder;
//	}
//	else {
//		playerOneTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"enter name"];
//	}
    
    playerOneTextField.text = [[GlobalSettingsHelper Instance] GetPlayerID];
	playerOneTextField.userInteractionEnabled = NO;
    
	playerOneTextField.borderStyle = UITextBorderStyleRoundedRect;
	playerOneTextField.textAlignment = NSTextAlignmentCenter;
//	playerOneTextField.backgroundColor = [UIColor redColor];
	playerOneTextField.textColor = [UIColor redColor];
//	[playerOneTextField setValue:[UIColor redColor] 
//					  forKeyPath:@"_placeholderLabel.textColor"];
    playerOneTextField.layer.cornerRadius=8.0f;
    playerOneTextField.layer.masksToBounds=YES;
    playerOneTextField.layer.borderColor=[[UIColor redColor]CGColor];
    playerOneTextField.layer.borderWidth= 2.0f;
    playerOneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[self addSubview:playerOneTextField];
	
	buttonAddPlayer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonAddPlayer addTarget:self action:@selector(addPlayer:) forControlEvents:UIControlEventTouchDown];
	[buttonAddPlayer setTitle:@"+" forState:UIControlStateNormal];
	buttonAddPlayer.frame = CGRectMake(180.0 + playersXOffset, 100 + playersYOffset, 30, 30);
	buttonAddPlayer.center = CGPointMake(([screen applicationFrame].size.width/2) + 100, 130 + playersYOffset);
	[self addSubview:buttonAddPlayer];
	
	
	
	multiplayerModeLabel = [[UILabel alloc] init];
	[multiplayerModeLabel setFrame:CGRectMake(50 + switchXOffset, 155 + switchYOffset, 300, 20)];
	multiplayerModeLabel.textAlignment = NSTextAlignmentCenter;
	multiplayerModeLabel.center = CGPointMake(([screen applicationFrame].size.width/2), 180 + switchYOffset);
	multiplayerModeLabel.backgroundColor = [UIColor clearColor]; 
	multiplayerModeLabel.textColor = [UIColor whiteColor];
	[multiplayerModeLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	multiplayerModeLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	multiplayerModeLabel.layer.shadowOpacity = 1.0;
	multiplayerModeLabel.layer.shadowRadius = 1.5;
	multiplayerModeLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Game type"], [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Last standing"]];
	multiplayerModeLabel.hidden = YES;
	[multiplayerModeLabel setAlpha:0];
	[self addSubview:multiplayerModeLabel];
	
	numberOfQuestionsLabel = [[UILabel alloc] init];
	[numberOfQuestionsLabel setFrame:CGRectMake(50 + switchXOffset, 155 + switchYOffset, 300, 20)];
	numberOfQuestionsLabel.textAlignment = NSTextAlignmentCenter;
	numberOfQuestionsLabel.center = CGPointMake(([screen applicationFrame].size.width/2), 185 + switchYOffset);
	numberOfQuestionsLabel.backgroundColor = [UIColor clearColor]; 
	numberOfQuestionsLabel.textColor = [UIColor whiteColor];
	[numberOfQuestionsLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	numberOfQuestionsLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	numberOfQuestionsLabel.layer.shadowOpacity = 1.0;
	numberOfQuestionsLabel.layer.shadowRadius = 1.5;
	numberOfQuestionsLabel.text = @"";
	multiplayerModeLabel.hidden = YES;
	[numberOfQuestionsLabel setAlpha:0];
	[self addSubview:numberOfQuestionsLabel];
	
	slideGameTypePicker = [[UISlider alloc] init];
	slideGameTypePicker.frame  = CGRectMake(50 + sliderXOffset,60 + sliderYOffset,160,20);
	slideGameTypePicker.center = CGPointMake(([screen applicationFrame].size.width/2), 220 + switchYOffset);
	slideGameTypePicker.minimumValue = 1;
	slideGameTypePicker.maximumValue = 8;
	slideGameTypePicker.value = 1;
	[slideGameTypePicker addTarget:self action:@selector(sliderGameTypeValueChanged:) forControlEvents:UIControlEventValueChanged];
	[slideGameTypePicker setAlpha:0];
	[self addSubview:slideGameTypePicker];	
	
	UpdateSliderGameTypeValue_isMovedDown = NO;
	UpdateSliderGameTypeValue_isMovedUp = YES;
	
	mostPointsGame_NumberOfQuestions = 2;
	
	[self setAlpha:0];
	
//	[buttonStart setAlpha:0];
//	
//	
//	m_activityIndicator = [[UIActivityIndicatorView alloc] init];
//	m_activityIndicator.frame  = CGRectMake(0,0,60,60);
//	m_activityIndicator.center = buttonStart.center;
//	m_activityIndicator.hidesWhenStopped  = YES;
//	[self addSubview:m_activityIndicator];	
//	[m_activityIndicator startAnimating];
//	[self bringSubviewToFront:m_activityIndicator];
//	
//	m_loadingLabel = [[UILabel alloc] init];
//	[m_loadingLabel setFrame:CGRectMake(0, 0, 250, 40)];
//	m_loadingLabel.backgroundColor = [UIColor clearColor]; 
//	m_loadingLabel.textColor = [UIColor redColor];
//	[m_loadingLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
//	m_loadingLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
//	m_loadingLabel.layer.shadowOpacity = 1.0;
//	m_loadingLabel.center = buttonStart.center;
//	m_loadingLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Loading game objects"];
//	m_loadingLabel.textAlignment = NSTextAlignmentCenter;		
//	[self addSubview:m_loadingLabel];
	
	[screen release];
}


- (void) drawPlaceholderInRect:(CGRect)rect {
    [[UIColor blueColor] setFill];
    [[self placeholder] drawInRect:rect withFont:[UIFont systemFontOfSize:16]];
}

- (IBAction)flipMode:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	
	
	if (modeSwitch.on) 
	{
		[infoOrGlobalIDLabel setAlpha:0];
		[buttonAddPlayer setAlpha:0];
		[miniLabel setAlpha:0];
		[playerOneTextField setAlpha:0];
		[UIView setAnimationDidStopSelector:@selector(doMoveOn)];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start training"];
		[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start training"] forState:UIControlStateNormal];
		switchLabel.center = CGPointMake(switchLabel.center.x, switchLabel.center.y - 40);
		modeSwitch.center = CGPointMake(modeSwitch.center.x, modeSwitch.center.y - 40);
		buttonStart.center = CGPointMake(buttonStart.center.x, buttonStart.center.y - 30);
        m_loadingLabel.center = buttonStart.center;
		buttonBack.center = CGPointMake(buttonBack.center.x, buttonBack.center.y - 30);
	}
	else
	{
		[infoOrGlobalIDLabel setAlpha:1];
		[buttonAddPlayer setAlpha:1];
		[miniLabel setAlpha:1];
		[playerOneTextField setAlpha:0.5];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start Game"];
		[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
		switchLabel.center = CGPointMake(switchLabel.center.x, switchLabel.center.y + 40);
		modeSwitch.center = CGPointMake(modeSwitch.center.x, modeSwitch.center.y + 40);
		buttonStart.center = CGPointMake(buttonStart.center.x, buttonStart.center.y + 30);
        m_loadingLabel.center = buttonStart.center;
		buttonBack.center = CGPointMake(buttonBack.center.x, buttonBack.center.y + 30);
	}
	
	[UIView commitAnimations];	
}

- (IBAction) sliderDifficultyValueChanged:(UISlider *)sender {  
	[self UpdateSliderDifficultyValue];
}  


- (IBAction) sliderGameTypeValueChanged:(UISlider *)sender {  
	[self UpdateSliderGameTypeValue];
}  

-(void) UpdateSliderDifficultyValue
{
	NSString *value = [[NSString alloc] initWithString:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"]];
	if ([slideDifficultyPicker value] >= 1.5) {
		
		if([slideDifficultyPicker value] >= 2.5)
		{
			value = [[[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"] retain];
		}
		else {
			value = [[[GlobalSettingsHelper Instance] GetStringByLanguage:@"normal"] retain];
		}
	}
	miniLabel.text = [NSString stringWithFormat:@"%@", value]; 
    difficultyLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Difficulty"], value]; 
	[value release];	
}

-(void) UpdateSliderGameTypeValue
{
	NSString *value = [[NSString alloc] initWithString:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Last standing"]];
	if ([slideGameTypePicker value] >= const_sliderGameTypeSwichValue) {
		mostPointsGame_NumberOfQuestions = ([slideGameTypePicker value] * 3)- 4;
		numberOfQuestionsLabel.text = [NSString stringWithFormat:@"%@: %d",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Number of questions"], mostPointsGame_NumberOfQuestions];  
		if (UpdateSliderGameTypeValue_isMovedDown == NO) {
			UpdateSliderGameTypeValue_isMovedDown = YES;
			UpdateSliderGameTypeValue_isMovedUp = NO;
			CGPoint newCenterForMultiplayerModeLabel = CGPointMake(multiplayerModeLabel.center.x, multiplayerModeLabel.center.y - 20.0f);
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:0.5f];
			multiplayerModeLabel.center = newCenterForMultiplayerModeLabel;
			[numberOfQuestionsLabel setAlpha:1];
			[UIView commitAnimations];
		}

		
		value = [[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Most points"] retain];
	}
	else {
		if (UpdateSliderGameTypeValue_isMovedUp == NO) {
			UpdateSliderGameTypeValue_isMovedUp = YES;
			UpdateSliderGameTypeValue_isMovedDown = NO;
			CGPoint newCenterForMultiplayerModeLabel = CGPointMake(multiplayerModeLabel.center.x, multiplayerModeLabel.center.y + 20.0f);
			[UIView beginAnimations:nil context:nil]; 
			[UIView setAnimationDuration:0.5f];
			multiplayerModeLabel.center = newCenterForMultiplayerModeLabel;
			[numberOfQuestionsLabel setAlpha:0];
			[UIView commitAnimations];
			numberOfQuestionsLabel.text = @"";
		}
	}

    multiplayerModeLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Game type"], value]; 
	[value release];	
}


-(void)goBack:(id)Sender
{
	[self FadeOut];
}



-(void) UpdateLabels
{
	slideDifficultyPicker.value = 1;
	[self UpdateSliderGameTypeValue];
	[self UpdateSliderDifficultyValue];
	switchLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Training mode:"];
	//playerOneTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
	if (playerTwoTextField != nil) {
		playerTwoTextField.text = [NSString stringWithFormat:@"%@ 2",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
	}
	if (playerThreeTextField != nil) {
		playerThreeTextField.text = [NSString stringWithFormat:@"%@ 3",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
	}
	if (playerFourTextField != nil) {
		playerFourTextField.text = [NSString stringWithFormat:@"%@ 4",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
	}
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	difficultyLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Difficulty"],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"]];
	[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start Game"];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

-(NSInteger)pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component
{
	return [pickerArray count];
}

-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	return [pickerArray objectAtIndex:row];
}

		 
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	switch (textField.tag) {
		case 101:
			if ([value length] == 0) {
				playerOneTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		case 102:
			if ([value length] == 0) {
				playerTwoTextField.text = [NSString stringWithFormat:@"%@ 2",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		case 103:
			if ([value length] == 0) {
				playerThreeTextField.text = [NSString stringWithFormat:@"%@ 3",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		case 104:
			if ([value length] == 0) {
				playerFourTextField.text = [NSString stringWithFormat:@"%@ 4",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		default:
			break;
	}
	
	[textField resignFirstResponder];
	
	return YES;	
}

-(void)startGame:(id)Sender
{
	
	BOOL multiplayer = NO;
	if (numberOfPlayers > 0) {
		NSString *playerOneString;
		if ([playerOneTextField.text length] == 0) {
			playerOneString = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
		}
		else {
			playerOneString = playerOneTextField.text;
		}

		Player *playerOne = [[Player alloc] initWithName:playerOneString andColor:playerOneTextField.textColor andPlayerSymbol:@"ArrowRed.png"];
		[m_players addObject:playerOne];
		
		if (numberOfPlayers > 1 ) {
				NSString *playerTwoString;
			if ([playerTwoTextField.text length] == 0) {
				playerTwoString = [NSString stringWithFormat:@"%@ 2",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			else {
				playerTwoString = playerTwoTextField.text;
			}

			multiplayer = YES;
			Player *playerTwo = [[Player alloc] initWithName:playerTwoString andColor:playerTwoTextField.textColor andPlayerSymbol:@"ArrowGreen.png"];
			[m_players addObject:playerTwo];
			
			if (numberOfPlayers > 2) {
				if ([playerThreeTextField.text length] == 0) {
					playerThreeTextField.text = [NSString stringWithFormat:@"%@ 3",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
				}
				Player *playerThree = [[Player alloc] initWithName:playerThreeTextField.text andColor:playerThreeTextField.textColor andPlayerSymbol:@"ArrowBlue.png"];
				[m_players addObject:playerThree];
				
				if (numberOfPlayers > 3) {
					if ([playerFourTextField.text length] == 0) {
						playerFourTextField.text = [NSString stringWithFormat:@"%@ 4",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
					}
					Player *playerFour = [[Player alloc] initWithName:playerFourTextField.text andColor:playerFourTextField.textColor andPlayerSymbol:@"ArrowPurple.png"];
					[m_players addObject:playerFour];
				}
			}
		}
	}

	Difficulty vDifficulty = easy;	
	if ([slideDifficultyPicker value] >= 1.5) {
		
		if([slideDifficultyPicker value] >= 2.5)
		{
			vDifficulty = hardDif;
		}
		else {
			vDifficulty = medium;
		}
	}
	GameType gameType = lastStanding;
	if (multiplayer == YES) {
		if ([slideGameTypePicker value] >= const_sliderGameTypeSwichValue) {
			
			gameType = mostPoints;
		}
	}



	if (m_game == nil) {
		m_game = [[Game alloc] init] ;
	}

	if (modeSwitch.on == YES) 
		[m_game SetTrainingMode:YES];
	else
		[m_game SetTrainingMode:NO];
	

	[m_game SetPlayers:m_players andDifficulty:vDifficulty andMultiplayers:multiplayer andGameType:gameType andNumberOfQuestions: mostPointsGame_NumberOfQuestions];
	[m_players removeAllObjects];
	
	[self FadeOut];
	[((StartGameMenu*)self.superview) FadeOut];
	
	
	//need to be sure the keyboard is closed, its only for player games this is necessary
	[playerOneTextField resignFirstResponder];

	[self FadeOutAndStartGame];
}




-(void)addPlayer:(id)Sender
{
	
//	InAppPurchaseManager *sharedManager = [InAppPurchaseManager sharedManager];
//	[sharedManager requestProUpgradeProductData];
	
	UIScreen *screen = [[UIScreen mainScreen] retain];
	BOOL switchViewShouldMove = NO;
	BOOL startGameAndBackBtnShouldMove = NO;
	BOOL startGameAndBackBtnShouldChangeSize = NO;
	BOOL removePlayerButtonShouldMove = NO;
	BOOL addPlayerButtonShouldMove = NO;
	BOOL fadeOutAddPlayerButton = NO;
	BOOL fadeInMultiplayerSwitch = NO;
	BOOL fadeInRemovePlayerButton = NO;
	BOOL fadeInTwo = NO;
	BOOL fadeInThree = NO;
	BOOL fadeInFour = NO;
	numberOfPlayers++;
	if (numberOfPlayers > 4) {
		numberOfPlayers = 4;
		return;
	}

	CGPoint newCenterForSwitch;
	CGPoint newCenterForSwitchLabel;
	CGPoint newCenterForRemovePlayerButton;
	CGPoint newCenterForAddPlayerButton;
	CGPoint newCenterForButtonBack;
	CGPoint newCenterForButtonStart;
	CGRect newFrameForButtonStart;
	CGRect newFrameForButtonBack;
	CGPoint newCenterForNumberOfQuestionsLabel;
	
	switch (numberOfPlayers) {
		case 2:
            playerOneTextField.userInteractionEnabled = YES;
            [playerOneTextField setAlpha:1];
            playerOneTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
            
			infoOrGlobalIDLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Local pass and play"];
			[slideGameTypePicker setAlpha:0];
			[multiplayerModeLabel setAlpha:0];
			[numberOfQuestionsLabel setAlpha:0];
			fadeInMultiplayerSwitch = YES;
			slideGameTypePicker.hidden = NO;
			multiplayerModeLabel.hidden = NO;
			numberOfQuestionsLabel.hidden = NO;
			//reposition add button
			addPlayerButtonShouldMove = YES;
			newCenterForAddPlayerButton = CGPointMake(buttonAddPlayer.center.x, buttonAddPlayer.center.y + 40.0f);
			
			if (!buttonRemovePlayer)
			{
				buttonRemovePlayer = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				[buttonRemovePlayer addTarget:self action:@selector(removePlayer:) forControlEvents:UIControlEventTouchDown];
				[buttonRemovePlayer setTitle:@"-" forState:UIControlStateNormal];
				buttonRemovePlayer.frame = CGRectMake(180.0 + playersXOffset, 100 + playersYOffset, 30, 30);
				buttonRemovePlayer.center = CGPointMake(([screen applicationFrame].size.width/2) + 100, 130 + playersYOffset);
				[buttonRemovePlayer setAlpha:0];
				[self addSubview:buttonRemovePlayer];

			}
			fadeInRemovePlayerButton = YES;
			
			
			if(!playerTwoTextField)
			{
				playerTwoTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + playersXOffset, 140 + playersYOffset, 150, 27)];
				playerTwoTextField.center = CGPointMake(([screen applicationFrame].size.width/2) - 10, 170 + playersYOffset);
				playerTwoTextField.clearsOnBeginEditing = YES;
				playerTwoTextField.tag = 102;
				playerTwoTextField.delegate = self;
				playerTwoTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"enter name"];
				playerTwoTextField.textAlignment = NSTextAlignmentCenter;
				playerTwoTextField.borderStyle = UITextBorderStyleRoundedRect;
//				playerTwoTextField.backgroundColor = [UIColor greenColor];
				playerTwoTextField.textColor = [UIColor greenColor];
//				[playerTwoTextField setValue:[UIColor greenColor] 
//								  forKeyPath:@"_placeholderLabel.textColor"];
                playerTwoTextField.layer.cornerRadius=8.0f;
                playerTwoTextField.layer.masksToBounds=YES;
                playerTwoTextField.layer.borderColor=[[UIColor greenColor]CGColor];
                playerTwoTextField.layer.borderWidth= 2.0f;
				[playerTwoTextField setAlpha:0];
                playerTwoTextField.autocorrectionType = UITextAutocorrectionTypeNo;
				[self addSubview:playerTwoTextField];
			}
			else 
				playerTwoTextField.hidden = NO;

			fadeInTwo = YES;
			startGameAndBackBtnShouldMove = YES;
//			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y + 130.0f);
//			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y + 130.0f);
			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y + 55.0f);
			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y + 55.0f);
			

			if ([playerOneTextField.text length] == 0) {
				playerOneTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		case 3:
			newCenterForSwitch = CGPointMake( slideGameTypePicker.center.x, 40.0f + slideGameTypePicker.center.y);
			newCenterForSwitchLabel = CGPointMake( multiplayerModeLabel.center.x, 40.0f + multiplayerModeLabel.center.y);
			newCenterForNumberOfQuestionsLabel = CGPointMake( numberOfQuestionsLabel.center.x, 40.0f + numberOfQuestionsLabel.center.y);
			 
			switchViewShouldMove = YES;
			
			//reposition add button
			removePlayerButtonShouldMove = YES;
			addPlayerButtonShouldMove = YES;
			newCenterForRemovePlayerButton = CGPointMake(buttonRemovePlayer.center.x, buttonRemovePlayer.center.y +40.0f);
			newCenterForAddPlayerButton = CGPointMake(buttonAddPlayer.center.x, buttonAddPlayer.center.y + 40.0f);
			
			if (!playerThreeTextField) {
				playerThreeTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + playersXOffset, 180 + playersYOffset, 150, 27)];
				playerThreeTextField.center = CGPointMake(([screen applicationFrame].size.width/2) - 10, 210 + playersYOffset);
				playerThreeTextField.clearsOnBeginEditing = YES;
				playerThreeTextField.tag = 103;
				playerThreeTextField.delegate = self;
				playerThreeTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"enter name"];
				playerThreeTextField.textAlignment = NSTextAlignmentCenter;
				playerThreeTextField.borderStyle = UITextBorderStyleRoundedRect;
//				playerThreeTextField.backgroundColor = [UIColor blueColor];
				playerThreeTextField.textColor = [UIColor blueColor];
//				[playerThreeTextField setValue:[UIColor blueColor] 
//									forKeyPath:@"_placeholderLabel.textColor"];
                playerThreeTextField.layer.cornerRadius=8.0f;
                playerThreeTextField.layer.masksToBounds=YES;
                playerThreeTextField.layer.borderColor=[[UIColor blueColor]CGColor];
                playerThreeTextField.layer.borderWidth= 2.0f;
				[playerThreeTextField setAlpha:0];
                playerThreeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
				[self addSubview:playerThreeTextField];
			}
			else {
				playerThreeTextField.hidden = NO;
			}
			
			fadeInThree = YES;
			startGameAndBackBtnShouldMove = YES;
			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y + 40.0f);
			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y + 40.0f);
			
			if ([playerTwoTextField.text length] == 0) {
				playerTwoTextField.text = [NSString stringWithFormat:@"%@ 2",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}

			break;
		case 4:
			newCenterForSwitch = CGPointMake( slideGameTypePicker.center.x, 40.0f + slideGameTypePicker.center.y);
			newCenterForSwitchLabel = CGPointMake( multiplayerModeLabel.center.x, 40.0f + multiplayerModeLabel.center.y);
			newCenterForNumberOfQuestionsLabel = CGPointMake( numberOfQuestionsLabel.center.x, 40.0f + numberOfQuestionsLabel.center.y);
			switchViewShouldMove = YES;
			//reposition add button
			removePlayerButtonShouldMove = YES;
			newCenterForRemovePlayerButton = CGPointMake(buttonRemovePlayer.center.x, buttonRemovePlayer.center.y +80.0f);

			if (!playerFourTextField) {
				playerFourTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + playersXOffset, 220 + playersYOffset, 150, 27)];
				playerFourTextField.center = CGPointMake(([screen applicationFrame].size.width/2) - 10, 250 + playersYOffset);
				playerFourTextField.clearsOnBeginEditing = YES;
				playerFourTextField.tag = 104;
				playerFourTextField.delegate = self;
				playerFourTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"enter name"];
				playerFourTextField.textAlignment = NSTextAlignmentCenter;
				playerFourTextField.borderStyle = UITextBorderStyleRoundedRect;
//				playerFourTextField.backgroundColor = [UIColor purpleColor];
				playerFourTextField.textColor = [UIColor purpleColor];
//				[playerFourTextField setValue:[UIColor purpleColor] 
//									forKeyPath:@"_placeholderLabel.textColor"];
                playerFourTextField.layer.cornerRadius=8.0f;
                playerFourTextField.layer.masksToBounds=YES;
                playerFourTextField.layer.borderColor=[[UIColor purpleColor]CGColor];
                playerFourTextField.layer.borderWidth= 2.0f;
				[playerFourTextField setAlpha:0];
				playerFourTextField.autocorrectionType = UITextAutocorrectionTypeNo;
				[self addSubview:playerFourTextField];
			}
			else {
				playerFourTextField.hidden = NO;
			}
			
			fadeInFour = YES;
			fadeOutAddPlayerButton = YES;
			startGameAndBackBtnShouldMove = NO;
//			newCenterForButtonStart = CGPointMake(buttonStart.center.x + 70.0f, buttonStart.center.y + 40.0f);
//			newCenterForButtonBack = CGPointMake(buttonBack.center.x - 70.0f, buttonBack.center.y - 30.0f);
			startGameAndBackBtnShouldChangeSize = YES;
			newFrameForButtonStart = CGRectMake(buttonStart.frame.origin.x  + 70.0f + 6.0f, buttonStart.frame.origin.y + 40.0f, buttonStart.frame.size.width - 30, buttonStart.frame.size.height);
			newFrameForButtonBack = CGRectMake(buttonBack.frame.origin.x - 70.0f + 16.0f, buttonBack.frame.origin.y - 15.0f, buttonBack.frame.size.width - 30, buttonBack.frame.size.height);
			if ([playerThreeTextField.text length] == 0) {
				playerThreeTextField.text = [NSString stringWithFormat:@"%@ 3",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		default:
			break;
	}
	

	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.5f];
	if (startGameAndBackBtnShouldChangeSize == YES) {
		buttonStart.frame = newFrameForButtonStart;
		buttonBack.frame = newFrameForButtonBack;
	}
	if (startGameAndBackBtnShouldMove == YES) {
		buttonStart.center = newCenterForButtonStart;
        m_loadingLabel.center = newCenterForButtonStart;
		buttonBack.center = newCenterForButtonBack;

	}
	if (addPlayerButtonShouldMove == YES) {
		buttonAddPlayer.center = newCenterForAddPlayerButton;	
	}
	if (removePlayerButtonShouldMove == YES) {
		buttonRemovePlayer.center = newCenterForRemovePlayerButton;
	}
	if (fadeOutAddPlayerButton == YES) {
		[buttonAddPlayer setAlpha:0];
		buttonRemovePlayer.center = newCenterForRemovePlayerButton; 
	}
	if (fadeInRemovePlayerButton == YES) {
		[buttonRemovePlayer setAlpha:1];
	}
	if (fadeInMultiplayerSwitch == YES) {
		[slideGameTypePicker setAlpha:1];
		[multiplayerModeLabel setAlpha:1];
		[numberOfQuestionsLabel setAlpha:1];
	}
	if(switchViewShouldMove == YES)
	{
		slideGameTypePicker.center = newCenterForSwitch;
		multiplayerModeLabel.center = newCenterForSwitchLabel;
		numberOfQuestionsLabel.center = newCenterForNumberOfQuestionsLabel;
	}
	[multiplayerModeLabel setAlpha:1];
	[slideGameTypePicker setAlpha:1];
	[numberOfQuestionsLabel setAlpha:1];
	
	[modeSwitch setAlpha:0];
	[switchLabel setAlpha:0];
	
	if (fadeInTwo == YES) {
		[playerTwoTextField setAlpha:1];
	}
	if (fadeInThree == YES) {
		[playerThreeTextField setAlpha:1];
	}
	if (fadeInFour == YES) {
		[playerFourTextField setAlpha:1];
	}
	[UIView commitAnimations];
	[screen release];
}

-(void)removePlayer:(id)Sender
{
	BOOL switchViewShouldMove = NO;
	BOOL startGameAndBackBtnShouldMove = NO;
	BOOL startGameAndBackBtnShouldChangeSize = NO;
	BOOL removePlayerButtonShouldMove = NO;
	BOOL addPlayerButtonShouldMove = NO;
	BOOL fadeInAddPlayerButton = NO;
	BOOL fadeOutMultiplayerSwitch = NO;
	BOOL fadeOutRemovePlayerButton = NO;
	BOOL fadeOutTwo = NO;
	BOOL fadeOutThree = NO;
	BOOL fadeOutFour = NO;
	BOOL setGameModeToLastStanding = NO;
	BOOL fadeInTrainingmodeSwitch = NO;
	CGPoint newCenterForSwitch;
	CGPoint newCenterForSwitchLabel;
	CGPoint newCenterFornumberOfQuestionsLabel;
	CGPoint newCenterForRemovePlayerButton;
	CGPoint newCenterForAddPlayerButton;
	CGPoint newCenterForButtonBack;
	CGPoint newCenterForButtonStart;
	CGRect newFrameForButtonStart;
	CGRect newFrameForButtonBack;
	
	if (numberOfPlayers > 1) {
		numberOfPlayers--;
	}
	
	switch (numberOfPlayers) {
		case 1:
            //text box one can not be edited
            playerOneTextField.userInteractionEnabled = NO;
            [playerOneTextField setAlpha:0.5];
            playerOneTextField.text = [[GlobalSettingsHelper Instance] GetPlayerID];
			infoOrGlobalIDLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"ID"],[[GlobalSettingsHelper Instance] GetPlayerID]];
            
			fadeInTrainingmodeSwitch = YES;
			
			fadeOutMultiplayerSwitch = YES;
			addPlayerButtonShouldMove = YES;
			newCenterForAddPlayerButton = CGPointMake(buttonAddPlayer.center.x, buttonAddPlayer.center.y - 40.0f);
			fadeOutRemovePlayerButton = YES;
			fadeOutTwo = YES;
			startGameAndBackBtnShouldMove = YES;
//			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y - 130.0f);
//			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y - 130.0f);
			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y - 55.0f);
			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y - 55.0f);
			setGameModeToLastStanding = YES;
			break;
		case 2:
			newCenterForSwitch = CGPointMake( slideGameTypePicker.center.x,slideGameTypePicker.center.y - 40.0f);
			newCenterForSwitchLabel = CGPointMake( multiplayerModeLabel.center.x, multiplayerModeLabel.center.y - 40.0f);
			newCenterFornumberOfQuestionsLabel = CGPointMake( numberOfQuestionsLabel.center.x, numberOfQuestionsLabel.center.y - 40.0f);
			switchViewShouldMove = YES;
			removePlayerButtonShouldMove = YES;
			addPlayerButtonShouldMove = YES;
			newCenterForRemovePlayerButton = CGPointMake(buttonRemovePlayer.center.x, buttonRemovePlayer.center.y -40.0f);
			newCenterForAddPlayerButton = CGPointMake(buttonAddPlayer.center.x, buttonAddPlayer.center.y - 40.0f);
			fadeOutThree = YES;
			startGameAndBackBtnShouldMove = YES;
			newCenterForButtonBack = CGPointMake(buttonBack.center.x, buttonBack.center.y - 40.0f);;
			newCenterForButtonStart = CGPointMake(buttonStart.center.x, buttonStart.center.y - 40.0f);;
			break;
		case 3:
			newCenterForSwitch = CGPointMake( slideGameTypePicker.center.x, slideGameTypePicker.center.y - 40.0f);
			newCenterForSwitchLabel = CGPointMake( multiplayerModeLabel.center.x, multiplayerModeLabel.center.y - 40.0f);
			newCenterFornumberOfQuestionsLabel = CGPointMake( numberOfQuestionsLabel.center.x, numberOfQuestionsLabel.center.y - 40.0f);
			switchViewShouldMove = YES;
			removePlayerButtonShouldMove = YES;
			newCenterForRemovePlayerButton = CGPointMake(buttonRemovePlayer.center.x, buttonRemovePlayer.center.y -80.0f);
			fadeOutFour = YES;
			fadeInAddPlayerButton = YES;
			startGameAndBackBtnShouldMove = NO;
			newCenterForButtonStart = CGPointMake(buttonStart.center.x - 70.0f, buttonStart.center.y - 40.0f);
			newCenterForButtonBack = CGPointMake(buttonBack.center.x + 70.0f, buttonBack.center.y + 15.0f);
			startGameAndBackBtnShouldChangeSize = YES;
			newFrameForButtonStart = CGRectMake(buttonStart.frame.origin.x  - 70.0f - 6.0f, buttonStart.frame.origin.y - 40.0f, buttonStart.frame.size.width + 30, buttonStart.frame.size.height);
			newFrameForButtonBack = CGRectMake(buttonBack.frame.origin.x + 70.0f - 16.0f, buttonBack.frame.origin.y  + 15.0f, buttonBack.frame.size.width + 30, buttonBack.frame.size.height);
			break;
		default:
			break;
	}
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:0.5f];
	if (startGameAndBackBtnShouldChangeSize == YES) {
		buttonStart.frame = newFrameForButtonStart;
		buttonBack.frame = newFrameForButtonBack;
	}
	if (addPlayerButtonShouldMove == YES) {
		buttonAddPlayer.center = newCenterForAddPlayerButton;
	}
	if (removePlayerButtonShouldMove == YES) {
		buttonRemovePlayer.center = newCenterForRemovePlayerButton;
	}
	if (fadeInAddPlayerButton) {
		[buttonAddPlayer setAlpha:1];
	}
	if (fadeOutRemovePlayerButton == YES) {
		[buttonRemovePlayer setAlpha:0];
	}
	if (fadeOutMultiplayerSwitch == YES) {
		[slideGameTypePicker setAlpha:0];
		[multiplayerModeLabel setAlpha:0];
		[numberOfQuestionsLabel setAlpha:0];
	}
	if(switchViewShouldMove == YES)
	{
		slideGameTypePicker.center = newCenterForSwitch;
		multiplayerModeLabel.center = newCenterForSwitchLabel;
		numberOfQuestionsLabel.center = newCenterFornumberOfQuestionsLabel;
	}
	if (fadeOutTwo == YES) {
		[playerTwoTextField setAlpha:0];
	}
	if (fadeOutThree == YES) {
		[playerThreeTextField setAlpha:0];
	}
	if (fadeOutFour == YES) {
		[playerFourTextField setAlpha:0];
	}
	if (fadeInTrainingmodeSwitch == YES) {
		[modeSwitch setAlpha:1];
		[switchLabel setAlpha:1];
	}
	

	if (startGameAndBackBtnShouldMove == YES) {
		buttonStart.center = newCenterForButtonStart;
        m_loadingLabel.center = newCenterForButtonStart;
		buttonBack.center = newCenterForButtonBack;
	}
	
	[UIView commitAnimations];
	


}

-(void) ShowLoadingGameObjects
{
	[buttonStart setAlpha:0];

	m_activityIndicator = [[UIActivityIndicatorView alloc] init];
	m_activityIndicator.frame  = CGRectMake(0,0,60,60);
	m_activityIndicator.center = buttonStart.center;
	m_activityIndicator.hidesWhenStopped  = YES;
	[self addSubview:m_activityIndicator];	
	[m_activityIndicator startAnimating];
	[self bringSubviewToFront:m_activityIndicator];
	
	m_loadingLabel = [[UILabel alloc] init];
	[m_loadingLabel setFrame:CGRectMake(0, 0, 250, 40)];
	m_loadingLabel.backgroundColor = [UIColor clearColor]; 
	m_loadingLabel.textColor = [UIColor redColor];
	[m_loadingLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	m_loadingLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	m_loadingLabel.layer.shadowOpacity = 1.0;
	m_loadingLabel.center = buttonStart.center;
	m_loadingLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Loading game objects"];
	m_loadingLabel.textAlignment = NSTextAlignmentCenter;		
	[self addSubview:m_loadingLabel];    

}

-(void) SetFinishedLoadingGameObjects
{

	[m_activityIndicator stopAnimating];
	[buttonStart setAlpha:1];
	m_loadingLabel.hidden = YES;
	[m_activityIndicator removeFromSuperview];
	[m_loadingLabel removeFromSuperview];
}

-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(TellParentToCleanUp)]; 
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void) FadeOutAndStartGame
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(TellParentToCleanUpAndStartGame)]; 
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void) TellParentToCleanUp
{
	if ([delegate respondsToSelector:@selector(cleanUpStartGameMenu)])
		[delegate cleanUpStartGameMenu];
}

-(void) TellParentToCleanUpAndStartGame
{
    if ([delegate respondsToSelector:@selector(cleanUpStartGameMenuAndStart:)])
        [delegate cleanUpStartGameMenuAndStart:m_game];
}


- (void)dealloc {
    [super dealloc];
}


@end
