//
//  InfoBarView.m
//  Tiling
//
//  Created by knut dullum on 27/02/2011.
//  Copyright 2011 Lemmus. All rights reserved.
//

#import "InfoBarViewBottom.h"
#import "Question.h"
#import <QuartzCore/QuartzCore.h>
#import "Player.h"
#import "GlobalSettingsHelper.h"
#import "SqliteHelper.h"


@implementation InfoBarViewBottom

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame{
	if ([super initWithFrame:frame] == nil) {
        return nil;
    }
	
	self.backgroundColor = [[UIColor alloc] initWithRed:200 green:200 blue:200 alpha:0.5];
	[self setAlpha:0];
	
	m_setPositionButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	[m_setPositionButton addTarget:self action:@selector(doSetPosition:) forControlEvents:UIControlEventTouchDown];
	[m_setPositionButton.titleLabel setFont:[UIFont boldSystemFontOfSize: 12]];
    m_setPositionButton.layer.borderWidth=2.0f;
    [m_setPositionButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    m_setPositionButton.layer.borderColor=[[UIColor blackColor] CGColor];
    
	[m_setPositionButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"OK"] forState:UIControlStateNormal];
	m_setPositionButton.frame = CGRectMake(220.0, 2.0, 98.0, 36.0);
	[self addSubview:m_setPositionButton];

	m_timerNumerator = 1;
	
	m_numberOfPlayersLeft = 0;
	m_drawUpdatedScore = NO;
	
	m_labelPool = [[NSMutableArray alloc] init];
	for (int i = 0; i < 4; i++) {
		UILabel *aLabel = [[UILabel alloc] init];
		[m_labelPool addObject:aLabel];
		[self addSubview:aLabel];
	}
	
    return self;
}

-(void) SetGameRef:(Game*) gameRef
{
	m_gameRef = [gameRef retain];	
	
	m_timerNumerator = 1;
	
	m_numberOfPlayersLeft = 0;
	Player *player = [[m_gameRef GetPlayer] retain];
	//Init the barwidth for each player

    
    [player SetBarWidth:200];
    m_barWidthStart = 200.0;
	
	[player release];
	
	[self setNeedsDisplay]; 
}

-(void) EnableSetPositionButton
{
	[m_setPositionButton setEnabled:YES];
	m_setPositionButton.alpha = 1;
}

-(void)doSetPosition:(id)Sender
{
	[m_setPositionButton setEnabled: NO];
	m_setPositionButton.alpha = 0.4f;
	
	if ([delegate respondsToSelector:@selector(SetPositionDone)])
        [delegate SetPositionDone];
}


