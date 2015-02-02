//
//  HighscoreGlobalView.m
//  MQNorway
//
//  Created by knut dullum on 01/11/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "HighscoreGlobalView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "UISwitch-extended.h"
#import "GlobalSettingsHelper.h"
#import "EnumHelper.h"
#import "HighscoreService.h"

@interface HighscoreGlobalView ()

// Private properties
@property (strong, nonatomic) HighscoreService *highscoreService;

@end

@implementation HighscoreGlobalView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
        UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
		self.backgroundColor = lightBlueColor;
		
        m_showingLevel = level5;
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_centerX = [screen applicationFrame].size.width/2;
		m_centerY = [screen applicationFrame].size.height/2;
		
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 180, 40)];
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
		[self addSubview:headerLabel];
		
		subheaderLabel = [[UILabel alloc] init];
		[subheaderLabel setFrame:CGRectMake(40, 5, 70, 60)];
		subheaderLabel.backgroundColor = [UIColor clearColor]; 
		subheaderLabel.textColor = [UIColor redColor];
		[subheaderLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
		subheaderLabel.transform = CGAffineTransformMakeRotation( M_PI/4 );
		subheaderLabel.text = [EnumHelper difficultyToNiceString:m_showingLevel];
		subheaderLabelCenter = subheaderLabel.center;
		[self addSubview:subheaderLabel];
		
		nameLabels = [[NSMutableArray alloc] init];
		nameLabelsCenter = [[NSMutableArray alloc] init];
		easyQLabels = [[NSMutableArray alloc] init];
		qLabelsCenter = [[NSMutableArray alloc] init];
		timeLabels = [[NSMutableArray alloc] init];
		timeLabelsCenter = [[NSMutableArray alloc] init];
		pointsLabels = [[NSMutableArray alloc] init];
		pointsLabelsCenter = [[NSMutableArray alloc] init];
		
		int labelsXoffset = 25;
		int labeslYoffset = 0;
		
        self.highscoreService = [HighscoreService defaultService];
		
		int yPos = 0;
		NSValue *tempval;
		for (int i = 0; i < 11; i++) {
			
			//set labels for names
			UILabel *playerNameLabel = [[UILabel alloc] init];
			[playerNameLabel setFrame:CGRectMake(3 + labelsXoffset, 100 + yPos + labeslYoffset, 120, 20)];
			playerNameLabel.backgroundColor = [UIColor clearColor]; 
			playerNameLabel.textColor = [UIColor whiteColor];
			[playerNameLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerNameLabel];
			[nameLabels addObject:playerNameLabel];
			tempval = [[NSValue valueWithCGPoint:playerNameLabel.center] retain];
			[nameLabelsCenter addObject:tempval];
			[tempval release];
			[playerNameLabel release];
			
			//set labels for questions passed
			UILabel *playerQLabel = [[UILabel alloc] init];
			[playerQLabel setFrame:CGRectMake(140 + labelsXoffset, 100 + yPos + labeslYoffset, 50, 20)];
			playerQLabel.backgroundColor = [UIColor clearColor]; 
			playerQLabel.textColor = [UIColor whiteColor];
			[playerQLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerQLabel];
			[easyQLabels addObject:playerQLabel];
			tempval = [[NSValue valueWithCGPoint:playerQLabel.center] retain];
			[qLabelsCenter addObject:tempval];
			[tempval release];
			[playerQLabel release];
			
			
			//time labels
			UILabel *playerTimeLabel = [[UILabel alloc] init];
			[playerTimeLabel setFrame:CGRectMake(220 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerTimeLabel.backgroundColor = [UIColor clearColor]; 
			playerTimeLabel.textColor = [UIColor whiteColor];
			[playerTimeLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerTimeLabel];
			[timeLabels addObject:playerTimeLabel];
			tempval = [[NSValue valueWithCGPoint:playerTimeLabel.center] retain];
			[timeLabelsCenter addObject:tempval];
			[tempval release];
			[playerTimeLabel release];
			
            /*
			UILabel *playerPointsLabel = [[UILabel alloc] init];
			[playerPointsLabel setFrame:CGRectMake(280 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerPointsLabel.backgroundColor = [UIColor clearColor]; 
			playerPointsLabel.textColor = [UIColor whiteColor];
			[playerPointsLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerPointsLabel];
			[pointsLabels addObject:playerPointsLabel];
			tempval = [[NSValue valueWithCGPoint:playerPointsLabel.center] retain];
			[pointsLabelsCenter addObject:tempval];
			[tempval release];
			[playerPointsLabel release];*/
			
			yPos += 25;
		}
		
		UILabel *headerHighscorePosition = [[UILabel alloc] init];
		[headerHighscorePosition setFrame:CGRectMake(3, 60, 50, 40)];
		headerHighscorePosition.backgroundColor = [UIColor clearColor]; 
		headerHighscorePosition.textColor = [UIColor yellowColor];
		[headerHighscorePosition setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerHighscorePosition.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Pos./Name"];
		headerHighscorePosition.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerHighscorePosition.layer.shadowOpacity = 1.0;
		[self addSubview:headerHighscorePosition];
		
		UILabel *headerQuestionsAnsw = [[UILabel alloc] init];
		[headerQuestionsAnsw setFrame:CGRectMake(118, 60, 90, 40)];
		headerQuestionsAnsw.backgroundColor = [UIColor clearColor]; 
		headerQuestionsAnsw.textColor = [UIColor yellowColor];
		[headerQuestionsAnsw setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerQuestionsAnsw.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No. answers"];
		headerQuestionsAnsw.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerQuestionsAnsw.layer.shadowOpacity = 1.0;
		[self addSubview:headerQuestionsAnsw];
		
		
		UILabel *headerTime = [[UILabel alloc] init];
		[headerTime setFrame:CGRectMake(221, 60, 90, 40)];
		headerTime.backgroundColor = [UIColor clearColor]; 
		headerTime.textColor = [UIColor yellowColor];
		[headerTime setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerTime.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time"];
		headerTime.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerTime.layer.shadowOpacity = 1.0;
		[self addSubview:headerTime];
		
		/*
		headerScore = [[UILabel alloc] init];
		[headerScore setFrame:CGRectMake(275, 60, 90, 40)];
		headerScore.backgroundColor = [UIColor clearColor]; 
		headerScore.textColor = [UIColor yellowColor];
		[headerScore setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerScore.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Score"];
		headerScore.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerScore.layer.shadowOpacity = 1.0;
		[self addSubview:headerScore];*/
		
		
		
		button_levelDown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelDown addTarget:self action:@selector(levelDown) forControlEvents:UIControlEventTouchDown];
		[button_levelDown setTitle:@"<- Level down" forState:UIControlStateNormal];
        button_levelDown.layer.borderWidth=1.0f;
        [button_levelDown setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button_levelDown.layer.borderColor=[[UIColor whiteColor] CGColor];
		button_levelDown.frame = CGRectMake(5, 385, 140, 40);
		button_levelDownCenter = button_levelDown.center;
		[self addSubview:button_levelDown];
		
		button_levelUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelUp addTarget:self action:@selector(levelUp) forControlEvents:UIControlEventTouchDown];
		[button_levelUp setTitle:@"Level up ->" forState:UIControlStateNormal];
        button_levelUp.layer.borderWidth=1.0f;
        [button_levelUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button_levelUp.layer.borderColor=[[UIColor whiteColor] CGColor];
		button_levelUp.frame = CGRectMake(170, 385, 140, 40);
		button_levelUpCenter = button_levelUp.center;
		[self addSubview:button_levelUp];
		
		button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
		[button_levelUp setAlpha:0];
		
        /*
		switchShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[switchShowButton addTarget:self action:@selector(goSwitchShow:) forControlEvents:UIControlEventTouchDown];
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View top ten"] forState:UIControlStateNormal];
		switchShowButton.frame = CGRectMake([screen applicationFrame].size.width/2 - (180/2), 390.0, 180.0, 40.0);
        switchShowButton.layer.borderWidth=1.0f;
        [switchShowButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        switchShowButton.layer.borderColor=[[UIColor whiteColor] CGColor];
		[self addSubview:switchShowButton];
		showTopTen = false;
        */
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
        buttonBack.layer.borderWidth=1.0f;
        [buttonBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        buttonBack.layer.borderColor=[[UIColor whiteColor] CGColor];
		buttonBack.frame = CGRectMake([screen applicationFrame].size.width/2 - (180/2), 435.0, 180.0, 40.0);
		[self addSubview:buttonBack];
		
		

		
		m_activityIndicator = [[UIActivityIndicatorView alloc] init];
		m_activityIndicator.frame  = CGRectMake(0,0,60,60);
		m_activityIndicator.center = CGPointMake([screen applicationFrame].size.width/2,[screen applicationFrame].size.height/2);
		m_activityIndicator.hidesWhenStopped  = YES;
		[self addSubview:m_activityIndicator];	
		[self bringSubviewToFront:m_activityIndicator];

        [self showPlayerHighscore:@5];

		[screen release];
		[self setAlpha:0];
    }
    return self;
}

-(void) levelUp
{
    [button_levelUp setUserInteractionEnabled:TRUE];
    [button_levelDown setUserInteractionEnabled:TRUE];
	//[switchShowButton setUserInteractionEnabled:FALSE];
    if (m_showingLevel == level1) {
		m_showingLevel = level2;
		[self changeLevel];
	}
	else  if(m_showingLevel == level2){
		m_showingLevel = level3;
		[self changeLevel];
	}
	else  if(m_showingLevel == level3){
		m_showingLevel = level4;
		[self changeLevel];
	}
	else  if(m_showingLevel == level4){
        [button_levelUp setUserInteractionEnabled:FALSE];
		m_showingLevel = level5;
		[self changeLevel];
	}
}

-(void) levelDown
{
	[button_levelUp setUserInteractionEnabled:TRUE];
    [button_levelDown setUserInteractionEnabled:TRUE];
	//[switchShowButton setUserInteractionEnabled:FALSE];
	if (m_showingLevel == level5) {
		m_showingLevel = level4;
		[self changeLevel];
	}
	else if(m_showingLevel == level4){
		m_showingLevel = level3;
		[self changeLevel];
	}
	else if(m_showingLevel == level3){
		m_showingLevel = level2;
		[self changeLevel];
	}
	else if(m_showingLevel == level2){
        [button_levelDown setUserInteractionEnabled:FALSE];
		m_showingLevel = level1;
		[self changeLevel];
	}
}

-(void) clearResults
{

	for (int i = 0; i < 11; i++) {
				
		UILabel *nameTempLabel = [[nameLabels objectAtIndex:i] retain];
		nameTempLabel.text = @"";
		[nameTempLabel release];	
		
		UILabel *answersLabel = [[easyQLabels objectAtIndex:i]retain];
		answersLabel.text = @"";
		[answersLabel release];

		UILabel *timeLabel = [[timeLabels objectAtIndex:i]retain];
		timeLabel.text = @"";
		[timeLabel release];
	
	}

}

-(void) changeLevel
{
	[self clearResults];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(finishedMovingLabelsIn)]; 
	CGPoint centerPoint = CGPointMake(m_centerX, m_centerY);
    
	NSString *levelString = @"easy";
	NSNumber* level = @1;
    switch (m_showingLevel) {
		case level1:
			button_levelUp.center = CGPointMake(m_centerX, button_levelUp.frame.origin.y + (button_levelUp.frame.size.height/2) );
			[button_levelDown setAlpha:0];
			break;
		case level2:
        case level3:
        case level4:
			button_levelUp.center = button_levelUpCenter;
			[button_levelUp setAlpha:1];
			button_levelDown.center = button_levelDownCenter;
			[button_levelDown setAlpha:1];
			break;
		case level5:
			button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
			[button_levelUp setAlpha:0];
		default:
			break;
	}
    levelString = [EnumHelper difficultyToNiceString:m_showingLevel] ;
    
	[subheaderLabel setAlpha:0];
	subheaderLabel.center = centerPoint;
	
    [self showPlayerHighscore:[NSNumber numberWithInt:m_showingLevel]];
}

-(void) finishedMovingLabelsIn
{
    subheaderLabel.text = [EnumHelper difficultyToNiceString:m_showingLevel];
	subheaderLabel.center = CGPointMake(m_centerX, subheaderLabel.frame.origin.y + (subheaderLabel.frame.size.height/2));
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[subheaderLabel setAlpha:1];
	subheaderLabel.center = subheaderLabelCenter;
	[UIView commitAnimations];	
}

-(void) showPlayerHighscore:(NSNumber*) level
{
	[self clearResults];
	[m_activityIndicator startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", level, @"level",nil];
    
    [self.highscoreService getHigscoreForPlayerAndLevel:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         
         [m_activityIndicator stopAnimating];
         if (error)
         {
             NSLog(@"Error %@",error);
             NSString* errorMessage = @"There was a problem! ";
             errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
             UIAlertView* myAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Error!"
                                     message:errorMessage
                                     delegate:nil
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles:nil];
             [myAlert show];
             
             
             
         }
         else {
             
             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             //NSLog(@"The datastring : %@",newStr);
             
              //remove front [ and back ] characters
              if ([newStr rangeOfString: @"]"].length >0) {
              [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
              [newStr deleteCharactersInRange: NSMakeRange(0,1)];
              NSLog(@"The datastring : %@",newStr);
              }
              
              NSMutableArray* dataArray = [[NSMutableArray alloc] init];
             
             int ind = 0;
              while ([newStr rangeOfString: @"}"].length >0) {
              NSRange match = [newStr rangeOfString: @"}"];
              NSString* rowSubstring1 = [newStr substringWithRange:NSMakeRange(0, match.location+1)];
              NSLog(@"The substring1 : %@",rowSubstring1);
              
              NSData *jsonData = [rowSubstring1 dataUsingEncoding:NSUTF8StringEncoding];
              NSDictionary *jsonObject=[NSJSONSerialization
              JSONObjectWithData:jsonData
              options:NSJSONReadingMutableLeaves
              error:nil];
              NSLog(@"jsonObject is %@",jsonObject);
              
              
                  
              [dataArray addObject:jsonObject];
              if ([newStr rangeOfString: @"}"].location + 2 < newStr.length) {
                  [newStr deleteCharactersInRange: NSMakeRange(0, match.location + 2)];
                }
              else{
                  [newStr deleteCharactersInRange: NSMakeRange(0, newStr.length)];
              }
              
                  UILabel *playerNameLabel = [[nameLabels objectAtIndex:ind] retain];
                  if ([[jsonObject objectForKey:@"userid"] isEqualToString:playerId]) {
                      [playerNameLabel setText:[NSString stringWithFormat:@"%@. %@",[jsonObject objectForKey:@"rank"],@"You/me"]];
                  }
                  else
                  {
                      [playerNameLabel setText:[NSString stringWithFormat:@"%@. %@",[jsonObject objectForKey:@"rank"],[jsonObject objectForKey:@"username"]]];
                  }
                  
                  
                  
                  [playerNameLabel release];
                  
                  UILabel *questionsLabel = [[easyQLabels objectAtIndex:ind] retain];
                  [questionsLabel setText:[NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"answeredquestions"]]];
                  [questionsLabel release];

                  UILabel *secondsLabel = [[timeLabels objectAtIndex:ind] retain];
                  [secondsLabel setText:[NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"seconds"]]];
                  [secondsLabel release];

                  ind ++;
              }
             
             
              //------------------------single value
             
             //NSData *jsonData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
             /*
              NSDictionary *jsonObject=[NSJSONSerialization
              JSONObjectWithData:jsonData
              options:NSJSONReadingMutableLeaves
              error:nil];*/
             /*
             NSDictionary *jsonObject=[NSJSONSerialization
                                       JSONObjectWithData:jsonData
                                       options:NSJSONWritingPrettyPrinted
                                       error:nil];
             NSLog(@"jsonObject is %@",jsonObject);
             
             NSString* userId = [jsonObject valueForKey:@"userid"];
             NSInteger npb = [[jsonObject valueForKey:@"newpersonalbest"] intValue];
             NSInteger rank = [[jsonObject valueForKey:@"rank"] intValue];
             NSInteger seconds = [[jsonObject objectForKey:@"seconds"] intValue];
             id questionsAnswered = [[jsonObject objectForKey:@"answeredquestions"] intValue];
             
             NSString* successMessage = [NSString stringWithFormat:@"Rank: %@  %ld items marked as complete", @"bal",(long)seconds];
             UIAlertView* myAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Success!"
                                     message:successMessage
                                     delegate:nil
                                     cancelButtonTitle:@"Okay"
                                     otherButtonTitles:nil];
             
             [myAlert show];
             */
             
         }
         
     }];
    
    
    
}

/*
-(void) showTopTen
{
	[self clearResults];
	[m_activityIndicator startAnimating];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Top ten"];
}
*/

-(void) UpdateLabels
{
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
}


//- (void)webViewDidFinishLoad:(UIWebView *)wv {
//	[loadingLabel setAlpha:0];
//	[m_activityIndicator stopAnimating];
//	[m_activityIndicator setAlpha:0];
//    NSLog (@"webViewDidFinishLoad");
//    //[activityIndicator stopAnimating]; bundle:[NSBundle mainBundle]
//}



-(void)goBack:(id)Sender
{
	[self FadeOut];
}

/*
-(void) goSwitchShow:(id)Sender
{
	[button_levelDown setUserInteractionEnabled:FALSE];
	[button_levelUp setUserInteractionEnabled:FALSE];
	[switchShowButton setUserInteractionEnabled:FALSE];
	if (showTopTen) {
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View top ten"] forState:UIControlStateNormal];
		[self showPlayerHighscore];
		showTopTen = FALSE;
	}
	else {
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View your position"] forState:UIControlStateNormal];
		showTopTen = TRUE;
		[self showTopTen];
	}
}
*/


-(void) FadeIn
{
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

-(void) TellParentToCleanUp
{
	if ([delegate respondsToSelector:@selector(cleanUpHigscoreGlobalView)])
		[delegate cleanUpHigscoreGlobalView];
}


#define HORIZ_SWIPE_DRAG_MIN 100

BOOL isProcessingListMove;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self];
	if(startTouchPosition.x != newTouchPosition.x || startTouchPosition.y != newTouchPosition.y) {
		isProcessingListMove = NO;
	}
	startTouchPosition = [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = touches.anyObject;
	CGPoint currentTouchPosition = [touch locationInView:self];
	
	// If the swipe tracks correctly.
	double diffx = startTouchPosition.x - currentTouchPosition.x + 0.1; // adding 0.1 to avoid division by zero
	double diffy = startTouchPosition.y - currentTouchPosition.y + 0.1; // adding 0.1 to avoid division by zero
	
	if(abs(diffx / diffy) > 1 && abs(diffx) > HORIZ_SWIPE_DRAG_MIN)
	{
		// It appears to be a swipe.
		if(isProcessingListMove) {
			// ignore move, we're currently processing the swipe
			return;
		}
		
		if (startTouchPosition.x < currentTouchPosition.x) {
			isProcessingListMove = YES;
			[self levelDown];
			return;
		}
		else {
			isProcessingListMove = YES;
			[self levelUp];
			return;
		}
	}
	else if(abs(diffy / diffx) > 1)
	{
		isProcessingListMove = YES;
		[super touchesMoved:touches	withEvent:event];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	isProcessingListMove = NO;
	[super touchesEnded:touches withEvent:event];
}


//fails , not in use
- (void)dealloc {
	[pathEasy release];
	[pathMedium release];
	[pathHard release];
	
    [super dealloc];
}
@end
