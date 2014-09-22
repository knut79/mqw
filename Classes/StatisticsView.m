//
//  StatisticsView.m
//  MQNorway
//
//  Created by knut dullum on 02/04/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "StatisticsView.h"
#import "GlobalSettingsHelper.h"
#import "SqliteHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation StatisticsView
@synthesize delegate;


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[self addSubview:m_skyView];
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(100, 0, 250, 40)];
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
//		headerLabel.shadowColor = [UIColor blackColor];
//		headerLabel.shadowOffset = CGSizeMake(2,2);
		headerLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		headerLabel.layer.shadowOpacity = 1.0;
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Statistics"];
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,20);
		[self addSubview:headerLabel];
		

		
		
	
		placeHeader = [[UILabel alloc] init];
		[placeHeader setFrame:CGRectMake(20, 70 - 20, 90, 40)];
		placeHeader.backgroundColor = [UIColor clearColor]; 
		placeHeader.textColor = [UIColor yellowColor];
		placeHeader.textAlignment = NSTextAlignmentLeft;
		[placeHeader setFont:[UIFont boldSystemFontOfSize:10.0f]];
		placeHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Target"];
		placeHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
		placeHeader.layer.shadowOpacity = 1.0;
		[self addSubview:placeHeader];
		
		questionsAnswHeader = [[UILabel alloc] init];
		[questionsAnswHeader setFrame:CGRectMake(0, 0, 90, 40)];
		questionsAnswHeader.backgroundColor = [UIColor clearColor]; 
		questionsAnswHeader.textColor = [UIColor yellowColor];
		questionsAnswHeader.textAlignment = NSTextAlignmentCenter;
		questionsAnswHeader.center = CGPointMake([screen applicationFrame].size.width/2,70);
		[questionsAnswHeader setFont:[UIFont boldSystemFontOfSize:10.0f]];
		questionsAnswHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No. answers"];
		questionsAnswHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
		questionsAnswHeader.layer.shadowOpacity = 1.0;
		[self addSubview:questionsAnswHeader];
		
		avgDistanceHeader = [[UILabel alloc] init];
		[avgDistanceHeader setFrame:CGRectMake([screen applicationFrame].size.width - 90 - 20, 70 - 20, 90, 40)];
		avgDistanceHeader.backgroundColor = [UIColor clearColor]; 
		avgDistanceHeader.textColor = [UIColor yellowColor];
		avgDistanceHeader.textAlignment = NSTextAlignmentRight;
		[avgDistanceHeader setFont:[UIFont boldSystemFontOfSize:10.0f]];
		avgDistanceHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Avg. distance"];
		avgDistanceHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
		avgDistanceHeader.layer.shadowOpacity = 1.0;
		[self addSubview:avgDistanceHeader];
		
		
		touchForMoreInfoHeader = [[UILabel alloc] init];
		[touchForMoreInfoHeader setFrame:CGRectMake(0, 0, 90, 40)];
		touchForMoreInfoHeader.backgroundColor = [UIColor clearColor]; 
		touchForMoreInfoHeader.textColor = [UIColor whiteColor];
		touchForMoreInfoHeader.textAlignment = NSTextAlignmentCenter;
		[touchForMoreInfoHeader setFont:[UIFont boldSystemFontOfSize:10.0f]];
		touchForMoreInfoHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"(Touch for info)"];
		touchForMoreInfoHeader.center = CGPointMake([screen applicationFrame].size.width/2,45);
		touchForMoreInfoHeader.layer.shadowColor = [[UIColor blackColor] CGColor];
		touchForMoreInfoHeader.layer.shadowOpacity = 1.0;
		[self addSubview:touchForMoreInfoHeader];
		
		
		destinationHeader = [[UILabel alloc] init];
		[destinationHeader setFrame:CGRectMake(0, 0, 300, 50)];
		destinationHeader.backgroundColor = [UIColor clearColor]; 
		destinationHeader.textColor = [UIColor blackColor];
		[destinationHeader setFont:[UIFont systemFontOfSize:12.0f]];
		destinationHeader.text = [NSString stringWithFormat:@"%@ %@. %@.",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Showing location, questions answered for given location"],
								  [[GlobalSettingsHelper Instance] GetStringByLanguage:@"and the average distance made to that target"],
								  [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Only for singleplayer games"]];
		destinationHeader.textAlignment = NSTextAlignmentLeft;
		destinationHeader.numberOfLines = 3;
		destinationHeader.center = CGPointMake([screen applicationFrame].size.width/2,65);
		[destinationHeader setAlpha:0];
		[self addSubview:destinationHeader];
		
		showingInfo = NO;
		
		

		
		m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 0.0f, 300, 320)];
		m_webView.center = CGPointMake([screen applicationFrame].size.width/2, 90 + (m_webView.frame.size.height/2));
		m_webView.backgroundColor = [UIColor clearColor]; 
		[m_webView setOpaque:NO];
		m_webView.scalesPageToFit = NO; 
		m_webView.delegate = self;
		//[self ReloadHtml];
		[self addSubview:m_webView];	
		
		
		loadingLabel = [[UILabel alloc] init];
		[loadingLabel setFrame:CGRectMake(100, 0, 250, 40)];
		loadingLabel.backgroundColor = [UIColor clearColor]; 
		loadingLabel.textColor = [UIColor whiteColor];
		[loadingLabel setFont:[UIFont boldSystemFontOfSize:22.0f]];
		loadingLabel.layer.shadowColor = [[UIColor blackColor] CGColor];
		loadingLabel.layer.shadowOpacity = 1.0;
		loadingLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Loading table"];
		loadingLabel.textAlignment = NSTextAlignmentCenter;
		loadingLabel.center = CGPointMake([screen applicationFrame].size.width/2 ,([screen applicationFrame].size.height/2)+ 50);
		[self addSubview:loadingLabel];
		
		m_activityIndicator = [[UIActivityIndicatorView alloc] init];
		m_activityIndicator.frame  = CGRectMake(0,0,60,60);
		m_activityIndicator.center = loadingLabel.center;
		m_activityIndicator.hidesWhenStopped  = YES;
		[self addSubview:m_activityIndicator];	
		[m_activityIndicator startAnimating];
		[self bringSubviewToFront:m_activityIndicator];
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,420);
		[self addSubview:buttonBack];
		
		[self setAlpha:0];
		
		[screen release];
    }
    return self;
}

