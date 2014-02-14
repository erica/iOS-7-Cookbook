/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "ConstraintUtilities-Matching.h"
#import "NSObject-Nametag.h"

#pragma mark - Named Constraint Support
@implementation VIEW_CLASS (NamedConstraintSupport)

// Returns first constraint with matching name
// Type not checked
- (NSLayoutConstraint *) constraintNamed: (NSString *) aName
{
    if (!aName) return nil;
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nametag && [constraint.nametag isEqualToString:aName])
            return constraint;

    // Recurse up the tree
    if (self.superview)
        return [self.superview constraintNamed:aName];

    return nil;
}

// Returns first constraint with matching name and view.
// Type not checked
- (NSLayoutConstraint *) constraintNamed: (NSString *) aName matchingView: (VIEW_CLASS *) view
{
    if (!aName) return nil;
    
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nametag && [constraint.nametag isEqualToString:aName])
        {
            if ([constraint.firstItem isEqual:view])
                return constraint;
            if ([constraint.secondItem isEqual:view])
                return constraint;
        }
    
    // Recurse up the tree
    if (self.superview)
        return [self.superview constraintNamed:aName matchingView:view];
    
    return nil;
}

// Returns all matching constraints
// Type not checked
- (NSArray *) constraintsNamed: (NSString *) aName
{
    // For this, all constraints match a nil item
    if (!aName) return self.constraints;
    
    // However, constraints have to have a name to match a non-nil name
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nametag && [constraint.nametag isEqualToString:aName])
            [array addObject:constraint];
    
    // recurse upwards
    if (self.superview)
        [array addObjectsFromArray:[self.superview constraintsNamed:aName]];
    
    return array;
}

// Returns all matching constraints specific to a given view
// Type not checked
- (NSArray *) constraintsNamed: (NSString *) aName matchingView: (VIEW_CLASS *) view
{
    // For this, all constraints match a nil item
    if (!aName) return self.constraints;
    
    // However, constraints have to have a name to match a non-nil name
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in self.constraints)
        if (constraint.nametag && [constraint.nametag isEqualToString:aName])
        {
            if ([constraint.firstItem isEqual:view])
                [array addObject:constraint];
            else if (constraint.secondItem && [constraint.secondItem isEqual:view])
                [array addObject:constraint];
        }
    
    // recurse upwards
    if (self.superview)
        [array addObjectsFromArray:[self.superview constraintsNamed:aName matchingView:view]];

    return array;
}
@end

#pragma mark - Constraint Matching
@implementation NSLayoutConstraint (ConstraintMatching)

// This ignores any priority, looking only at y (R) mx + b
- (BOOL) isEqualToLayoutConstraint: (NSLayoutConstraint *) constraint
{
    // I'm still wavering on these two checks
    if (![self.class isEqual:[NSLayoutConstraint class]]) return NO;
    if (![self.class isEqual:constraint.class]) return NO;
    
    // Compare properties
    if (self.firstItem != constraint.firstItem) return NO;
    if (self.secondItem != constraint.secondItem) return NO;
    if (self.firstAttribute != constraint.firstAttribute) return NO;
    if (self.secondAttribute != constraint.secondAttribute) return NO;
    if (self.relation != constraint.relation) return NO;
    if (self.multiplier != constraint.multiplier) return NO;
    if (self.constant != constraint.constant) return NO;
    
    return YES;
}

// This looks at priority too
- (BOOL) isEqualToLayoutConstraintConsideringPriority:(NSLayoutConstraint *)constraint
{
    if (![self isEqualToLayoutConstraint:constraint])
        return NO;
    
    return (self.priority == constraint.priority);
}

- (BOOL) refersToView: (VIEW_CLASS *) view
{
    if (!view)
        return NO;
    if (!self.firstItem) // shouldn't happen. Illegal
        return NO;
    if ([self.firstItem isEqual:view])
        return YES;
    if (!self.secondItem)
        return NO;
    return [self.secondItem isEqual:view];
}

