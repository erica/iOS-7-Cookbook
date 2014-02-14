/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIView+ConstraintHelper.h"

#pragma mark - MyLabel
@interface MyLabel : UILabel
@end

@implementation MyLabel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(100, 100);
}

@end

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    MyLabel *view1;
    BOOL top;
}

- (void)action
{
    if (top)
    {
        NSLayoutConstraint *constraintToMatch  = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        [self.view removeMatchingConstraint:constraintToMatch ];
        
        NSLayoutConstraint *updatedConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self.view addConstraint:updatedConstraint];
    }
    else
    {
        NSLayoutConstraint *constraintToMatch  = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0f constant:0];
        [self.view removeMatchingConstraint:constraintToMatch ];
        
        NSLayoutConstraint *updatedConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
        [self.view addConstraint:updatedConstraint];
    }

    [UIView animateWithDuration:0.3 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    top = !top;
}


- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action));
    
    view1 = [[MyLabel alloc] init];
    view1.text = @"View 1";
    view1.backgroundColor = [UIColor colorWithRed:0.694 green:0.894 blue:0.702 alpha:1];

    // Turns off automatic translation of autoresizing masks into constraints
    view1.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:view1];

    NSLayoutConstraint *updatedConstraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0f constant:0];
    [self.view addConstraint:updatedConstraint];

    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    [self.view addConstraint:constraint];
    
    top = YES;
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
