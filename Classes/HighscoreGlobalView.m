//
//  HighscoreGlobalView.m
//  MQNorway
//
//  Created by knut dullum on 01/11/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "HighscoreGlobalView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "UISwitch-extended.h"
#import "GlobalSettingsHelper.h"


@implementation HighscoreGlobalView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		m_centerX = [screen applicationFrame].size.width/2;
		m_centerY = [screen applicationFrame].size.height/2;
		
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 180, 40)];
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		//		headerLabel.shadowColor = [UIColor blackColor];
		//		headerLabel.shadowOffset = CGSizeMake(2,2);
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
		[self addSubview:headerLabel];
		
		subheaderLabel = [[UILabel alloc] init];
		[subheaderLabel setFrame:CGRectMake(40, 5, 70, 60)];
		subheaderLabel.backgroundColor = [UIColor clearColor]; 
		subheaderLabel.textColor = [UIColor redColor];
		[subheaderLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
		subheaderLabel.transform = CGAffineTransformMakeRotation( M_PI/4 );
		subheaderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"];
		subheaderLabelCenter = subheaderLabel.center;
		[self addSubview:subheaderLabel];
		
		nameLabels = [[NSMutableArray alloc] init];
		nameLabelsCenter = [[NSMutableArray alloc] init];
		easyQLabels = [[NSMutableArray alloc] init];
		qLabelsCenter = [[NSMutableArray alloc] init];
		timeLabels = [[NSMutableArray alloc] init];
		timeLabelsCenter = [[NSMutableArray alloc] init];
		pointsLabels = [[NSMutableArray alloc] init];
		pointsLabelsCenter = [[NSMutableArray alloc] init];
		
		int labelsXoffset = 0;
		int labeslYoffset = 0;
		
		
		int yPos = 0;
		NSValue *tempval;
		for (int i = 0; i < 10; i++) {
			
			//set labels for names
			UILabel *playerNameLabel = [[UILabel alloc] init];
			[playerNameLabel setFrame:CGRectMake(3 + labelsXoffset, 100 + yPos + labeslYoffset, 120, 20)];
			playerNameLabel.backgroundColor = [UIColor clearColor]; 
			playerNameLabel.textColor = [UIColor whiteColor];
			[playerNameLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerNameLabel];
			[nameLabels addObject:playerNameLabel];
			tempval = [[NSValue valueWithCGPoint:playerNameLabel.center] retain];
			[nameLabelsCenter addObject:tempval];
			[tempval release];
			[playerNameLabel release];
			
			//set labels for questions passed
			UILabel *playerQLabel = [[UILabel alloc] init];
			[playerQLabel setFrame:CGRectMake(140 + labelsXoffset, 100 + yPos + labeslYoffset, 50, 20)];
			playerQLabel.backgroundColor = [UIColor clearColor]; 
			playerQLabel.textColor = [UIColor whiteColor];
			[playerQLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerQLabel];
			[easyQLabels addObject:playerQLabel];
			tempval = [[NSValue valueWithCGPoint:playerQLabel.center] retain];
			[qLabelsCenter addObject:tempval];
			[tempval release];
			[playerQLabel release];
			
			
			//time labels
			UILabel *playerTimeLabel = [[UILabel alloc] init];
			[playerTimeLabel setFrame:CGRectMake(220 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerTimeLabel.backgroundColor = [UIColor clearColor]; 
			playerTimeLabel.textColor = [UIColor whiteColor];
			[playerTimeLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerTimeLabel];
			[timeLabels addObject:playerTimeLabel];
			tempval = [[NSValue valueWithCGPoint:playerTimeLabel.center] retain];
			[timeLabelsCenter addObject:tempval];
			[tempval release];
			[playerTimeLabel release];
			
			UILabel *playerPointsLabel = [[UILabel alloc] init];
			[playerPointsLabel setFrame:CGRectMake(280 + labelsXoffset, 100 + yPos + labeslYoffset, 80, 20)];
			playerPointsLabel.backgroundColor = [UIColor clearColor]; 
			playerPointsLabel.textColor = [UIColor whiteColor];
			[playerPointsLabel setFont:[UIFont boldSystemFontOfSize:15.0f]];
			[self addSubview:playerPointsLabel];
			[pointsLabels addObject:playerPointsLabel];
			tempval = [[NSValue valueWithCGPoint:playerPointsLabel.center] retain];
			[pointsLabelsCenter addObject:tempval];
			[tempval release];
			[playerPointsLabel release];
			
			yPos += 25;
		}
		
		UILabel *headerHighscorePosition = [[UILabel alloc] init];
		[headerHighscorePosition setFrame:CGRectMake(3, 60, 50, 40)];
		headerHighscorePosition.backgroundColor = [UIColor clearColor]; 
		headerHighscorePosition.textColor = [UIColor yellowColor];
		[headerHighscorePosition setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerHighscorePosition.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Pos."];
		headerHighscorePosition.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerHighscorePosition.layer.shadowOpacity = 1.0;
		[self addSubview:headerHighscorePosition];
		
		UILabel *headerQuestionsAnsw = [[UILabel alloc] init];
		[headerQuestionsAnsw setFrame:CGRectMake(118, 60, 90, 40)];
		headerQuestionsAnsw.backgroundColor = [UIColor clearColor]; 
		headerQuestionsAnsw.textColor = [UIColor yellowColor];
		[headerQuestionsAnsw setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerQuestionsAnsw.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No. answers"];
		headerQuestionsAnsw.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerQuestionsAnsw.layer.shadowOpacity = 1.0;
		[self addSubview:headerQuestionsAnsw];
		
		
		UILabel *headerTime = [[UILabel alloc] init];
		[headerTime setFrame:CGRectMake(221, 60, 90, 40)];
		headerTime.backgroundColor = [UIColor clearColor]; 
		headerTime.textColor = [UIColor yellowColor];
		[headerTime setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerTime.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Time"];
		headerTime.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerTime.layer.shadowOpacity = 1.0;
		[self addSubview:headerTime];
		
		
		headerScore = [[UILabel alloc] init];
		[headerScore setFrame:CGRectMake(275, 60, 90, 40)];
		headerScore.backgroundColor = [UIColor clearColor]; 
		headerScore.textColor = [UIColor yellowColor];
		[headerScore setFont:[UIFont boldSystemFontOfSize:10.0f]];
		headerScore.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Score"];
		headerScore.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerScore.layer.shadowOpacity = 1.0;
		[self addSubview:headerScore];
		
		
		
		button_levelDown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelDown addTarget:self action:@selector(levelDown) forControlEvents:UIControlEventTouchDown];
		[button_levelDown setTitle:@"<- Level down" forState:UIControlStateNormal];
		button_levelDown.frame = CGRectMake(5, 345, 140, 40);
		//button_levelDown.frame = CGRectMake(5, 350, 140, 40);
		button_levelDownCenter = button_levelDown.center;
		[self addSubview:button_levelDown];
		
		button_levelUp = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button_levelUp addTarget:self action:@selector(levelUp) forControlEvents:UIControlEventTouchDown];
		[button_levelUp setTitle:@"Level up ->" forState:UIControlStateNormal];
		button_levelUp.frame = CGRectMake(170, 345, 140, 40);
		//button_levelUp.frame = CGRectMake(170, 350, 140, 40);
		button_levelUpCenter = button_levelUp.center;
		[self addSubview:button_levelUp];
		
		button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
		[button_levelUp setAlpha:0];
		
		switchShowButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[switchShowButton addTarget:self action:@selector(goSwitchShow:) forControlEvents:UIControlEventTouchDown];
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View top ten"] forState:UIControlStateNormal];
		switchShowButton.frame = CGRectMake([screen applicationFrame].size.width/2 - (180/2), 390.0, 180.0, 40.0);
		//buttonBack.frame = CGRectMake(80.0, 410.0, 180.0, 40.0);
		[self addSubview:switchShowButton];
		showTopTen = false;
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake([screen applicationFrame].size.width/2 - (180/2), 435.0, 180.0, 40.0);
		//buttonBack.frame = CGRectMake(80.0, 410.0, 180.0, 40.0);
		[self addSubview:buttonBack];
		
		m_showingLevel = hardDif;

		
		m_activityIndicator = [[UIActivityIndicatorView alloc] init];
		m_activityIndicator.frame  = CGRectMake(0,0,60,60);
		m_activityIndicator.center = CGPointMake([screen applicationFrame].size.width/2,[screen applicationFrame].size.height/2);
		m_activityIndicator.hidesWhenStopped  = YES;
		[self addSubview:m_activityIndicator];	
		[m_activityIndicator startAnimating];
		[self bringSubviewToFront:m_activityIndicator];
		
		
		recordName = FALSE;
		recordScore = FALSE;
		recordTime = FALSE;

		NSString *soapMessage = [NSString stringWithFormat:
								 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
								 "<SOAP-ENV:Envelope\n"
								 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
								 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
								 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
								 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
								 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
								 "<SOAP-ENV:Body>\n"
								 "<GetHighscoreList xmlns=\"http://quizmap.net/\">\n"
								 "<difficulty>hard</difficulty>\n"
								 "<league>empty</league>\n"
								 "</GetHighscoreList>\n"
								 "</SOAP-ENV:Body>\n"
								 "</SOAP-ENV:Envelope>"
								 ];
		
		index = 0;
		NSLog(@"%@", soapMessage);
		
		NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/HighscoreServ.asmx"];
		NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
		NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
		
		[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
		[theRequest addValue: @"http://quizmap.net/GetHighscoreList" forHTTPHeaderField:@"SOAPAction"];
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
		
		[screen release];
		[self setAlpha:0];
    }
    return self;
}

-(void) levelUp
{
	[button_levelDown setUserInteractionEnabled:FALSE];
	[button_levelUp setUserInteractionEnabled:FALSE];
	[switchShowButton setUserInteractionEnabled:FALSE];
	if (m_showingLevel == easy) {
		m_showingLevel = medium;
		[self changeLevel];
	}
	else  if(m_showingLevel == medium){
		m_showingLevel = hardDif;
		[self changeLevel];
	}
}

-(void) levelDown
{
	[button_levelDown setUserInteractionEnabled:FALSE];
	[button_levelUp setUserInteractionEnabled:FALSE];
	[switchShowButton setUserInteractionEnabled:FALSE];
	if (m_showingLevel == hardDif) {
		m_showingLevel = medium;
		[self changeLevel];
	}
	else if(m_showingLevel == medium){
		m_showingLevel = easy;
		[self changeLevel];
	}
}

-(void) clearResults
{
	
	
	for (int i = 0; i < 10; i++) {
				
		UILabel *nameTempLabel = [[nameLabels objectAtIndex:i] retain];
		nameTempLabel.text = @"";
		[nameTempLabel release];	
		
		UILabel *pointsLabel = [[pointsLabels objectAtIndex:i]retain];
		pointsLabel.text = @"";
		[pointsLabel release];

		UILabel *timeLabel = [[timeLabels objectAtIndex:i]retain];
		timeLabel.text = @"";
		[timeLabel release];
	
	}

}

-(void) changeLevel
{
	[self clearResults];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[UIView setAnimationDelegate:self]; 
	[UIView setAnimationDidStopSelector:@selector(finishedMovingLabelsIn)]; 
	CGPoint centerPoint = CGPointMake(m_centerX, m_centerY);
	NSString *levelString = @"easy";
	switch (m_showingLevel) {
		case easy:
			button_levelUp.center = CGPointMake(m_centerX, button_levelUp.frame.origin.y + (button_levelUp.frame.size.height/2) );
			[button_levelDown setAlpha:0];
			levelString = @"easy";
			break;
		case medium:
			button_levelUp.center = button_levelUpCenter;
			[button_levelUp setAlpha:1];
			button_levelDown.center = button_levelDownCenter;
			[button_levelDown setAlpha:1];
			levelString = @"medium";
			break;
		case hardDif:
		case veryhardDif:
			button_levelDown.center = CGPointMake(m_centerX, button_levelDown.frame.origin.y + (button_levelDown.frame.size.height/2) );
			[button_levelUp setAlpha:0];
			levelString = @"hard";
		default:
			break;
	}
	[subheaderLabel setAlpha:0];
	subheaderLabel.center = centerPoint;
	[UIView commitAnimations];	
	
	[m_activityIndicator startAnimating];
	
	recordName = FALSE;
	recordScore = FALSE;
	recordTime = FALSE;
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
							 "<GetHighscoreList xmlns=\"http://quizmap.net/\">\n"
							 "<difficulty>%@</difficulty>\n"
							 "<league>empty</league>\n"
							 "</GetHighscoreList>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",levelString
							 ];
	
	
	NSLog(@"%@",soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/HighscoreServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetHighscoreList" forHTTPHeaderField:@"SOAPAction"];
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

-(void) finishedMovingLabelsIn
{
	switch (m_showingLevel) {
		case easy:
			subheaderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"easy"];
			break;
		case medium:
			subheaderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"medium"];
			break;
		case hardDif:
		case veryhardDif:
			subheaderLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"hard"];
			break;
		default:
			break;
	}
	subheaderLabel.center = CGPointMake(m_centerX, subheaderLabel.frame.origin.y + (subheaderLabel.frame.size.height/2));
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	[subheaderLabel setAlpha:1];
	subheaderLabel.center = subheaderLabelCenter;
	[UIView commitAnimations];	
}

-(void) showPlayerHighscore
{
	[self clearResults];
	[m_activityIndicator startAnimating];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
	
	recordName = FALSE;
	recordScore = FALSE;
	recordTime = FALSE;
	index = 0;
	
	NSString *levelString = @"hard";
	switch (m_showingLevel) {
		case easy:
			levelString = @"easy";
			break;
		case medium:
			levelString = @"medium";
			break;
		default:
			break;
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
							 "<GetListForPlayer xmlns=\"http://quizmap.net/\">\n"
							 "<playerID>%@</playerID>\n"
							 "<difficulty>%@</difficulty>\n"
							 "</GetListForPlayer>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",[[GlobalSettingsHelper Instance] GetPlayerID],levelString
							 ];
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/HighscoreServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetListForPlayer" forHTTPHeaderField:@"SOAPAction"];
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

-(void) showTopTen
{
	[self clearResults];
	[m_activityIndicator startAnimating];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Top ten"];
	
	recordName = FALSE;
	recordScore = FALSE;
	recordTime = FALSE;
	index = 0;
	NSString *levelString = @"hard";
	switch (m_showingLevel) {
		case easy:
			levelString = @"easy";
			break;
		case medium:
			levelString = @"medium";
			break;
		default:
			break;
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
								 "<GetHighscoreList xmlns=\"http://quizmap.net/\">\n"
								 "<difficulty>%@</difficulty>\n"
                                 "<league>none</league>\n"
								 "</GetHighscoreList>\n"
								 "</SOAP-ENV:Body>\n"
								 "</SOAP-ENV:Envelope>",levelString
								 ];
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/HighscoreServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizmap.net/GetHighscoreList" forHTTPHeaderField:@"SOAPAction"];
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

-(void) UpdateLabels
{
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Highscores"];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
}


//- (void)webViewDidFinishLoad:(UIWebView *)wv {
//	[loadingLabel setAlpha:0];
//	[m_activityIndicator stopAnimating];
//	[m_activityIndicator setAlpha:0];
//    NSLog (@"webViewDidFinishLoad");
//    //[activityIndicator stopAnimating]; bundle:[NSBundle mainBundle]
//}



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
	
	if( [elementName isEqualToString:@"place"])
	{
        recordPlace = TRUE;    
	}
	
	if( [elementName isEqualToString:@"name"])
	{
		recordName = TRUE;
	}
	
	if( [elementName isEqualToString:@"score"])
	{
		recordScore = TRUE;
	}
	
	if( [elementName isEqualToString:@"time"])
	{
		recordTime = TRUE;
	}
    
    if( [elementName isEqualToString:@"questions"])
	{
		recordQuestions = TRUE;
	}

}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if (index < 9) {
        if(recordName)
        {
            UILabel *tempLabel = [[nameLabels objectAtIndex:index] retain];
            tempLabel.text = [NSString stringWithFormat:@"%d. %@",index + 1, string];
            [tempLabel release];
            recordName = FALSE;
        }
        
        if(recordScore)
        {
            UILabel *pointsLabel = [[pointsLabels objectAtIndex:index]retain];
            pointsLabel.text = [NSString stringWithFormat:@"%d", [string intValue]];
            [pointsLabel release];
            recordScore = FALSE;
        }
        
        if(recordTime)
        {
            UILabel *timeLabel = [[timeLabels objectAtIndex:index]retain];
            NSString *seconds = [[NSString stringWithFormat:@"%d",[string intValue]%60] retain];
            if ([seconds length] == 1 ) {
                timeLabel.text = [NSString stringWithFormat:@"%d:0%d ",[string intValue]/60,[string intValue]%60];
            }
            else {
                timeLabel.text = [NSString stringWithFormat:@"%d:%d ",[string intValue]/60,[string intValue]%60];
            }
            [seconds release];
            [timeLabel release];
            recordTime = FALSE;
        }	
    }
    else
    {
        NSLog(@"Too much soap data returned!");
        recordTime = FALSE;
        recordScore = FALSE;
        recordName = FALSE;
    }


}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
	if( [elementName isEqualToString:@"Player"])
	{
		index ++;

	}
    if( [elementName isEqualToString:@"anyType"])
	{
		index ++;
	}


						  
	if( [elementName isEqualToString:@"GetHighscoreListResponse"])
	{
		[m_activityIndicator stopAnimating];
		[button_levelDown setUserInteractionEnabled:TRUE];
		[button_levelUp setUserInteractionEnabled:TRUE];
		[switchShowButton setUserInteractionEnabled:TRUE];
		
	}
	
	if( [elementName isEqualToString:@"GetListForPlayerResponse"])
	{
		[m_activityIndicator stopAnimating];
		[button_levelDown setUserInteractionEnabled:TRUE];
		[button_levelUp setUserInteractionEnabled:TRUE];
		[switchShowButton setUserInteractionEnabled:TRUE];
		
	}
	
	
}

