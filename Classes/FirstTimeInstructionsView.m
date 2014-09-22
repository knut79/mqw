//
//  FirstTimeInstructionsView.m
//  MQNorway
//
//  Created by knut dullum on 05/05/2011.
//  Copyright 2011 lemmus. All rights reserved.
//

#import "FirstTimeInstructionsView.h"
#import "GlobalSettingsHelper.h"
#import "SqliteHelper.h"


@implementation FirstTimeInstructionsView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
		
		UIScreen *screen = [[UIScreen mainScreen] retain];
		
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
		
		m_skyView = [[SkyView alloc] initWithFrame:frame];
		[m_skyView setAlpha:0.8];
		[self addSubview:m_skyView];
       
		
		UIImage *dragToMoveImage = [UIImage imageNamed:@"DragToMoveInstr.png"];
		UIImageView *dragToMoveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 191)];
		dragToMoveImageView.center = CGPointMake(([screen applicationFrame].size.width /4 ) + 20, (dragToMoveImageView.frame.size.height /2 ) +35);
		[dragToMoveImageView setImage:dragToMoveImage];
		[self addSubview:dragToMoveImageView];
		
		
		dragToMoveLabel = [[UILabel alloc] init];
		[dragToMoveLabel setFrame:CGRectMake(0, 0, 160, 40)];
		dragToMoveLabel.backgroundColor = [UIColor clearColor]; 
		dragToMoveLabel.textColor = [UIColor whiteColor];
		dragToMoveLabel.textAlignment = NSTextAlignmentCenter;
		[dragToMoveLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		dragToMoveLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Drag to move cursor"];
		dragToMoveLabel.center = CGPointMake(([screen applicationFrame].size.width /4 ),(dragToMoveImageView.frame.size.height ) + 20);
		dragToMoveLabel.shadowColor = [UIColor blackColor];
		dragToMoveLabel.shadowOffset = CGSizeMake(2,2);
		[self addSubview:dragToMoveLabel];
		
		UIImage *tapToMoveImage = [UIImage imageNamed:@"TapToMoveInstr.png"];
		UIImageView *tapToMoveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 191)];
		tapToMoveImageView.center = CGPointMake((([screen applicationFrame].size.width /4 ) * 3) + 20,(tapToMoveImageView.frame.size.height /2 ) + 35);
		[tapToMoveImageView setImage:tapToMoveImage];
		[self addSubview:tapToMoveImageView];

		
		tapToMoveLabel = [[UILabel alloc] init];
		[tapToMoveLabel setFrame:CGRectMake(0, 0, 160, 40)];
		tapToMoveLabel.backgroundColor = [UIColor clearColor]; 
		tapToMoveLabel.textColor = [UIColor whiteColor];
		tapToMoveLabel.textAlignment = NSTextAlignmentCenter;
		[tapToMoveLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		tapToMoveLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap to move cursor"];
		tapToMoveLabel.center = CGPointMake((([screen applicationFrame].size.width /4 ) * 3),(tapToMoveImageView.frame.size.height) + 20);
		tapToMoveLabel.shadowColor = [UIColor blackColor];
		tapToMoveLabel.shadowOffset = CGSizeMake(2,2);
		[self addSubview:tapToMoveLabel];
		
		UIImage *zoomInImage = [UIImage imageNamed:@"ZoomInInstr.png"];
		UIImageView *zoomInImageImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 191)];
		zoomInImageImageView.center = CGPointMake(([screen applicationFrame].size.width / 4 ) + 20, (dragToMoveImageView.frame.size.height /2 ) +225);
		[zoomInImageImageView setImage:zoomInImage];
		[self addSubview:zoomInImageImageView];
		
		
		zoomInLabel = [[UILabel alloc] init];
		[zoomInLabel setFrame:CGRectMake(0, 0, 160, 40)];
		zoomInLabel.backgroundColor = [UIColor clearColor]; 
		zoomInLabel.textColor = [UIColor whiteColor];
		zoomInLabel.textAlignment = NSTextAlignmentCenter;
		[zoomInLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		zoomInLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Zoom in"];
		zoomInLabel.center = CGPointMake((zoomInImageImageView.frame.size.width /2 ) + 15,(zoomInImageImageView.frame.size.height ) + 210);
		zoomInLabel.shadowColor = [UIColor blackColor];
		zoomInLabel.shadowOffset = CGSizeMake(2,2);
		[self addSubview:zoomInLabel];
		
		UIImage *zoomOutImage = [UIImage imageNamed:@"ZoomOutInstr.png"];
		UIImageView *zoomOutImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 191)];
		zoomOutImageView.center = CGPointMake((([screen applicationFrame].size.width /4 ) * 3) + 20, (dragToMoveImageView.frame.size.height /2 ) +225);
		[zoomOutImageView setImage:zoomOutImage];
		[self addSubview:zoomOutImageView];

		
		zoomOutLabel = [[UILabel alloc] init];
		[zoomOutLabel setFrame:CGRectMake(0, 0, 160, 40)];
		zoomOutLabel.backgroundColor = [UIColor clearColor]; 
		zoomOutLabel.textColor = [UIColor whiteColor];
		zoomOutLabel.textAlignment = NSTextAlignmentCenter;
		[zoomOutLabel setFont:[UIFont boldSystemFontOfSize:12.0f]];
		zoomOutLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Zoom out"];
		zoomOutLabel.center = CGPointMake((zoomOutImageView.frame.size.width /2 ) + 172,(zoomOutImageView.frame.size.height) + 210);
		zoomOutLabel.shadowColor = [UIColor blackColor];
		zoomOutLabel.shadowOffset = CGSizeMake(2,2);
		[self addSubview:zoomOutLabel];
		
		
		
		headerLabel = [[UILabel alloc] init];
		[headerLabel setFrame:CGRectMake(80, 0, 300, 40)];
		headerLabel.center = CGPointMake([screen applicationFrame].size.width/2, 20);
		headerLabel.backgroundColor = [UIColor clearColor]; 
		headerLabel.textAlignment = NSTextAlignmentCenter;
		headerLabel.textColor = [UIColor whiteColor];
		[headerLabel setFont:[UIFont boldSystemFontOfSize:17.0f]];
		headerLabel.shadowColor = [UIColor blackColor];
		headerLabel.shadowOffset = CGSizeMake(2,2);
		[self addSubview:headerLabel];
		
		
