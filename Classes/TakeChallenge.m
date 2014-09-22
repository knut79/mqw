//
//  TakeChallenge.m
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "TakeChallenge.h"

@implementation TakeChallenge
@synthesize webView;
@synthesize challengesTableView;
@synthesize backButton;
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


- (void) ReloadHtml
{

	if (webView != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoad];
        [pageToLoad appendString:pageEndToLoad];
        
		[webView loadHTMLString:pageToLoad baseURL:nil];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    datasourceArray = [[NSMutableArray alloc] init];
    
    [datasourceArray addObject:@"test1"];
    [datasourceArray addObject:@"test2"];
    [datasourceArray addObject:@"test3"];
    [datasourceArray addObject:@"test4"];
    
    
    pageStartToLoad = [[[NSMutableString alloc] init] retain];
    [pageStartToLoad appendString:@"<html><head></head><body>"];
    [pageStartToLoad appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#C0C0C0><td colspan='2'>Difficulty Creation time</td><td>Status</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#FFFFFF><td>creatorID</td><td>questionsAns</td><td>sumKmExceded</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#FFFFFF><td>targetID</td><td>questionsAns</td><td>sumKmExceded</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#000000><td colspan='3'></td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#C0C0C0><td colspan='2'>Difficulty Creation time</td><td>Status</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#FFFFFF><td>creatorID</td><td>questionsAns</td><td>sumKmExceded</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#FFFFFF><td>targetID</td><td>questionsAns</td><td>sumKmExceded</td></tr>"];
    
    pageMiddleToLoad = [[[NSMutableString alloc] init] retain];
    
    pageEndToLoad = [[[NSMutableString alloc] init] retain];
    [pageEndToLoad appendString:@"</table>"];
    [pageEndToLoad appendString:@"</body></html>"];
    
    [self ReloadHtml];
}

- (void)viewDidUnload
{
    [self setChallengesTableView:nil];
    [self setBackButton:nil];
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
            [challengesTableView reloadData];	
            
		}
		else
		{
			NSLog(@"yes button was pressed\n");

		}
	

	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [challengesTableView release];
    [backButton release];
    [webView release];
    [super dealloc];
}
- (IBAction)backButtonPushed:(id)sender {
    [self.view setAlpha:0];
    [self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpTakeChallengeViewCtrl)])
        [delegate cleanUpTakeChallengeViewCtrl];
}


#pragma mark xmlparser


-(void) GetTargetChallengesStatus
{
	//recordFriends = FALSE;
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
							 "<GetTargetChallengesStatus xmlns=\"http://quizmap.net/\">\n"
							 "<playerID>%@</playerID>\n"
							 "</GetTargetChallengesStatus>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",@"pera"
							 ];//[[GlobalSettingsHelper Instance] GetPlayerID]
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/ChallengeServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetTargetChallengesStatus" forHTTPHeaderField:@"SOAPAction"];
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


-(void) GetCreatedChallengesStatus
{
    
	//[m_activityIndicator startAnimating];
    
	
	//recordPlayerStartingWith = FALSE;
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
							 "<GetCreatedChallengesStatus xmlns=\"http://quizmap.net/\">\n"
							 "<playerIDStartWith>%@</playerIDStartWith>\n"
							 "</GetCreatedChallengesStatus>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",@"pera"
							 ];//[[GlobalSettingsHelper Instance] GetPlayerID]
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/ChallengeServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetCreatedChallengesStatus" forHTTPHeaderField:@"SOAPAction"];
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
	
	if( [elementName isEqualToString:@"status"])
        recordStatus= TRUE;    

    if( [elementName isEqualToString:@"creationTime"])
        recordCreationTime= TRUE;    

    if( [elementName isEqualToString:@"difficulty"])
        recordDifficulty= TRUE;    

    if ([elementName isEqualToString:@"targetResult"]) 
        readTargetValues = TRUE;

    if ([elementName isEqualToString:@"creatorResult"]) 
        readCreatorValues = TRUE;

    
    if ([elementName isEqualToString:@"questionsAns"]) 
        recordQuestionsAnswered = TRUE;

    if ([elementName isEqualToString:@"sumKmExceded"]) 
        recordSumKmExceded = TRUE;
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (recordStatus) 
        currentCollectedStatus = string;

    if (recordCreationTime) 
        currentCollectedCreationTime = string;

    if (recordDifficulty) 
        currentCollectedDifficulty = string;

    if (readTargetValues) {
        if (recordQuestionsAnswered) 
            currentCollectedTargetQuestionsAnswered = string;

        if(recordSumKmExceded)
            currentCollectedTargetSumKmExceded = string;

    }
    if (readCreatorValues) {
        if (recordQuestionsAnswered) 
            currentCollectedCreatorQuestionsAnswered = string;

        if(recordSumKmExceded)
            currentCollectedCreatorSumKmExceded = string;

    }
    
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"status"])
        recordStatus= FALSE;    
    
    if( [elementName isEqualToString:@"creationTime"])
        recordCreationTime= FALSE;    
    
    if( [elementName isEqualToString:@"difficulty"])
        recordDifficulty= FALSE;    
    
    if ([elementName isEqualToString:@"targetResult"]) 
        readTargetValues = FALSE;
    
    if ([elementName isEqualToString:@"creatorResult"]) 
        readCreatorValues = FALSE;
    
    
    if ([elementName isEqualToString:@"questionsAns"]) 
        recordQuestionsAnswered = FALSE;
    
    if ([elementName isEqualToString:@"sumKmExceded"]) 
        recordSumKmExceded = FALSE;
    
	if( [elementName isEqualToString:@"GetCreatedChallengesStatusResponse"] || [elementName isEqualToString:@"GetTargetChallengesStatusResponse"] )
	{

	}
	
}

@end
