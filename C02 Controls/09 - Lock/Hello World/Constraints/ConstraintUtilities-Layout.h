/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */


#import <Foundation/Foundation.h>
#import "ConstraintUtilities-Install.h"

/*
 
 All this was built primarily in lockstep with book development
 If you find anything here you can use, go for it.
 
 */

// Utility
NSLayoutAttribute attributeForAlignment(NSLayoutFormatOptions alignment);
BOOL constraintIsHorizontal(NSLayoutConstraint *constraint);

// Build and Install
NSArray *visualConstraints(NSString *format, NSLayoutFormatOptions options, NSDictionary *metrics, NSDictionary *bindings, NSUInteger fallbackPriority);
void addVisualConstraints(NSString *format, NSLayoutFormatOptions options, NSDictionary *metrics, NSDictionary *bindings, NSUInteger fallbackPriority, NSString *name);

// Constrain within the view's superview
void constrainWithinSuperview(VIEW_CLASS *view, NSUInteger priority);
void constrainToSuperview(VIEW_CLASS *view, float minimumSize, NSUInteger  priority);

// Stretching
void stretchToSuperview(VIEW_CLASS *view, CGFloat indent, NSUInteger priority);
void stretchHorizontallyToSuperview(VIEW_CLASS *view, CGFloat indent, NSUInteger priority);

// Sizing
void constrainViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority);
void constrainMinimumViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority);
void constrainMaximumViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority);

// Rows and Columns
void buildLineWithSpacing(NSArray *views, NSLayoutFormatOptions alignment, NSString *spacing, NSUInteger priority);
void buildLine(NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority);
void pseudoDistributeWithSpacers(VIEW_CLASS *superview, NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority);
void pseudoDistributeCenters(NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority);

#pragma mark - non visual format items

// Alignment
void alignView(VIEW_CLASS *view, NSLayoutAttribute attribute, NSInteger inset, NSUInteger priority);
void centerView(VIEW_CLASS *view, NSUInteger priority);
void centerViewX(VIEW_CLASS *view, NSUInteger priority);
void centerViewY(VIEW_CLASS *view, NSUInteger priority);

// Position
NSLayoutConstraint *constraintPositioningViewX(VIEW_CLASS *view, CGFloat x);
NSLayoutConstraint *constraintPositioningViewY(VIEW_CLASS *view, CGFloat y);
NSArray *constraintsPositioningView(VIEW_CLASS *view, CGPoint point);
void positionView(VIEW_CLASS *view, CGPoint point, NSUInteger priority);

// Apply format for view
void pin(VIEW_CLASS *view, NSString *format);
void pinWithPriority(VIEW_CLASS *view, NSString *format, NSString *name, int priority);

// Contrast View
void loadContrastViewsOntoView(VIEW_CLASS *aView);


