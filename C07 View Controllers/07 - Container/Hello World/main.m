/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "FlipViewController.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (UIViewController *)newFlipController
{
    UIViewController *blueController = [[UIViewController alloc] init];
    blueController.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *redController = [[UIViewController alloc] init];
    redController.view.backgroundColor = [UIColor redColor];
    
    FlipViewController *flipController = [[FlipViewController alloc]  initWithFrontController:blueController andBackController:redController];
    flipController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    flipController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    return flipController;
}

- (void)modal:(id)sender
{
    [self.navigationController presentViewController:[self newFlipController] animated:YES completion:nil];
}

- (void)push:(id)sender
{
    [self.navigationController pushViewController:[self newFlipController] animated:YES];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Modal", @selector(modal:));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Push", @selector(push:));
    
    if (!IS_IPAD) return;
    
    UIViewController *flip = [self newFlipController];
    PREPCONSTRAINTS(flip.view);
    CONSTRAIN_SIZE(flip.view, 400.0, 300.0);
    CENTER_VIEW(self.view, flip.view);
    
    // Setup Child View Controller
    [self addChildViewController:flip];
    [self.view addSubview:flip.view];
    [flip didMoveToParentViewController:self];
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
