/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "CoreDataHelper.h"
#import "Person.h"
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    CoreDataHelper *dataHelper;
}

#pragma mark Data Source

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return dataHelper.fetchedResultsController.sections.count;
}

// Rows per section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = dataHelper.fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

// Return the title for a given section
- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *titles = [dataHelper.fetchedResultsController sectionIndexTitles];
    if ((NSInteger)titles.count <= section)
        return @"Error";
    return titles[section];
}

// Section index titles
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    return [dataHelper.fetchedResultsController sectionIndexTitles];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"generic" forIndexPath:indexPath];
    
    // Recover object from fetched results
	Person *person = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.fullname;
    
	return cell;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // When a row is selected, update the title accordingly
    Person *person = (Person *)[dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    self.title = person.fullname;
}

#pragma mark Setup
#define GETINDEX(ATTRIBUTE) [attributes indexOfObject:ATTRIBUTE]
- (void)initializeData
{
    NSArray *attributes = @[@"number", @"gender", @"givenname", @"middleinitial", @"surname", @"streetaddress", @"city", @"state", @"zipcode", @"country", @"emailaddress", @"password", @"telephonenumber", @"mothersmaiden", @"birthday", @"cctype", @"ccnumber", @"cvv2", @"ccexpires", @"nationalid", @"ups", @"occupation", @"domain", @"bloodtype", @"pounds", @"kilograms", @"feetinches", @"centimeters"];
    NSString *dataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakePersons" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lineArray = [dataString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *line in lineArray)
    {
        NSArray *items = [line componentsSeparatedByString:@","];
        if (items.count != attributes.count) continue;
        
        Person *person = (Person *)[dataHelper newObject];
        
        person.surname = items[GETINDEX(@"surname")];
        person.section = [[person.surname substringFromIndex:0] substringToIndex:1];
        
        person.emailaddress = items[GETINDEX(@"emailaddress")];
        person.gender = items[GETINDEX(@"gender")];
        person.middleinitial = items[GETINDEX(@"middleinitial")];
        person.occupation = items[GETINDEX(@"occupation")];
        person.givenname = items[GETINDEX(@"givenname")];
    }
    
    if ([dataHelper save])
        NSLog(@"Database created");
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"generic"];
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"Person";
    dataHelper.defaultSortAttribute = @"surname";
    
    // Check for existing data
    BOOL firstRun = !dataHelper.hasStore;
    
    // Setup core data
    [dataHelper setupCoreData];
    if (firstRun)
        [self initializeData];
    
    [dataHelper fetchData];
    [self.tableView reloadData];
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
