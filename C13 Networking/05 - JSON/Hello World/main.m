/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#define WXFORECAST @"http://api.openweathermap.org/data/2.5/forecast/daily?q=%@&units=Imperial&cnt=7&mode=json"
#define LOCATION @"Fairbanks"

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    NSArray *items;
    NSDateFormatter * dateFormatter;
}

#pragma mark - UITableViewDatasource

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
    // Top level dictionary for the forecast data
    NSDictionary * top = [items objectAtIndex:indexPath.row];
    
    // The date of the this forecast under top
    NSString * unixtime = top[@"dt"];
    
    // The weather dictionary that includes the sky description (actually an array of weather dictionaries, we always take the first)
    NSDictionary * weather = top[@"weather"][0];
    
    // The sky description string under weather
    NSString * wxDescription = weather[@"description"];

    // Convert the unixtime somethine we can use
    NSDate * wxDate = [NSDate dateWithTimeIntervalSince1970:[unixtime doubleValue]];
    
	UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = wxDescription;
    cell.detailTextLabel.text = [dateFormatter stringFromDate:wxDate];
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
        
        // Parse the JSON from the data object
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        // Store off the top level array of forecasts
        items = json[@"list"];
        
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
