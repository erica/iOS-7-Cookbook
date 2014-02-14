/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;

@interface UIView (NameExtensions)
- (UIView *) viewNamed: (NSString *) aName;
@property (nonatomic, strong) NSString *nametag;
@end