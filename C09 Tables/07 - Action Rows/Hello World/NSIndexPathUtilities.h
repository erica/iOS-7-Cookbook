/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;

#define INDEXPATH(SECTION, ROW) [NSIndexPath indexPathForRow:ROW inSection:SECTION]

@interface NSIndexPath (adjustments)

// Is this index path before the other
- (BOOL)before:(NSIndexPath *)path;

@property (nonatomic, readonly) NSIndexPath *next;
@property (nonatomic, readonly) NSIndexPath *previous;
@end
