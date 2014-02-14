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
    UIImageView *frontObject;
    UIImageView *backObject;
}

- (void)swap:(id)sender
{
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[UIView animateWithDuration:1.0f
					 animations:^{
						 frontObject.alpha = 0.0f;
						 backObject.alpha = 1.0f;
						 frontObject.transform = CGAffineTransformMakeScale(0.25f, 0.25f);
						 backObject.transform = CGAffineTransformIdentity;
						 [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
					 }
					 completion:^(BOOL done){
                         UIImageView *tmp = frontObject;
                         frontObject = backObject;
                         backObject = tmp;
						 self.navigationItem.rightBarButtonItem.enabled = YES;
					 }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Add secondary object
    backObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Maroon.png"]];
    [self.view addSubview:backObject];
    PREPCONSTRAINTS(backObject);
    CENTER_VIEW(self.view, backObject);
    
    // Add primary object
    frontObject = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Purple.png"]];
    [self.view addSubview:frontObject];
    PREPCONSTRAINTS(frontObject);
    CENTER_VIEW(self.view, frontObject);
    
    // Prepare secondary object
    backObject.alpha = 0.0f;
    backObject.transform = CGAffineTransformMakeScale(0.25f, 0.25f);
    
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Swap", @selector(swap:));
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
