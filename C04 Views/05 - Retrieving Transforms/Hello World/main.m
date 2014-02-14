/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIView-Transform.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect dest = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    
    UIView *compareView = [[UIView alloc] initWithFrame:dest];
    compareView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:compareView];
    
    UIView *testView = [[UIView alloc] initWithFrame:dest];
    testView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:testView];
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, M_PI_4);
    transform = CGAffineTransformScale(transform, 1.5f, 0.75f);
    transform = CGAffineTransformTranslate(transform, 30.0f, 40.0f);
    testView.transform = transform;
    
    NSLog(@"Translation: (%0.3f, %0.3f)", testView.tx, testView.ty);
    NSLog(@"Scale: (%0.3f, %0.3f)", testView.xscale, testView.yscale);
    NSLog(@"Rotation: %0.3f", testView.rotation);
    
    compareView.transform = CGAffineTransformMakeTranslation(testView.tx, testView.ty);
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
