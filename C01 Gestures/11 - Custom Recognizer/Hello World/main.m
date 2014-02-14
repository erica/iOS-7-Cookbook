/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "CircleRecognizer.h"
#import "Utility.h"


#pragma mark - UIColor+Random

@interface UIColor (Random)
+ (UIColor *)randomColor;
@end

@implementation UIColor(Random)

+ (UIColor *)randomColor
{
    static BOOL seeded = NO;
    if (!seeded)
    {
        seeded = YES;
        srandom(time(NULL));
    }
	
	float intensityOffset = 0.25f;
    CGFloat red =  (CGFloat)random()/(CGFloat)RAND_MAX; red = (red / 2.0f) + intensityOffset;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX; blue = (blue / 2.0f) + intensityOffset;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX; green = (green / 2.0f) + intensityOffset;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    CircleRecognizer *recognizer = [[CircleRecognizer alloc] initWithTarget:self action:@selector(handleCircleRecognizer:)];
	[self.view addGestureRecognizer:recognizer];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)handleCircleRecognizer:(UIGestureRecognizer *) recognizer
{
	// Respond to a recognition event by updating the background
    // I do this just to give the user some feedback that the recognizer succeeded
	self.view.backgroundColor = [UIColor randomColor];
    NSLog(@"Circle recognized");
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
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
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
