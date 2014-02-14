/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "AnimationHelper.h"


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
    
    // Define the three stages of the animation in forward order
    AnimationBlock makeSmall = ^(void){
        bounceView.transform = CGAffineTransformMakeScale(0.01f, 0.01f);};
    AnimationBlock makeLarge = ^(void){
        bounceView.transform = CGAffineTransformMakeScale(1.15f, 1.15f);};
    AnimationBlock restoreToOriginal = ^(void) {
        bounceView.transform = CGAffineTransformIdentity;};
    
    // Create the three completion links in reverse order
    CompletionBlock reenable = ^(BOOL finished) {
        [self enable:YES];};
    CompletionBlock shrinkBack = ^(BOOL finished) {
        [UIView animateWithDuration:0.3f animations:restoreToOriginal completion: reenable];};
    CompletionBlock bounceLarge = ^(BOOL finished){
        [NSThread sleepForTimeInterval:0.5f];
        [UIView animateWithDuration:0.3 animations:makeLarge completion:shrinkBack];};
    
    // Start the animation
    [UIView animateWithDuration:0.1f animations:makeSmall completion:bounceLarge];
}

// Additional example - utilizing AnimationHelper
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
    
    // Go
    CompletionBlock allDone = ^(BOOL done){[self enable:YES];};
    CompletionBlock done = ^(BOOL done){sleep(2); [AnimationHelper viewAnimation:bounceView viaTransform:transientTransform toTransform:shrinkTransform completion:allDone]();};
    AnimationBlock block = [AnimationHelper viewAnimation:bounceView viaTransform:transientTransform toTransform:CGAffineTransformIdentity completion:done];
    block();
}

// Additional example - utilizing AnimationHelper
- (void)actionMove
{
    CGFloat midX = CGRectGetMidX(self.view.bounds);
    CGFloat midY = CGRectGetMidY(self.view.bounds);
    CGPoint centerPoint = CGPointMake(midX, midY);
    CGPoint beyondPoint = CGPointMake(midX * 1.2f, midY);
    
    // Init
    [self enable:NO];
    bounceView.center = CGPointMake(-midX, midY);
    bounceView.transform = CGAffineTransformIdentity;
    
    // Go
    CompletionBlock allDone = ^(BOOL done){[self enable:YES];};
    CompletionBlock done = ^(BOOL done){sleep(2); [AnimationHelper viewAnimation:bounceView viaCenter:CGPointMake(midX * 1.2f, midY) toCenter:CGPointMake(-midX, midY) completion:allDone]();};
    AnimationBlock block = [AnimationHelper viewAnimation:bounceView viaCenter:beyondPoint toCenter:centerPoint completion:done];
    block();
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
