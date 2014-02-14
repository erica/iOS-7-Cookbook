/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "PushButton.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    PushButton *button;
    UIImageView *butterflyView;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO];

    button = [PushButton button];
    [self.view addSubview:button];
    PREPCONSTRAINTS(button);
    CENTER_VIEW(self.view, button);
    CONSTRAIN_WIDTH(button, 300);
    [button addTarget:self action:@selector(pushed:) forControlEvents: UIControlEventTouchUpInside];
}

- (void)pushed:(PushButton *)aButton
{
    self.title = aButton.isOn ? @"Button: On" : @"Button: Off";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!butterflyView)
    {
        // Load Butterflies
        NSMutableArray *butterflies = [NSMutableArray array];
        UIImage *image;
        for (int i = 1; i <= 17; i++)
        {
            NSString *butterfly = [NSString stringWithFormat:@"bf_%d.png", i];
            if ((image = [UIImage imageNamed:butterfly]))
                [butterflies addObject:image];
        }
        
        CGSize size = ((UIImage *)[butterflies lastObject]).size;
        
        butterflyView = [[UIImageView alloc] initWithFrame:(CGRect){.size = size}];
        [butterflyView setAnimationImages:butterflies];
        [butterflyView setAnimationDuration:1.2f];
        [butterflyView startAnimating];
        [self.view addSubview:butterflyView];
        [self.view sendSubviewToBack:butterflyView];
        PREPCONSTRAINTS(butterflyView);
        CENTER_VIEW(self.view, butterflyView);
    }
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
