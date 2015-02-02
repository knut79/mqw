//
//  TakeChallenge.m
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "TakeChallenge.h"
#import "GlobalSettingsHelper.h"

#import "HighscoreService.h"

@interface TakeChallenge ()

// Private properties
@property (strong, nonatomic) HighscoreService *highscoreService;

@end

@implementation TakeChallenge
@synthesize m_game;
@synthesize staticChallengesTableView;
@synthesize backButton;
@synthesize delegate;
@synthesize statusButton;
@synthesize staticChallengesHeader;
@synthesize dynamicChallengesHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        

        

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
    
    dynamicChallengesHeader.backgroundColor = [UIColor clearColor];
    dynamicChallengesHeader.textColor = [UIColor whiteColor];
    dynamicChallengesHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
    dynamicChallengesHeader.layer.shadowOpacity = 1.0;

    staticChallengesHeader.backgroundColor = [UIColor clearColor];
    staticChallengesHeader.textColor = [UIColor whiteColor];
    staticChallengesHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
    staticChallengesHeader.layer.shadowOpacity = 1.0;
    
    getStaticChallengesRetry = 0;
    getDynamicChallengesRetry = 0;
    
    backButton.layer.borderWidth=1.0f;
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    backButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    
    statusButton.layer.borderWidth=1.0f;
    [statusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    statusButton.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    datasourceArray = [[NSMutableArray alloc] init];
    
    self.highscoreService = [HighscoreService defaultService];
    
    
    [self getStaticChallenges];
    //[self getChallengesResults];
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
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", @1, @"level",nil];
    
    [self.highscoreService getHigscoreForPlayerAndLevel:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         
         [activityIndicatorStaticChallenges stopAnimating];
         [activityIndicatorStaticChallenges setAlpha:0];
         if (error)
         {
             NSLog(@"Error %@",error);
             if (getStaticChallengesRetry < 2 ) {
                 getStaticChallengesRetry++;
                 [self getStaticChallenges];
             }
             else
             {
                 getStaticChallengesRetry = 0;
                 
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
         }
         else {
             getStaticChallengesRetry = 0;
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
                 
                 [datasourceArray addObject:[jsonObject objectForKey:@"username"]];
                 
                 ind ++;
             }
             [staticChallengesTableView reloadData];
         }
         
     }];
}

/*
-(void) getChallengesResults
{
    [activityIndicatorChallengeResults setAlpha:1];
	[activityIndicatorChallengeResults startAnimating];
	
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    //HighscoreService* highscoreService = [HighscoreService defaultService];
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", @1, @"level",nil];
    
    [self.highscoreService getHigscoreForPlayerAndLevel:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
         
         [activityIndicatorChallengeResults stopAnimating];
         [activityIndicatorChallengeResults setAlpha:0];
         if (error)
         {
             NSLog(@"Error %@",error);
            
             
             if (getChallengesResultsRetry < 2 ) {
                 getChallengesResultsRetry++;
                 [self getChallengesResults];
             }
             else
             {
                 getChallengesResultsRetry = 0;
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
         }
         else {
             getChallengesResultsRetry = 0;
             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             //NSLog(@"The datastring : %@",newStr);
             
             //remove front [ and back ] characters
             if ([newStr rangeOfString: @"]"].length >0) {
                 [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
                 [newStr deleteCharactersInRange: NSMakeRange(0,1)];
                 NSLog(@"The datastring : %@",newStr);
             }
             
             NSMutableArray* dataArray = [[NSMutableArray alloc] init];
             [pageMiddleToLoad retain];
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
                 
                 
                 [pageMiddleToLoad appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>creatorID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 [pageMiddleToLoad appendString:[NSString stringWithFormat:@"<tr bgcolor=#FFFFFF><td>targetID</td><td>%@</td><td>sumKmExceded</td></tr>",[jsonObject objectForKey:@"username"]]];
                 
                 
                 ind ++;
             }
             [pageMiddleToLoad release];
             
             [self ReloadHtml];
             
         }
         
     }];
}
*/
 
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [datasourceArray count];
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
    cell.textLabel.text = [NSString	 stringWithFormat:@"%@",[datasourceArray objectAtIndex:[indexPath row]]];
    
    //try setting color
    if (([indexPath row] % 2) == 0) 
        [cell setCellColor:[ UIColor lightGrayColor ] ];
    else
        [cell setCellColor:[ UIColor grayColor ] ];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
    	NSString *alertString = [NSString stringWithFormat:@"Clicked on %@", [datasourceArray objectAtIndex:[indexPath row]]];
    	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:[NSString stringWithFormat:@"Take challenge by %@",[datasourceArray objectAtIndex:[indexPath row]]] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    	[alert show];
    	[alert release];
    
    //[self.view setAlpha:0];
    //[self dealloc];
    
//    if ([delegate respondsToSelector:@selector(returnSelectedUserAndCleanUp:)])
//        [delegate returnSelectedUserAndCleanUp:[datasourceArray objectAtIndex:[indexPath row]]];
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{

		if(buttonIndex == 0)
		{
			NSLog(@"no button was pressed\n");
            [staticChallengesTableView reloadData];
            
		}
		else
		{
			NSLog(@"yes button was pressed\n");
            
            
            

            
            if (m_game == nil) {
                m_game = [[Game alloc] init] ;
            }
            

                [m_game SetTrainingMode:NO];
            

                [m_game SetMapBorder:YES];

            
            Difficulty vDifficulty = level1;
            Player* m_player = [[Player alloc] initWithName:[[GlobalSettingsHelper Instance] GetPlayerName] andColor:[UIColor redColor] andPlayerSymbol:@"ArrowRed.png"];
            
            [m_game SetPlayer:m_player andDifficulty:vDifficulty];

            
            [self.view setAlpha:0];
            [self dealloc];
            
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
    [super dealloc];
}
- (IBAction)backButtonPushed:(id)sender {
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpTakeChallengeViewCtrl)])
        [delegate cleanUpTakeChallengeViewCtrl];
}


@end
