/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - ModalController

@interface ModalController : UIViewController
- (IBAction)done:(id)sender;
@end

@implementation ModalController
- (IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    // Stop holding onto the popover
    popover = nil;
}

- (void)action:(id)sender
{
    // Always check for existing popover
    if (popover)
        [popover dismissPopoverAnimated:YES];
    
    // Retrieve the nav controller from the storyboard
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:[NSBundle mainBundle]];
    UINavigationController *controller = [storyboard instantiateInitialViewController];
    
    // Present either modally or as a popover
    if (IS_IPHONE)
    {
        [self.navigationController presentViewController:controller animated:YES completion:nil];
    }
    else
    {
        // No done button on iPads
        controller.topViewController.navigationItem.rightBarButtonItem = nil;
        
        // Set the preferred content size to iPhone-sized
        controller.topViewController.preferredContentSize = CGSizeMake(320.0f, 480.0f - 44.0f);
        
        // Create and deploy the popover
        popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    }
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
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
