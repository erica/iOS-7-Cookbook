/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;

@interface CrayonHandler : NSObject
@property (nonatomic, readonly) NSInteger numberOfSections;

- (NSString *)colorNameAtIndexPath:(NSIndexPath *)path;
- (UIColor *)colorAtIndexPath:(NSIndexPath *)path;
- (NSInteger)countInSection:(NSInteger)section;
- (NSString *)nameForSection:(NSInteger)section;
@end
