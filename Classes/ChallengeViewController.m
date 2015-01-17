//
//  ChallengeViewController.m
//  MQNorway
//
//  Created by knut dullum on 21/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "ChallengeViewController.h"

@implementation ChallengeViewController
@synthesize webView;
@synthesize buttonAddRandomUser;
@synthesize buttonGoBack;
@synthesize buttonSendChallenge;
@synthesize buttonAddContact;
@synthesize buttonRemovePlayer;
@synthesize delegate;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    UIColor *lightBlueColor = [UIColor colorWithRed: 100.0/255.0 green: 149.0/255.0 blue:237.0/255.0 alpha: 1.0];
    self.view.backgroundColor = lightBlueColor;
    
    playersToChallenge = [[NSMutableArray alloc] init];

    
    pageStartToLoad = [[[NSMutableString alloc] init] retain];
    [pageStartToLoad appendString:@"<html><head></head><body>"];
    [pageStartToLoad appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
    
    pageEndToLoad = [[[NSMutableString alloc] init] retain];
    [pageEndToLoad appendString:@"</table>"];
    [pageEndToLoad appendString:@"</body></html>"];
    
    pageAddressesToLoad = [[[NSMutableString alloc] init] retain];
    
    assureNoDuplicatesEmails = [[NSMutableArray alloc] init];
    assureNoDuplicatesPlayerIDs = [[NSMutableArray alloc] init];
    
    [buttonSendChallenge setAlpha:.5];
    buttonSendChallenge.userInteractionEnabled = NO;
    buttonSendChallenge.layer.borderWidth=1.0f;
    [buttonSendChallenge setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonSendChallenge.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    buttonRemovePlayer.layer.borderWidth=1.0f;
    [buttonRemovePlayer setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonRemovePlayer.layer.borderColor=[[UIColor whiteColor] CGColor];
    [buttonRemovePlayer setAlpha:.5];
    
    buttonAddContact.layer.borderWidth=1.0f;
    [buttonAddContact setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonAddContact.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    buttonGoBack.layer.borderWidth=1.0f;
    [buttonGoBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonGoBack.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    buttonAddRandomUser.layer.borderWidth=1.0f;
    [buttonAddRandomUser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonAddRandomUser.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    buttonAddRandomUser.layer.borderWidth=1.0f;
    [buttonAddRandomUser setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonAddRandomUser.layer.borderColor=[[UIColor whiteColor] CGColor];
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    self.friendPickerController = nil;
    [self setButtonAddContact:nil];
    [self setButtonAddRandomUser:nil];
    [self setButtonGoBack:nil];
    [self setButtonSendChallenge:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [buttonAddContact release];
    [buttonAddRandomUser release];
    [buttonGoBack release];
    [buttonSendChallenge release];
    [webView release];
    [buttonRemovePlayer release];
    [super dealloc];
}




- (IBAction)addFriendPushed:(id)sender {

   
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"user_friends"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self addFriendPushed:sender];
                                          }
                                      }];
        return;
    }
    
    if (self.friendPickerController == nil) {
        // Create friend picker, and get data loaded into it.
        self.friendPickerController = [[FBFriendPickerViewController alloc] init];
        self.friendPickerController.title = @"Pick Friends";
        self.friendPickerController.delegate = self;
    }
    
    [self.friendPickerController loadData];
    [self.friendPickerController clearSelection];
    
    [self presentViewController:self.friendPickerController animated:YES completion:nil];
}

- (IBAction)addRandomPlayerPushed:(id)sender {
    
    /*
    if (addExistingPlayerViewController == nil) {
        addExistingPlayerViewController = [[AddExPlrViewCtrl alloc] initWithNibName:@"AddExPlrViewCtrl" bundle:nil]; 
        [addExistingPlayerViewController setDelegate:self];
        [self.view addSubview:addExistingPlayerViewController.view];
    }
    else
        [addExistingPlayerViewController.view setAlpha:1];
    */
    
    //ask for random user
    UserService* userService = [UserService defaultService];
    NSMutableString* usedUsers =[[[NSMutableString alloc] init] autorelease];
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    for (int i = 0; i < playersToChallenge.count; i++) {
        [usedUsers appendString:[NSString stringWithFormat:@"%@;",[[playersToChallenge objectAtIndex:i] valueForKey:@"userid"]]];
    }
    if (usedUsers.length == 0) {
        [usedUsers appendString:@"bogus"];
    }
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:playerId, @"id", usedUsers, @"usedusers", nil];
    [userService getRandomUser:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
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
             
         } else {
             
             NSMutableString* newStr = [[NSMutableString alloc] initWithData:result encoding:NSUTF8StringEncoding];
             
             
             //for testing
             //NSData *jsonData = [@"{ \"key1\": \"value1\",\"key2\": \"value2\" }" dataUsingEncoding:NSUTF8StringEncoding];
             
             
             //if we have set of values
             /*
              
              //remove front [ and back ] characters
              if ([newStr rangeOfString: @"]"].length >0) {
              [newStr deleteCharactersInRange: NSMakeRange([newStr length]-1, 1)];
              [newStr deleteCharactersInRange: NSMakeRange(0,1)];
              NSLog(@"The datastring : %@",newStr);
              }
              
              NSMutableArray* dataArray = [[NSMutableArray alloc] init];
              
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
              if ([newStr rangeOfString: @"}"].length >0) {
              [newStr deleteCharactersInRange: NSMakeRange(0, match.location + 2)];
              }
              
              }
              */
             
             NSData *jsonData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
             /*
              NSDictionary *jsonObject=[NSJSONSerialization
              JSONObjectWithData:jsonData
              options:NSJSONReadingMutableLeaves
              error:nil];*/
             NSDictionary *jsonObject=[NSJSONSerialization
                                       JSONObjectWithData:jsonData
                                       options:NSJSONWritingPrettyPrinted
                                       error:nil];
             NSLog(@"jsonObject is %@",jsonObject);
             
             NSString* userId = [jsonObject valueForKey:@"userId"];
             NSString* name = [jsonObject valueForKey:@"name"];

             
             NSDictionary* playerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:userId,@"userid",name,@"name", nil];
             //[playerDictionary setValue:userId forKey:@"userid"];
             //[playerDictionary setValue:name forKey:@"name"];
             [playersToChallenge addObject:playerDictionary];
             
             [self ReloadHtml];
             
         }
     }];
}



