/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "RibbonPull.h"


const CGFloat kDesiredHeight = 120.0f;

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    RibbonPull *ribbonPull;
    UIView *hiddenView;
    NSLayoutConstraint * ribbonPullTopConstraint;
    NSLayoutConstraint * hiddentViewTopConstraint;
    BOOL isHidden;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    isHidden = YES;
    
    hiddenView = [UIView new];
    hiddenView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5f];
    [self.view addSubview:hiddenView];
    PREPCONSTRAINTS(hiddenView);
    ALIGN_VIEW_LEFT(self.view, hiddenView);
    ALIGN_VIEW_RIGHT(self.view, hiddenView);
    CONSTRAIN_HEIGHT(hiddenView, 120);
    hiddentViewTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, hiddenView, -kDesiredHeight);
    [self.view addConstraint:hiddentViewTopConstraint];
    
    ribbonPull = [RibbonPull new];
    [self.view addSubview:ribbonPull];
    PREPCONSTRAINTS(ribbonPull);
    ALIGN_VIEW_RIGHT_CONSTANT(self.view, ribbonPull, -30);
    ribbonPullTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, ribbonPull, 0);
    [self.view addConstraint:ribbonPullTopConstraint];
    
    [ribbonPull addTarget:self action:@selector(updateDrawer:) forControlEvents:UIControlEventValueChanged];
}

- (void)updateDrawer:(UIControl *)aControl
{
    [self.view removeConstraint:hiddentViewTopConstraint];
    [self.view removeConstraint:ribbonPullTopConstraint];
    if (isHidden)
    {
        hiddentViewTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, hiddenView, 0);
        ribbonPullTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, ribbonPull, kDesiredHeight);
    }
    else
    {
        hiddentViewTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, hiddenView, -kDesiredHeight);
        ribbonPullTopConstraint = CONSTRAINT_FOR_ALIGN_VIEW_TOP_CONSTANT(self.view, ribbonPull, 0);
    }
    [self.view addConstraint:hiddentViewTopConstraint];
    [self.view addConstraint:ribbonPullTopConstraint];
    
    [UIView animateWithDuration:1.0f animations:^(){
        [self.view layoutIfNeeded];
    }];
    
    isHidden = !isHidden;
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
