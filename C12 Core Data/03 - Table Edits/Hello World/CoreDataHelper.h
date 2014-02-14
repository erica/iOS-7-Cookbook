/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;
@import CoreData;

/*
 
 Section name is always "section". Makes life easy.
 
 */

@interface CoreDataHelper : NSObject
@property (nonatomic) NSString *entityName;
@property (nonatomic) NSString *defaultSortAttribute;

@property (nonatomic) NSManagedObjectContext *context;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, readonly) BOOL hasStore;
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) NSInteger numberOfEntities;

- (void)setupCoreData;

- (void)fetchData;
- (void)fetchItemsMatching:(NSString *)searchString forAttribute:(NSString *)attribute sortingBy:(NSString *)sortAttribute;

- (BOOL)save;
- (NSManagedObject *)newObject;
- (BOOL)clearData;
- (BOOL)deleteObject:(NSManagedObject *)object;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;
@end
