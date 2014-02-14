/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import Social;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController

#pragma mark - Utility
- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark - Social
- (void)postSocial:(NSString *)serviceType
{
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:serviceType];
    [controller addImage:[UIImage imageNamed:@"BookCover"]];
    [controller setInitialText:@"I'm reading the iOS Developer's Cookbook"];
    controller.completionHandler = ^(SLComposeViewControllerResult result){
        switch (result)
        {
            case SLComposeViewControllerResultCancelled:
                NSLog(@"Cancelled");
                break;
            case SLComposeViewControllerResultDone:
                NSLog(@"Posted");
                break;
            default:
                break;
        }
    };
    [self presentViewController:controller];
}
- (void)postToFacebook
{
    [self postSocial:SLServiceTypeFacebook];
}

- (void)postToTwitter
{
    [self postSocial:SLServiceTypeTwitter];
}

#pragma mark - Setup

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        self.navigationItem.leftBarButtonItem = BARBUTTON(@"Facebook", @selector(postToFacebook));
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Twitter", @selector(postToTwitter));
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