-(void)goBack:(id)Sender
{
	[self FadeOut];
}

-(void) goSwitchShow:(id)Sender
{
	[button_levelDown setUserInteractionEnabled:FALSE];
	[button_levelUp setUserInteractionEnabled:FALSE];
	[switchShowButton setUserInteractionEnabled:FALSE];
	if (showTopTen) {
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View top ten"] forState:UIControlStateNormal];
		[self showPlayerHighscore];
		showTopTen = FALSE;
	}
	else {
		[switchShowButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"View your position"] forState:UIControlStateNormal];
		showTopTen = TRUE;
		[self showTopTen];
	}
}


-(void) FadeIn
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView commitAnimations];	
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
	if ([delegate respondsToSelector:@selector(cleanUpHigscoreGlobalView)])
		[delegate cleanUpHigscoreGlobalView];
}


#define HORIZ_SWIPE_DRAG_MIN 100

BOOL isProcessingListMove;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	CGPoint newTouchPosition = [touch locationInView:self];
	if(startTouchPosition.x != newTouchPosition.x || startTouchPosition.y != newTouchPosition.y) {
		isProcessingListMove = NO;
	}
	startTouchPosition = [touch locationInView:self];
	[super touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event 
{
	UITouch *touch = touches.anyObject;
	CGPoint currentTouchPosition = [touch locationInView:self];
	
	// If the swipe tracks correctly.
	double diffx = startTouchPosition.x - currentTouchPosition.x + 0.1; // adding 0.1 to avoid division by zero
	double diffy = startTouchPosition.y - currentTouchPosition.y + 0.1; // adding 0.1 to avoid division by zero
	
	if(abs(diffx / diffy) > 1 && abs(diffx) > HORIZ_SWIPE_DRAG_MIN)
	{
		// It appears to be a swipe.
		if(isProcessingListMove) {
			// ignore move, we're currently processing the swipe
			return;
		}
		
		if (startTouchPosition.x < currentTouchPosition.x) {
			isProcessingListMove = YES;
			[self levelDown];
			return;
		}
		else {
			isProcessingListMove = YES;
			[self levelUp];
			return;
		}
	}
	else if(abs(diffy / diffx) > 1)
	{
		isProcessingListMove = YES;
		[super touchesMoved:touches	withEvent:event];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
	isProcessingListMove = NO;
	[super touchesEnded:touches withEvent:event];
}


//fails , not in use
- (void)dealloc {
	[pathEasy release];
	[pathMedium release];
	[pathHard release];
	
    [super dealloc];
}
@end
