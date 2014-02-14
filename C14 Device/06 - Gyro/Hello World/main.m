/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import CoreMotion;
#import "Utility.h"

#define RECTCENTER(RECT) CGPointMake(CGRectGetMidX(RECT), CGRectGetMidY(RECT))

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    CMMotionManager *motionManager;
    UIImageView *imageView;
}

- (void)shutDownMotionManager
{
    NSLog(@"Shutting down motion manager");
    [motionManager stopDeviceMotionUpdates];
    motionManager = nil;
}

- (void)establishMotionManager
{
    if (motionManager)
        [self shutDownMotionManager];
    
    NSLog(@"Establishing motion manager");
    
    // Establish the motion manager
    motionManager = [[CMMotionManager alloc] init];
    if (motionManager.deviceMotionAvailable)
        [motionManager
         startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]
         withHandler: ^(CMDeviceMotion *motion, NSError *error) {
             CATransform3D transform;
             transform = CATransform3DMakeRotation(motion.attitude.pitch, 1, 0, 0);
             transform = CATransform3DRotate(transform, motion.attitude.roll, 0, 1, 0);
             transform = CATransform3DRotate(transform, motion.attitude.yaw, 0, 0, 1);
             imageView.layer.transform = transform;
         }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *imageName = IS_IPAD ? @"BookCover_iPad" : @"BookCover_iPhone";
    UIImage *image = [UIImage imageNamed:imageName];
    imageView = [[UIImageView alloc] initWithImage:image];
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = RECTCENTER(self.view.bounds);
    [self.view addSubview:imageView];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}


@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
{
    TestBedViewController *tbvc;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [tbvc shutDownMotionManager];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [tbvc establishMotionManager];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    tbvc = [[TestBedViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
    _window.rootViewController = tbvc;
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
