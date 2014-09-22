//
//  CreatePlayerVC.m
//  MQNorway
//
//  Created by knut on 5/19/12.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "CreatePlayerVC.h"

@implementation CreatePlayerVC

@synthesize activityIndicator;
@synthesize errorPlayerIDLabel;
@synthesize errorEmailLabel;
@synthesize playerIDTextfield;
@synthesize emailTextfield;
@synthesize createPlayerButton;
@synthesize emailMessageViewLabel;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    emailTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    emailTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    playerIDTextfield.autocorrectionType = UITextAutocorrectionTypeNo;
    playerIDTextfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    emailMessageViewLabel.layer.cornerRadius = 8;
    emailMessageViewLabel.layer.borderColor = [UIColor blueColor].CGColor;
    emailMessageViewLabel.layer.borderWidth = 1.0;
    
    alreadyViewUp = NO;
}


- (void)viewDidUnload
{
    [self setEmailTextfield:nil];
    [self setPlayerIDTextfield:nil];
    [self setCreatePlayerButton:nil];
    [self setErrorEmailLabel:nil];
    [self setErrorPlayerIDLabel:nil];
    [self setActivityIndicator:nil];
    [self setEmailMessageViewLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    //  return 0;
    return [emailTest evaluateWithObject:candidate];
}

- (BOOL) validateName: (NSString *) candidate {
    NSString *nameRegex = @"^[a-zA-Z0-9]*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    //  return 0;
    return [nameTest evaluateWithObject:candidate];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([touches count] == 1) {
        
        
        [playerIDTextfield.superview endEditing:YES];
        [emailTextfield.superview endEditing:YES];
        
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 102) {
    }
    
    //else
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //alternative textfield
    if (textField.tag == 102) {
        [self emailEnterViewUp];
    }
    
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    //NSLog(@"the value is %@",textField.text);
    if (textField.tag == 102) {
        [self emailEndViewDown];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.tag == 102) {
        [self emailEndViewDown];
    }
    [textField resignFirstResponder];
    return YES;
}

- (void) emailEnterViewUp
{   
    if(!alreadyViewUp)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect = self.view.frame;
        rect.origin.y -= 170;
        self.view.frame = rect;
        [UIView commitAnimations];
        alreadyViewUp = !alreadyViewUp;
    }
}

- (void) emailEndViewDown
{        
    if(alreadyViewUp)
    {
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        CGRect rect = self.view.frame;
        rect.origin.y += 170;
        self.view.frame = rect;
        [UIView commitAnimations];
        alreadyViewUp = !alreadyViewUp;
    }
}

- (IBAction)createPlayerIDButtonPushed:(id)sender
{
    [self tryCreatePlayer];
	
}

