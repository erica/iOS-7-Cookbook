/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

@interface UIView (ConstraintHelper)

// Constraint Management (Recipe 5-1)
- (BOOL)constraint:(NSLayoutConstraint *)constraint1 matches:(NSLayoutConstraint *)constraint2;
- (NSLayoutConstraint *)constraintMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraint:(NSLayoutConstraint *)aConstraint;
- (void)removeMatchingConstraints:(NSArray *)anArray;

// Superview bounds limits (Recipe 5-2)
- (NSArray *)constraintsLimitingViewToSuperviewBounds;
- (void)constrainWithinSuperviewBounds;
- (void)addSubviewAndConstrainToBounds:(UIView *)view;

// Size & Position (Recipe 5-2)
- (NSArray *)sizeConstraints:(CGSize)aSize;
- (NSArray *)positionConstraints: (CGPoint)aPoint;
- (void)constrainSize:(CGSize)aSize;
- (void)constrainPosition: (CGPoint)aPoint; // w/in superview bounds

// Centering (Recipe 5-3)
- (NSLayoutConstraint *)horizontalCenteringConstraint;
- (NSLayoutConstraint *)verticalCenteringConstraint;
- (void)centerHorizontallyInSuperview;
- (void)centerVerticallyInSuperview;
- (void)centerInSuperview;

// Aspect Ratios (Recipe 5-4)
- (NSLayoutConstraint *)aspectConstraint:(CGFloat)aspectRatio;
- (void)constrainAspectRatio:(CGFloat)aspectRatio;

@end
