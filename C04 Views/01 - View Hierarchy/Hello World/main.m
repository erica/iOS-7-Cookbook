/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    NSArray *items;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Dump", @selector(dumpTree:));

    items = [@"A*B*C*D*E*F*G*H*I*J*K*L" componentsSeparatedByString:@"*"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    // Feel free to edit the Sample xib and storyboard files to get a sense of how they work
    UIView *sampleView = [[[NSBundle mainBundle] loadNibNamed:@"Sample" owner:self options:NULL] objectAtIndex:0];
    if (sampleView)
    {
        NSMutableString *outstring = [NSMutableString string];
        [self dumpView:sampleView atIndent:0 into:outstring];
        NSLog(@"Dumping sample view: %@", outstring);
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Sample" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [storyboard instantiateInitialViewController];
    if (vc.view)
    {
        NSMutableString *outstring = [NSMutableString string];
        [self dumpView:vc.view atIndent:0 into:outstring];
        NSLog(@"Dumping sample storyboard: %@", outstring);
    }
}


// Recursively travel down the view tree, increasing the
// indentation level for children
- (void)dumpView: (UIView *) aView atIndent: (int) indent into: (NSMutableString *) outstring
{
    // Add the indentation
    for (int i = 0; i < indent; i++)
        [outstring appendString:@"--"];
    
    // Add the class description
    [outstring appendFormat:@"[%2d] %@\n", indent,
     [[aView class] description]];
    
    // Recurse on subviews
    for (UIView *view in aView.subviews)
        [self dumpView:view atIndent:indent + 1 into:outstring];
}

// Start the tree recursion at level 0 with the root view
- (void) dumpTree: (id) sender
{
    NSMutableString *outstring = [NSMutableString string];
    [self dumpView:self.view atIndent:0 into:outstring];
    NSLog(@"%@", outstring);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	// This simple table has only one section
	return 1;
}

- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
	// Return the number of items
	return items.count;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"cell"];
	cell.textLabel.text = [items objectAtIndex:indexPath.row];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Respond to user interaction
    self.title = [items objectAtIndex:indexPath.row];
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
