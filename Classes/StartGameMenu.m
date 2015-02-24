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

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) { 

		UIScreen *screen = [[UIScreen mainScreen] retain];
		
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		self.opaque = YES;

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
	
	
	miniLabel = [[UILabel alloc] init];
	[miniLabel setFrame:CGRectMake(145, 18, 70, 30)];
	miniLabel.center = CGPointMake(([screen applicationFrame].size.width/2) + 10,35);
	miniLabel.backgroundColor = [UIColor clearColor]; 
	miniLabel.textColor = [UIColor redColor];
	[miniLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
	miniLabel.transform = CGAffineTransformMakeRotation( M_PI/4 );
	miniLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Level"],@"1"];
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
	difficultyLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Level"],@"1"];
	[self addSubview:difficultyLabel];
	
	slideDifficultyPicker = [[UISlider alloc] init];
	slideDifficultyPicker.frame  = CGRectMake(50 + sliderXOffset,60 + sliderYOffset,120,20);
	slideDifficultyPicker.center = CGPointMake([screen applicationFrame].size.width/2, 120 + sliderYOffset);
	slideDifficultyPicker.minimumValue = 1;
	slideDifficultyPicker.maximumValue = 5;
	slideDifficultyPicker.value = 1;
	[slideDifficultyPicker addTarget:self action:@selector(sliderDifficultyValueChanged:) forControlEvents:UIControlEventValueChanged];
	[self addSubview:slideDifficultyPicker];		
	
    /*
	modeLabel = [[UILabel alloc] init];
	[modeLabel setFrame:CGRectMake(0, 0, 200, 30)];
	modeLabel.center = CGPointMake(([screen applicationFrame].size.width/2)-50, 190 + playersYOffset + 20);
	modeLabel.textAlignment = NSTextAlignmentCenter;
	modeLabel.backgroundColor = [UIColor clearColor];
	modeLabel.textColor = [UIColor whiteColor];
	[modeLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	modeLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	modeLabel.layer.shadowOpacity = 1.0;
	modeLabel.layer.shadowRadius = 1.5;
	modeLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Training mode:"];
	[self addSubview:modeLabel];
	
	modeSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
	[modeSwitch addTarget: self action: @selector(flipMode:) forControlEvents:UIControlEventValueChanged];
	// Set the desired frame location of onoff here
	modeSwitch.on = NO; 
	modeSwitch.center = CGPointMake(([screen applicationFrame].size.width/2) +50, 190 + playersYOffset + 20);
	[self addSubview: modeSwitch];
    */
    
    
	borderLabel = [[UILabel alloc] init];
	[borderLabel setFrame:CGRectMake(0, 0, 200, 30)];
	borderLabel.center = CGPointMake(([screen applicationFrame].size.width/2)-50, 190 + playersYOffset - 20);
	borderLabel.textAlignment = NSTextAlignmentCenter;
	borderLabel.backgroundColor = [UIColor clearColor];
	borderLabel.textColor = [UIColor whiteColor];
	[borderLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
	borderLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
	borderLabel.layer.shadowOpacity = 1.0;
	borderLabel.layer.shadowRadius = 1.5;
	borderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Use borders:"];
	[self addSubview:borderLabel];
	
	borderSwitch = [[UISwitch alloc] initWithFrame: CGRectZero];
	//[borderSwitch addTarget: self action: @selector(flipMode:) forControlEvents:UIControlEventValueChanged];
	// Set the desired frame location of onoff here
	borderSwitch.on = YES;
	borderSwitch.center = CGPointMake(([screen applicationFrame].size.width/2) +50, 190 + playersYOffset - 20);
	[self addSubview: borderSwitch];
	
	
	buttonStart = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonStart addTarget:self action:@selector(startGame:) forControlEvents:UIControlEventTouchDown];
	[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
	buttonStart.frame = CGRectMake(60 + playersXOffset, 160 + playersYOffset, 150.0, 40.0);
    buttonStart.layer.borderWidth=1.0f;
    [buttonStart setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonStart.layer.borderColor=[[UIColor whiteColor] CGColor];
	buttonStart.center = CGPointMake([screen applicationFrame].size.width/2, 265 + playersYOffset);
    m_loadingLabel.center = buttonStart.center;
	[self addSubview:buttonStart];
	
	
	buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
    buttonBack.layer.borderWidth=1.0f;
    [buttonBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonBack.layer.borderColor=[[UIColor whiteColor] CGColor];
	buttonBack.frame = CGRectMake(60 + playersXOffset, 160 + playersYOffset, 150.0, 40.0);
	//buttonBack.center = CGPointMake([screen applicationFrame].size.width/2, 240 + playersYOffset);
	buttonBack.center = CGPointMake([screen applicationFrame].size.width/2, 320 + playersYOffset);
	[self addSubview:buttonBack];
	
	
    /*
	playerOneTextField = [[UITextField alloc] initWithFrame:CGRectMake(10 + playersXOffset, 100 + playersYOffset, 150, 27)];
	playerOneTextField.center = CGPointMake(([screen applicationFrame].size.width/2) - 10, 130 + playersYOffset);
	playerOneTextField.clearsOnBeginEditing = YES;
	playerOneTextField.tag = 101;
	playerOneTextField.delegate = self;
    [playerOneTextField setAlpha:0.5];
    
    
    playerOneTextField.text = [[GlobalSettingsHelper Instance] GetPlayerName];
	playerOneTextField.userInteractionEnabled = NO;
    
	playerOneTextField.borderStyle = UITextBorderStyleRoundedRect;
	playerOneTextField.textAlignment = NSTextAlignmentCenter;
	playerOneTextField.textColor = [UIColor redColor];
    playerOneTextField.layer.cornerRadius=8.0f;
    playerOneTextField.layer.masksToBounds=YES;
    playerOneTextField.layer.borderColor=[[UIColor redColor]CGColor];
    playerOneTextField.layer.borderWidth= 2.0f;
    playerOneTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	[self addSubview:playerOneTextField];*/
	

	slideGameTypePicker = [[UISlider alloc] init];
	slideGameTypePicker.frame  = CGRectMake(50 + sliderXOffset,60 + sliderYOffset,160,20);
	slideGameTypePicker.center = CGPointMake(([screen applicationFrame].size.width/2), 220 + switchYOffset);
	slideGameTypePicker.minimumValue = 1;
	slideGameTypePicker.maximumValue = 8;
	slideGameTypePicker.value = 1;
	[slideGameTypePicker addTarget:self action:@selector(sliderGameTypeValueChanged:) forControlEvents:UIControlEventValueChanged];
	[slideGameTypePicker setAlpha:0];
	[self addSubview:slideGameTypePicker];	
	
	[self setAlpha:0];
	
	[screen release];
}

/*
- (IBAction)flipMode:(id)sender {
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	
	
	
	if (modeSwitch.on) 
	{
		[miniLabel setAlpha:0];
		//[playerOneTextField setAlpha:0];
		[UIView setAnimationDidStopSelector:@selector(doMoveOn)];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start training"];
		[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start training"] forState:UIControlStateNormal];

	}
	else
	{
		[miniLabel setAlpha:1];
		//[playerOneTextField setAlpha:0.5];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start Game"];
		[buttonStart setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Start game"] forState:UIControlStateNormal];
	}
	
	[UIView commitAnimations];	
}
*/

- (IBAction) sliderDifficultyValueChanged:(UISlider *)sender {  
	[self UpdateSliderDifficultyValue];
}  


- (IBAction) sliderGameTypeValueChanged:(UISlider *)sender {  
	[self UpdateSliderGameTypeValue];
}  

-(void) UpdateSliderDifficultyValue
{

	miniLabel.text = [NSString stringWithFormat:@"%@: %i",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Level"],(int)[slideDifficultyPicker value]];
    difficultyLabel.text = [NSString stringWithFormat:@"%@: %i",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Difficulty"],(int) [slideDifficultyPicker value]];

}

-(void)goBack:(id)Sender
{
	[self FadeOut];
}



-(void) UpdateLabels
{
	slideDifficultyPicker.value = 1;
	[self UpdateSliderDifficultyValue];
	//modeLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Training mode:"];

	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	difficultyLabel.text = [NSString stringWithFormat:@"%@: %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Difficulty"],@"1"];
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

/*
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	switch (textField.tag) {
		case 101:
			if ([value length] == 0) {
				playerOneTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
			}
			break;
		default:
			break;
	}
	
	[textField resignFirstResponder];
	
	return YES;	
}
*/

-(void)startGame:(id)Sender
{

    m_player = [[Player alloc] initWithName:[[GlobalSettingsHelper Instance] GetPlayerName] andColor:[UIColor redColor] andPlayerSymbol:@"ArrowRed.png"];


	Difficulty vDifficulty = level1;

    if([slideDifficultyPicker value] >= 2.0)
    {
        vDifficulty = level2;
        if([slideDifficultyPicker value] >= 3.0)
        {
            vDifficulty = level3;
            if([slideDifficultyPicker value] >= 4.0)
            {
                vDifficulty = level4;
                if([slideDifficultyPicker value] >= 4.0)
                {
                    vDifficulty = level5;
                }
            }
        }
    }

	if (m_game == nil) {
		m_game = [[Game alloc] init] ;
	}

    /*
	if (modeSwitch.on == YES) 
		[m_game SetGameMode:trainingMode];
	else
		[m_game SetGameMode:regularMode];
    */
    
    
    [m_game SetGameMode:regularMode];
    
    if (borderSwitch.on == YES)
		[m_game SetMapBorder:YES];
	else
		[m_game SetMapBorder:NO];
	

	[m_game SetPlayer:m_player andDifficulty:vDifficulty];
	
	[self FadeOut];
	[((StartGameMenu*)self.superview) FadeOut];
	
	
	//need to be sure the keyboard is closed, its only for player games this is necessary
	//[playerOneTextField resignFirstResponder];

	[self FadeOutAndStartGame];
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
