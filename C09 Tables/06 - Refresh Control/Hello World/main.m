/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "DataManager.h"
#import "DetailViewController.h"

#define VALID(ITEM) (![ITEM isKindOfClass:[NSNull class]])

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController <DataManagerDelegate>
@end

@implementation TestBedViewController
{
    DataManager *manager;
}


// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (manager.entries) return manager.entries.count;
    return 0;
}

// On user tap, present detail
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [manager.entries objectAtIndex:indexPath.row];
    if (VALID(dict[@"price"]) && VALID(dict[@"large image"]) && VALID(dict[@"address"]))
    {
        DetailViewController *detail = [[DetailViewController alloc] initWithDictionary:dict];
        [self.navigationController pushViewController:detail animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic" forIndexPath:indexPath];
    cell = [cell initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"generic"];
    
    if (indexPath.row >= (NSInteger)manager.entries.count)
    {
        NSLog(@"Unexpected error. Trying to address %d of %d items", indexPath.row, manager.entries.count);
        return nil;
    }
    
    NSDictionary *dict = [manager.entries objectAtIndex:indexPath.row];
    
    cell.textLabel.text = dict[@"name"];
    cell.detailTextLabel.text = dict[@"artist"];
    cell.imageView.image = dict[@"image"];
    
    NSString *address = dict[@"address"];
    if (![address isKindOfClass:[NSNull class]])
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
	return cell;
}

- (void)dataIsReady:(id)sender
{
    self.title = @"iTunes Top Albums";
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
}

- (void)loadData
{
    self.title = @"Loading...";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self.refreshControl beginRefreshing];
    
    [manager loadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 72.0f;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"generic"];
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Load", @selector(loadData));
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    
    manager = [[DataManager alloc] init];
    manager.delegate = self;
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
