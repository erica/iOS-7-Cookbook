/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UTIHelper.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UITextViewDelegate>
@end

@implementation TestBedViewController
{
    UITextView *textView;
    BOOL enableWatcher;
}

- (void)updatePasteboard
{
    if (enableWatcher)
        [UIPasteboard generalPasteboard].string = textView.text;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self updatePasteboard];
}

- (void)toggle:(UIBarButtonItem *)bbi
{
    enableWatcher = !enableWatcher;
    bbi.title = enableWatcher ? @"Stop Watching" : @"Watch";
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.delegate = self;
    [self updatePasteboard];
    [self.view addSubview:textView];
    
    PREPCONSTRAINTS(textView);
    STRETCH_VIEW(self.view, textView);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Watch", @selector(toggle:));
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
