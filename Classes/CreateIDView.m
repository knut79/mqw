//
//  CreateIDView.m
//  MQNorway
//
//  Created by knut dullum on 18/11/2011.
//  Copyright 2011 lemmus. All rights reserved.
//
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "AddressBook/ABPerson.h"
#import "CreateIDView.h"


@implementation CreateIDView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
       
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = YES;
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 250, 40)];
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2, 40);
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		[self addSubview:headerLabel];
		[headerLabel release];
		
		
		noConnection = FALSE;
		recordUniqueID = FALSE;
		recordProposal = FALSE;
        recordEmail = FALSE;
        
        itsAProposal = FALSE;
        uniqueEmail = FALSE;
        readyToCreate = FALSE;
		
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Create player ID"];
		
        

		
		emailTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 150, 27)];
//		emailTextField.clearsOnBeginEditing = YES;
		emailTextField.tag = 108;
        emailTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Enter email"];
		emailTextField.delegate = self;
		emailTextField.borderStyle = UITextBorderStyleRoundedRect;
		emailTextField.textAlignment = NSTextAlignmentCenter;
		emailTextField.center = CGPointMake(([screen applicationFrame].size.width/2), 160);
		[self addSubview:emailTextField];
        
        errorEmailLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 250, 27)];
		errorEmailLabel.textAlignment = NSTextAlignmentCenter;
        errorEmailLabel.textColor = [UIColor redColor];
        errorEmailLabel.backgroundColor = [UIColor clearColor]; 
		errorEmailLabel.center = CGPointMake(([screen applicationFrame].size.width/2), 160 + 30);
		[self addSubview:errorEmailLabel];
        
        
		
//		NSString *theEmailAddressWeWantToObtain = @"";
//		ABPerson *aPerson = [[ABAddressBook sharedAddressBook] me];
//		ABMultiValue *emails = [aPerson valueForProperty:kABEmailProperty];
//		if([emails count] > 0)
//			emailTextField.text = [emails valueAtIndex:0];
        
        
//		ABRecordRef *aPerson = [[ABAddressBook sharedAddressBook] me];
//		ABMultiValue *emails = [aPerson valueForProperty:kABEmailProperty];
//		if([emails count] > 0)
//			emailTextField.text = [emails valueAtIndex:0];
        
        
//        ABMultiValueRef emails = ABRecordCopyValue(record, kABPersonEmailProperty);

		
		globalIDTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 100, 150, 27)];
//		globalIDTextField.clearsOnBeginEditing = YES;
		globalIDTextField.tag = 108;
		globalIDTextField.delegate = self;
		globalIDTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Enter ID"];
		globalIDTextField.borderStyle = UITextBorderStyleRoundedRect;
		globalIDTextField.textAlignment = NSTextAlignmentCenter;
		globalIDTextField.center = CGPointMake(([screen applicationFrame].size.width/2), 220);
		[self addSubview:globalIDTextField];
        
        errorGlobalIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 250, 27)];
		errorGlobalIDLabel.textAlignment = NSTextAlignmentCenter;
        errorGlobalIDLabel.textColor = [UIColor redColor];
        errorGlobalIDLabel.backgroundColor = [UIColor clearColor]; 
		errorGlobalIDLabel.center = CGPointMake(([screen applicationFrame].size.width/2 ), 220 + 30);
		[self addSubview:errorGlobalIDLabel];
		
		buttonCreateID = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonCreateID addTarget:self action:@selector(createGlobalID:) forControlEvents:UIControlEventTouchDown];
		[buttonCreateID setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Create global ID"] forState:UIControlStateNormal];
		buttonCreateID.frame = CGRectMake(60 , 160 , 150.0, 40.0);
		buttonCreateID.center = CGPointMake(([screen applicationFrame].size.width/2), 300);
		[self addSubview:buttonCreateID];
        
        
        //_? TODO   check for network connection
        //-if no connection, return setting use of local name . 
        
        
		
		[screen release];
    }
    return self;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
//	NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
//	switch (textField.tag) {
//		case 108:
//			if ([value length] == 0) {
//				emailTextField.text = [NSString stringWithFormat:@"%@ 1",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Player"]];
//			}
//			break;
//
//		default:
//			break;
//	}
	
	[textField resignFirstResponder];
	
	return YES;	
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