- (BOOL) isHorizontal
{
    return IS_HORIZONTAL_ATTRIBUTE(self.firstAttribute);
}
@end

#pragma mark - Managing Matching Constraints
@implementation VIEW_CLASS (ConstraintMatching)

// Find first matching constraint. (Priority, Archiving ignored)
- (NSLayoutConstraint *) constraintMatchingConstraint: (NSLayoutConstraint *) aConstraint
{
    NSArray *views = [@[self] arrayByAddingObjectsFromArray:self.superviews];
    for (VIEW_CLASS *view in views)
        for (NSLayoutConstraint *constraint in view.constraints)
            if ([constraint isEqualToLayoutConstraint:aConstraint])
                return constraint;

    return nil;
}


// Return all constraints from self and subviews
// Call on self.window for the entire collection
- (NSArray *) allConstraints
{
    NSMutableArray *array = [NSMutableArray array];
    [array addObjectsFromArray:self.constraints];
    for (VIEW_CLASS *view in self.subviews)
        [array addObjectsFromArray:[view allConstraints]];
    return array;
}

// Ancestor constraints pointing to self
- (NSArray *) referencingConstraintsInSuperviews
{
    NSMutableArray *array = [NSMutableArray array];
    for (VIEW_CLASS *view in self.superviews)
    {
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if (![constraint.class isEqual:[NSLayoutConstraint class]])
                continue;
            
            if ([constraint refersToView:self])
                [array addObject:constraint];
        }
    }
    return array;
}

// Ancestor *and* self constraints pointing to self
- (NSArray *) referencingConstraints
{
    NSMutableArray *array = [self.referencingConstraintsInSuperviews mutableCopy];
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if (![constraint.class isEqual:[NSLayoutConstraint class]])
            continue;
        
        if ([constraint refersToView:self])
            [array addObject:constraint];
    }
    return array;
}

// Find all matching constraints. (Priority, archiving ignored)
// Use with arrays returned by format strings to find installed versions
- (NSArray *) constraintsMatchingConstraints: (NSArray *) constraints
{
    NSMutableArray *array = [NSMutableArray array];
    for (NSLayoutConstraint *constraint in constraints)
    {
        NSLayoutConstraint *match = [self constraintMatchingConstraint:constraint];
        if (match)
            [array addObject:match];
    }
    return array;
}

// All constraints matching view in this ascent
// See also: referencingConstraints and referencingConstraintsInSuperviews
- (NSArray *) constraintsReferencingView: (VIEW_CLASS *) view
{
    NSMutableArray *array = [NSMutableArray array];
    NSArray *views = [@[self] arrayByAddingObjectsFromArray:self.superviews];

    for (VIEW_CLASS *view in views)
        for (NSLayoutConstraint *constraint in view.constraints)
        {
            if (![constraint.class isEqual:[NSLayoutConstraint class]])
                continue;
            
            if ([constraint refersToView:view])
                [array addObject:constraint];
        }
    
    return array;
}

// Remove constraint
- (void) removeMatchingConstraint: (NSLayoutConstraint *) aConstraint
{
    NSLayoutConstraint *match = [self constraintMatchingConstraint:aConstraint];
    if (match)
        [match remove];
}

// Remove constraints
// Use for removing constraings generated by format
- (void) removeMatchingConstraints: (NSArray *) anArray
{
    for (NSLayoutConstraint *constraint in anArray)
        [self removeMatchingConstraint:constraint];
}

// Remove constraints via name
- (void) removeConstraintsNamed: (NSString *) name
{
    NSArray *array = [self constraintsNamed:name];
    for (NSLayoutConstraint *constraint in array)
        [constraint remove];
}

// Remove named constraints matching view
- (void) removeConstraintsNamed: (NSString *) name matchingView: (VIEW_CLASS *) view
{
    NSArray *array = [self constraintsNamed:name matchingView:view];
    for (NSLayoutConstraint *constraint in array)
        [constraint remove];
}
@end

