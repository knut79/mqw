//
//  TakeChallenge.m
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "TakeChallenge.h"
#import "GlobalSettingsHelper.h"
#import "LocationsHelper.h"
#import "ChallengeService.h"

@interface TakeChallenge ()

// Private properties
@property (strong, nonatomic) ChallengeService *challengeService;

@end

@implementation TakeChallenge
@synthesize m_game;
@synthesize staticChallengesTableView;
@synthesize dynamicChallengesTableView;
@synthesize backButton;
@synthesize delegate;
@synthesize statusButton;
@synthesize staticChallengesHeader;
@synthesize dynamicChallengesHeader;
@synthesize retryButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        staticChallengeDataCache = [[NSMutableDictionary alloc] init];
        dynamicChallengeDataCache = [[NSMutableDictionary alloc] init];
        currentQuestonIds = [[NSMutableArray alloc] init];
        retryButton.hidden = YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (IBAction)statusButtonPushed:(id)sender {

    if (challengeStatusView == nil) {
        challengeStatusView = [[ChallengeStatusView alloc] initWithFrame:[self.view frame]];
        [challengeStatusView setDelegate:self];
        [self.view addSubview:challengeStatusView];
        [challengeStatusView FadeIn];
    }
    else
    {
        [challengeStatusView FadeIn];
    }
}

-(void) cleanUpChallengeStatusView
{
    [challengeStatusView release];
    [challengeStatusView removeFromSuperview];
    challengeStatusView = nil;
}



#pragma mark - View lifecycle

