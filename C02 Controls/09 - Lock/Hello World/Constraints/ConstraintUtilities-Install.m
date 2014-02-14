/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "ConstraintUtilities-Install.h"

#pragma mark - Views

#pragma mark - Hierarchy
@implementation VIEW_CLASS (HierarchySupport)

// Return an array of all superviews
- (NSArray *) superviews
{
    NSMutableArray *array = [NSMutableArray array];
    VIEW_CLASS *view = self.superview;
    while (view)
    {
        [array addObject:view];
        view = view.superview;
    }
    
    return array;
}

// Return an array of all subviews
- (NSArray *) allSubviews
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (VIEW_CLASS *view in self.subviews)
    {
        [array addObject:view];
        [array addObjectsFromArray:[view allSubviews]];
    }
    
    return array;
}

// Test if the current view has a superview relationship to a view
- (BOOL) isAncestorOf: (VIEW_CLASS *) aView
{
    return [aView.superviews containsObject:self];
}

// Return the nearest common ancestor between self and another view
- (VIEW_CLASS *) nearestCommonAncestor: (VIEW_CLASS *) aView
{
    // Check for same view
    if ([self isEqual:aView])
        return self;
    
    // Check for direct superview relationship
    if ([self isAncestorOf:aView])
        return self;
    if ([aView isAncestorOf:self])
        return aView;
    
    // Search for indirect common ancestor
    NSArray *ancestors = self.superviews;
    for (VIEW_CLASS *view in aView.superviews)
        if ([ancestors containsObject:view])
            return view;
    
    // No common ancestor
    return nil;
}
@end

#pragma mark - Constraint-Ready Views
@implementation VIEW_CLASS (ConstraintReadyViews)
+ (instancetype) view
{
    VIEW_CLASS *newView = [[VIEW_CLASS alloc] initWithFrame:CGRectZero];
    newView.translatesAutoresizingMaskIntoConstraints = NO;
    return newView;
}
@end

#pragma mark - NSLayoutConstraint

#pragma mark - View Hierarchy
@implementation NSLayoutConstraint (ViewHierarchy)
// Cast the first item to a view
- (VIEW_CLASS *) firstView
{
    return self.firstItem;
}

// Cast the second item to a view
- (VIEW_CLASS *) secondView
{
    return self.secondItem;
}

// Are two items involved or not
- (BOOL) isUnary
{
    return self.secondItem == nil;
}

// Return NCA
- (VIEW_CLASS *) likelyOwner
{
    if (self.isUnary)
        return self.firstView;
    
    return [self.firstView nearestCommonAncestor:self.secondView];
}
@end

#pragma mark - Self Install
@implementation NSLayoutConstraint (SelfInstall)
- (BOOL) install
{
    // Handle Unary constraint
    if (self.isUnary)
    {
        // Add weak owner reference
        [self.firstView addConstraint:self];
        return YES;
    }
    
    // Install onto nearest common ancestor
    VIEW_CLASS *view = [self.firstView nearestCommonAncestor:self.secondView];
    if (!view)
    {
        NSLog(@"Error: Constraint cannot be installed. No common ancestor between items.");
        return NO;
    }
    
    [view addConstraint:self];    
    return YES;
}

// Set priority and install
- (BOOL) install: (float) priority
{
    self.priority = priority;
    return [self install];
}

- (void) remove
{
    if (![self.class isEqual:[NSLayoutConstraint class]])
    {
        NSLog(@"Error: Can only uninstall NSLayoutConstraint. %@ is an invalid class.", self.class.description);
        return;
    }
    
    if (self.isUnary)
    {
        VIEW_CLASS *view = self.firstView;
        [view removeConstraint:self];
        return;
    }
    
    // Remove from preferred recipient
    VIEW_CLASS *view = [self.firstView nearestCommonAncestor:self.secondView];
    if (!view) return;
    
    // If the constraint not on view, this is a no-op
    [view removeConstraint:self];
}
@end