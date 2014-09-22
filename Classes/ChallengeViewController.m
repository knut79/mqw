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
@synthesize buttonAddUser;
@synthesize buttonAddEmail;
@synthesize buttonGoBack;
@synthesize buttonSendChallenge;
@synthesize textFieldEmail;
@synthesize buttonAddContact;
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
    pageStartToLoad = [[[NSMutableString alloc] init] retain];
    [pageStartToLoad appendString:@"<html><head></head><body>"];
    [pageStartToLoad appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
    
    pageEndToLoad = [[[NSMutableString alloc] init] retain];
    [pageEndToLoad appendString:@"</table>"];
    [pageEndToLoad appendString:@"</body></html>"];
    
    pageAddressesToLoad = [[[NSMutableString alloc] init] retain];
    
    assureNoDuplicatesEmails = [[NSMutableArray alloc] init];
    assureNoDuplicatesPlayerIDs = [[NSMutableArray alloc] init];
    
    textFieldEmail.clearsOnBeginEditing = YES;
    textFieldEmail.tag = 102;
    textFieldEmail.delegate = self;
    textFieldEmail.borderStyle = UITextBorderStyleRoundedRect;
    textFieldEmail.textAlignment = NSTextAlignmentCenter;
    textFieldEmail.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [buttonSendChallenge setAlpha:.5];
    buttonSendChallenge.userInteractionEnabled = NO;
    
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setButtonAddContact:nil];
    [self setButtonAddUser:nil];
    [self setButtonAddEmail:nil];
    [self setButtonGoBack:nil];
    [self setButtonSendChallenge:nil];
    [self setTextFieldEmail:nil];
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
    [buttonAddUser release];
    [buttonAddEmail release];
    [buttonGoBack release];
    [buttonSendChallenge release];
    [textFieldEmail release];
    [webView release];
    [super dealloc];
}
- (IBAction)addContactPushed:(id)sender {
    ABPeoplePickerNavigationController *picker =
    [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissModalViewControllerAnimated:YES];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    @try {
        ABMultiValueRef emailMultiValue = ABRecordCopyValue(person, kABPersonEmailProperty);
        NSArray *emailAddresses = [(NSArray *)ABMultiValueCopyArrayOfAllValues(emailMultiValue) autorelease];
        if ([emailAddresses count] == 0) {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"No email for contact" 
                                                                 message:@"This contact is not registrated with email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alertView show]; 
        } else {
            for (int i = 0; i< [emailAddresses count]; i++) {
                if ([self validateEmail:[emailAddresses objectAtIndex:i]] == YES) {
                    if ([self emailExists:[emailAddresses objectAtIndex:i]] == NO) {
                        [pageAddressesToLoad appendString:[NSString stringWithFormat:@"<tr><td>Email: %@</td></tr>",[emailAddresses objectAtIndex:i]]];
                        [self ReloadHtml];
                    }
                }
            }
        }

        CFRelease(emailMultiValue);
    }
    @catch (NSException *exception) {
        NSLog(@"ERROR in adding playerID!");
    }
    @finally {
        [self dismissModalViewControllerAnimated:YES];
    }    

    
    
    
    return NO;
}



- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
    

    return NO;
}

-(BOOL) emailExists:(NSString*) email
{
    BOOL exists = NO;
    for (int i = 0; i < [assureNoDuplicatesEmails count];i++) {
        if([((NSString*)[assureNoDuplicatesEmails objectAtIndex:i]) isEqualToString:email] == YES)
        {
            exists = YES;
            break;
        }
    }
    if (exists == NO) 
        [assureNoDuplicatesEmails addObject:email];
    
    return exists;
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //  return 0;
    return [emailTest evaluateWithObject:candidate];
}



- (IBAction)addUserPushed:(id)sender {
    
    if (addExistingPlayerViewController == nil) {
        addExistingPlayerViewController = [[AddExPlrViewCtrl alloc] initWithNibName:@"AddExPlrViewCtrl" bundle:nil]; 
        [addExistingPlayerViewController setDelegate:self];
        [self.view addSubview:addExistingPlayerViewController.view];
    }
    else
        [addExistingPlayerViewController.view setAlpha:1];
    
}

- (IBAction)addEmailPushed:(id)sender {
    if ((textFieldEmail.text == nil) || [self validateEmail:textFieldEmail.text] ==0) {
        //errorEmailLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not valid email format"];
        //valid = NO;
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Not valid" 
                                                    message:@"Not valid email" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [alertView show];
    }
    else
    {

        if ([self emailExists:textFieldEmail.text] == NO) 
        {
            [pageAddressesToLoad appendString:[NSString stringWithFormat:@"<tr><td>Email: %@</td></tr>",textFieldEmail.text]];
            textFieldEmail.text = @"";
        
            [self ReloadHtml];
        }
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	switch (textField.tag) {
		case 101:
//			if ([value length] == 0) {
//				textFieldUser.placeholder = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Input user"]];
//			}
            break;

		default:
			break;
	}
	
	[textField resignFirstResponder];
	
	return YES;	
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
    if([assureNoDuplicatesEmails count] + [assureNoDuplicatesPlayerIDs count] == 0)
    {
        [buttonSendChallenge setTitle:@"No challenges to send" forState:UIControlStateNormal];
        [buttonSendChallenge setAlpha:.5];
        buttonSendChallenge.userInteractionEnabled = NO;
    }
    else
    {
        [buttonSendChallenge setAlpha:1];
        buttonSendChallenge.userInteractionEnabled = YES;

        if ([assureNoDuplicatesPlayerIDs count] + [assureNoDuplicatesPlayerIDs count] == 1) {
            [buttonSendChallenge setTitle:@"Send 1 challenge" forState:UIControlStateNormal];
        }
        else
        {
            [buttonSendChallenge setTitle:[NSString stringWithFormat:@"Send %d challenges",[assureNoDuplicatesPlayerIDs count] + [assureNoDuplicatesEmails count]] forState:UIControlStateNormal];
        }
    }
    
    
	if (webView != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoad];
        [pageToLoad appendString:pageAddressesToLoad];
        [pageToLoad appendString:pageEndToLoad];

		[webView loadHTMLString:pageToLoad baseURL:nil];
    }
}

-(void) setChallenge:(Challenge*) pChallenge
{
    challenge = pChallenge;
}
- (IBAction)buttonGoBackPushed:(id)sender {
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpChallengView)])
        [delegate cleanUpChallengView];
}
@end
