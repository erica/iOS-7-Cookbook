/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "UIView-NameExtensions.h"
#import <objc/runtime.h>

static const char nametag_key; // Thanks Oliver Drobnik

@implementation UIView (NameExtensions)

#pragma mark Associations

- (id) nametag 
{
    return objc_getAssociatedObject(self, (void *) &nametag_key);
}

- (void)setNametag:(NSString *)theNametag
{
    objc_setAssociatedObject(self, (void *) &nametag_key, theNametag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)viewWithNametag:(NSString *)aName
{
    if (!aName) return nil;
    
    // Is this the right view?
    if ([self.nametag isEqualToString:aName])
        return self;
    
    // Recurse depth first on subviews
    for (UIView *subview in self.subviews) 
    {
        UIView *resultView = [subview viewNamed:aName];
        if (resultView) return resultView;
    }
    
    // Not found
    return nil;
}

- (UIView *)viewNamed:(NSString *)aName
{
    if (!aName) return nil;
    return [self viewWithNametag:aName];
}

@end