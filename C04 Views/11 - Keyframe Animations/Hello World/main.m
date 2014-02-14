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
	UIView *bounceView;
}

- (void)enable:(BOOL)enabled
{
    for (UIBarButtonItem *item in self.navigationItem.leftBarButtonItems)
        item.enabled = enabled;
    self.navigationItem.rightBarButtonItem.enabled = enabled;
}

// Recipe example
- (void)bounce
{
    // Init
    [self enable:NO];
    bounceView.transform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    bounceView.center = RECTCENTER(self.view.bounds);
    
    [UIView animateKeyframesWithDuration:0.6
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);
                                                                }];
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.transform = CGAffineTransformIdentity;
                                                                }];
                              }
                              completion:^(BOOL finished) {
                                  [self enable:YES];
                              }];
}

- (void)actionZoom
{
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    CGAffineTransform transientTransform = CGAffineTransformMakeScale(1.2f, 1.2f);
    CGAffineTransform shrinkTransform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    
    // Init
    [self enable:NO];
    bounceView.center = CGPointMake(midX, midY);
    bounceView.transform = shrinkTransform;
    
    // I had this as one animation block originally using calculated durations and start times.
    // Apparently, the long (2 second) delay between the bounce in and bounce out seem to make
    // things go wonky.  Breaking them up in two animations with a delay solved things.
    [UIView animateKeyframesWithDuration:0.6
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.transform = transientTransform;
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.transform = CGAffineTransformIdentity;
                                                                }];
                              }
                              completion:^(BOOL finished) {
                                  [UIView animateKeyframesWithDuration:0.6
                                                                 delay:2.0
                                                               options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                                            animations:^{
                                                                
                                                                [UIView addKeyframeWithRelativeStartTime:0.0
                                                                                        relativeDuration:0.5
                                                                                              animations:^{
                                                                                                  bounceView.transform = transientTransform;
                                                                                              }];
                                                                
                                                                [UIView addKeyframeWithRelativeStartTime:0.5
                                                                                        relativeDuration:0.5
                                                                                              animations:^{
                                                                                                  bounceView.transform = shrinkTransform;
                                                                                              }];
                                                            }
                                                            completion:^(BOOL finished) {
                                                                [self enable:YES];
                                                            }];
                              }];
}


// Additional example
- (void)actionMove
{
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    CGPoint centerPoint = CGPointMake(midX, midY);
    CGPoint beyondPoint = CGPointMake(midX * 1.2f, midY);
    CGPoint offScreenPoint = CGPointMake(-midX, midY);
    
    // Init
    [self enable:NO];
    bounceView.center = CGPointMake(-midX, midY);
    bounceView.transform = CGAffineTransformIdentity;
    
    // Again, had this in one key frame block originally.  In addition to the timing issues,
    // discovered an odd bug in the cubic mode calculations that caused a strange floating issue.
    // Linear mode solved the issue but made for a very stiff / jarring bounce.
    // Breaking into two separate animations solved the issues.  
    [UIView animateKeyframesWithDuration:0.6
                                   delay:0.0
                                 options:UIViewKeyframeAnimationOptionCalculationModeCubic
                              animations:^{
                                  [UIView addKeyframeWithRelativeStartTime:0.0
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.center = beyondPoint;
                                                                }];
                                  
                                  [UIView addKeyframeWithRelativeStartTime:0.5
                                                          relativeDuration:0.5
                                                                animations:^{
                                                                    bounceView.center = centerPoint;
                                                                }];
                              }
                              completion:^(BOOL finished) {
                                  [UIView animateKeyframesWithDuration:0.6
                                                                 delay:2
                                                               options:UIViewKeyframeAnimationOptionCalculationModeCubic
                                                            animations:^{
                                                                
                                                                [UIView addKeyframeWithRelativeStartTime:0.0
                                                                                        relativeDuration:0.5
                                                                                              animations:^{
                                                                                                  bounceView.center = beyondPoint;
                                                                                              }];
                                                                
                                                                [UIView addKeyframeWithRelativeStartTime:0.5
                                                                                        relativeDuration:0.5
                                                                                              animations:^{
                                                                                                  bounceView.center = offScreenPoint;
                                                                                              }];
                                                            }
                                                            completion:^(BOOL finished) {
                                                                
                                                                [self enable:YES];
                                                            }];
                              }];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    bounceView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 150.0f, 150.0f)];
    bounceView.backgroundColor = [UIColor redColor];
    [self.view addSubview:bounceView];
    bounceView.transform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
    
    self.navigationItem.leftBarButtonItems = @[BARBUTTON(@"Zoom", @selector(actionZoom)), BARBUTTON(@"Move", @selector(actionMove))];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Show", @selector(bounce));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    bounceView.center = RECTCENTER(self.view.bounds);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    bounceView.center = RECTCENTER(self.view.bounds);
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
