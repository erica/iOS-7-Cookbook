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
    UILabel *view1;
    NSLayoutConstraint *aspectConstraint;
    BOOL useFourToThree;
}

- (UILabel *)createLabelWithTitle:(NSString *)title onParent:(UIView *)parentView
{
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.backgroundColor = [UIColor colorWithRed:0.694 green:0.894 blue:0.702 alpha:1];
    
    [parentView addSubview:label];
    
    // Turn off automatic translation of autoresizing masks into constraints
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Add constraints
    [label constrainWithinSuperviewBounds];
    [label addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[label(>=theWidth@750)]" options:0 metrics:@{@"theWidth":@300.0} views:NSDictionaryOfVariableBindings(label)]];
    [label addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[label(>=theHeight@750)]" options:0 metrics:@{@"theHeight":@300.0} views:NSDictionaryOfVariableBindings(label)]];
    [label centerInSuperview];
    
    return label;
}

- (void)action
{
    [self toggleAspectRatio];
}

- (void)toggleAspectRatio
{
    
    if (aspectConstraint)
        [self.view removeConstraint:aspectConstraint];
    
    if (useFourToThree)
        aspectConstraint = [view1 aspectConstraint:(4.0f / 3.0f)];
        //aspectConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeHeight multiplier:(4.0f / 3.0f) constant:0.0f];
    else
        aspectConstraint = [view1 aspectConstraint:(16.0f / 9.0f)];
        //aspectConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view1 attribute:NSLayoutAttributeHeight multiplier:(16.0f / 9.0f) constant:0.0f];
    
    [self.view addConstraint:aspectConstraint];
    useFourToThree = !useFourToThree;
    
    [self logSubviews];
    
}

- (void)logSubviews
{
    for (UIView *subview in self.view.subviews)
        NSLog(@"View (%d) location: %@", [self.view.subviews indexOfObject:subview], NSStringFromCGRect(subview.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self logSubviews];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Switch", @selector(action));
    
    view1 = [self createLabelWithTitle:@"View 1" onParent:self.view];
    [self toggleAspectRatio];
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
