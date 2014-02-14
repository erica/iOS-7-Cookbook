/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "RotatingSegue.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <RotatingSegueDelegate>
@end

@implementation TestBedViewController
{
    NSArray *childControllers;
    UIView *backsplash;
    UIPageControl *pageControl;
    int vcIndex;
    int nextIndex;
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    // Create backsplash for animation support
    backsplash = [[UIView alloc] init];
    [self.view addSubview:backsplash];
    PREPCONSTRAINTS(backsplash);
    ALIGN_VIEW_LEFT_CONSTANT(self.view, backsplash, 50);
    ALIGN_VIEW_RIGHT_CONSTANT(self.view, backsplash, -50);
    ALIGN_VIEW_TOP_CONSTANT(self.view, backsplash, 50);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, backsplash, -50);
    
    // Add a page view controller
    pageControl = [[UIPageControl alloc] init];
    pageControl.currentPage = 0;
    pageControl.numberOfPages = 4;
    pageControl.userInteractionEnabled = NO;
    [self.view addSubview:pageControl];
    PREPCONSTRAINTS(pageControl);
    ALIGN_VIEW_TOP_CONSTANT(self.view, pageControl, 10);
    CENTER_VIEW_H(self.view, pageControl);
    
    // Load child array from storyboard
    UIStoryboard *aStoryboard = [UIStoryboard storyboardWithName:@"child" bundle:[NSBundle mainBundle]];
    childControllers = [NSArray arrayWithObjects:
                        [aStoryboard instantiateViewControllerWithIdentifier:@"0"],
                        [aStoryboard instantiateViewControllerWithIdentifier:@"1"],
                        [aStoryboard instantiateViewControllerWithIdentifier:@"2"],
                        [aStoryboard instantiateViewControllerWithIdentifier:@"3"],
                        nil];
    
    UISwipeGestureRecognizer *leftSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(progress:)];
    leftSwiper.direction = UISwipeGestureRecognizerDirectionLeft;
    leftSwiper.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:leftSwiper];
    
    UISwipeGestureRecognizer *rightSwiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(regress:)];
    rightSwiper.direction = UISwipeGestureRecognizerDirectionRight;
    rightSwiper.numberOfTouchesRequired = 1;
    [self.view addGestureRecognizer:rightSwiper];
    
    // Set each child's tag
    for (UIViewController *controller in childControllers)
    {
        controller.view.tag = 1066;
    }
    
    // Initialize scene with first child controller
    vcIndex = 0;
    UIViewController *controller = (UIViewController *)[childControllers objectAtIndex:0];
    
    // Add child view controller
    [self addChildViewController:controller];
    [backsplash addSubview:controller.view];
    PREPCONSTRAINTS(controller.view);
    ALIGN_VIEW_LEFT(backsplash, controller.view);
    ALIGN_VIEW_RIGHT(backsplash, controller.view);
    ALIGN_VIEW_TOP(backsplash, controller.view);
    ALIGN_VIEW_BOTTOM(backsplash, controller.view);
    [controller didMoveToParentViewController:self];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

// Informal delegate method
- (void)segueDidComplete
{
    UIViewController *source = [childControllers objectAtIndex:vcIndex];
    UIViewController *destination = [childControllers objectAtIndex:nextIndex];
    
    [destination didMoveToParentViewController:self];
    [source removeFromParentViewController];
    
    PREPCONSTRAINTS(destination.view);
    ALIGN_VIEW_LEFT(backsplash, destination.view);
    ALIGN_VIEW_RIGHT(backsplash, destination.view);
    ALIGN_VIEW_TOP(backsplash, destination.view);
    ALIGN_VIEW_BOTTOM(backsplash, destination.view);
    
    vcIndex = nextIndex;
    pageControl.currentPage = vcIndex;
}

// Transition to new view using custom segue
- (void)switchToView:(int)newIndex goingForward:(BOOL)goesForward
{
    if (vcIndex == newIndex) return;
    nextIndex = newIndex;
    
    // Segue to the new controller
    UIViewController *source = [childControllers objectAtIndex:vcIndex];
    UIViewController *destination = [childControllers objectAtIndex:newIndex];
    
    destination.view.bounds = source.view.bounds;
    [source.view removeConstraints:source.view.constraints];
    [source willMoveToParentViewController:nil];
    [self addChildViewController:destination];
    
    RotatingSegue *segue = [[RotatingSegue alloc] initWithIdentifier:@"segue" source:source destination:destination];
    segue.goesForward = goesForward;
    segue.delegate = self;
    [segue perform];
}

// Go forward
- (void)progress:(id)sender
{
    int newIndex = ((vcIndex + 1) % childControllers.count);
    [self switchToView:newIndex goingForward:YES];
}

// Go backwards
- (void)regress:(id) sender
{
    int newIndex = vcIndex - 1;
    if (newIndex < 0) newIndex = childControllers.count - 1;
    [self switchToView:newIndex goingForward:NO];
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
