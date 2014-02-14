/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <Foundation/Foundation.h>
#import "ConstraintUtilities-Install.h"
#import "NSObject-Nametag.h"

#pragma mark - Testing Constraint Elements

#define IS_SIZE_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeWidth), @(NSLayoutAttributeHeight)] containsObject:@(ATTRIBUTE)]
#define IS_CENTER_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeCenterX), @(NSLayoutAttributeCenterY)] containsObject:@(ATTRIBUTE)]
#define IS_EDGE_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeRight), @(NSLayoutAttributeTop), @(NSLayoutAttributeBottom), @(NSLayoutAttributeLeading), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeBaseline)] containsObject:@(ATTRIBUTE)]
#define IS_LOCATION_ATTRIBUTE(ATTRIBUTE) (IS_EDGE_ATTRIBUTE(ATTRIBUTE) || IS_CENTER_ATTRIBUTE(ATTRIBUTE))

#define IS_HORIZONTAL_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeLeft), @(NSLayoutAttributeRight), @(NSLayoutAttributeLeading), @(NSLayoutAttributeTrailing), @(NSLayoutAttributeCenterX), @(NSLayoutAttributeWidth)] containsObject:@(ATTRIBUTE)]
#define IS_VERTICAL_ATTRIBUTE(ATTRIBUTE) [@[@(NSLayoutAttributeTop), @(NSLayoutAttributeBottom), @(NSLayoutAttributeCenterY), @(NSLayoutAttributeHeight), @(NSLayoutAttributeBaseline)] containsObject:@(ATTRIBUTE)]

#define IS_HORIZONTAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllLeft), @(NSLayoutFormatAlignAllRight), @(NSLayoutFormatAlignAllLeading), @(NSLayoutFormatAlignAllTrailing), @(NSLayoutFormatAlignAllCenterX), ] containsObject:@(ALIGNMENT)]
#define IS_VERTICAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllTop), @(NSLayoutFormatAlignAllBottom), @(NSLayoutFormatAlignAllCenterY), @(NSLayoutFormatAlignAllBaseline), ] containsObject:@(ALIGNMENT)]

/*
 NAMED CONSTRAINTS
 Naming makes constraints more self-documenting, enabling you to retrieve 
 them by tag. These methods also add an option to find constraints that
 specifically match a certain view.
 */

#pragma mark - Named Constraint Support
@interface VIEW_CLASS (NamedConstraintSupport)

// Single
- (NSLayoutConstraint *) constraintNamed: (NSString *) aName;
- (NSLayoutConstraint *) constraintNamed: (NSString *) aName matchingView: (VIEW_CLASS *) view;

// Multiple
- (NSArray *) constraintsNamed: (NSString *) aName;
- (NSArray *) constraintsNamed: (NSString *) aName matchingView: (VIEW_CLASS *) view;
@end

/*
 MATCHING CONSTRAINTS
 Test if one constraint is essentially the same as another.
 This is particularly important when you generate new constraints 
 and want to remove their equivalents from another view.
 */

#pragma mark - Constraint Matching
@interface NSLayoutConstraint (ConstraintMatching)
- (BOOL) isEqualToLayoutConstraint: (NSLayoutConstraint *) constraint;
- (BOOL) isEqualToLayoutConstraintConsideringPriority: (NSLayoutConstraint *) constraint;
- (BOOL) refersToView: (VIEW_CLASS *) aView;
@property (nonatomic, readonly) BOOL isHorizontal;
@end

#pragma mark - Managing Matching Constraints
@interface VIEW_CLASS (ConstraintMatching)
@property (nonatomic, readonly) NSArray *allConstraints;
@property (nonatomic, readonly) NSArray *referencingConstraintsInSuperviews;
@property (nonatomic, readonly) NSArray *referencingConstraints;

// Retrieving constraints
- (NSLayoutConstraint *) constraintMatchingConstraint: (NSLayoutConstraint *) aConstraint;
- (NSArray *) constraintsMatchingConstraints: (NSArray *) constraints;

// Constraints referencing a given view
- (NSArray *) constraintsReferencingView: (VIEW_CLASS *) view;

// Removing matching constraints
- (void) removeMatchingConstraint: (NSLayoutConstraint *) aConstraint;
- (void) removeMatchingConstraints: (NSArray *) anArray;

// Removing named constraints
- (void) removeConstraintsNamed: (NSString *) name;
- (void) removeConstraintsNamed: (NSString *) name matchingView: (VIEW_CLASS *) view;
@end