- (void)webViewDidFinishLoad:(UIWebView *)wv {
	[loadingLabel setAlpha:0];
	[m_activityIndicator stopAnimating];
	[m_activityIndicator setAlpha:0];
    NSLog (@"webViewDidFinishLoad");
    //[activityIndicator stopAnimating]; bundle:[NSBundle mainBundle]
}
//
//-(void) loadView
//{
//	UIViewController *caont;
//	[super loadView];
//}
//
//-(void) viewDidLoad
//{
//	 NSLog (@"webViewDidFinishLoad");
//}

-(void) UpdateText
{
	destinationHeader.text = [NSString stringWithFormat:@"%@ %@. %@.",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Showing location, questions answered for given location"],
							  [[GlobalSettingsHelper Instance] GetStringByLanguage:@"and the average distance made to that target"],
							  [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Only for singleplayer games"]];

	placeHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Target"];
	questionsAnswHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"No. answers"];
	avgDistanceHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Avg. distance"];
	touchForMoreInfoHeader.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"(Touch for info)"];
	
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Statistics"];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	//[self ReloadHtml];
	
}

- (void) ReloadHtml
{
	if (m_webView != nil) {
		
//		DistanceMeasurement measurement = [[GlobalSettingsHelper Instance] GetDistance];
//		NSString *measurementString;
//		if (measurement == mile) {
//			measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"miles"];
//		}
//		else {
//			measurementString = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"km"];
//		}

		
		NSMutableString *pageToLoad = [[[NSMutableString alloc] init] autorelease];
		[pageToLoad appendString:@"<html><head></head><body>"];
		[pageToLoad appendString:@"<table border='0' CELLSPACING=3 width='280'>"];
//		[pageToLoad appendString:@"<tr>"];
//		[pageToLoad appendString:@"<th><font size='3'>Destination</font></th>"];
//		[pageToLoad appendString:@"<th>Questions answered</th>"];
//		[pageToLoad appendString:@"<th>Average distance to target</th>"];
//		[pageToLoad appendString:@"</tr>"];
		
		
		BOOL noResults = YES;
		FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE locationtype = 'City'"
							" AND sumAnswers > 0 " 
							"ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow])
		{
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Cities"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while([results next]);
			noResults = NO;
		}
        [results close];

		

		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE locationtype = 'State'" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow])
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"States"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE locationtype = 'County'"
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow])
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Counties"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while ([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE locationtype = 'Fjord'" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
		if ([results hasAnotherRow]== YES)
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Fjords"]]];

			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										 [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while ([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer,avgDistance , sumAnswers FROM location WHERE locationtype = 'Lake'" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow] == YES)
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Lakes"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer,avgDistance , sumAnswers FROM location WHERE locationtype = 'Mountain'" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow] == YES)
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Mountains"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE locationtype = 'Island'" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow] == YES)
		{	
			[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Islands"]]];
			do
			{
				[pageToLoad appendString:@"<tr>"];
				[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
										  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//				if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//				{
//					[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//				}
//				else {
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
											  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
											   [[results stringForColumn:@"avgDistance"] intValue]],
                                              [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//				}
				
				[pageToLoad appendString:@"</tr>"];
			}while([results next]);
			noResults = NO;
		}
        [results close];
		
		results = [[SqliteHelper Instance] executeQuery:@"SELECT locationID, locationNameEng,locationNameNor,locationNameSpn,locationNameFra,locationNameGer ,avgDistance , sumAnswers FROM location WHERE (locationtype = 'UnDefRegion'" 
				   "OR locationtype = 'UnDefPlace')" 
				   " AND sumAnswers > 0 " 
				   "ORDER BY avgDistance DESC, ? ASC",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]];
        [results next];
		if ([results hasAnotherRow] == YES)
		{
		
			//[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Other"]]];
			do
			{
				BOOL headerAdded = NO;
				//if one of the connecting questions is marked as notUsed. dont show this location
				if(![[results stringForColumn:@"locationID"] hasSuffix:@"NU"])
				{
					if (headerAdded == NO) {
						[pageToLoad appendString:[NSString stringWithFormat:@"<tr BGCOLOR='#FFFFFF'><th COLSPAN=3>%@</th></tr>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Other"]]];
						headerAdded = YES;
					}
					
					
					[pageToLoad appendString:@"<tr>"];
					[pageToLoad appendString:[NSString stringWithFormat:@"<td><div style='width: 100px; overflow:hidden;'>%@</div></td>",
											  [results stringForColumn:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"locationNameEng"]]]];
//					if ([[dictionary objectForKey:@"sumAnswers"] intValue] <= 0 ) 
//					{
//						[pageToLoad appendString:[NSString stringWithFormat:@"<td COLSPAN=2 ALIGN='center'>%@</td>",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Not yet answered"]]];
//					}
//					else {
						[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[results stringForColumn:@"sumAnswers"]]];
						[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='right'>%d %@</td>",
												  [[GlobalSettingsHelper Instance] ConvertToRightDistance:
												   [[results stringForColumn:@"avgDistance"] intValue]],
                                                  [[GlobalSettingsHelper Instance] GetDistanceMeasurementString]]];
