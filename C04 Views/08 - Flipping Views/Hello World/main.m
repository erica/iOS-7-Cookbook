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
    UIImageView *purple;
    UIImageView *maroon;
    BOOL fromPurple;
}

- (void)flip:(id)sender
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIView * toView = fromPurple ? maroon : purple;
    UIView * fromView = fromPurple ? purple : maroon;
    [UIView transitionFromView: fromView
                        toView: toView
                      duration: 1.0f
                       options: UIViewAnimationOptionTransitionFlipFromLeft
                    completion: ^(BOOL done){
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                        fromPurple = !fromPurple;
                        CENTER_VIEW(self.view, toView);
                    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create objects
    maroon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    purple = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    
    fromPurple = YES;
    
    // Setup constraints
    [self.view addSubview:maroon];
    PREPCONSTRAINTS(maroon);
    CENTER_VIEW(self.view, maroon);

    [self.view addSubview:purple];
    PREPCONSTRAINTS(purple);
    CENTER_VIEW(self.view, purple);
    
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Flip", @selector(flip:));
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