- (void)viewDidLoad
{

    UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
    self.view.backgroundColor = lightBlueColor;
    
    
    [super viewDidLoad];
    
    [self.view setAlpha:0];
    
    dynamicChallengesHeader.backgroundColor = [UIColor clearColor];
    dynamicChallengesHeader.textColor = [UIColor whiteColor];
    dynamicChallengesHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
    dynamicChallengesHeader.layer.shadowOpacity = 1.0;

    staticChallengesHeader.backgroundColor = [UIColor clearColor];
    staticChallengesHeader.textColor = [UIColor whiteColor];
    staticChallengesHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
    staticChallengesHeader.layer.shadowOpacity = 1.0;
    
    retryButton.layer.borderWidth=1.0f;
    [retryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    retryButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    backButton.layer.borderWidth=1.0f;
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    
    statusButton.layer.borderWidth=1.0f;
    [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    statusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    datasourceStaticArray = [[NSMutableArray alloc] init];
    datasourceDynamicArray = [[NSMutableArray alloc] init];
    
    self.challengeService = [ChallengeService defaultService];
    
 
    
    [self getStaticChallenges];
    [self getDynamicChallenges];
}

-(void) FadeIn
{
    self.view.hidden = NO;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.view setAlpha:1];
    [UIView commitAnimations];
}


- (void)viewDidUnload
{
    [self setStaticChallengesTableView:nil];
    [self setBackButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


-(void) getStaticChallenges
{
    [activityIndicatorStaticChallenges setAlpha:1];
	[activityIndicatorStaticChallenges startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    /*
    NSDictionary *jsonDictionaryTest = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id",nil];
    
    
    [self.challengeService insertTestData:jsonDictionaryTest completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         if (error)
         {
             NSLog(@"Error %@",error);
             
             [activityIndicatorStaticChallenges stopAnimating];
             [activityIndicatorStaticChallenges setAlpha:0];
             
             
             NSString* errorMessage = @"Problem collecting data! ";
             //errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
             UIAlertView* myAlert = [[UIAlertView alloc]
                                     initWithTitle:@"Error!"
                                     message:errorMessage
                                     delegate:nil
                                     cancelButtonTitle:@"Push retry"
                                     otherButtonTitles:nil];
             [myAlert show];
             
             retryButton.hidden = NO;
         }
     }];
    */
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id",@"true",@"getcompleted",@"true",@"getnotcompleted",nil];
    
    [self.challengeService getStaticChallengesForUser:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         if (error)
         {
             NSLog(@"Error %@",error);

                 [activityIndicatorStaticChallenges stopAnimating];
                 [activityIndicatorStaticChallenges setAlpha:0];

             
                 NSString* errorMessage = @"Problem collecting data! ";
                 //errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
                 UIAlertView* myAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error!"
                                         message:errorMessage
                                         delegate:nil
                                         cancelButtonTitle:@"Push retry"
                                         otherButtonTitles:nil];
                 [myAlert show];
             
             retryButton.hidden = NO;
         }
         else {
             [activityIndicatorStaticChallenges stopAnimating];
             [activityIndicatorStaticChallenges setAlpha:0];

             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             retryButton.hidden = YES;
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
                 
                 
                [datasourceStaticArray addObject:[jsonObject objectForKey:@"title"]];
                [staticChallengeDataCache setValue:[[jsonObject objectForKey:@"questionIds"] componentsSeparatedByString:@";"] forKey:[jsonObject objectForKey:@"title"]];
                 if ([jsonObject objectForKey:@"borders"] != NULL) {
                     [staticChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                 }
                 else
                 {
                     [staticChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                 }
                 
                 if ([jsonObject objectForKey:@"completed"] != NULL) {
                     [staticChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                 }
                 else
                 {
                     [staticChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                 }
                 
                 
                 ind ++;
             }
             [staticChallengesTableView reloadData];
         }
         
     }];
}


-(void) getDynamicChallenges
{
    [activityIndicatorDynamicChallenge setAlpha:1];
	[activityIndicatorDynamicChallenge startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id",nil];
    
    [self.challengeService getDynamicChallengesForUser:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         if (error)
         {
             NSLog(@"Error %@",error);

                 [activityIndicatorDynamicChallenge stopAnimating];
                 [activityIndicatorDynamicChallenge setAlpha:0];
             
             
                 NSString* errorMessage = @"Problem collecting data!";
                 //errorMessage = [errorMessage stringByAppendingString:[error localizedDescription]];
                 UIAlertView* myAlert = [[UIAlertView alloc]
                                         initWithTitle:@"Error!"
                                         message:errorMessage
                                         delegate:nil
                                         cancelButtonTitle:@"Push retry"
                                         otherButtonTitles:nil];
                 [myAlert show];
             
             retryButton.hidden = NO;
             
         }
         else {
             retryButton.hidden = YES;
             [activityIndicatorDynamicChallenge stopAnimating];
             [activityIndicatorDynamicChallenge setAlpha:0];
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
                 

                 [datasourceDynamicArray addObject:[jsonObject objectForKey:@"title"]];
                 [dynamicChallengeDataCache setValue:[[jsonObject objectForKey:@"questionIds"] componentsSeparatedByString:@";"] forKey:[jsonObject objectForKey:@"title"]];
                 if ([jsonObject objectForKey:@"borders"] != NULL) {
                     [dynamicChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                 }
                 else
                 {
                     [dynamicChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"borders"]];
                 }
                 
                 if ([jsonObject objectForKey:@"completed"] != NULL) {
                     [dynamicChallengeDataCache setValue:@YES forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                 }
                 else
                 {
                     [dynamicChallengeDataCache setValue:@NO forKey:[NSString stringWithFormat:@"%@_%@",[jsonObject objectForKey:@"title"],@"completed"]];
                 }
                 
                 
                 ind ++;
             }
             [dynamicChallengesTableView reloadData];
         }
         
     }];
}

 
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == staticChallengesTableView)
    {
        return [datasourceStaticArray count];
    }
    else
    {
        return [datasourceDynamicArray count];
    }
    
}

// Customize the appearance of table view cells.

- (ColorTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ColorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell = [[[ColorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    //cell.textLabel.text = [NSString	 stringWithFormat:@"Cell Row #%d", [indexPath row]];
    if(tableView == staticChallengesTableView)
    {
        cell.textLabel.text = [NSString	 stringWithFormat:@"%@",[datasourceStaticArray objectAtIndex:[indexPath row]]];
        currentCompletedValue = [[staticChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceStaticArray objectAtIndex:[indexPath row] ],@"completed"]] boolValue];
    }
    else
    {
        currentCompletedValue = [[dynamicChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceDynamicArray objectAtIndex:[indexPath row] ],@"completed"]] boolValue];
        cell.textLabel.text = [NSString	 stringWithFormat:@"%@",[datasourceDynamicArray objectAtIndex:[indexPath row]]];
    }
    
    
    //try setting color

    if (([indexPath row] % 2) == 0)
    {
        if (currentCompletedValue)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }

        cell.textLabel.textColor = [UIColor whiteColor];
        //cell.backgroundColor = lightBlueColor;
        [cell setCellColor:[UIColor lightGrayColor ] ];

    }
    else
    {
        if (currentCompletedValue)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        [cell setCellColor:[ UIColor grayColor ] ];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
    
    NSString *alertString;
    if(tableView == staticChallengesTableView)
    {
        isStaticChallengeMode = YES;
        alertString = [NSString stringWithFormat:@"Clicked on %@", [datasourceStaticArray objectAtIndex:[indexPath row]]];
    	alertStaticChallenge = [[UIAlertView alloc] initWithTitle:alertString message:[NSString stringWithFormat:@"Take challenge %@",[datasourceStaticArray objectAtIndex:[indexPath row]]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        currentQuestonIds = [staticChallengeDataCache objectForKey:[datasourceStaticArray objectAtIndex:[indexPath row]]];
        currentBorderValue = [[staticChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceStaticArray objectAtIndex:[indexPath row] ],@"borders"]] boolValue];
        currentCompletedValue = [[staticChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceStaticArray objectAtIndex:[indexPath row] ],@"completed"]] boolValue];
        [alertStaticChallenge show];
    	[alertStaticChallenge release];
    }
    else
    {
        isStaticChallengeMode = NO;
        alertString = [NSString stringWithFormat:@"Clicked on %@", [datasourceDynamicArray objectAtIndex:[indexPath row]]];
    	alertDynamicChallenge = [[UIAlertView alloc] initWithTitle:alertString message:[NSString stringWithFormat:@"Take challenge by %@",[datasourceDynamicArray objectAtIndex:[indexPath row]]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        currentQuestonIds = [dynamicChallengeDataCache objectForKey:[datasourceDynamicArray objectAtIndex:[indexPath row]]];
        currentBorderValue = [[dynamicChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceDynamicArray objectAtIndex:[indexPath row] ],@"borders"]] boolValue];
        currentCompletedValue = [[dynamicChallengeDataCache objectForKey:[NSString stringWithFormat:@"%@_%@",[datasourceDynamicArray objectAtIndex:[indexPath row] ],@"completed"]] boolValue];
        [alertDynamicChallenge show];
    	[alertDynamicChallenge release];
    }
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{

		if(buttonIndex == 0)
		{
			NSLog(@"no button was pressed\n");
            [staticChallengesTableView reloadData];
            [dynamicChallengesTableView reloadData];
            
		}
		else
		{
			NSLog(@"yes button was pressed\n");
            
            if (m_game == nil) {
                m_game = [[Game alloc] init] ;
            }
            
            [[LocationsHelper Instance] CollectQuestionsOnIds:currentQuestonIds];
            if (isStaticChallengeMode) {
                [m_game SetGameMode:staticChallengeMode];
            }
            else
            {
               [m_game SetGameMode:dynamicChallengeMode];
            }
            
            [m_game SetMapBorder:currentBorderValue];

            
            Difficulty vDifficulty = level1;
            Player* m_player = [[Player alloc] initWithName:[[GlobalSettingsHelper Instance] GetPlayerName] andColor:[UIColor redColor] andPlayerSymbol:@"ArrowRed.png"];
            
            [m_game SetPlayer:m_player andDifficulty:vDifficulty];

            
            [self.view setAlpha:0];
            //[self dealloc];
            
            if ([delegate respondsToSelector:@selector(cleanUpStartGameMenuAndStart:)])
                [delegate cleanUpStartGameMenuAndStart:m_game];
            
            

		}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [staticChallengesTableView release];
    [backButton release];
    [activityIndicatorStaticChallenges release];
    [activityIndicatorDynamicChallenge release];
    [statusButton release];
    [staticChallengesHeader release];
    [dynamicChallengesHeader release];
    [dynamicChallengesTableView release];
    [retryButton release];
    [super dealloc];
}
- (IBAction)backButtonPushed:(id)sender {
    /*
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpTakeChallengeViewCtrl)])
        [delegate cleanUpTakeChallengeViewCtrl];*/
    [self FadeOut];
}


-(void) FadeOut
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(cleanUpTakeChallengeViewCtrl)];
    [self.view setAlpha:0];
    [UIView commitAnimations];
}


- (IBAction)retryButtonPushed:(id)sender {
    [self getStaticChallenges];
    [self getDynamicChallenges];
}
@end
