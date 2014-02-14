/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import QuickLook;
#import "QLItem.h"
#import "Utility.h"
#import "InboxHelper.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController <QLPreviewControllerDataSource>
- (void)scanDocs;
@end


#define DOCUMENTS_PATH  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation TestBedViewController
{
    NSArray *items;
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

- (void)scanDocs
{
    items = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:DOCUMENTS_PATH error:nil];
    [self.tableView reloadData];
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"generic" forIndexPath:indexPath];
    cell.textLabel.text = [items objectAtIndex:indexPath.row];
    return cell;
}

// Support swipe-to-delete
- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= (NSInteger) items.count)
    {
        // Catch Bug Here
        NSLog(@"System Inconsistency. Requested row %d", indexPath.row);
        return;
    }
    
    // Tried to avoid holding onto that cell -- didn't change the bug
    NSString *title = [[[self tableView:self.tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    NSString *path = [DOCUMENTS_PATH stringByAppendingPathComponent:title];
    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:path error:&error])
            NSLog(@"Error deleting item %@: %@", path, error.localizedFailureReason);
    }
    
    [self scanDocs];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    QuickItem *item = [[QuickItem alloc] init];
    
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    NSString *title = cell.textLabel.text;
    NSString *path = [DOCUMENTS_PATH stringByAppendingPathComponent:title];
    
    item.path = path;
    return item;
}

- (void)push
{
    QLPreviewController *controller = [[QLPreviewController alloc] init];
    controller.dataSource = self;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self push];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    if (indexPath)
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Set up table
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"generic"];
    [self scanDocs];
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
{
    TestBedViewController * tbvc;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [InboxHelper checkAndProcessInbox];
    [tbvc scanDocs];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    tbvc = [[TestBedViewController alloc] init];
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
