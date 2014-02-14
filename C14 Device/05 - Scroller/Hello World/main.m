/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import CoreMotion;
#import "Utility.h"

#define SIGN(_NUM_) ((_NUM_ < 0) ? (-1) : 1)

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    CMMotionManager * motionManager;
    float xoff;
    float xaccel;
	float xvelocity;
    
    float yoff;
	float yaccel;
	float yvelocity;
}

- (void)tick
{
    xoff += xvelocity;
    xoff = MIN(xoff, 1.0f);
    xoff = MAX(xoff, 0.0f);
    
    yoff += yvelocity;
    yoff = MIN(yoff, 1.0f);
    yoff = MAX(yoff, 0.0f);
    
    UIScrollView * scrollView = (UIScrollView *) self.view;
    CGFloat xsize = scrollView.contentSize.width - scrollView.frame.size.width;
    CGFloat ysize = scrollView.contentSize.height - scrollView.frame.size.height;
    scrollView.contentOffset = CGPointMake(xoff * xsize, yoff * ysize);
}

- (void)loadView
{
    self.view = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.01;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *map = @"http://maps.weather.com/images/maps/current/curwx_720x486.jpg";
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:
     ^{
         // Load the weather data
         NSURL *weatherURL = [NSURL URLWithString:map];
         NSData *imageData = [NSData dataWithContentsOfURL:weatherURL];
         
         // Update the image on the main thread using the main queue
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             UIImage *weatherImage = [UIImage imageWithData:imageData];
             UIImageView *imageView = [[UIImageView alloc] initWithImage:weatherImage];
             CGSize initSize = weatherImage.size;
             CGSize destSize = weatherImage.size;
             
             while ((destSize.width < (self.view.frame.size.width * 4)) ||
                    (destSize.height < (self.view.frame.size.height * 4)))
             {
                 destSize.width += initSize.width;
                 destSize.height += initSize.height;
             }
             
             imageView.frame = (CGRect){.size = destSize};
             UIScrollView * scrollView = (UIScrollView *) self.view;
             scrollView.contentSize = destSize;
             [scrollView addSubview:imageView];
             
             // only allowing accelerometer-based scrolling
             scrollView.userInteractionEnabled = NO;
             
             // Activate the accelerometer
             [motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                 // extract the acceleration components
                 CMAcceleration acceleration = accelerometerData.acceleration;
                 float xx = -acceleration.x;
                 float yy = (acceleration.z + 0.5f) * 2.0f; // between face up and face forward
                 
                 // Has the direction changed?
                 float accelDirX = SIGN(xvelocity) * -1.0f;
                 float newDirX = SIGN(xx);
                 float accelDirY = SIGN(yvelocity) * -1.0f;
                 float newDirY = SIGN(yy);
                 
                 // Accelerate. To increase viscosity lower the additive value
                 if (accelDirX == newDirX) xaccel = (abs(xaccel) + 0.005f) * SIGN(xaccel);
                 if (accelDirY == newDirY) yaccel = (abs(yaccel) + 0.005f) * SIGN(yaccel);
                 
                 // Apply acceleration changes to the current velocity
                 xvelocity = -xaccel * xx;
                 yvelocity = -yaccel * yy;
             }];
             
             // Start the physics timer
             [NSTimer scheduledTimerWithTimeInterval:0.03f target:self selector:@selector(tick) userInfo:nil repeats:YES];
         }];
     }];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [motionManager stopAccelerometerUpdates];
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
