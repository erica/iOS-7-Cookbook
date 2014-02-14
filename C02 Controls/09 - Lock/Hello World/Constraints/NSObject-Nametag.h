/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

// A nametag is an associated string object that can be assigned to any object.
// Similar in intent and nature to UIView's "tag" property, it allows you to
// assing readable text to objects for annotation and searching.

#pragma mark - Support nametags universally
@interface NSObject (Nametags)
@property (nonatomic, strong) NSString *nametag;
@end

