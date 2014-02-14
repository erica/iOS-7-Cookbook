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
    UISegmentedControl *seg;
}

- (NSArray *)fooBarArray
{
    return [@"Foo*Bar*Baz*Qux" componentsSeparatedByString:@"*"];
}

- (void)push:(id)sender
{
    NSString *newTitle = [self fooBarArray][seg.selectedSegmentIndex];
    UIViewController *newController = [[TestBedViewController alloc] init];
    newController.edgesForExtendedLayout = UIRectEdgeNone;
    newController.title = newTitle;
    [self.navigationController pushViewController:newController animated:YES];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Push", @selector(push:));
    
    seg = [[UISegmentedControl alloc] initWithItems:[self fooBarArray]];
    seg.selectedSegmentIndex = 0;
    [self.view addSubview:seg];
    PREPCONSTRAINTS(seg);
    
    UILabel *label = [self labelWithTitle:@"Select Title for Pushed Controller"];
    [self.view addSubview:label];
    PREPCONSTRAINTS(label);
    
    id topLayoutGuide = self.topLayoutGuide;
    CONSTRAIN(self.view, label, @"H:|-[label(>=0)]-|");
    CONSTRAIN(self.view, seg, @"H:|-[seg(>=0)]-|");
    CONSTRAIN_VIEWS(self.view, @"V:[topLayoutGuide]-[label]-[seg]", NSDictionaryOfVariableBindings(seg, label, topLayoutGuide));
}

- (UILabel *)labelWithTitle:(NSString *)aTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = aTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura" size:IS_IPAD ? 18.0f : 12.0f];
    label.numberOfLines = 999;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    return label;
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
