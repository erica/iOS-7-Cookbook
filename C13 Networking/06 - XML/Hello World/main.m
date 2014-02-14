/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "XMLParser.h"
#import "TreeNode.h"
#import "Utility.h"

#define WXFORECAST @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&units=Imperial&cnt=7&mode=xml"
#define LOCATION @"Fairbanks"

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    TreeNode *root;
    TreeNode *forecastsRoot;
    NSDateFormatter *dateFormatter;
}

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView
{
	return 1;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section
{
    return forecastsRoot.children.count;
}

// Return a cell for the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TreeNode * forecastRoot = forecastsRoot.children[indexPath.row];
    NSString * day = [forecastRoot attributes][@"day"];
    TreeNode * cloudsNode = [forecastRoot nodeForKey:@"clouds"];
    NSString * wxDescription = [cloudsNode attributes][@"value"];
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = wxDescription;
    cell.detailTextLabel.text = day;
    return cell;
}

#pragma mark - Web Service Download

- (void)loadWebService
{
    self.title = LOCATION;
    
    // Start the refresh control
    [self.refreshControl beginRefreshing];
    
    // Create the URL string based on location
    NSString * urlString = [NSString stringWithFormat:WXFORECAST, LOCATION];
    
    // Setup the session
    NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    // Create a data task to transfer the web service endpoint contents
    NSURLSessionDataTask * dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        // Stop the refresh control
        [self.refreshControl endRefreshing];
        if (error)
        {
            self.title = error.localizedDescription;
            return;
        }
        
        // Create the XML parser
        XMLParser *parser = [[XMLParser alloc] init];
        
        // Parse the XML from the data object
        root = [parser parseXMLFromData:data];
        
        // Store off the top level parent of forecasts
        forecastsRoot = [root nodesForKey:@"forecast"][0];
        
        [self.tableView reloadData];
    }];
    
    // Start the download task
    [dataTask resume];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(loadWebService) forControlEvents:UIControlEventValueChanged];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    
    [self loadWebService];
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
