/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIView-NameExtensions.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void) action:(id)sender
{
    UISwitch *aSwitch = (UISwitch *) [self.view viewNamed:@"topSwitch"];
    aSwitch.on = !aSwitch.isOn;
    
    ((UILabel *)[self.view viewNamed:@"infoLabel"]).text = [NSString stringWithFormat:@"The switch is %@", aSwitch.isOn ? @"on" : @"off"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    ((UILabel *)[self.view viewNamed:@"infoLabel"]).text = @"The switch is on";
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action:));
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.tintColor = COOKBOOK_PURPLE_COLOR;
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
