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
    UILabel *label;
}

- (void)peekAtBatteryState
{
    NSArray *stateArray = @[@"Battery state is unknown", @"Battery is not plugged into a charging source", @"Battery is charging", @"Battery state is full"];
    
    NSString *status = [NSString stringWithFormat:@"Battery state: %@, Battery level: %0.2f%%",
                        stateArray[[UIDevice currentDevice].batteryState],
                        [UIDevice currentDevice].batteryLevel * 100];
    
    NSLog(@"%@", status);
    label.text = status;
}

- (void)updateTitle
{
    self.title = [NSString stringWithFormat:@"Proximity %@", [UIDevice currentDevice].proximityMonitoringEnabled ? @"On" : @"Off"];
}

- (void)toggle:(id)sender
{
    // Determine the current proximity monitoring and toggle it
    BOOL isEnabled = [UIDevice currentDevice].proximityMonitoringEnabled;
    [UIDevice currentDevice].proximityMonitoringEnabled = !isEnabled;
    [self updateTitle];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 99;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:label];
    
    PREPCONSTRAINTS(label);
    CONSTRAIN(self.view, label, @"H:|-[label(>=0)]-|");
    CONSTRAIN(self.view, label, @"V:|[label(>=0)]|");
    
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Toggle", @selector(toggle:));
    [self updateTitle];
    
    // Add proximity state checker
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceProximityStateDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSLog(@"The proximity sensor %@", [UIDevice currentDevice].proximityState ?
              @"will now blank the screen" : @"will now restore the screen");
    }];
    
    // Enable battery monitoring
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    
    // Add observers for battery state and level changes
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryStateDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSLog(@"Battery State Change");
        [self peekAtBatteryState];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIDeviceBatteryLevelDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification) {
        NSLog(@"Battery Level Change");
        [self peekAtBatteryState];
    }];
    
    // Example of device properties
    UIDevice *device = [UIDevice currentDevice];
    NSLog(@"System name: %@", device.systemName);
    NSLog(@"System version: %@", device.systemVersion);
    NSLog(@"Model: %@", device.model);
    NSLog(@"Name: %@", device.name);
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