//					}
					
					[pageToLoad appendString:@"</tr>"];
				}
			}while([results next]);
			noResults = NO;
		}
        [results close];
		
		if (noResults == YES) {
			[pageToLoad appendString:@"<tr>"];

			//[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'>%@</td>",[dictionary objectForKey:@"sumAnswers"]]];
			[pageToLoad appendString:[NSString stringWithFormat:@"<td ALIGN='center'><div style='width: 100px; overflow:hidden;'>Answer questions in singleplayer game or training mode</div></td>"]];

			
			[pageToLoad appendString:@"</tr>"];
		}
							

		[pageToLoad appendString:@"</table>"];
		[pageToLoad appendString:@"</body></html>"];
		
		


		[m_webView loadHTMLString:pageToLoad baseURL:nil];
	}	
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	// Get some details about the view
	CGSize size = [scrollView frame].size;
	CGPoint offset = [scrollView contentOffset];
	CGSize contentSize = [scrollView contentSize];
	
	// Are we at the bottom?
	if (-offset.y + size.height <= contentSize.height)
		NSLog(@"bottom");
	else
		NSLog(@"not bottom");
}

-(void)goBack:(id)Sender
{
	[self FadeOut];
}

-(void) FadeIn
{
	[loadingLabel setAlpha:1];
	[self UpdateText];
	//self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];  
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView setAnimationDidStopSelector:@selector(FinishedFadingIn)];  
	[UIView commitAnimations];	
}

-(void) FinishedFadingIn
{
	[loadingLabel setAlpha:1];
	[m_activityIndicator setAlpha:1];
	[m_activityIndicator startAnimating];
	[self ReloadHtml];
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
    if ([delegate respondsToSelector:@selector(cleanUpStatisticsView)])
        [delegate cleanUpStatisticsView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self]; 	      
	[UIView setAnimationDidStopSelector:@selector(FinishedAnimatingPlayer)];  
	[UIView setAnimationDuration:0.4];
	if (showingInfo == NO) {
		[destinationHeader setAlpha:1];
		[touchForMoreInfoHeader setAlpha:0];
		[questionsAnswHeader setAlpha:0];
		[placeHeader setAlpha:0];
		[avgDistanceHeader setAlpha:0];
		showingInfo = YES;
	}
	else {
		[destinationHeader setAlpha:0];
		[touchForMoreInfoHeader setAlpha:1];
		[questionsAnswHeader setAlpha:1];
		[placeHeader setAlpha:1];
		[avgDistanceHeader setAlpha:1];
		showingInfo = NO;
	}


	[UIView commitAnimations];	

}



- (void)dealloc {
    [super dealloc];
}


@end
