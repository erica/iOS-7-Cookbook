/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIDevice-Reachability.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <ReachabilityWatcher>
@end

@implementation TestBedViewController
{
    UITextView *textView;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    textView = [[UITextView alloc] init];
    textView.editable = NO;
    textView.font = [UIFont fontWithName:@"Futura" size:IS_IPAD ? 24.0f : 12.0f];
    textView.textColor = COOKBOOK_PURPLE_COLOR;
    textView.text = @"";
    [self.view addSubview:textView];
    PREPCONSTRAINTS(textView);
    STRETCH_VIEW(self.view, textView);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Test", @selector(runTests));
}


- (void)log:(id)formatstring,...
{
    va_list arglist;
	if (!formatstring) return;
	va_start(arglist, formatstring);
	NSString *outstring = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
	va_end(arglist);
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        NSString *newString = [NSString stringWithFormat:@"%@\n%@: %@", textView.text, [NSDate date], outstring];
        textView.text = newString;
        [textView scrollRangeToVisible:NSMakeRange(newString.length, 1)];
    }];
}

// Run basic reachability tests
- (void)runTests
{
    // Many of the following reachability tests can block.  In your production code, they should not be run in the main thread.
    
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         UIDevice *device = [UIDevice currentDevice];
         [self log:@"\n\nReachability Tests"];
         [self log:@"Current host: %@", [device hostname]];
         [self log:@"Local WiFi IP: %@", [device localWiFiIPAddress]];
         [self log:@"All WiFi IP: %@", [device localWiFiIPAddresses]];
         
         [self log:@"Network available?: %@", [device networkAvailable] ? @"Yes" : @"No"];
         [self log:@"Active WLAN?: %@", [device activeWLAN] ? @"Yes" : @"No"];
         [self log:@"Active WWAN?: %@", [device activeWWAN] ? @"Yes" : @"No"];
         [self log:@"Active hotspot?: %@", [device activePersonalHotspot] ? @"Yes" : @"No"];
         
         [self checkAddresses];
     }];
}

- (void)checkAddresses
{
    UIDevice *device = [UIDevice currentDevice];
    if (![device networkAvailable]) return;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"\n\nChecking IP Addresses"];
         }];
         NSString *google = [device getIPAddressForHost:@"www.google.com"];
         NSString *amazon = [device getIPAddressForHost:@"www.amazon.com"];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"Google: %@", google];
             [self log:@"Amazon: %@", amazon];
             [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
             
             [self checkSites];
         }];
     }];
}

- (void)checkSite:(NSString *)urlString
{
    UIDevice *device = [UIDevice currentDevice];
    [self log:@"• %@ : %@", urlString, [device hostAvailable:urlString] ? @"available" : @"not available"];
}

// Note, if your ISP redirects unavailable sites to their own servers, these will give false positives.
- (void)checkSites
{
    [[[NSOperationQueue alloc] init] addOperationWithBlock:
     ^{
         NSDate *date = [NSDate date];
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"\n\nChecking Site Availability"];
         }];
         NSOperationQueue * siteCheckOperationQueue = [[NSOperationQueue alloc] init];
         [siteCheckOperationQueue addOperationWithBlock:^{
             [self checkSite:@"www.google.com"];
             [self checkSite:@"www.ericasadun.com"];
             [self checkSite:@"www.notverylikely.com"];
             [self checkSite:@"192.168.0.108"];
             [self checkSite:@"pearson.com"];
             [self checkSite:@"www.pearson.com"];
         }];
         [siteCheckOperationQueue waitUntilAllOperationsAreFinished];
         
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self log:@"Elapsed time: %0.1f", [[NSDate date] timeIntervalSinceDate:date]];
         }];
     }];
}

- (void)reachabilityChanged
{
    [self log:@"\n\n**** REACHABILITY CHANGED! ****"];
    [self runTests];
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
    
    [[UIDevice currentDevice] scheduleReachabilityWatcher:tbvc];
    
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
