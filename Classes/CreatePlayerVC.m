//
//  CreatePlayerVC.m
//  MQNorway
//
//  Created by knut on 5/19/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//
#import "UserService.h"
#import "CreatePlayerVC.h"

//test
#import "HighscoreService.h"

@implementation CreatePlayerVC

@synthesize loginView, profilePictureView, nameLabel,statusLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.statusLabel.numberOfLines = 1;
        self.statusLabel.adjustsFontSizeToFitWidth = YES;
        self.statusLabel.minimumScaleFactor = 0.5;
    }
    return self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {

    isFirstLoginDone = YES;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    [self.view setAlpha:1];
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You need to log in to facebook to use the app!";
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
    [super viewDidLoad];
    
    //@"manage_friendlists" to write
    self.loginView.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    
}


- (void)viewDidUnload
{
    self.profilePictureView = nil;
    self.loginView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //If you've added the -ObjC flag to your linker options, then you don't have to add this code
    
    // Override point for customization after application launch.
    [FBLoginView class];
    [FBProfilePictureView class];

    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    // Call FBAppCall's handleOpenURL:sourceApplication to handle Facebook app responses
    BOOL wasHandled = [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    
    // You can add your app-specific url handling code here if needed
    
    return wasHandled;
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    self.profilePictureView.profileID = user.objectID;
    self.nameLabel.text = user.name;

    if(isFirstLoginDone) {
        [self WritePlayerID: user.objectID andName:user.first_name];
        [FBRequestConnection startWithGraphPath:@"/me/friends"
                                     parameters:nil
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error
                                                  ) {
                                  if(error)
                                      NSLog(@"the error is %@",error);
                                  NSLog(@"the result is %@",result);
                                  /* handle the result */
                              }];
        if ([delegate respondsToSelector:@selector(cleanUpCreatePlayerVC)])
            [delegate cleanUpCreatePlayerVC];
    }
    isFirstLoginDone = NO;
     
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    
    if([result isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"dictionary");
        result=[result objectForKey:@"data"];
        if ([result isKindOfClass:[NSArray class]])
            
            for(int i=0;i<[result count];i++){
                
                NSDictionary *result2=[result objectAtIndex:i];
                NSString *result1=[result2 objectForKey:@"id"];
                NSLog(@"uid:%@",result1);
                //[uids addObject:result1];
            }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) WritePlayerID:(NSString*) playerID andName:(NSString*) firstname
{
    
    [self WritePlayerLocally:playerID andName:firstname];
    [self WritePlayerToServer:playerID andName:firstname];
   
}


-(void) WritePlayerLocally:(NSString*) playerID andName:(NSString*) firstname
{
    NSLog(@"Writing playerID %@ to localdata.plist file.",playerID);
    //NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:pathPlist])
    {
        NSLog(@"Failed writing to file LocalData.plist, file does not exist");
        NSString *boundle = [[NSBundle mainBundle] pathForResource:@"LocalData" ofType:@"plist"];
        [fileManager removeItemAtPath:pathPlist error:&error];
        [fileManager copyItemAtPath:boundle toPath:pathPlist error:&error];
    }
    //write data
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    [data setObject:[NSString stringWithFormat:@"%@",playerID] forKey:@"playerID"];
    [data setObject:[NSString stringWithFormat:@"%@",firstname] forKey:@"playerFirstname"];
    
    [data writeToFile: pathPlist atomically:YES];
    
    [[GlobalSettingsHelper Instance] SetPlayerFbID:playerID];
}

-(void) WritePlayerToServer:(NSString*) playerID andName:(NSString*) firstname
{

    UserService *userService = [UserService defaultService];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@",
                              @"userFbId", playerID];
    NSDictionary *item = @{ @"UserFbId" : playerID, @"Name" : firstname };
    [userService writeItemItNotExists:item predicate:predicate completion:^{
    
        
        
        //[self testCode];
        
    }];
}

-(void) testCode
{
    //test code
    
    NSString *playerId = [[GlobalSettingsHelper Instance] GetPlayerID];
    HighscoreService* highscoreService = [HighscoreService defaultService];
    NSInteger hei = 3;
    
    NSDictionary *jsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    playerId, @"id", @0, @"level",@444,@"seconds",@4,@"questionsAnswered", @(hei),@"distanceLeft",nil];
    [highscoreService sendScoreGetRankForPlayer:jsonDictionary completion:^(NSData* result, NSHTTPURLResponse* response, NSError* error)
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
             
             
             
             NSLog(@"The datastring : %@",newStr);
             
             
             
             
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
         }
     }];

}

- (void)dealloc {
    [nameLabel release];
    [statusLabel release];
    [profilePictureView release];
    [super dealloc];
}
@end
