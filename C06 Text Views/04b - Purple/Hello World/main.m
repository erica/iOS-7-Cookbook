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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create two standard text fields
    UITextField *textField1 = [[UITextField alloc] init];
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview: textField1];
    PREPCONSTRAINTS(textField1);
    CONSTRAIN_SIZE(textField1, 30, 200);
    CENTER_VIEW_H(self.view, textField1);
    ALIGN_VIEW_TOP_CONSTANT(self.view, textField1, 40);
    
    UITextField *textField2 = [[UITextField alloc] init];
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview: textField2];
    PREPCONSTRAINTS(textField2);
    CONSTRAIN_SIZE(textField2, 30, 200);
    CENTER_VIEW_H(self.view, textField2);
    ALIGN_VIEW_TOP_CONSTANT(self.view, textField2, 80);
    
    // Create a purple view to be used as the input view
    UIView *purpleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 120.0f)];
    purpleView.backgroundColor = COOKBOOK_PURPLE_COLOR;
    
    // Assign the input view
    textField2.inputView = purpleView;
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
