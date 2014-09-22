//
//  SettingsMenuView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "SettingsMenuView.h"
#import "GlobalSettingsHelper.h"

@implementation SettingsMenuView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.9];
		[m_skyView setBackgroundFile:@"clouds.png"];
		[self addSubview:m_skyView];

		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(100, 0, 180, 40)];
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2,25);
		headerLabel.textAlignment = UITextAlignmentCenter;
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
		headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"];
		[self addSubview:headerLabel];
		headerLabelCenter = headerLabel.center;

		buttonLanguage = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonLanguage addTarget:self action:@selector(changeLanguage:) forControlEvents:UIControlEventTouchDown];
		[buttonLanguage setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Language: english"] forState:UIControlStateNormal];
		buttonLanguage.frame = CGRectMake(80.0, 60.0, 180.0, 40.0);
		buttonLanguage.center = CGPointMake([screen applicationFrame].size.width/2,70);
		[self addSubview:buttonLanguage];
		buttonLanguageCenter = buttonLanguage.center;

		buttonDistance = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonDistance addTarget:self action:@selector(changeDistance:) forControlEvents:UIControlEventTouchDown];
		[buttonDistance setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance in: kilometers"] forState:UIControlStateNormal];
		buttonDistance.frame = CGRectMake(80.0, 160.0, 180.0, 40.0);
		buttonDistance.center = CGPointMake([screen applicationFrame].size.width/2,170);
		[self addSubview:buttonDistance];
		buttonDistanceCenter = buttonDistance.center;
		
		buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonBack addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchDown];
		[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
		buttonBack.frame = CGRectMake(80.0, 260.0, 180.0, 40.0);
		buttonBack.center = CGPointMake([screen applicationFrame].size.width/2,270);
		[self addSubview:buttonBack];
		buttonBackCenter = buttonBack.center;


		[self setAlpha:0];
		[screen release];
    }
    return self;
}

-(void)changeLanguage:(id)Sender
{
	if ([[GlobalSettingsHelper Instance] GetLanguage] == english ) {
		[[GlobalSettingsHelper Instance] SetLanguage:norwegian];
	}
	else
	 {
		 [[GlobalSettingsHelper Instance] SetLanguage:english];
	 }

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[headerLabel setAlpha:0];
	headerLabel.center = CGPointMake(headerLabelCenter.x, buttonLanguageCenter.y);
	[buttonLanguage setAlpha:0.25];
	[buttonDistance setAlpha:0];
	buttonDistance.center = CGPointMake(buttonDistanceCenter.x, buttonLanguageCenter.y);
	[buttonBack setAlpha:0];
	buttonBack.center = CGPointMake(buttonBackCenter.x, buttonLanguageCenter.y);
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(finishedMovingOut)];
	[UIView commitAnimations];	
}

-(void) finishedMovingOut
{
	[self UpdateLabels];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[headerLabel setAlpha:1];
	headerLabel.center = headerLabelCenter;
	[buttonLanguage setAlpha:1];
	[buttonDistance setAlpha:1];
	buttonDistance.center = buttonDistanceCenter;
	[buttonBack setAlpha:1];
	buttonBack.center = buttonBackCenter;
	[UIView setAnimationDidStopSelector:@selector(finishedMovingOut)];
	[UIView commitAnimations];	
}

-(void) UpdateLabels
{

	[buttonLanguage setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Language: english"] forState:UIControlStateNormal];
	if ([[GlobalSettingsHelper Instance] GetDistance] == km) {
		[buttonDistance setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance in: kilometers"] forState:UIControlStateNormal];
	}
	else {
		[buttonDistance setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance in: miles"] forState:UIControlStateNormal];
	}
	
	[buttonBack setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Back"] forState:UIControlStateNormal];
	headerLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"];
}

-(void)changeDistance:(id)Sender
{
	if ([[GlobalSettingsHelper Instance] GetDistance] == km) {
		[[GlobalSettingsHelper Instance] SetDistance:mile];
		[buttonDistance setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance in: miles"]  forState:UIControlStateNormal];
	}
	else
	{
		[[GlobalSettingsHelper Instance] SetDistance:km];
		[buttonDistance setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Distance in: kilometers"] forState:UIControlStateNormal];
		[[GlobalSettingsHelper Instance] SetDistance:km];
	}
}

-(void)goBack:(id)Sender
{
	if ([delegate respondsToSelector:@selector(SettingsMenuViewHiding)])
        [delegate SettingsMenuViewHiding];
	[self FadeOut];
}


-(CGImageRef) CreateStrechedCGImageFromCGImage:(CGImageRef) image  andWidth:(NSInteger) width andHeight:(NSInteger) height 
{ 
	// Create the bitmap context 
	CGContextRef    context = NULL; 
	void *          bitmapData; 
	int             bitmapByteCount; 
	int             bitmapBytesPerRow; 
	

	// Declare the number of bytes per row. Each pixel in the bitmap in this 
	// example is represented by 4 bytes; 8 bits each of red, green, blue, and 
	// alpha. 
	bitmapBytesPerRow   = (width * 4); 
	bitmapByteCount     = (bitmapBytesPerRow * height); 
	
	// Allocate memory for image data. This is the destination in memory 
	// where any drawing to the bitmap context will be rendered. 
	bitmapData = malloc( bitmapByteCount ); 
	if (bitmapData == NULL) 
	{ 
		return nil; 
	}
	
	
	// Create the bitmap context. We want pre-multiplied ARGB, 8-bits 
	// per component. Regardless of what the source image format is 
	// (CMYK, Grayscale, and so on) it will be converted over to the format 
	// specified here by CGBitmapContextCreate. 
	CGColorSpaceRef colorspace = CGImageGetColorSpace(image); 
	context = CGBitmapContextCreate (bitmapData,width,height,8,bitmapBytesPerRow, 
									 colorspace,kCGImageAlphaNoneSkipFirst); 
	CGColorSpaceRelease(colorspace); 
	
	if (context == NULL) 
		// error creating context 
		return nil; 
	
	// Draw the image to the bitmap context. Once we draw, the memory 
	// allocated for the context for rendering will then contain the 
	// raw image data in the specified color space. 
	CGContextDrawImage(context, CGRectMake(0,0,width, height), image); 
	
	
	CGImageRef imgRef = CGBitmapContextCreateImage(context); 
	CGContextRelease(context); 
	free(bitmapData); 
	
	return imgRef; 
}


-(void) FadeIn
{
	self.hidden = NO;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[self setAlpha:1];
	[m_skyView setAlpha:0.9];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.9];
	[self setAlpha:0];
	[UIView commitAnimations];	
}


- (void)dealloc {
    [super dealloc];
}


@end
