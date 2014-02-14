/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "UIView-SubviewGeometry.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIImageView *butterflyView;
}

- (void)updateButterfly:(NSTimer *)timer
{
    [UIView animateWithDuration:0.6f animations:^(void){
        butterflyView.center = [butterflyView randomCenterInView:self.view withInset:10.0f];
    }];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Load butterfly images
	NSMutableArray *butterflies = [NSMutableArray array];
	for (int i = 1; i <= 17; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"bf_%d", i]];
		if (image) [butterflies addObject:image];
    }
    
    butterflyView = [[UIImageView alloc] initWithFrame:CGRectMake(40.0f, 300.0f, 100.0f, 51.0f)];
	butterflyView.animationImages = butterflies;
	butterflyView.animationDuration = 0.75f;
	[self.view addSubview:butterflyView];
	[butterflyView startAnimating];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(updateButterfly:) userInfo:nil repeats:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
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