-(void) SetTrainingText
{
	if (m_pauseButton == nil) {
		m_pauseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[m_pauseButton addTarget:self action:@selector(PauseGame) forControlEvents:UIControlEventTouchDown];
		//[m_pauseButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Settings"] forState:UIControlStateNormal];
		m_pauseButton.frame = CGRectMake(2.0, 5.0, 30.0, 30.0);
		m_pauseButton.backgroundColor = [UIColor clearColor];
		m_pauseButton.adjustsImageWhenHighlighted = YES;
		
		
		//[m_pauseButton setTitle:@"vc2:v1" forState:UIControlStateNormal];
		[m_pauseButton setImage:[UIImage imageNamed:@"pauseBtn.png"] forState:UIControlStateNormal];
//		UIImage *buttonImageNormal = [UIImage imageNamed:@"pause.png"];
//		UIImage *strechableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0];
//		[m_pauseButton setBackgroundImage:strechableButtonImageNormal forState:UIControlStateNormal];
		[self addSubview:m_pauseButton];
	}
	if (m_trainingLabel == nil) {
		m_trainingLabel = [[UILabel alloc] init];
		[m_trainingLabel setFrame:CGRectMake(35, 0, 182, 20)];
		m_trainingLabel.backgroundColor = [UIColor clearColor]; 
		[m_trainingLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
		m_trainingLabel.numberOfLines = 1;
		m_trainingLabel.adjustsFontSizeToFitWidth = YES;
		m_trainingLabel.textColor = [UIColor blackColor];
		m_trainingLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
		m_trainingLabel.layer.shadowOpacity = 1.0;
		m_trainingLabel.layer.shadowRadius = 1.5;
		m_trainingLabel.textAlignment = NSTextAlignmentCenter;
		[self addSubview:m_trainingLabel];
	}
	if (m_trainingLabel2 == nil) {
		m_trainingLabel2 = [[UILabel alloc] init];
		[m_trainingLabel2 setFrame:CGRectMake(25, 15, 200, 20)];
		m_trainingLabel2.backgroundColor = [UIColor clearColor]; 
		[m_trainingLabel2 setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_trainingLabel2.layer.shadowColor = [[UIColor blackColor] CGColor];
		m_trainingLabel2.layer.shadowOpacity = 1.0;
		m_trainingLabel2.layer.shadowRadius = 1.5;
		m_trainingLabel2.textAlignment = NSTextAlignmentCenter;
		[self addSubview:m_trainingLabel2];
	}
	m_trainingLabel2.layer.shadowOpacity = 1.0;
	m_trainingLabel2.textColor = [UIColor whiteColor];
	
	if (m_diffAvg == nil) {
		m_diffAvg = [[UILabel alloc] init];
		[m_diffAvg setFrame:CGRectMake(130, 15, 110, 20)];
		m_diffAvg.backgroundColor = [UIColor clearColor]; 
		[m_diffAvg setFont:[UIFont boldSystemFontOfSize:14.0f]];
		m_diffAvg.textColor = [UIColor blackColor];
//		m_diffAvg.layer.shadowColor = [[UIColor blackColor] CGColor];
//		m_diffAvg.layer.shadowOpacity = 1.0;
//		m_diffAvg.layer.shadowRadius = 1.5;
		m_diffAvg.textAlignment = NSTextAlignmentCenter;
		[m_diffAvg setAlpha:0];
		[self addSubview:m_diffAvg];
	}
	[m_diffAvg setAlpha:0];

	
	[m_trainingLabel setAlpha:1];
	m_trainingLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"Current average distance"];
	[m_trainingLabel2 setAlpha:1];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:1.0f];
	//[m_pauseButton setAlpha:0];
	[m_pauseButton setAlpha:1];
	m_pauseButton.center = CGPointMake(17, 20);
	[UIView commitAnimations];
	
	
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	int averageDistanceFromTarget;
	//read out average distance 
	FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT avgDistance FROM location WHERE locationID = ?;", [[[m_gameRef GetQuestion] GetLocation] GetID]];
	while([results next]) {
        NSLog(@"int - %i",[results intForColumn:@"avgDistance"]);
        NSLog(@"string - %@",[results stringForColumn:@"avgDistance"]);
        
        averageDistanceFromTarget = [results intForColumn:@"avgDistance"];
	}
	m_training_oldAvg = averageDistanceFromTarget;
	[m_gameRef Training_AddOldResult:[[[m_gameRef GetQuestion] GetLocation] GetName] avgValue:averageDistanceFromTarget];
	
	if (averageDistanceFromTarget < 0)
		m_trainingLabel2.text = [NSString stringWithFormat:@"%@",[[GlobalSettingsHelper Instance] GetStringByLanguage:@"No average"]];
	else
		m_trainingLabel2.text = [NSString stringWithFormat:@"%d %@",averageDistanceFromTarget,[[GlobalSettingsHelper Instance] GetStringByLanguage:@"km"]];
	
	[results close];

	[f release];
}

-(void) UpdateTrainingText
{

	m_trainingLabel.text = [[GlobalSettingsHelper Instance] GetStringByLanguage:@"New average distance"];
	NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
	[f setNumberStyle:NSNumberFormatterDecimalStyle];
	int averageDistanceFromTarget;
	//read out average distance 
	FMResultSet *results = [[SqliteHelper Instance] executeQuery:@"SELECT avgDistance FROM location WHERE locationID = ?;", [[[m_gameRef GetQuestion] GetLocation] GetID]];
	while([results next]) {

        averageDistanceFromTarget = [results intForColumn:@"avgDistance"];
	}
    [results close];
	//new avg is higher, Too bad
	int diffAvgValue = averageDistanceFromTarget - m_training_oldAvg;
	if (diffAvgValue> 0){
		m_diffAvg.text = [NSString stringWithFormat:@"(+%d km)",diffAvgValue];
		m_diffAvg.textColor = [UIColor redColor];
		m_trainingLabel2.textColor = [UIColor redColor];
		m_trainingLabel2.layer.shadowOpacity = 0.0;
	}
	else{
		m_diffAvg.text = [NSString stringWithFormat:@"(%d km)",diffAvgValue];
		m_diffAvg.textColor = [UIColor greenColor];
		m_trainingLabel2.textColor = [UIColor greenColor];
	}

	[m_gameRef Training_AddNewResult:[[[m_gameRef GetQuestion] GetLocation] GetName] avgValue:averageDistanceFromTarget];
	
	m_trainingLabel2.text = [NSString stringWithFormat:@"%d %@",averageDistanceFromTarget,[[GlobalSettingsHelper Instance] GetStringByLanguage:@"km"]];
	[f release];
	
	[m_diffAvg setAlpha:1];
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:1.0f];
	m_pauseButton.center = CGPointMake(-30, 20);
	[UIView commitAnimations];
	
	[UIView beginAnimations:nil context:nil]; 
	[UIView setAnimationDuration:2.5f];
	[m_diffAvg setAlpha:0];
	[UIView commitAnimations];
	
}


