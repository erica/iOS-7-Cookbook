/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <Foundation/Foundation.h>

#pragma mark - Cross Platform
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
    #define VIEW_CLASS UIView
#elif TARGET_OS_MAC
    #define VIEW_CLASS NSView
#endif

typedef enum
{
    LayoutPriorityRequired = 1000,
    LayoutPriorityHigh = 750,
    LayoutPriorityDragResizingWindow = 510,
    LayoutPriorityMedium = 501,
    LayoutPriorityFixedWindowSize = 500,
    LayoutPriorityLow = 250,
    LayoutPriorityFittingSize = 50,
    LayoutPriorityMildSuggestion = 1,
} ConstraintLayoutPriority;

// A few items for my convenience
#define AQUA_SPACE  8
#define AQUA_INDENT 20
#define PREPCONSTRAINTS(VIEW) [VIEW setTranslatesAutoresizingMaskIntoConstraints:NO]

@interface VIEW_CLASS (HierarchySupport)
@property (nonatomic, readonly) NSArray *superviews;
@property (nonatomic, readonly) NSArray *allSubviews;
- (BOOL) isAncestorOf: (VIEW_CLASS *) aView;
- (VIEW_CLASS *) nearestCommonAncestor: (VIEW_CLASS *) aView;
@end

@interface VIEW_CLASS (ConstraintReadyViews)
+ (instancetype) view;
@end

@interface NSLayoutConstraint (ViewHierarchy)
@property (nonatomic, readonly) VIEW_CLASS *firstView;
@property (nonatomic, readonly) VIEW_CLASS *secondView;
@property (nonatomic, readonly) BOOL isUnary;
@property (nonatomic, readonly) VIEW_CLASS *likelyOwner;
@end

@interface NSLayoutConstraint (SelfInstall)
- (BOOL) install;
- (BOOL) install: (float) priority;
- (void) remove;
@end