#pragma mark delegate method
-(void) returnSelectedUserAndCleanUp:(NSString*) user
{
    [addExistingPlayerViewController removeFromParentViewController];
    addExistingPlayerViewController = nil;
    
    if (user != nil && [self userExists:user] == NO) 
    {
        [pageAddressesToLoad appendString:[NSString stringWithFormat:@"<tr><td>User: %@</td></tr>",user]];
        [self ReloadHtml];
    }
}

-(BOOL)userExists:(NSString*) user
{
    BOOL exists = NO;
    for (int i = 0; i < [assureNoDuplicatesPlayerIDs count];i++) {
        if([((NSString*)[assureNoDuplicatesPlayerIDs objectAtIndex:i]) isEqualToString:user] == YES)
        {
            exists = YES;
            break;
        }
    }
    if (exists == NO) 
        [assureNoDuplicatesPlayerIDs addObject:user];
    
    return exists;    
}

- (void) ReloadHtml
{
    if (webView != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoad];
        for (int i = 0; i < playersToChallenge.count; i++) {
            [pageToLoad appendString:[NSString stringWithFormat:@"<tr><td>%@</td></tr>",[[playersToChallenge objectAtIndex:i] valueForKey:@"name"]]];
        }
        [pageToLoad appendString:pageAddressesToLoad];
        [pageToLoad appendString:pageEndToLoad];
        
		[webView loadHTMLString:pageToLoad baseURL:nil];
    }
    
    if(playersToChallenge.count>0)
    {
        if (playersToChallenge.count>1) {
            [buttonSendChallenge setTitle:[NSString stringWithFormat:@"Send %lu challenges",(unsigned long)playersToChallenge.count] forState:UIControlStateNormal];
        }
        else
        {
            [buttonSendChallenge setTitle:@"Send 1 challenge" forState:UIControlStateNormal];
        }
        [buttonSendChallenge setAlpha:1];
        buttonSendChallenge.userInteractionEnabled = YES;
        
        [buttonRemovePlayer setAlpha:1];
        buttonRemovePlayer.userInteractionEnabled = YES;
        
    }
    else
    {
        [buttonRemovePlayer setAlpha:.5];
        buttonRemovePlayer.userInteractionEnabled = NO;
        
        [buttonSendChallenge setTitle:@"No challenges to send" forState:UIControlStateNormal];
        [buttonSendChallenge setAlpha:.5];
        buttonSendChallenge.userInteractionEnabled = NO;
    }
    
}


