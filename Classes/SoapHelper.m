//
//  GameEndHelper.m
//  MQNorway
//
//  Created by knut dullum on 09/01/2012.
//  Copyright (c) 2012 lemmus. All rights reserved.
//
#import "GlobalSettingsHelper.h"
#import "SoapHelper.h"

@implementation SoapHelper
@synthesize delegate;
-(void) setScore 
{
	recordPosition = FALSE;
	recordUserMessage = FALSE;
    
	
	NSString *soapMessage = [NSString stringWithFormat:
							 @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
							 "<SOAP-ENV:Envelope\n"
							 "xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"\n"
							 "xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"\n"
							 "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "SOAP-ENV:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"\n"
							 "xmlns:SOAP-ENV=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
							 "<SOAP-ENV:Body>\n"
							 "<SetScore xmlns=\"http://tempuri.org/\">\n"
							 "<playerID>%@</playerID>\n"
                             "<score>999</score>\n"
                             "<questions>911</questions>\n"
                             "<time>22</time>\n"
							 "<difficulty>easy</difficulty>\n"
							 "</SetScore>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",[[GlobalSettingsHelper Instance] GetPlayerID]
							 ];
	
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/ASP.NET/HighscoreServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://tempuri.org/SetScore" forHTTPHeaderField:@"SOAPAction"];
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


-(void) sendDeviceToken
{
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
							 "<MFUpdateDeviceToken xmlns=\"http://quizfeud.net/\">\n"
							 "<playerID>%@</playerID>\n"
                             "<deviceToken>%@</deviceToken>\n"
							 "</MFUpdateDeviceToken>\n"
							 "</SOAP-ENV:Body>\n"
							 "</SOAP-ENV:Envelope>",[[GlobalHelper Instance] ReadPlayerID],deviceToken
							 ];
	
	NSLog(@"%@", soapMessage);
	
	NSURL *url = [NSURL URLWithString:@"http://www.quizmap.net/mapfeud/MFPlayerServ.asmx"];
	
	NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
	NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
	
	[theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[theRequest addValue: @"http://quizfeud.net/MFUpdateDeviceToken" forHTTPHeaderField:@"SOAPAction"];
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
    
        
    m_userMessage = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"No connection with the server"]];
    //delegate call back
    if ([delegate respondsToSelector:@selector(noScoreResultConnection)])
        [delegate noScoreResultConnection];
		
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
	
	if( [elementName isEqualToString:@"position"])
	{
        recordPosition = TRUE;    
	}
	
	if( [elementName isEqualToString:@"userMessage"])
	{
		recordUserMessage = TRUE;
	}
    
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{

        if(recordPosition)
        {
            m_position = [NSString stringWithFormat:@"%@",string];
            recordPosition = FALSE;
        }
        
        if(recordUserMessage)
        {
            m_userMessage = [NSString stringWithFormat:@"%@",string];
            recordUserMessage = FALSE;
        }
    
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    
	if( [elementName isEqualToString:@"SetScoreResult"])
	{

        //delegate call back
        if ([delegate respondsToSelector:@selector(gotScoreResult)])
            [delegate gotScoreResult];
	}
    
    if( [elementName isEqualToString:@"MFUpdateDeviceTokenResponse"])
	{
        //int test = 0;
	}
}

-(NSString*) getUserMessage
{
    return m_userMessage;
}

@end
