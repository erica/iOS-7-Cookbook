/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "LockControl.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self lock:nil];
}

- (void)handleUnlock:(LockControl *)control
{
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Lock", @selector(lock:));
}

- (void)lock:(id) sender
{
    self.navigationItem.rightBarButtonItem = nil;
    
    LockControl *lock = [LockControl new];
    [lock addTarget:self action:@selector(handleUnlock:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:lock];
    
    PREPCONSTRAINTS(lock);
    CENTER_VIEW(self.view, lock);
    
    lock.alpha = 0.0f;
    [UIView animateWithDuration:0.3f animations:^(){
        lock.alpha = 1.0f;
    }];
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
