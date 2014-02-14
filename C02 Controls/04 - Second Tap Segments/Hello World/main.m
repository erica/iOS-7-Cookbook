/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


@class SecondTapSegmentedControl;

@protocol SecondTapSegmentedControlDelegate <NSObject>
- (void)performSegmentAction:(SecondTapSegmentedControl *)aDTSC;
@end

@interface SecondTapSegmentedControl : UISegmentedControl
@property (nonatomic, weak) id <SecondTapSegmentedControlDelegate> tapDelegate;
@end

@implementation SecondTapSegmentedControl

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
	if (self.tapDelegate) [self.tapDelegate performSegmentAction:self];
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <SecondTapSegmentedControlDelegate>
@end

@implementation TestBedViewController
{
    NSUInteger tapCount;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add a segment testbed to the view
    NSArray *items = [@"One*Two*Three" componentsSeparatedByString:@"*"];
    SecondTapSegmentedControl *seg = [[SecondTapSegmentedControl alloc] initWithItems:items];
    seg.tapDelegate = self;
    [self.view addSubview:seg];
    PREPCONSTRAINTS(seg);
    ALIGN_VIEW_TOP(self.view, seg);
    ALIGN_VIEW_LEFT(self.view, seg);
    ALIGN_VIEW_RIGHT(self.view, seg);
    
    seg.selectedSegmentIndex = 0;
    self.title = @"One";
}

- (void)performSegmentAction:(SecondTapSegmentedControl *)seg
{
    NSArray *items = [@"One*Two*Three" componentsSeparatedByString:@"*"];
    NSString *selected = [items objectAtIndex:seg.selectedSegmentIndex];
    
    // Check for a subsequent taps
    NSString * againString = [NSString stringWithFormat:@"%@ (again #", selected];
    if ([selected isEqualToString:self.title] || [self.title hasPrefix:againString])
    {
        tapCount++;
        selected = [NSString stringWithFormat:@"%@ (again #%d)", selected, tapCount];
        NSDictionary *attributeDictionary = @{NSForegroundColorAttributeName : [UIColor redColor]};
        [seg setTitleTextAttributes:attributeDictionary forState:UIControlStateSelected];
    }
    else
    {
        [seg setTitleTextAttributes:nil forState:UIControlStateSelected];
        tapCount = 0;
    }
    self.title = selected;
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
