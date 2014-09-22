//
//  TestView.m
//  MQNorway
//
//  Created by knut dullum on 19/08/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "TestView.h"



@implementation TestView

@synthesize greeting, nameInput, webData, soapResults, xmlParser, delegate;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		UIScreen *screen = [[UIScreen mainScreen] retain];
        // Initialization code.
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(100, 0, 250, 40)];
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,25);
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"TEST"];
		//		headerLabel.shadowColor = [UIColor blackColor];
		//		headerLabel.shadowOffset = CGSizeMake(2,2);
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		[self addSubview:headerLabel];
        
        SoapHelper* ssb = [[SoapHelper alloc] init];
        [ssb setDelegate:self];
        [ssb setScore];
		
		clockView = [[ClockView alloc] init];
//		//clockView.center = CGPointMake([screen applicationFrame].size.width/2, 90 + (m_webView.frame.size.height/2));
		[clockView setDelegate:self];
		[self addSubview:clockView];			
		
		m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0.0f, 150, 320)];
		m_webView.center = CGPointMake([screen applicationFrame].size.width/2, 90 + (m_webView.frame.size.height/2));
		m_webView.backgroundColor = [UIColor clearColor]; 
		[m_webView setOpaque:NO];
		m_webView.scalesPageToFit = NO; 
		m_webView.delegate = self;
		[self ReloadHtml];
		[self addSubview:m_webView];	
		
		
		buttonTest = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonTest addTarget:self action:@selector(goAnimate:) forControlEvents:UIControlEventTouchDown];
		[buttonTest setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"TestAnimation"] forState:UIControlStateNormal];
		buttonTest.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonTest.center = CGPointMake([screen applicationFrame].size.width/2,380);
		[self addSubview:buttonTest];
		
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,420);
		[self addSubview:buttonBack];
		
		
		pointLabel = [[UILabel alloc] init];
		[pointLabel setFrame:CGRectMake(0, 0, 250, 40)];
		pointLabel.backgroundColor = [UIColor clearColor]; 
		pointLabel.textColor = [UIColor whiteColor];
		[pointLabel setFont:[UIFont boldSystemFontOfSize:10.0f]];
		pointLabel.layer.masksToBounds = NO;
		pointLabel.text = @"7777";
		pointLabel.textAlignment = NSTextAlignmentCenter;
		pointLabel.center = CGPointMake(10,10);
		[pointLabel setAlpha:0];
		[self addSubview:pointLabel];
		
		
		recordResults = FALSE;
		
		
//		NSString *soapMessage = [NSString stringWithFormat:
//								 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
//								 "<SOAP-ENV:Envelope\n"
//								 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
//								 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
//								 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
//								 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
//								 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
//								 "<SOAP-ENV:Body>\n"
//								 "<GetListOfTen xmlns=\"http://tempuri.org/\">\n"
//								 "<playerName>hans</playerName>\n"
//								 "<playerGuid>123er</playerGuid>\n"
//								 "<score>5555</score>\n"
//								 "<time>3457</time>\n"
//								 "<difficulty>easy</difficulty>\n"
//								 "</GetListOfTen>\n"
//								 "</SOAP-ENV:Body>\n"
//								 "</SOAP-ENV:Envelope>"
//								 ];
		
		NSString *soapMessage = [NSString stringWithFormat:
								 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
								 "<SOAP-ENV:Envelope\n"
								 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
								 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
								 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
								 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
								 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
								 "<SOAP-ENV:Body>\n"
								 "<GetHighscoreList xmlns=\"http://tempuri.org/\">\n"
								 "<difficulty>easy</difficulty>\n"
								 "<league>empty</league>\n"
								 "</GetHighscoreList>\n"
								 "</SOAP-ENV:Body>\n"
								 "</SOAP-ENV:Envelope>"
								 ];

		
		NSLog(@"%@", soapMessage);
		
		//NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/MyWebService.asmx"];
		NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/HighscoreWebService.asmx"];

		NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
		NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
		
		[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		[theRequest addValue: @"http://tempuri.org/GetHighscoreList" forHTTPHeaderField:@"SOAPAction"];
		//[theRequest addValue: @"http://tempuri.org/GetListOfTen" forHTTPHeaderField:@"SOAPAction"];
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
		
		//[nameInput resignFirstResponder];
		
		
		
		
		[screen release];
		
		[self setAlpha:0];
    }
	
	

    return self;
}

