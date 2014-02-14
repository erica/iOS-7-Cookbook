/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "CustomSlider.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    CustomSlider *slider;
    UIImageView *imageView;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    // Set global UISlider appearance attributes
    [[UISlider appearance] setMinimumTrackTintColor:[UIColor blackColor]];
    [[UISlider appearance] setMaximumTrackTintColor:[UIColor grayColor]];
    
	// Add the slider
    slider = [CustomSlider slider];
    [slider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
	[self.view addSubview:slider];
    PREPCONSTRAINTS(slider);
    CENTER_VIEW_H(self.view, slider);
    CENTER_VIEW_V_CONSTANT(self.view, slider, 40);
    CONSTRAIN_WIDTH(slider, 240);
    
    // Create a custom title view
    imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookCover"]];
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    CENTER_VIEW_H(self.view, imageView);
    ALIGN_VIEW_TOP_CONSTANT(self.view, imageView, 60);
}

- (void)updateValue:(UISlider *)aSlider
{
    // Scale the title view
    imageView.transform = CGAffineTransformMakeScale(1.0f + 4.0f * aSlider.value, 1.0f);
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
