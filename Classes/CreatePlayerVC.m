//
//  CreatePlayerVC.m
//  MQNorway
//
//  Created by knut on 5/19/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "CreatePlayerVC.h"

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
        
        // Custom initialization
        /*
        FBLoginView *loginView = [[FBLoginView alloc] init];
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 5);
        [self.view addSubview:loginView];*/
    }
    return self;
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {

    /*
    [FBSettings setLoggingBehavior:[NSSet setWithObjects:FBLoggingBehaviorFBRequests, nil]];
    if (FBSession.activeSession.isOpen) {
        [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection,id<FBGraphUser> user,NSError *error) {
            if (!error) {
                [self WritePlayerID:user.first_name];
            }
        }];
    }*/
    

    //self.statusLabel.text = @"You're logged in as";
    /*
    if ([delegate respondsToSelector:@selector(cleanUpCreatePlayerVC)])
        [delegate cleanUpCreatePlayerVC];*/
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
    
    
    [self WritePlayerID: user.objectID andName:user.first_name];
    
    if(isFirstLoginDone) {
        if ([delegate respondsToSelector:@selector(cleanUpCreatePlayerVC)])
            [delegate cleanUpCreatePlayerVC];
    }
    isFirstLoginDone = NO;
     
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void) WritePlayerID:(NSString*) playerID andName:(NSString*) firstname
{
    NSLog(@"Writing playerID %@ to localdata.plist file.",playerID);
    //NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
        NSLog(@"Failed writing to file LocalData.plist, file does not exist");
    
    //write data
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    [data setObject:[NSString stringWithFormat:@"%@",playerID] forKey:@"playerID"];
    [data setObject:[NSString stringWithFormat:@"%@",firstname] forKey:@"playerFirstname"];
    
    [data writeToFile: pathPlist atomically:YES];
}

- (void)dealloc {
    [nameLabel release];
    [statusLabel release];
    [profilePictureView release];
    [super dealloc];
}
@end
