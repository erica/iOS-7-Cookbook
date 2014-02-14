/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#define IMAGE_SIZE  100.0f

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController
@end

@implementation TestBedViewController
{
    NSMutableArray *items;
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
    cell.imageView.image = items[indexPath.row];
	return cell;
}

#pragma mark Edits
- (void) setBarButtonItems
{
    // Expire any ongoing operations
    if (self.undoManager.isUndoing || self.undoManager.isRedoing)
    {
        [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
        return;
    }
    
    UIBarButtonItem *undo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, self.undoManager, @selector(undo));
    undo.enabled = self.undoManager.canUndo;
    UIBarButtonItem *redo = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, self.undoManager, @selector(redo));
    redo.enabled = self.undoManager.canRedo;
    UIBarButtonItem *add = SYSBARBUTTON(UIBarButtonSystemItemAdd, @selector(addItem:));
    
    self.navigationItem.leftBarButtonItems = @[add, undo, redo];
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

- (void) updateItemAtIndexPath: (NSIndexPath *) indexPath withObject: (id) object
{
    // Prepare for undo
    id undoObject = object ? nil : [items objectAtIndex:indexPath.row];
	[[self.undoManager prepareWithInvocationTarget:self] updateItemAtIndexPath:indexPath withObject:undoObject];
    
	// You cannot insert a nil item. Passing nil is a delete request.
    [self.tableView beginUpdates];
    if (!object)
    {
        [items removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    else
    {
        [items insertObject:object atIndex:indexPath.row];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [self.tableView endUpdates];
    
    [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
}

- (void) addItem: (id) sender
{
	// add a new item
	NSIndexPath *newPath = [NSIndexPath indexPathForRow:items.count inSection:0];
    UIImage *image = blockImage(IMAGE_SIZE);
	[self updateItemAtIndexPath:newPath withObject:image];
}

- (void)tableView:(UITableView *)aTableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// delete item
	[self updateItemAtIndexPath:indexPath withObject:nil];
}

-(void) tableView: (UITableView *) tableView moveRowAtIndexPath: (NSIndexPath *) oldPath toIndexPath:(NSIndexPath *) newPath
{
	if (oldPath.row == newPath.row) return;
	
	[[self.undoManager prepareWithInvocationTarget:self] tableView:self.tableView moveRowAtIndexPath:newPath toIndexPath:
     oldPath];
    
	id item = [items objectAtIndex:oldPath.row];
	[items removeObjectAtIndex:oldPath.row];
	[items insertObject:item atIndex:newPath.row];
    
    if (self.undoManager.isUndoing || self.undoManager.isRedoing)
    {
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:@[oldPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.tableView endUpdates];
    }
    
    [self performSelector:@selector(setBarButtonItems) withObject:nil afterDelay:0.1f];
}

#pragma mark Selection
- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // No op
    // UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark First Responder for Undo Support
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self resignFirstResponder];
}

#pragma mark View Setup

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Re-adjust the cell insets so the images appear centered
    [self.tableView reloadData];
}

// Set up table
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    self.tableView.rowHeight = IMAGE_SIZE + 20.0f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    items = [NSMutableArray array];
    
    // Provide Undo Support
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self setBarButtonItems];
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