-(void)createGlobalID:(id)Sender
{
    BOOL valid = YES;
    //validate text fields
    if ((globalIDTextField.text == nil) || [self validateName:globalIDTextField.text]==0) {
        errorGlobalIDLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not valid player ID"];
        valid = NO;
    }
    else
        errorGlobalIDLabel.text = @"";
    
    if ((emailTextField.text == nil) || [self validateEmail:emailTextField.text] ==0) {
        errorEmailLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not valid email format"];
        valid = NO;
    }
    else
        errorEmailLabel.text = @"";
    
    if (valid == NO) 
        return;
    
	//show message box if not unique id found, give suggestion. put suggestion in textbox
	//eg. ID  ove taken, however ove1 is not taken
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<SOAP-ENV:Body>\n"
							 "<CreatePlayerID xmlns=\"http://quizmap.net/\">\n"
							 "<playerID>%@</playerID>\n"
                             "<email>%@</email>\n"
                             "<nationality>none</nationality>\n"
							 "</CreatePlayerID>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",globalIDTextField.text,emailTextField.text
							 ];
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/PlayerServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/CreatePlayerID" forHTTPHeaderField:@"SOAPAction"];
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
	{
		[xmlParser release];
	}
	
	xmlParser = [[NSXMLParser alloc] initWithData: webData];
	[xmlParser setDelegate: self];
	[xmlParser setShouldResolveExternalEntities: YES];
	[xmlParser parse];
	
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
            errorEmailLabel.text = [NSString stringWithFormat:@"%@ %@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Email occupied by user"],string];
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
	
	if( [elementName isEqualToString:@"CreatePlayerIDResult"])
	{
        
        if (itsAProposal == TRUE) {
            alertNotUnique = [[UIAlertView alloc] initWithTitle:@"Not unique" 
                                                        message:[NSString stringWithFormat:@"ID %@ taken, however %@ is not taken",globalIDTextField.text,collectedID]  delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];

        }
        else
        {
            if (uniqueEmail == TRUE) {
                NSLog(@"collected id is  %@",collectedID);
                alertNotUnique = [[UIAlertView alloc] initWithTitle:@"ID is unique" 
                                                        message:[NSString stringWithFormat:@"Create ID %@ ",collectedID]  delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
                readyToCreate = TRUE;
            }
            
            
        }
        [alertNotUnique show];

		
        
        //globalIDTextField.text = [NSString stringWithFormat:@"%@",string];
        
        
		[m_activityIndicator stopAnimating];
		//		[button_levelDown setUserInteractionEnabled:TRUE];
		//		[button_levelUp setUserInteractionEnabled:TRUE];
		//		[switchShowButton setUserInteractionEnabled:TRUE];
		//		
	}
}

- (void)alertView : (UIAlertView *)alertView clickedButtonAtIndex : (NSInteger)buttonIndex
{
	if(readyToCreate)
	{
		readyToCreate = FALSE;
		if(buttonIndex == 0)
		{
			NSLog(@"no button was pressed\n");
			globalIDTextField.text = @"";
			globalIDTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Enter new ID"];
		}
		else
		{
			NSLog(@"yes button was pressed\n");
			//create new id..with nationality and token for the APS
//			[[SqliteHelper Instance] executeNonQuery:@"INSERT INTO globalID VALUES (?, ?, ?);", 
//			 [NSString stringWithFormat:@"%@",collectedID],@"none",@"none"];
            [[SqliteHelper Instance] executeUpdate:@"INSERT INTO globalID VALUES (?, ?, ?);",
			 collectedID,@"none",@"none"];
            //[[GlobalSettingsHelper Instance] SetPlayerID:collectedID];
            
            [self FadeOut];
		}
	}
	
	
	if (noConnection) {
		noConnection = FALSE;

		if(buttonIndex == 0)
		{
			NSLog(@"no button was pressed\n");
			globalIDTextField.text = @"";
			globalIDTextField.placeholder = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Enter new ID"];
		}
		else
		{
			NSLog(@"yes button was pressed\n");
            [[GlobalSettingsHelper Instance] SetPlayerID:@"tempID"];
            
            [self FadeOut];
		}
        
        [self FadeOut];
		
        
        //call back to parent class, the parent class should dealloc the 
		//[self initStartGameElements];
	}
	
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
	if ([delegate respondsToSelector:@selector(cleanUpCreateIDView)])
		[delegate cleanUpCreateIDView];
}


- (void)dealloc {
    [super dealloc];
}


@end
