/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "UIView+ConstraintHelper.h"

@implementation UIView (ConstraintHelper)

#pragma mark - Constraint Management

// This ignores any priority, looking only at y (R) mx + b
- (BOOL) constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2
{
    if (constraint1.firstItem != constraint2.firstItem) return NO;
    if (constraint1.secondItem != constraint2.secondItem) return NO;
    if (constraint1.firstAttribute != constraint2.firstAttribute) return NO;
    if (constraint1.secondAttribute != constraint2.secondAttribute) return NO;
    if (constraint1.relation != constraint2.relation) return NO;
    if (constraint1.multiplier != constraint2.multiplier) return NO;
    if (constraint1.constant != constraint2.constant) return NO;
    
    return YES;
}

// Find first matching constraint. (Priority, Archiving ignored)
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint
{
    for (NSLayoutConstraint *constraint in self.constraints)
    {
        if ([self constraint:constraint matches:aConstraint])
            return constraint;
    }
    
    for (NSLayoutConstraint *constraint in self.superview.constraints)
    {
        if ([self constraint:constraint matches:aConstraint])
            return constraint;
    }
    
    return nil;
}

// Remove constraint
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint
{
    NSLayoutConstraint *match = [self constraintMatchingConstraint:aConstraint];
    if (match)
    {
        [self removeConstraint:match];
        [self.superview removeConstraint:match];
    }
}

- (void)removeMatchingConstraints:(NSArray *)anArray
{
    for (NSLayoutConstraint *constraint in anArray)
        [self removeMatchingConstraint:constraint];
}

@end
