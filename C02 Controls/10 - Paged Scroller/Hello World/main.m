/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "PagedImageScrollView.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UIPageViewControllerDelegate, UIScrollViewDelegate>
@end

@implementation TestBedViewController
{
    PagedImageScrollView * scrollView;
    UIPageControl * pageControl;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    scrollView = [[PagedImageScrollView alloc] init];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    PREPCONSTRAINTS(scrollView);
    ALIGN_VIEW_LEFT(self.view, scrollView);
    ALIGN_VIEW_RIGHT(self.view, scrollView);
    ALIGN_VIEW_TOP(self.view, scrollView);
    ALIGN_VIEW_BOTTOM(self.view, scrollView);
    scrollView.images = @[[UIImage imageNamed:@"bird"], [UIImage imageNamed:@"ladybug"], [UIImage imageNamed:@"flowers"], [UIImage imageNamed:@"sheep"]];

    pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = scrollView.images.count;
    pageControl.currentPage = 0;
    pageControl.pageIndicatorTintColor = [UIColor grayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [pageControl addTarget:self action:@selector(handlePageControlChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    PREPCONSTRAINTS(pageControl);
    ALIGN_VIEW_LEFT(self.view, pageControl);
    ALIGN_VIEW_RIGHT(self.view, pageControl);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, pageControl, -20);
}

// Update the scrollView after page control interaction
- (void)handlePageControlChange:(UIPageControl *)sender
{
    CGFloat offset = scrollView.frame.size.width * pageControl.currentPage;
    [scrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

// Update the page control after scrolling
- (void)scrollViewDidEndDecelerating:(id)sender
{
    CGFloat distance = scrollView.contentOffset.x / scrollView.contentSize.width;
    NSInteger page =  distance * pageControl.numberOfPages;
    pageControl.currentPage = page;
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
