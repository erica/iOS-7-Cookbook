/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "DocWatchHelper.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    NSArray *items;
    DocWatchHelper *helper;
}

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return items.count;
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

- (void)scanDocuments
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    [self.tableView reloadData];
}

// Set up table
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self scanDocuments];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kDocumentChanged object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         // Contents changed
         [self scanDocuments];
     }];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    helper = [DocWatchHelper watcherForPath:path];
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
