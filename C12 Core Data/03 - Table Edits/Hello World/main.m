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

@interface TestBedViewController : UITableViewController <UISearchBarDelegate, NSFetchedResultsControllerDelegate>
@end

@implementation TestBedViewController
{
    CoreDataHelper *dataHelper;
    UISearchDisplayController *searchController;
    NSArray *lineArray;
    int index;
    BOOL sectionHeadersAffected;
}

#pragma mark Data Source

// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (dataHelper.numberOfEntities == 0) return 0;
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

// Allow scrolling to search bar
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	// Query the titles for the section associated with an index title
	if (title == UITableViewIndexSearch)
	{
		[self.tableView scrollRectToVisible:searchController.searchBar.frame animated:NO];
		return -1;
	}
	return [dataHelper.fetchedResultsController.sectionIndexTitles indexOfObject:title];
}

// Section index titles
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)aTableView
{
    if (aTableView == searchController.searchResultsTableView) return nil;
    return [[NSArray arrayWithObject:UITableViewIndexSearch] arrayByAddingObjectsFromArray:[dataHelper.fetchedResultsController sectionIndexTitles]];
}

// Return a table-specific cell and populate it with the data at the index path
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [aTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
	Person *person = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = person.fullname;
	return cell;
}

#pragma mark Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // no op
}

#pragma mark Editing and Undo
- (void)setBarButtonItems
{
    // Expire any ongoing operations
    if (dataHelper.context.undoManager.isUndoing || dataHelper.context.undoManager.isRedoing)
    {
        [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
        return;
    }
    
    UIBarButtonItem *undo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, dataHelper.context.undoManager, @selector(undo));
    undo.enabled = dataHelper.context.undoManager.canUndo;
    UIBarButtonItem *redo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, dataHelper.context.undoManager, @selector(redo));
    redo.enabled = dataHelper.context.undoManager.canRedo;
    UIBarButtonItem *add = SYSBARBUTTON(UIBarButtonSystemItemAdd, @selector(addItem));
    
    self.navigationItem.leftBarButtonItems = @[add, undo, redo];
}

- (void)refresh
{
    // If searching, fetch search results, otherwise all data
    if (searchController.searchBar.text)
        [dataHelper fetchItemsMatching:searchController.searchBar.text forAttribute:@"surname" sortingBy:nil];
    else
        [dataHelper fetchData];
    dataHelper.fetchedResultsController.delegate = self;
    
    // Reload tables
    [self.tableView reloadData];
    [searchController.searchResultsTableView reloadData];
    
    // Update bar button items
    [self setBarButtonItems];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (type == NSFetchedResultsChangeDelete)
        [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (type == NSFetchedResultsChangeInsert)
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    sectionHeadersAffected = YES;
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    if (type == NSFetchedResultsChangeInsert)
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    if (type == NSFetchedResultsChangeDelete)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    sectionHeadersAffected = NO;
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    
    if (sectionHeadersAffected)
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.tableView.numberOfSections)] withRowAnimation:UITableViewRowAnimationNone];
    
    [self setBarButtonItems];
}

#define GETINDEX(ATTRIBUTE) [attributes indexOfObject:ATTRIBUTE]
- (void)setupNewPerson: (Person *) person
{
    // Add a new item to the database
    NSArray *attributes = @[@"number", @"gender", @"givenname", @"middleinitial", @"surname", @"streetaddress", @"city", @"state", @"zipcode", @"country", @"emailaddress", @"password", @"telephonenumber", @"mothersmaiden", @"birthday", @"cctype", @"ccnumber", @"cvv2", @"ccexpires", @"nationalid", @"ups", @"occupation", @"domain", @"bloodtype", @"pounds", @"kilograms", @"feetinches", @"centimeters"];
    
    if (!lineArray)
    {
        NSString *dataString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FakePersons" ofType:@"csv"] encoding:NSUTF8StringEncoding error:nil];
        lineArray = [dataString componentsSeparatedByString:@"\n"];
    }
    NSString *line = lineArray[index++];
    NSArray *items = [line componentsSeparatedByString:@","];
    
    person.surname = items[GETINDEX(@"surname")];
    person.section = [[person.surname substringFromIndex:0] substringToIndex:1];
    person.emailaddress = items[GETINDEX(@"emailaddress")];
    person.gender = items[GETINDEX(@"gender")];
    person.middleinitial = items[GETINDEX(@"middleinitial")];
    person.occupation = items[GETINDEX(@"occupation")];
    person.givenname = items[GETINDEX(@"givenname")];
}

- (void)addItem
{
    // Surround the "add" functionality with undo grouping
    NSUndoManager *manager = dataHelper.context.undoManager;
    [manager beginUndoGrouping];
    {
        Person *person = (Person *)[dataHelper newObject];
        [self setupNewPerson:person];
    }
    [manager endUndoGrouping];
    [manager setActionName:@"Add"];
    [dataHelper save];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // delete request
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *object = [dataHelper.fetchedResultsController objectAtIndexPath:indexPath];
        NSUndoManager *manager = dataHelper.context.undoManager;
        [manager beginUndoGrouping];
        {
            [dataHelper.context deleteObject:object];
        }
        [manager endUndoGrouping];
        [manager setActionName:@"Delete"];
        [dataHelper save];
    }
}

- (BOOL)tableView:(UITableView *)aTableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Editing only on the main table
    if (aTableView == searchController.searchResultsTableView) return NO;
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;     // no reordering allowed
}

- (void) setEditing: (BOOL) isEditing animated: (BOOL) animated
{
    [super setEditing:isEditing animated:animated];
    [self.tableView setEditing:isEditing animated:animated];
    
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if (path)
        [self.tableView deselectRowAtIndexPath:path animated:YES];
    
    [self setBarButtonItems];
}

#pragma mark Search Bar
- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
	aSearchBar.text = @"";
	[dataHelper fetchData];
}

- (void)searchBar:(UISearchBar *)aSearchBar textDidChange:(NSString *)searchText
{
	[dataHelper fetchItemsMatching:aSearchBar.text forAttribute:@"surname" sortingBy:nil];
}

#pragma mark Setup

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.tableView = [[UITableView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Create a search bar
	UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 44.0f)];
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
	searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
	searchBar.keyboardType = UIKeyboardTypeAlphabet;
	searchBar.delegate = self;
	self.tableView.tableHeaderView = searchBar;
	
	// Create the search display controller
	searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
	searchController.searchResultsDataSource = self;
	searchController.searchResultsDelegate = self;
    
    // Establish Core Data
    dataHelper = [[CoreDataHelper alloc] init];
    dataHelper.entityName = @"Person";
    dataHelper.defaultSortAttribute = @"surname";
    
    // Prepare for data entry
    srand(time(0));
    index = rand() % 1000;
    
    // Setup
    [dataHelper setupCoreData];
    // [dataHelper clearData]; // You may want to clear the data on run
    [self refresh];
}

#pragma mark First Responder

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    
    if (dataHelper.numberOfEntities == 0) return;
    
    // Hide the search bar
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
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