-(void) setGameRef:(Game*) pGame
{
    game = pGame;
}


-(void) setChallenge:(Challenge*) pChallenge
{
    challenge = pChallenge;
}

- (IBAction)removePlayerPushed:(id)sender {
    [playersToChallenge removeLastObject];
    [self ReloadHtml];
}

- (IBAction)sendChallengePushed:(id)sender {
    
    //send challenge to users
    ChallengeService* challengeService = [ChallengeService defaultService];
    NSMutableString* usersCommaseparated =[[[NSMutableString alloc] init] autorelease];
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    for (int i = 0; i < playersToChallenge.count; i++) {
        [usersCommaseparated appendString:[NSString stringWithFormat:@"%@;",[[playersToChallenge objectAtIndex:i] valueForKey:@"userid"]]];
    }
    if (usersCommaseparated.length == 0) {
        [usersCommaseparated appendString:@"bogus"];
    }
    
    
    NSMutableString* questionsCommaseparated =[[[NSMutableString alloc] init] autorelease];
    for (int i = 0; i < [game GetPassedQuestions].count;i++)
    {
        Question* tempQuestion = [[game GetPassedQuestions] objectAtIndex:i];
        [questionsCommaseparated appendString:[NSString stringWithFormat:@"%@;",[tempQuestion GetID]]];
    }
    
    /*
    NSNumber* answers = @([game GetPassedQuestions].count);
    NSNumber* seconds = @([[game GetPlayer] GetSecondsUsed]);
    BOOL borders = [game UsingBorders];
    
        NSDictionary *testDictionary = [NSDictionary dictionaryWithObjectsAndKeys:playerId, @"id",@([[game GetPlayer] GetSecondsUsed]),@"seconds",nil];
    NSDictionary *test2Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@1,@"flags",nil];
     NSDictionary *test3Dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@([game UsingBorders]),@"borders",nil];
     */
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:playerId, @"id",usersCommaseparated, @"recipients",questionsCommaseparated,@"questions",@1, @"level",@([game GetPassedQuestions].count),@"answers",@([[game GetPlayer] GetSecondsUsed]),@"seconds",@([game UsingBorders]),@"borders",@YES,@"flags",nil];
    
    [challengeService sendChallenge:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
     {
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
             
         } else {
             
             //succeded sending challenge
             [self.view setAlpha:0];
             [self dealloc];
             
             if ([delegate respondsToSelector:@selector(cleanUpChallengView)])
                 [delegate cleanUpChallengView];
         }
     }];

}

- (IBAction)buttonGoBackPushed:(id)sender {
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpChallengView)])
        [delegate cleanUpChallengView];
}


- (void)facebookViewControllerDoneWasPressed:(id)sender {
    
    // we pick up the users from the selection, and create a string that we use to update the text view
    // at the bottom of the display; note that self.selection is a property inherited from our base class
    for (id<FBGraphUser> user in self.friendPickerController.selection) {

        NSDictionary* playerDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:user.objectID,@"userid",user.name,@"name", nil];
        //[playerDictionary setValue:user.objectID forKey:@"userid"];
        //[playerDictionary setValue:user.name forKey:@"name"];
        [playersToChallenge addObject:playerDictionary];

    }
    
    [self ReloadHtml];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)facebookViewControllerCancelWasPressed:(id)sender {
[self dismissViewControllerAnimated:YES completion:NULL];
}

@end