-(void) tryCreatePlayer
{
    [emailTextfield resignFirstResponder];
    [playerIDTextfield resignFirstResponder];
    
    [activityIndicator startAnimating];
    
    BOOL valid = YES;
    //validate text fields
    if ((playerIDTextfield.text == nil) || [self validateName:playerIDTextfield.text]==0) {
        errorPlayerIDLabel.text = @"Not valid player ID";
        valid = NO;
    }
    else
        errorPlayerIDLabel.text = @"";
    NSLog(@"email text is %@",emailTextfield.text);
    if ((emailTextfield.text != nil) && ![emailTextfield.text isEqualToString:@""]) {
        if ([self validateEmail:emailTextfield.text] ==0) {
            errorEmailLabel.text = @"Not valid email format";
            valid = NO;
        }
        else
            errorEmailLabel.text = @"";
    }
    
    
    
    if (valid == NO) 
    {
        [activityIndicator stopAnimating];
        return;
    }
    
	//show message box if not unique id found, give suggestion. put suggestion in textbox
	//eg. ID  ove taken, however ove1 is not taken
    NSString* deviceToken = @"empty";
    if ([[GlobalHelper Instance] getDeviceToken] != nil) {
        deviceToken = [[GlobalHelper Instance] getDeviceToken];
    }
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<SOAP-ENV:Body>\n"
							 "<MFNCreatePlayerID xmlns=\"http://mapfeudnorway.net/\">\n"
							 "<playerID>%@</playerID>\n"
                             "<email>%@</email>\n"
                             "<nationality>none</nationality>\n"
                             "<pushtoken>%@</pushtoken>\n"
							 "</MFNCreatePlayerID>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",playerIDTextfield.text,emailTextfield.text,@"empty",deviceToken
							 ];
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/mapfeud/MFNPlayerServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://mapfeudnorway.net/MFNCreatePlayerID" forHTTPHeaderField:@"SOAPAction"];
	[theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
	[theRequest setHTTPMethod:@"POST"];
	[theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
	
	
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if( theConnection )
	{
		webData = [[NSMutableData data] retain];
	}
	else
	{
		NSLog(@"theConnection is NULL");
	}
    
}


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	[webData setLength: 0];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[webData appendData:data];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
    
	noConnection = TRUE;
	alertNotUnique = [[UIAlertView alloc] initWithTitle:@"No connection" 
												message:@"No connection with server. Create ID later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
	[alertNotUnique show];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSLog(@"DONE. Received Bytes: %d", [webData length]);
	NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
	
	NSLog(@"%@", theXML);
    [theXML release];
	if( xmlParser )
		[xmlParser release];

    
    if ([webData length] == 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Bad connection"
                                                         message:@"Retry submit"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        
        
        [alert show];
    }
    else
    {
        
        xmlParser = [[NSXMLParser alloc] initWithData: webData];
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: YES];
        [xmlParser parse];
    }
    
    [connection release];
	[webData release];
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if( [elementName isEqualToString:@"proposal"])
	{
		recordProposal = TRUE;
	}
	
	if( [elementName isEqualToString:@"uID"])
	{
		recordUniqueID = TRUE;
	}
    
    if( [elementName isEqualToString:@"emailStatus"])
	{
		recordEmail = TRUE;
	}
	
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if (recordProposal) {
		//recordProposalID = FALSE;
        if ([string isEqualToString:@"true"]) {
            itsAProposal = TRUE;
        }
        recordProposal = FALSE;
	}
    
    if (recordEmail) {
        if ([string isEqualToString:@"unique"] == FALSE) {
            errorEmailLabel.text = [NSString stringWithFormat:@"Email occupied by user %@",string];
        }
        else
        {
            uniqueEmail = TRUE;
        }
        
        recordEmail = FALSE;
    }
	
	if (recordUniqueID) {
        collectedID = [NSString stringWithFormat:@"%@",string];
        collectedID = [[NSString alloc] initWithFormat:@"%@",string];
		recordUniqueID = FALSE;
	}
	
	
	
}


-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	
	if( [elementName isEqualToString:@"MFNCreatePlayerIDResult"])
	{
        
        if (itsAProposal == TRUE) {
            alertNotUnique = [[UIAlertView alloc] initWithTitle:@"Not unique" 
                                                        message:[NSString stringWithFormat:@"ID %@ taken, however %@ is not taken",playerIDTextfield.text,collectedID]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            
        }
        else
        {
            if (uniqueEmail == TRUE) {
                NSLog(@"collected id is  %@",collectedID);
                alertNotUnique = [[UIAlertView alloc] initWithTitle:@"ID created" 
                                                            message:[NSString stringWithFormat:@"ID %@ created",collectedID]  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                
                readyToCreate = TRUE;
            }
            
            
        }
        [alertNotUnique show];
        
        
		[activityIndicator stopAnimating];
        
	}
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{
    NSString* avTitle = [alertView title];
    //NSString* buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
	if(readyToCreate)
	{
		readyToCreate = FALSE;
		if(buttonIndex == 0)
		{
			playerIDTextfield.text = @"";
            [self WritePlayerID:playerIDTextfield.text];
            
            if ([delegate respondsToSelector:@selector(cleanUpCreatePlayerVC)])
                [delegate cleanUpCreatePlayerVC];
            
		}
	}
    
    
    if ([avTitle isEqualToString:@"Bad connection"]) {
        if (buttonIndex==0) {
            [self tryCreatePlayer];
        }
    }
    
    
    if ([avTitle isEqualToString:@"Set location"]) {
        if (buttonIndex==0) {
            [self startLocationManager];
        }
    }
}


-(void) WritePlayerID:(NSString*) playerID
{
    NSLog(@"Writing playerID %@ to localdata.plist file.",collectedID);
    //NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *pathPlist = [documentsDirectory stringByAppendingPathComponent:@"LocalData.plist"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:pathPlist])
        NSLog(@"Failed writing to file LocalData.plist, file does not exist");
    
    //write data
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: pathPlist];
    
    [data setObject:[NSString stringWithFormat:@"%@",collectedID] forKey:@"playerID"];
    
    [data writeToFile: pathPlist atomically:YES];
}

@end