-(void) gotScoreResult
{
    NSLog(@"got results");
}


- (void) ReloadHtml
{
	if (m_webView != nil) {
		
		

		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:@"<html><head></head><body>"];
		[pageToLoad appendString:@"HHHHHHTEST"];
		[pageToLoad appendString:@"</body></html>"];

		[m_webView loadHTMLString:pageToLoad baseURL:nil];
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
	
	
	NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
	[pageToLoad appendString:@"<html><head></head><body>"];
	[pageToLoad appendString:@"theXML"];
	[pageToLoad appendString:@"</body></html>"];
	
	[m_webView loadHTMLString:theXML baseURL:nil];
	
	
	
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
	if( [elementName isEqualToString:@"HelloResult"])
	{
		if(!soapResults)
		{
			soapResults = [[NSMutableString alloc] init];
		}
		recordResults = TRUE;
	}
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( recordResults )
	{
		[soapResults appendString: string];
	}
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"HelloResult"])
	{
		recordResults = FALSE;
		greeting.text = soapResults;
		[soapResults release];
		soapResults = nil;
	}
}


-(void)goBack:(id)Sender
{

	[self FadeOut];
}

-(void)goAnimate:(id)Sender
{
//	[clockView StartClock];

//	challengeFriendsView = [[ChallengeFriendsView alloc] initWithFrame:[self frame]];
//    [self addSubview:challengeFriendsView];
//    [challengeFriendsView FadeIn];
    
    if (challengeViewController == nil) {
    challengeViewController = [[ChallengeViewController alloc] initWithNibName:@"ChallengeViewController" bundle:nil]; 
    [self addSubview:challengeViewController.view];
    }
    
    
    
    
//    if (addExistingPlayerViewController == nil) {
//        addExistingPlayerViewController = [[AddExPlrViewCtrl alloc] initWithNibName:@"AddExPlrViewCtrl" bundle:nil]; 
//        [addExistingPlayerViewController setDelegate:self];
//        [self addSubview:addExistingPlayerViewController.view];
//    }
//    else
//    {
//        [addExistingPlayerViewController.view setAlpha:1];
//    }

    
}

-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	//[loadingLabel setAlpha:1];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(FinFadingOut)];
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(void) FinFadingOut
{
	if ([delegate respondsToSelector:@selector(CloseTestView)])
        [delegate CloseTestView];
}

-(void) DeductPoint
{
//	[UIView beginAnimations:@"pointDeduction" context:nil];
//	[UIView setAnimationDidStopSelector:@selector(DeductPointFinished)];  
//	[UIView setAnimationDelegate:self]; 
//	[UIView setAnimationDuration:1];
//	[pointLabel setAlpha:1];
//	pointLabel.center = CGPointMake(70, 70);
//	pointLabel.transform = CGAffineTransformMakeScale(2.0, 2.0);
//	[UIView commitAnimations];		
}

-(void) DeductPointFinished
{
	[UIView beginAnimations:@"pointDeductionFinished" context:nil];
	[UIView setAnimationDidStopSelector:@selector(ResetPointLabel)];  
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDuration:0.5];
	[pointLabel setAlpha:0];
	[UIView commitAnimations];
}

-(void) ResetPointLabel
{
	pointLabel.center = CGPointMake(10,10);
}

-(void) returnSelectedUserAndCleanUp:(NSString*) user
{
    [addExistingPlayerViewController removeFromParentViewController];
    addExistingPlayerViewController = nil;
    [buttonBack setTitle:user forState:UIControlStateNormal];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[m_skyView release],m_skyView = nil;
	[headerLabel release],headerLabel = nil;
	[m_webView release], m_webView = nil;
	[buttonBack release], buttonBack = nil;
    [super dealloc];
}


@end
