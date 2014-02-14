/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CoreDataHelper.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation CoreDataHelper

#pragma mark - Fetch
- (void)fetchItemsMatching:(NSString *)searchString forAttribute:(NSString *)attribute sortingBy:(NSString *)sortAttribute
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:_entityName inManagedObjectContext:_context];
    
    // Init a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.entity = entity;
    [fetchRequest setFetchBatchSize:0];
    
    // Apply an ascending sort for the items
    NSString *sortKey = sortAttribute ? : _defaultSortAttribute;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:YES selector:nil];
    NSArray *descriptors = @[sortDescriptor];
    fetchRequest.sortDescriptors = descriptors;
    
    // Setup predicate
    if (searchString && searchString.length && attribute && attribute.length)
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K contains[cd] %@", attribute, searchString];

    // Init the fetched results controller
    NSError __autoreleasing *error;
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_context sectionNameKeyPath:@"section" cacheName:nil];
    
    // Perform the fetch
    if (![_fetchedResultsController performFetch:&error])
        NSLog(@"Error fetching data: %@", error.localizedFailureReason);
}

- (void)fetchData
{
    [self fetchItemsMatching:nil forAttribute:nil sortingBy:nil];
}

#pragma mark - Info
- (NSInteger)numberOfSections
{
    return _fetchedResultsController.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = _fetchedResultsController.sections[section];
    return sectionInfo.numberOfObjects;
}

- (NSInteger)numberOfEntities
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:_entityName inManagedObjectContext:_context]];
    [request setIncludesSubentities:YES];
    
    NSError __autoreleasing *error;
    NSUInteger count = [_context countForFetchRequest:request error:&error];
    if(count == NSNotFound)
    {
        NSLog(@"Error: Could not count entities %@", error.localizedFailureReason);
        return 0;
    }
    
    return count;
}

# pragma mark - Management
// Save
- (BOOL)save
{
    NSError __autoreleasing *error;
    BOOL success;
    if (!(success = [_context save:&error]))
        NSLog(@"Error saving context: %@", error.localizedFailureReason);
    return success;
}

// Delete all objects
- (BOOL)clearData
{
    [self fetchData];
    if (!_fetchedResultsController.fetchedObjects.count) return YES;
    for (NSManagedObject *entry in _fetchedResultsController.fetchedObjects)
        [_context deleteObject:entry];
    return [self save];
}

// Delete one object
- (BOOL)deleteObject:(NSManagedObject *)object
{
    [self fetchData];
    if (!_fetchedResultsController.fetchedObjects.count) return NO;
    [_context deleteObject:object];
    return [self save];
}

// Create new object
- (NSManagedObject *)newObject
{
    NSManagedObject *object = [NSEntityDescription insertNewObjectForEntityForName:_entityName inManagedObjectContext:_context];
    return object;
}

#pragma mark - Init
- (BOOL)hasStore
{
    if (!_entityName)
    {
        NSLog(@"Error: entity name not set");
        return NO;
    }
    
    NSString *path = [NSString stringWithFormat:@"%@/%@.sqlite", DOCUMENTS_FOLDER, _entityName];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

- (void)setupCoreData
{
    NSError __autoreleasing *error;
    
    if (!_entityName || !_defaultSortAttribute)
    {
        NSLog(@"Error: set entity name, sort, and section names before init");
        return;
    }

    // Init the model
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    // Create the store coordinator
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];

    // Connect to store
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.sqlite", DOCUMENTS_FOLDER, _entityName]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error])
    {
        NSLog(@"Error creating persistent store coordinator: %@", error.localizedFailureReason);
        return;
    }

    // Create establish the context
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = persistentStoreCoordinator;

    [self fetchData];
}
@end
