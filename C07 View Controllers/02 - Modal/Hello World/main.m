/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark Custom Modal View Controller
@interface ModalViewController : UIViewController
- (IBAction)done:(id)sender;
@end

@implementation ModalViewController
- (IBAction)done:(id)sender {[self dismissViewControllerAnimated:YES completion:nil];}
@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UISegmentedControl * segmentedControl;
    UISegmentedControl * iPadStyleControl;
}

- (void)action:(id)sender
{
    // Load info controller from storyboard
    NSString *sourceName = IS_IPAD ? @"Modal~iPad" : @"Modal~iPhone";
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sourceName bundle:[NSBundle mainBundle]];
    UINavigationController *navController = [sb instantiateViewControllerWithIdentifier:@"infoNavigationController"];
    
    // Select the transition style
	int styleSegment = [segmentedControl selectedSegmentIndex];
	int transitionStyles[4] = {UIModalTransitionStyleCoverVertical, UIModalTransitionStyleCrossDissolve, UIModalTransitionStyleFlipHorizontal, UIModalTransitionStylePartialCurl};
	navController.modalTransitionStyle = transitionStyles[styleSegment];
    
	// Select the presentation style for iPad only
	if (IS_IPAD)
	{
		int presentationSegment = [iPadStyleControl selectedSegmentIndex];
		int presentationStyles[3] = {UIModalPresentationFullScreen, UIModalPresentationPageSheet, UIModalPresentationFormSheet};
        
		if (navController.modalTransitionStyle == UIModalTransitionStylePartialCurl)
		{
			// Partial curl with any non-full screen presentation raises an exception
			navController.modalPresentationStyle = UIModalPresentationFullScreen;
			[iPadStyleControl setSelectedSegmentIndex:0];
		}
		else
			navController.modalPresentationStyle = presentationStyles[presentationSegment];
	}
    
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
    
	segmentedControl = [[UISegmentedControl alloc] initWithItems:[@"Slide Fade Flip Curl" componentsSeparatedByString:@" "]];
	[segmentedControl setSelectedSegmentIndex:0];
    self.navigationItem.titleView = segmentedControl;
    
    if (IS_IPAD)
	{
		NSArray *presentationChoices = [NSArray arrayWithObjects:@"Full Screen", @"Page Sheet", @"Form Sheet", nil];
		iPadStyleControl = [[UISegmentedControl alloc] initWithItems:presentationChoices];
        [iPadStyleControl setSelectedSegmentIndex:0];
		[self.view addSubview:iPadStyleControl];
        PREPCONSTRAINTS(iPadStyleControl);
        CENTER_VIEW_H(self.view, iPadStyleControl);
        id topLayoutGuide = self.topLayoutGuide;
        CONSTRAIN_VIEWS(self.view, @"V:[topLayoutGuide]-[iPadStyleControl]", NSDictionaryOfVariableBindings(topLayoutGuide, iPadStyleControl));
	}
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeAll;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
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
