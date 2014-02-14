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
{
    UIDatePicker *picker;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];

    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Time", @"Date", @"DT", @"Count"]];
    [segmentedControl addTarget:self action:@selector(action:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;

    picker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    [picker setDate:[NSDate date]];
    [self.view addSubview:picker];
    PREPCONSTRAINTS(picker);
    CENTER_VIEW_H(self.view, picker);
    CENTER_VIEW_V(self.view, picker);
}

- (void)action:(UISegmentedControl *)segmentedControl
{
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            picker.datePickerMode = UIDatePickerModeTime;
            break;
        case 1:
            picker.datePickerMode = UIDatePickerModeDate;
            break;
        case 2:
            picker.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case 3:
            picker.datePickerMode = UIDatePickerModeCountDownTimer;
            break;
            
        default:
            break;
    }
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
