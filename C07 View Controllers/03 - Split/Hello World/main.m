/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - DetailViewController
@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate>
@property (nonatomic, strong) UIPopoverController *myPopoverController;
@end

@implementation DetailViewController
+ (instancetype)controller
{
	DetailViewController *controller = [[DetailViewController alloc] init];
	controller.view.backgroundColor = [UIColor blackColor];
	return controller;
}

// Called upon going into portrait mode, hiding the normal table view
- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)aPopoverController
{
    barButtonItem.title = aViewController.title;
	self.navigationItem.leftBarButtonItem = barButtonItem;
    self.myPopoverController = aPopoverController;
}

// Called upon going into landscape mode.
- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
	self.navigationItem.leftBarButtonItem = nil;
    self.myPopoverController = nil;
}

// Use this to avoid the pop-over hiding in portrait. When omitted, you get the default behavior.
/* - (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
 {
 return NO;
 }*/
@end

#pragma mark - ColorTableViewController
@interface ColorTableViewController : UITableViewController
@end

@implementation ColorTableViewController

+ (instancetype)controller
{
    ColorTableViewController *controller = [[ColorTableViewController alloc] init];
    controller.title = @"Colors";
    return controller;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSArray *)selectors
{
    return @[@"blackColor", @"redColor", @"greenColor", @"blueColor", @"cyanColor", @"yellowColor", @"magentaColor", @"orangeColor", @"purpleColor", @"brownColor"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self selectors].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic"];
	if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"generic"];
    
    NSString *item = [self selectors][indexPath.row];
	cell.textLabel.text = item;
	cell.textLabel.textColor = [UIColor performSelector:NSSelectorFromString(item) withObject:nil];
	
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINavigationController *nav = [self.splitViewController.viewControllers lastObject];
	UIViewController *controller = [nav topViewController];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	controller.view.backgroundColor = cell.textLabel.textColor;
}
@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (UISplitViewController *)splitviewController
{
	// Create the navigation-run root view
	ColorTableViewController *rootVC = [ColorTableViewController controller];
	UINavigationController *rootNav = [[UINavigationController alloc] initWithRootViewController:rootVC];
	
	// Create the navigation-run detail view
	DetailViewController *detailVC = [DetailViewController controller];
	UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
	
	// Add both to the split view controller
	UISplitViewController *svc = [[UISplitViewController alloc] init];
	svc.viewControllers = @[rootNav, detailNav];
	svc.delegate = detailVC;
	
	return svc;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    UISplitViewController *svc = [self splitviewController];
    svc.edgesForExtendedLayout = UIRectEdgeNone;
    _window.rootViewController = svc;
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
