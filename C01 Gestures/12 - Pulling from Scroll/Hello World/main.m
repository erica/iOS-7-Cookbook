/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "PullView.h"
#import "DragView.h"
#import "UIColor-Random.h"


const CGFloat kSide = 80.0f;
const CGFloat kSideIPAD = 160.0f;
const NSUInteger kNumberOfObjects = 10;

#define SIDE	(IS_IPAD ? kSideIPAD : kSide)


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UIScrollView * scrollView;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Clear", @selector(clear));
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Colors", @selector(recolor));
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
	scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	scrollView.contentSize = CGSizeMake(SIDE * kNumberOfObjects, SIDE);
    [self.view addSubview:scrollView];
    
    PREPCONSTRAINTS(scrollView);
    ALIGN_VIEW_TOP(self.view, scrollView);
    ALIGN_VIEW_LEFT(self.view, scrollView);
    CONSTRAIN_HEIGHT(scrollView, IS_IPAD ? 200.0f : 100.0f);
    STRETCH_VIEW_H(self.view, scrollView);
    
	[self setColors];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (UIDeviceOrientationIsLandscape(toInterfaceOrientation));
}

// Remove all custom views from the layout area
- (void)clear
{
	for (UIView *view in self.view.subviews)
		if (view != scrollView) [view removeFromSuperview];
}

// Set the random contents of the scroll view
- (void)setColors
{
	float offset = 0.0f;
	for (NSUInteger i = 0; i < kNumberOfObjects; i++)
	{
		UIImage *image = randomBlockImage(SIDE, IS_IPAD ? 30.0f : 15.0f);
		PullView *pullView = [[PullView alloc] initWithImage:image];
		pullView.frame = CGRectMake(offset, 0.0f, SIDE, SIDE);
		[scrollView addSubview:pullView];
		
		offset += SIDE;
	}
}

// Force an update of the scroll view elements
- (void)recolor
{
	for (UIView *view in scrollView.subviews)
    {
		if ([[view class] isKindOfClass:[PullView class]])
        {
			[view removeFromSuperview];
        }
	}
	[self setColors];
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
