//
//  InstructionsView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "InstructionsView.h"
#import "GlobalSettingsHelper.h"
#import <QuartzCore/QuartzCore.h>


@implementation InstructionsView
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
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"];
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,20);
		[self addSubview:headerLabel];


		m_webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, 300, 320)];
		m_webView.center = CGPointMake([screen applicationFrame].size.width/2, 60 + (m_webView.frame.size.height/2));
		m_webView.backgroundColor = [UIColor clearColor]; 
		[m_webView setOpaque:NO];
		m_webView.scalesPageToFit = NO; 
		[self ReloadHtml];
		[self addSubview:m_webView];	
	
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

-(void) UpdateText
{
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Instructions"];
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	[self ReloadHtml];
	
}

- (void) ReloadHtml
{
	if (m_webView != nil) 
	{
		
		
//		NSString *pageUrlToLoad ;
//		if ( [[GlobalSettingsHelper Instance] GetLanguage] == norwegian) {
//			if (m_norTextFromFile == nil) {
//				NSString *filePathNor = [[NSBundle mainBundle] pathForResource:@"InfoNor" ofType:@"html"];
//				if (filePathNor) {
//					NSError *error = nil;
//					m_norTextFromFile = [[NSString stringWithContentsOfFile:filePathNor encoding:NSUTF8StringEncoding error:&error] retain];
//					if (m_norTextFromFile == nil) {
//						NSLog(@"Failed in reading html. Error: %@", error);
//					}
//					
//				}
//			} 
//			pageUrlToLoad = [m_norTextFromFile retain];
//		}
//		else {
//			if (m_engTextFromFile == nil) {
//				NSString *filePath = [[NSBundle mainBundle] pathForResource:@"InfoEng" ofType:@"html"];
//				if (filePath) {
//					m_engTextFromFile = [[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil] retain];
//				}
//			}
//			pageUrlToLoad = [m_engTextFromFile retain];
//		}
		
		
		NSString *filePathNor = [[NSBundle mainBundle] pathForResource:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"InfoEng"] ofType:@"html"];
		if (filePathNor) 
		{
			NSError *error = nil;
			NSString *textFromFile = [[NSString stringWithContentsOfFile:filePathNor encoding:NSUTF8StringEncoding error:&error] retain];
			if (textFromFile == nil) 
			{
				NSLog(@"Failed in reading html. Error: %@", error);
			}
//			
//			pageUrlToLoad = [m_norTextFromFile retain];
			
			NSString *path = [[NSBundle mainBundle] bundlePath];
			NSURL *baseURL = [NSURL fileURLWithPath:path];
			[m_webView loadHTMLString:textFromFile baseURL:baseURL];
//			[pageUrlToLoad release];
			
		}

	
		
//		NSString *path = [[NSBundle mainBundle] bundlePath];
//		NSURL *baseURL = [NSURL fileURLWithPath:path];
//		[m_webView loadHTMLString:pageUrlToLoad baseURL:baseURL];
//		[pageUrlToLoad release];
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
	self.hidden = NO;
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
	if ([delegate respondsToSelector:@selector(cleanUpInstructionsView)])
		[delegate cleanUpInstructionsView];
}

- (void)dealloc {
    [super dealloc];
}


@end
