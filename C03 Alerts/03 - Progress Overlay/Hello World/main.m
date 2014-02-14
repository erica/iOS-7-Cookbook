/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TappableView

@interface TappableView : UIView
@end

@implementation TappableView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Uncomment to make the view disappear on touch
    //[self removeFromSuperview];
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)removeOverlay:(UIView *)overlayView
{
    [overlayView removeFromSuperview];
}

- (void)action
{
    UIWindow *window = self.view.window;
    TappableView *overlayView = [[TappableView alloc] initWithFrame:window.bounds];
    overlayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    overlayView.userInteractionEnabled = YES;
    
    // Add an activity indicator
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [aiv startAnimating];
    [overlayView addSubview:aiv];
    PREPCONSTRAINTS(aiv);
    CENTER_VIEW(overlayView, aiv);
    
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.text = @"Please wait...";
    [overlayView addSubview:label];
    PREPCONSTRAINTS(label);
    CENTER_VIEW_H(overlayView, label);
    CENTER_VIEW_V_CONSTANT(overlayView, label, -44);
    
    [window addSubview:overlayView];
    
    // Comment out if you are using touch-to-remove
    [self performSelector:@selector(removeOverlay:) withObject:overlayView afterDelay:5.0f];
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
