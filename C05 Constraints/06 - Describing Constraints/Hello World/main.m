/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIView+ConstraintHelper.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIView *view1;
}

- (UIView *)createBoxOnParent:(UIView *)parentView
{
    UIView * view = [[UIView alloc] init];
    view.backgroundColor = [UIColor colorWithRed:0.694 green:0.894 blue:0.702 alpha:1];
    
    [parentView addSubview:view];
    
    // Turn off automatic translation of autoresizing masks into constraints
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add constraints
    [view constrainWithinSuperviewBounds];
    [view centerInSuperview];
    [view constrainSize:CGSizeMake(100, 100)];
    
    return view;
}

- (void)action
{
    NSLog(@"*** Superview ***");
    [self.view showConstraints];
    NSLog(@"*** view1 (Label) ***");
    [view1 showConstraints];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Show Constraints", @selector(action));
    
    view1 = [self createBoxOnParent:self.view];
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