//		buttonDontShowAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		[buttonDontShowAgain addTarget:self action:@selector(DontShowAgain:) forControlEvents:UIControlEventTouchDown];
//		[buttonDontShowAgain setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Don´t show again"] forState:UIControlStateNormal];
//		buttonDontShowAgain.frame = CGRectMake(0, 0, 100, 40);
//		[buttonDontShowAgain setFont:[UIFont boldSystemFontOfSize:10.0f]];
//		buttonDontShowAgain.center = CGPointMake([screen applicationFrame].size.width/4,[screen applicationFrame].size.height - 30);
//		[self addSubview:buttonDontShowAgain];
//		
//		buttonShowAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//		[buttonShowAgain addTarget:self action:@selector(ShowAgain:) forControlEvents:UIControlEventTouchDown];
//		[buttonShowAgain setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Close"] forState:UIControlStateNormal];
//		buttonShowAgain.frame = CGRectMake(0, 0, 100, 40.0);
//		[buttonShowAgain setFont:[UIFont boldSystemFontOfSize:12.0f]];
//		buttonShowAgain.font = [UIFont boldSystemFontOfSize:12.0f];
//		buttonShowAgain.center = CGPointMake(([screen applicationFrame].size.width/4)*3,[screen applicationFrame].size.height - 30);
//		[self addSubview:buttonShowAgain];
		
		
		buttonDontShowAgain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[buttonDontShowAgain addTarget:self action:@selector(DontShowAgain:) forControlEvents:UIControlEventTouchDown];
		[buttonDontShowAgain setTitle:@"OK" forState:UIControlStateNormal];
		buttonDontShowAgain.frame = CGRectMake(0, 0, 300, 40.0);
		buttonDontShowAgain.center = CGPointMake(([screen applicationFrame].size.width/2),[screen applicationFrame].size.height - 30);
		[self addSubview:buttonDontShowAgain];
		
		self.hidden = YES;
		
		[screen release];
		
    }
    return self;
}

-(void) SetPlayer:(NSString*) playername
{
	m_playerName = playername;
	headerLabel.text = [NSString stringWithFormat:@"%@, %@",playername,[[GlobalSettingsHelper Instance] GetStringByLanguage:@"this is how to play"]];
	[buttonDontShowAgain setTitle:[NSString stringWithFormat:@"%@ %@!",playername,[[GlobalSettingsHelper Instance] GetStringByLanguage:@"understands"]] forState:UIControlStateNormal];
	dragToMoveLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Drag to move cursor"];
	tapToMoveLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Tap to move cursor"];
	zoomInLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Zoom in"];
	zoomOutLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Zoom out"];
	
}

-(void) DontShowAgain:(id)Sender
{
	//put player name in table and datestamp
	[[SqliteHelper Instance] executeUpdate:@"INSERT INTO firstinstructions VALUES (?, ?);",m_playerName,@"bogus"];
	[self FadeOut];
}

-(void) ShowAgain:(id)Sender
{
	[self FadeOut];
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationDelegate:self];       
	[UIView setAnimationDidStopSelector:@selector(FinishedFadingOut)];   
	[self setAlpha:0];
	[UIView commitAnimations];	
}

-(BOOL) FadeIn
{
	FMResultSet *resultsPlayers = [[SqliteHelper Instance] executeQuery:@"SELECT * FROM firstinstructions where playername =?",m_playerName];
    [resultsPlayers next];
	if ([resultsPlayers hasAnotherRow]==NO) {
		self.hidden = NO;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[self setAlpha:1];
		[UIView commitAnimations];	
		[self setUserInteractionEnabled:YES];
		return YES;
	}
	else {
		return NO;
	}
    [resultsPlayers close];

}

-(void) FinishedFadingOut
{
	if ([delegate respondsToSelector:@selector(StartNewGame)])
		[delegate StartNewGame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
