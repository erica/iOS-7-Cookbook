/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;

@interface CrayonHandler : NSObject
@property (nonatomic, readonly) NSInteger numberOfSections;
@property (nonatomic, readonly) NSArray *filteredArray;

- (NSString *)colorNameAtIndexPath:(NSIndexPath *)path;
- (UIColor *)colorAtIndexPath:(NSIndexPath *)path;
- (UIColor *)colorNamed:(NSString *)aColor;
- (NSInteger)countInSection:(NSInteger)section;
- (NSString *)nameForSection:(NSInteger)section;
- (NSInteger)filterWithString:(NSString *)filter;
@end
