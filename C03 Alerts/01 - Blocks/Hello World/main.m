/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "BlockAlertView.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    BlockAlertView * blockAlertView;
}

- (void) action
{
    blockAlertView = [[BlockAlertView alloc] initWithTitle:@"What is your name?" message:@"Please enter your name below"];
    blockAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [blockAlertView setCancelButtonWithTitle:@"Cancel" actionBlock:^{
        NSLog(@"Tapped Cancel");
    }];
    
    __weak TestBedViewController * weakSelf = self;
    [blockAlertView addButtonWithTitle:@"OK" actionBlock:^{
        TestBedViewController * strongSelf = weakSelf;
        if (strongSelf)
        {
            NSString * name = [strongSelf->blockAlertView textFieldAtIndex:0].text;
            NSLog(@"Tapped OK after entering: %@", name);
        }
    }];
    
    [blockAlertView show];
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action));
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
