/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "CustomAlert.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    CustomAlert * alertView;
}

- (void) action
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    alertView = [[CustomAlert alloc] initWithFrame:CGRectMake(0, 0, 240, 200)];
    [self.view addSubview:alertView];
    alertView.label.text = @"Custom Alert View";
    [alertView.button setTitle:@"OK" forState:UIControlStateNormal];
    [alertView.button addTarget:self action:@selector(handleButton:) forControlEvents:UIControlEventTouchUpInside];
    [alertView show];
}

- (void) handleButton:(id)sender
{
    [alertView dismiss];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action));
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"flowers"]];
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    ALIGN_VIEW_TOP(self.view, imageView);
    ALIGN_VIEW_BOTTOM(self.view, imageView);
    ALIGN_VIEW_LEFT(self.view, imageView);
    ALIGN_VIEW_RIGHT(self.view, imageView);
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
