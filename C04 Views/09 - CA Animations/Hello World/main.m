/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIImageView *frontObject;
    UIImageView *backObject;
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
}

- (void)animate:(id)sender
{
	// Set up the animation
	CATransition *animation = [CATransition animation];
	animation.delegate = self;
	animation.duration = 1.0f;
	animation.timingFunction = UIViewAnimationCurveEaseInOut;
	
	switch ([(UISegmentedControl *)self.navigationItem.titleView selectedSegmentIndex])
	{
		case 0:
			animation.type = kCATransitionFade;
			break;
		case 1:
			animation.type = kCATransitionMoveIn;
			break;
		case 2:
			animation.type = kCATransitionPush;
			break;
		case 3:
			animation.type = kCATransitionReveal;
		default:
			break;
	}
	animation.subtype = kCATransitionFromBottom;
	
	// Perform the animation
	[self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[self.view.layer addAnimation:animation forKey:@"animation"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add secondary object
    backObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    [self.view addSubview:backObject];
    PREPCONSTRAINTS(backObject);
    CENTER_VIEW(self.view, backObject);
    
    // Add primary object
    frontObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    [self.view addSubview:frontObject];
    PREPCONSTRAINTS(frontObject);
    CENTER_VIEW(self.view, frontObject);
    
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Go", @selector(animate:));
    
    // Add a segmented control to select the animation
	UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:[@"Fade Over Push Reveal" componentsSeparatedByString:@" "]];
	sc. selectedSegmentIndex = 0;
	self.navigationItem.titleView = sc;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.tintColor = COOKBOOK_PURPLE_COLOR;
    return YES;
}

@end


#pragma mark - main

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}
