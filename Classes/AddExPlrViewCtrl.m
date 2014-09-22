//
//  AddExPlrViewCtrl.m
//  MQNorway
//
//  Created by knut dullum on 21/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "AddExPlrViewCtrl.h"
#import "GlobalSettingsHelper.h"
@implementation AddExPlrViewCtrl
@synthesize activityIndicator;
@synthesize playersTableView;
@synthesize textFieldUser;
@synthesize btnSearchUser;
@synthesize btnShowFriends;
@synthesize btnBack;
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


- (BOOL) validateName: (NSString *) candidate {
    NSString *nameRegex = @"^[a-zA-Z0-9]*$";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    //  return 0;
    return [nameTest evaluateWithObject:candidate];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    self.title = @"Search";

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datasourceArray = [[NSMutableArray alloc] init];
//    [datasourceArray addObject:[NSString stringWithFormat:@"hei hei"]];
//    [datasourceArray addObject:[NSString stringWithFormat:@"lei lei"]];
    [self setWantsFullScreenLayout:YES];

	textFieldUser.clearsOnBeginEditing = YES;
	textFieldUser.tag = 101;
	textFieldUser.delegate = self;
	textFieldUser.textAlignment = NSTextAlignmentCenter;
    textFieldUser.autocorrectionType = UITextAutocorrectionTypeNo;
    
    
    [playersTableView setBackgroundColor:[UIColor clearColor]];
    
    

}

- (void)viewDidUnload
{
    [self setTextFieldUser:nil];
    [self setBtnSearchUser:nil];
    [self setBtnShowFriends:nil];
    [self setBtnBack:nil];
    [self setPlayersTableView:nil];
 
    [self setActivityIndicator:nil];
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
    [textFieldUser release];
    [btnSearchUser release];
    [btnShowFriends release];
    [btnBack release];
    [playersTableView release];
    [activityIndicator release];
    [super dealloc];
}
 

- (IBAction)btnBackPushed:(id)sender {
    
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(returnSelectedUserAndCleanUp:)])
        [delegate returnSelectedUserAndCleanUp:nil];
    
}

- (IBAction)btnShowFriendsPushed:(id)sender {
    [activityIndicator startAnimating];
    [self GetFriends];
}

- (IBAction)btnSearchPushed:(id)sender {
    if ([textFieldUser.text length] < 3) {
        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Too few letters" 
                                                             message:@"Need 3 letters or more" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
        [alertView show];    
    }
    else
        [self GetPlayersStartingWith];
}


#pragma mark UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
	
	NSString *value = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
	
	switch (textField.tag) {
		case 101:
            if ([self validateName:value]==0) {
                UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Not valid" 
                                                                     message:@"Not valid name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
                [alertView show];
            }
            else
            {
                if ([value length] > 0)
                {
                    if ([textFieldUser.text length] < 3) {
                        UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"Too few letters" 
                                                                             message:@"Need 3 letters or more" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
                        [alertView show];    
                    }
                    else
                        [self GetPlayersStartingWith];
                }
            }

			break;

		default:
			break;
	}
	
	[textField resignFirstResponder];
	
	return YES;	
}

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
    if ([indexPath row] == 1) {
        [cell setCellColor:[ UIColor redColor ] ];
    }
    else if([indexPath row] == 2)
    {
    [cell setCellColor:[ UIColor grayColor ] ];
    }
    else
    {
    [cell setCellColor:[ UIColor greenColor ] ];
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// open a alert with an OK and cancel button
//	NSString *alertString = [NSString stringWithFormat:@"Clicked on %@", [datasourceArray objectAtIndex:[indexPath row]]];
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertString message:@"" delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
//	[alert show];
//	[alert release];
    
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(returnSelectedUserAndCleanUp:)])
        [delegate returnSelectedUserAndCleanUp:[datasourceArray objectAtIndex:[indexPath row]]];
}


#pragma mark xmlparser


-(void) GetFriends
{
	recordFriends = FALSE;
	index = 0;
    [datasourceArray removeAllObjects];
	
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<SOAP-ENV:Body>\n"
							 "<GetFriends xmlns=\"http://quizmap.net/\">\n"
							 "<playerID>%@</playerID>\n"
							 "</GetFriends>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",@"pera"
							 ];//[[GlobalSettingsHelper Instance] GetPlayerID]
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/PlayerServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetFriends" forHTTPHeaderField:@"SOAPAction"];
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


-(void) GetPlayersStartingWith
{
    
	//[m_activityIndicator startAnimating];
    
	
	recordPlayerStartingWith = FALSE;
	index = 0;
    [datasourceArray removeAllObjects];
	
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<SOAP-ENV:Body>\n"
							 "<GetPlayersStartingWith xmlns=\"http://quizmap.net/\">\n"
							 "<playerIDStartWith>%@</playerIDStartWith>\n"
							 "</GetPlayersStartingWith>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",textFieldUser.text
							 ];
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/PlayerServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetPlayersStartingWith" forHTTPHeaderField:@"SOAPAction"];
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
    [activityIndicator stopAnimating];
	NSLog(@"ERROR with theConenction");
	[connection release];
	[webData release];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [activityIndicator stopAnimating];
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
	
	if( [elementName isEqualToString:@"pID"])
	{
        recordFriends= TRUE;    
	}
    
    if ([elementName isEqualToString:@"name"]) {
        recordPlayerStartingWith = TRUE;
    }

    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (index < 9) {
        if(recordPlayerStartingWith ||recordFriends)
        {
            recordFriends = FALSE;
            recordPlayerStartingWith = FALSE;
            [datasourceArray addObject:string];
            
        }

    }
    else
    {
        NSLog(@"Too much soap data returned!");
        recordFriends = FALSE;
        recordPlayerStartingWith = FALSE;

    }
    
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"FriendWithScore"] || [elementName isEqualToString:@"PlayerName"])
	{
		index ++;
	}
    
	if( [elementName isEqualToString:@"GetFriendsResponse"] || [elementName isEqualToString:@"GetPlayersStartingWithResponse"] )
	{
		//[m_activityIndicator stopAnimating];
        [playersTableView reloadData];
		index = 0;
        
        if ([datasourceArray count] == 0) {
            UIAlertView *alertView = [[[UIAlertView alloc] initWithTitle:@"No players" 
                                                                 message:@"No players found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil] autorelease];
            [alertView show];
        }
	}
	
}



@end