-(void) HideTrainingElements
{
	[m_trainingLabel setAlpha:0];
	[m_trainingLabel2 setAlpha:0];
	[m_pauseButton setAlpha:0];
}

-(void) PauseGame
{
	if ([delegate respondsToSelector:@selector(PauseTraining)])
		[delegate PauseTraining];
}

-(void) UpdatePoints
{
	m_finishedAnimating = NO;
	UIScreen *screen = [[UIScreen mainScreen] retain];
	int playerIndex = 0;
    Player* pTemp = [[m_gameRef GetPlayer] retain];

    //gamepoint must be measured to drawFiguresViews representation. 25% of value, possibly x and y offsets and zoom factor at 25%
    int endX, endY;
    endX = [screen applicationFrame].size.width/2;
    endY = 10;

    // Determine the animation's path.
    CGPoint startPoint = CGPointMake(([pTemp GetGamePoint].x *0.25f * 0.3695f), ([pTemp GetGamePoint].y *0.25f * 0.3695f)- [screen applicationFrame].size.height );
    CGPoint curvePoint1 = CGPointMake(startPoint.x + 70, startPoint.y);
    CGPoint endPoint = CGPointMake(endX, endY);
    CGPoint curvePoint2 = CGPointMake(endPoint.x + 50, endPoint.y - 50);

    
    // Create the animation's path.
    CGPathRef path = NULL;
    CGMutablePathRef mutablepath = CGPathCreateMutable();
    CGPathMoveToPoint(mutablepath, NULL, startPoint.x, startPoint.y);
    CGPathAddCurveToPoint(mutablepath, NULL, curvePoint1.x, curvePoint1.y,
                          curvePoint2.x, curvePoint2.y,
                          endPoint.x, endPoint.y);
    path = CGPathCreateCopy(mutablepath);
    CGPathRelease(mutablepath);

    //NSMutableArray* m_labelPool = [[NSMutableArray init] alloc];
    if ([pTemp GetLastRoundScore] > 0) {
        
    
    //UILabel *aLabel = [[UILabel alloc] init];
    UILabel *aLabel = [m_labelPool objectAtIndex:playerIndex];
    aLabel.hidden = NO;
    [aLabel setFrame:CGRectMake(0, 0, 30, 20)];
    aLabel.backgroundColor = [UIColor clearColor]; 
    [aLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
    aLabel.textColor = [pTemp GetColor];// [UIColor whiteColor];
    aLabel.textAlignment = NSTextAlignmentCenter;
        aLabel.text = [NSString stringWithFormat:@"%d",[pTemp GetLastRoundScore]]; 
    //[self addSubview:aLabel];
    CALayer *iconViewLayer = aLabel.layer;
    
    CAKeyframeAnimation *animatedIconAnimation = [CAKeyframeAnimation animationWithKeyPath: @"position"];
    animatedIconAnimation.duration = 1.8;
    animatedIconAnimation.delegate = self;
    animatedIconAnimation.path = path;
    animatedIconAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [iconViewLayer addAnimation:animatedIconAnimation forKey:@"animateIcon"];

    
    // Start the icon animation.
    [iconViewLayer setPosition:CGPointMake(endPoint.x, endPoint.y)];
    }
		

	[screen release];
	[pTemp release];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (m_finishedAnimating == NO) {
		m_finishedAnimating = YES;
		m_drawUpdatedScore = YES;
		for (int i = 0; i < 4; i++) {
			((UILabel*)[m_labelPool objectAtIndex:i]).hidden = YES;
		}
		[self setNeedsDisplay]; 
		
	}

	m_drawUpdatedScore = NO;
	
	if ([delegate respondsToSelector:@selector(FinishedAnimating)])
		[delegate FinishedAnimating];
}



-(void) SetBars
{
	[self setNeedsDisplay]; 

}


-(void) UpdateBars
{
	m_timerNumerator = 1;
	m_numberOfPlayersLeft = 0;
	int playersLeftAfterAnimation = 0;
	Question *currentQuestion = [[m_gameRef GetQuestion] retain];
	Player *player = [[m_gameRef GetPlayer]retain];
	//Init the barwidth for each player


    if ([player IsOut] == NO) {
        m_numberOfPlayersLeft++;
    }
    
    /*
    if (([player GetKmLeft] + [player GetCurrentKmTimeBonus]) > 0) {
        playersLeftAfterAnimation ++;

        //only singleplayer games wil give highscores
        //[player IncreasQuestionsPassedAndScore:currentQuestion];

    }

	[m_gameRef SetPlayersLeft:playersLeftAfterAnimation];*/
	[player release];
	[currentQuestion release];
	

	m_distanceBarsTimer =[NSTimer scheduledTimerWithTimeInterval:0.025
			target:self selector:@selector(AnimateBars)
			userInfo:nil repeats:YES];
}

-(void) AnimateBars
{

	Player *player = [[m_gameRef GetPlayer] retain];
	BOOL m_playerBarStillChanging = NO;

		if ([player IsOut] == NO ) {
			
			int kmLeft = [player GetKmLeft];
			int goingForKmLeft = [player GetLastKmLeft] - (20 * m_timerNumerator);
            int kmTimeBonus = [player GetCurrentKmTimeBonus];
			
			if (goingForKmLeft < kmLeft ) {
				goingForKmLeft = kmLeft;
			}
			else if(goingForKmLeft < 0){
				goingForKmLeft = 0;
			}
			else {
				m_playerBarStillChanging = YES;
			}

			if ((goingForKmLeft + kmTimeBonus) <= 0) {
				[player SetOut:YES];
			}

			int barWidth = (float)goingForKmLeft * (m_barWidthStart/const_startKmDistance);
            float timeBonusBarFactor = (float)[player GetKmLeft] + (float)kmTimeBonus;
            if (timeBonusBarFactor <= 0.0f) 
                timeBonusBarFactor = 0.0f;
            else if(timeBonusBarFactor > const_startKmDistance)
                timeBonusBarFactor = const_startKmDistance;
            
            
            int barWidthTimeBonus = timeBonusBarFactor * (m_barWidthStart/const_startKmDistance);

			//text for info bar
			[player SetKmLeft_ForInfoBar:goingForKmLeft];
			//new bar width
			[player SetBarWidth:barWidth];
            [player SetTimeBonusBarWidth:barWidthTimeBonus];
	}
	[player release];
	m_timerNumerator++;

	
	if ((m_playerBarStillChanging == NO) || (m_timerNumerator > 300)) {
		[m_distanceBarsTimer invalidate];
		//m_timerNumerator = 1;
		
		if ([delegate respondsToSelector:@selector(FinishedAnimating)])
			[delegate FinishedAnimating];
	}
	
	[self setNeedsDisplay]; 
}

-(void) DrawBarsOnce
{
	Player *player = [[m_gameRef GetPlayer] retain];
    
    if ([player IsOut] == NO ) {
			
        int kmLeft = [player GetKmLeft];
        
        int barWidth = (float)kmLeft * (m_barWidthStart/const_startKmDistance);

        //text for info bar
        [player SetKmLeft_ForInfoBar:kmLeft];
        //new bar width
        [player SetBarWidth:barWidth];


	}
	[player release];

	[self setNeedsDisplay]; 
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	
	if(m_gameRef != nil)
	{
		//[m_setPositionButton setTitle:[[GlobalSettingsHelper Instance] GetStringByLanguage:@"Position set"] forState:UIControlStateNormal];
		if ([m_gameRef IsTrainingMode] == YES ) 
		{
			return;
		}
		else 
		{
			
			[self HideTrainingElements];

			// Grab the drawing context
			CGContextRef context = UIGraphicsGetCurrentContext();
			// like Processing pushMatrix
			CGContextSaveGState(context);
			CGContextScaleCTM(context, 1.0, -1.0);	

            [self drawForOnePlayer:context];
			// like Processing popMatrix
			CGContextRestoreGState(context);
		}
	}
}


-(void) drawBarAndText:(CGContextRef) context barWidth:(NSInteger) barWidth andText:(NSString*) theString
				 textX:(NSInteger) textX textY:(NSInteger) textY barX:(NSInteger) barX barY:(NSInteger) barY barHeight:(NSInteger) barHeight barColor:(UIColor*) barColor timeBonusBarWidth:(NSInteger) timeBonusBarWidth
{
	if ((barWidth <= 0) && (timeBonusBarWidth <= 0)) {
		barWidth = 0;
		theString = @"Game over";
	}
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    

	
	UIColor *uicolor = [barColor retain];
	CGColorRef color = [uicolor CGColor];
    CGFloat red = 200.0f;
    CGFloat green = 200.0f;
    CGFloat blue = 200.0f;
    CGFloat alpha = 1.0f;
	int numComponents = CGColorGetNumberOfComponents(color);
	if (numComponents == 4)
	{
		const CGFloat *components = CGColorGetComponents(color);
		red = components[0];
		green = components[1];
		blue = components[2];
		alpha = components[3];
	}

	[uicolor release];
    
    CGContextSetRGBFillColor(context, red, green, blue, 0.5f); 
    CGContextFillRect(context, CGRectMake(barX ,barY * -1, timeBonusBarWidth, barHeight));
	
    CGContextSetRGBFillColor(context, red, green, blue, alpha); 
    CGContextFillRect(context, CGRectMake(barX ,barY * -1, barWidth, barHeight));
	const char *text = [theString UTF8String];
	CGContextSelectFont(context, "Helvetica", 10.0, kCGEncodingMacRoman);

	if (uicolor == [UIColor blueColor] ) {
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	}

	if (uicolor == [UIColor purpleColor]) {
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	}

	CGContextSetTextDrawingMode(context, kCGTextFill);
	CGContextShowTextAtPoint(context, textX,textY * -1, text, strlen(text));
}

-(void) drawForOnePlayer:(CGContextRef) context
{

	//CGContextSetRGBFillColor(context, 255, 255, 255, 1);
	CGContextSetFillColorWithColor(context,[UIColor blackColor].CGColor);
	CGContextFillRect(context, CGRectMake(10 ,31 * -1, 200, 10));
	//set lines 
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	CGContextMoveToPoint(context, 10, 31 * -1);
	CGContextAddLineToPoint( context, 10,(31 * -1) + 21);
	CGContextClosePath(context);
	CGContextMoveToPoint(context, 10 + 105, 31 * -1);
	CGContextAddLineToPoint( context, 10 + 105,(31 * -1) + 15);
	CGContextClosePath(context);
	CGContextMoveToPoint(context, 210, 31 * -1);
	CGContextAddLineToPoint( context, 210,(31 * -1) + 21);
	CGContextClosePath(context);
	CGContextStrokePath(context);
	
	
    //_? GETPLAYER
	NSArray *player = [[m_gameRef GetPlayer]retain];
	//Init the barwidth for each player
	NSInteger barWidth = 0;
	NSInteger kmLeft = 0;
	UIColor *barColor;

    barWidth = [player GetBarWidth];
    kmLeft = [player GetKmLeft_ForInfoBar];
    barColor = [[player GetColor] retain];
    NSString *barText = [NSString stringWithFormat:@"%d %@ %@",[[GlobalSettingsHelper Instance] ConvertToRightDistance:kmLeft],[[GlobalSettingsHelper Instance] GetDistanceMeasurementString], [player GetDistanceTimeBounusString]];
    if([player HasGivenUp] == YES)
    {
        barWidth = 0;
        barText = [NSString stringWithFormat:@"%@ %@",[player GetName],[[GlobalSettingsHelper Instance] GetStringByLanguage:@"has given up"]];
    }
    [self drawBarAndText: context barWidth:barWidth andText:barText
                   textX:10 textY:30 barX:10 barY:20 barHeight:10 barColor:barColor timeBonusBarWidth:[player GetTimeBonusBarWidth]];
    [barColor release];

	
	[player release];

}


-(void) FadeIn
{
	//m_setPositionButton.alpha = 1.0f;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:1];
	[UIView commitAnimations];	
}

-(void) FadeOut
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.5];
	[self setAlpha:0];
	[UIView commitAnimations];	
}


- (void)dealloc {
    [super dealloc];
}


@end
