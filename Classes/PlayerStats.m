//
//  PlayerStats.m
//  MQNorway
//
//  Created by knut dullum on 13/02/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//

#import "PlayerStats.h"

@implementation PlayerStats
@synthesize labelHeader;
@synthesize buttonBack;
@synthesize webViewStats;
@synthesize activityIndicator;
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
    [activityIndicator startAnimating];
    
    arrayNames = [[NSMutableArray alloc] init];
    arrayWins = [[NSMutableArray alloc] init];
    arrayLosses = [[NSMutableArray alloc] init];
    
    pageStartToLoad = [[[NSMutableString alloc] init] retain];
    [pageStartToLoad appendString:@"<html><head></head><body>"];
    [pageStartToLoad appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#eee9e9 ALIGN='center'><th>You vs. Player</th><th>Wins</th><th>Losses</th></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#b22222 ALIGN='center'><td>TEST per</td><td>1</td><td>4</td></tr>"];
    [pageStartToLoad appendString:@"<tr bgcolor=#98fb98 ALIGN='center'><td>TEST hans</td><td>4</td><td>2</td></tr>"];
        [pageStartToLoad appendString:@"<tr bgcolor=#dccdc ALIGN='center'><td>TEST sverre</td><td>12</td><td>12</td></tr>"];
    int wins = 0;
    int losses = 0;
    for (int i = 0; i<[arrayNames count]; i++) {
        NSString* colorProperty;
        if([[arrayWins objectAtIndex:i] intValue] == [[arrayLosses objectAtIndex:i] intValue])
            colorProperty = @"dccdc";
        else if([[arrayWins objectAtIndex:i] intValue] > [[arrayLosses objectAtIndex:i] intValue])
            colorProperty = @"98fb98";
        else
            colorProperty = @"b22222";
        
        [pageStartToLoad appendString:[NSString stringWithFormat:@"<tr bgcolor=#%@ ALIGN='center'><td>%@</td><td>%@</td><td>%@</td></tr>",colorProperty,[arrayNames objectAtIndex:i],[arrayWins objectAtIndex:i],[arrayLosses objectAtIndex:i]]];
        wins = wins + [[arrayWins objectAtIndex:i] intValue];
        losses = losses + [[arrayLosses objectAtIndex:i] intValue];
        
    }

    [pageStartToLoad appendString:[NSString stringWithFormat:@"<tr bgcolor=#eee9e9 ALIGN='center'><th>Total</th><th>%d</th><th>%d</th></tr>",wins,losses]];

    
    pageEndToLoad = [[[NSMutableString alloc] init] retain];
    [pageEndToLoad appendString:@"</table>"];
    [pageEndToLoad appendString:@"</body></html>"];
    
    [self GetFriends];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setLabelHeader:nil];
    [self setButtonBack:nil];
    [self setWebViewStats:nil];
    [self setActivityIndicator:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) ReloadHtml
{
	if (webViewStats != nil) {
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:pageStartToLoad];
        [pageToLoad appendString:pageEndToLoad];
        
		[webViewStats loadHTMLString:pageToLoad baseURL:nil];
    }
}

#pragma mark xmlparser


-(void) GetFriends
{
	recordName = FALSE;
    recordWins = FALSE;
    recordLosses = FALSE;
	index = 0;
	
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
	
	NSLog(@"%@",theXML);
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
        recordName = TRUE;    
	}
    if( [elementName isEqualToString:@"wins"])
	{
        recordWins = TRUE;    
	}
    
    if( [elementName isEqualToString:@"losses"])
	{
        recordLosses = TRUE;    
	}
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if(recordName)
    {
        recordName = FALSE;
        [arrayNames addObject:string];  
    }
    if(recordWins)
    {
        recordWins = FALSE;
        [arrayWins addObject:string];  
    }
    if(recordLosses)
    {
        recordLosses = FALSE;
        [arrayLosses addObject:string];  
    }


}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"FriendWithScore"])
		index ++;

    if( [elementName isEqualToString:@"GetFriendsResponse"])
        [self ReloadHtml];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [labelHeader release];
    [buttonBack release];
    [webViewStats release];
    [activityIndicator release];
    [super dealloc];
}
- (IBAction)buttonBackPushed:(id)sender {
    [self.view setAlpha:0];
    //[self dealloc];
    
    if ([delegate respondsToSelector:@selector(cleanUpPlayerStatsViewCtrl)])
        [delegate cleanUpPlayerStatsViewCtrl];
}
@end
