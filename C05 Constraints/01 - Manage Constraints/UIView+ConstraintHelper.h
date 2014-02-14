/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

@interface UIView (ConstraintHelper)

// Constraint Management
- (BOOL) constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2;
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraints:(NSArray *)anArray;
@end
