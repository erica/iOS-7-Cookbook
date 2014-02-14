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
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation TestBedViewController

- (void)fadeOut:(id)sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 self.imageView.alpha = 0.0f;
					 }
					 completion:^(BOOL done){
						 self.navigationItem.rightBarButtonItem.enabled = YES;
						 self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade In", @selector(fadeIn:));
					 }];
}


- (void)fadeIn:(id)sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 self.imageView.alpha = 1.0f;
					 }
					 completion:^(BOOL done){
						 self.navigationItem.rightBarButtonItem.enabled = YES;
						 self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade Out", @selector(fadeOut:));
					 }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Fade In", @selector(fadeIn:));
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
