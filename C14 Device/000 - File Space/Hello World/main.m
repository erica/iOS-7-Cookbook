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

- (void)action
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fsAttr = [fm attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumber * fileSystemSize = [fsAttr  objectForKey:NSFileSystemSize];
    NSLog(@"System space: %@ bytes", [numberFormatter stringFromNumber:fileSystemSize]);
    NSLog(@"System space: %@ megabytes", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:fileSystemSize.longLongValue / 1024 / 1024]]);
    
    NSNumber * fileSystemFreeSize = [fsAttr  objectForKey:NSFileSystemFreeSize];
    NSLog(@"System free space: %@ bytes", [numberFormatter stringFromNumber:fileSystemFreeSize]);
    NSLog(@"System space: %@ megabytes", [numberFormatter stringFromNumber:[NSNumber numberWithLongLong:fileSystemFreeSize.longLongValue / 1024 / 1024]]);
}

- (void)loadView
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
