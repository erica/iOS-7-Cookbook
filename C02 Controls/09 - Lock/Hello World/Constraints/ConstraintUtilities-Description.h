/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <Foundation/Foundation.h>
#import "ConstraintUtilities-Install.h"

/*
 
 Description Category -- Supports debugging.
 Not for real-world deployment. Please use these with care.
 
 */


// String utility conversions cross-platform
#if TARGET_OS_IPHONE
    #define RECTSTRING(_aRect_)         NSStringFromCGRect(_aRect_)
    #define POINTSTRING(_aPoint_)       NSStringFromCGPoint(_aPoint_)
    #define SIZESTRING(_aSize_)         NSStringFromCGSize(_aSize_)
#elif TARGET_OS_MAC
    #define RECTSTRING(_aRect_)         NSStringFromRect(_aRect_)
    #define POINTSTRING(_aPoint_)       NSStringFromPoint(_aPoint_)
    #define SIZESTRING(_aSize_)         NSStringFromSize(_aSize_)
#endif
#define AFFINESTRING(_transform_)       NSStringFromCGAffineTransform(_transform_)

// Retrieving Hug and Resistance values cross-platform
#if TARGET_OS_IPHONE
    #define HUG_VALUE_H(VIEW) [VIEW contentHuggingPriorityForAxis:UILayoutConstraintAxisHorizontal]
    #define HUG_VALUE_V(VIEW) [VIEW contentHuggingPriorityForAxis:UILayoutConstraintAxisVertical]
    #define RESIST_VALUE_H(VIEW) [VIEW contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisHorizontal]
    #define RESIST_VALUE_V(VIEW) [VIEW contentCompressionResistancePriorityForAxis:UILayoutConstraintAxisVertical]
#elif TARGET_OS_MAC
    #define HUG_VALUE_H(VIEW) [VIEW contentHuggingPriorityForOrientation:NSLayoutConstraintOrientationHorizontal]
    #define HUG_VALUE_V(VIEW) [VIEW contentHuggingPriorityForOrientation:NSLayoutConstraintOrientationVertical]
    #define RESIST_VALUE_H(VIEW) [VIEW contentCompressionResistancePriorityForOrientation:NSLayoutConstraintOrientationHorizontal]
    #define RESIST_VALUE_V(VIEW) [VIEW contentCompressionResistancePriorityForOrientation:NSLayoutConstraintOrientationVertical]
#endif

#define READABLERECT(_aRect_) [NSString stringWithFormat:@"(%d %d; %d %d)" , (int) (_aRect_).origin.x, (int) (_aRect_).origin.y, (int) (_aRect_).size.width, (int) (_aRect_).size.height]
#define READABLEINSETS(_insets_) [NSString stringWithFormat:@"[t:%d, l:%d, b:%d, r:%d]", (int) _insets_.top, (int) _insets_.left, (int) _insets_.bottom, (int) _insets_.right]


/*
 STRING DESCRIPTION
 Produces an item.attribute Relation m * item.attribute + b description
 of the constraint in question
 */

@interface NSLayoutConstraint (StringDescription)
+ (NSString *) nameForLayoutAttribute: (NSLayoutAttribute) anAttribute;
+ (NSString *) nameForFormatOption: (NSLayoutFormatOptions) anOption;
+ (NSString *) nameForLayoutRelation: (NSLayoutRelation) aRelation;
@property (nonatomic, readonly) NSString *stringValue;
@end

/*
 VISUAL FORMAT
 Apple-style + a few minor additions
 */

@interface NSLayoutConstraint (FormatDescription)
@property (nonatomic, readonly) NSString *visualFormat;
@end

/*
 CODE DESCRIPTION
 From constraint to code. For books.
 */

@interface NSLayoutConstraint (CodeDescription)
+ (NSString *) codeNameForLayoutAttribute: (NSLayoutAttribute) anAttribute;
+ (NSString *) codeNameForLayoutRelation: (NSLayoutRelation) aRelation;
- (NSString *) codeDescriptionWithBindings: (NSDictionary *) dict;
@property (nonatomic, readonly) NSString *codeDescription;
@end

/*
 CONSTRAINT VIEW UTILITY
 Readable representations for descriptions
 */

@interface VIEW_CLASS (ConstraintUtility)
- (NSString *) readableFrame;
- (NSString *) readableAlignmentInsets;
- (NSString *) readableAlignmentRect;
@end

/*
 FUNCTIONALITY DESCRIPTION
 Add role descriptions that explain what each constraint does
 */

@interface NSLayoutConstraint (SelfDescription)
// Describe the role of the constraint, suitable for auto-naming
@property (nonatomic, readonly) NSString *constraintDescription;
+ (void) autoAddConstraintNames: (NSArray *) constraints;
@end

/*
 AUTO NAMING
 Assign names to constraints and views 
 */

@interface VIEW_CLASS (AutoNaming)
- (void) addConstraintNames;
- (void) addViewNames;
@end

/*
 VIEW DESCRIPTION
 Explain all view features
 */

@interface VIEW_CLASS (Description)

#if TARGET_OS_IPHONE
+ (NSString *) nameForContentMode: (UIViewContentMode) mode;
#endif

@property (nonatomic, readonly) NSString *viewLayoutDescription;
@property (nonatomic, readonly) NSString *superviewsDescription;
@property (nonatomic, readonly) NSString *trace;
- (void) testAmbiguity;
- (void) showViewReport: (BOOL) descend;
- (void) listConstraints;
- (void) listAllConstraints;
@end