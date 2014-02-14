/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "ConstraintUtilities-Layout.h"
#import "ConstraintUtilities-Matching.h"
#import "NSObject-Nametag.h"

#pragma mark - Utility

// Paranoia in action.
NSLayoutAttribute attributeForAlignment(NSLayoutFormatOptions alignment)
{
    switch (alignment)
    {
        case NSLayoutFormatAlignAllLeft:
            return NSLayoutAttributeLeft;
        case NSLayoutFormatAlignAllRight:
            return NSLayoutAttributeRight;
        case NSLayoutFormatAlignAllTop:
            return NSLayoutAttributeTop;
        case NSLayoutFormatAlignAllBottom:
            return NSLayoutAttributeBottom;
        case NSLayoutFormatAlignAllLeading:
            return NSLayoutAttributeLeading;
        case NSLayoutFormatAlignAllTrailing:
            return NSLayoutAttributeTrailing;
        case NSLayoutFormatAlignAllCenterX:
            return NSLayoutAttributeCenterX;
        case NSLayoutFormatAlignAllCenterY:
            return NSLayoutAttributeCenterY;
        case NSLayoutFormatAlignAllBaseline:
            return NSLayoutAttributeBaseline;
        default:
            return NSLayoutAttributeNotAnAttribute;
    }
}

BOOL constraintIsHorizontal(NSLayoutConstraint *constraint)
{
    return IS_HORIZONTAL_ATTRIBUTE(constraint.firstAttribute);
}

#pragma mark - Build and Install

// Wrapping the NSLayoutConstraint method into a function that
// performs generation. Applies fallback priority
// to any item not already prioritized by the format string.

NSArray *visualConstraints(NSString *format, NSLayoutFormatOptions options, NSDictionary *metrics, NSDictionary *bindings, NSUInteger fallbackPriority)
{
    // Build constraints
    NSArray *constraints = [NSLayoutConstraint
                            constraintsWithVisualFormat:format
                            options:options
                            metrics:metrics
                            views:bindings];
    
    for (NSLayoutConstraint *constraint in constraints)
        if (constraint.priority == LayoutPriorityRequired)
            constraint.priority = fallbackPriority;

    return constraints;
}

// Generate and then install constraints with naming
void addVisualConstraints(NSString *format, NSLayoutFormatOptions options, NSDictionary *metrics, NSDictionary *bindings, NSUInteger fallbackPriority, NSString *name)
{
    NSArray *constraints = visualConstraints(format, options, metrics, bindings, fallbackPriority);
    for (NSLayoutConstraint *constraint in constraints)
    {
        if (name)
            constraint.nametag = name;
        [constraint install];
    }
}

#pragma mark - Visibility

// Constrain to superview
void constrainWithinSuperview(VIEW_CLASS *view, NSUInteger priority)
{
    if (!view || !view.superview)
        return;
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);    
    for (NSString *format in @[
         @"H:|->=0-[view]",
         @"H:[view]->=0-|",
         @"V:|->=0-[view]",
         @"V:[view]->=0-|"])
        addVisualConstraints(format, 0, nil, bindings, priority, @"Constrain to Superview");
}

// Constrain within superview with minimum sizing
void constrainToSuperview(VIEW_CLASS *view, float side, NSUInteger  priority)
{
    if (!view || !view.superview)
        return;
    
    // Check for minimum sizing
    if (side == 0)
    {
        constrainWithinSuperview(view, priority);
        return;
    }
    
    NSDictionary *metrics = @{@"priority":@(priority), @"side":@(side)};
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    
    for (NSString *format in @[
         @"H:|->=0@priority-[view(==side@priority)]",
         @"H:[view]->=0@priority-|",
         @"V:|->=0@priority-[view(==side@priority)]",
         @"V:[view]->=0@priority-|"])
        addVisualConstraints(format, 0, metrics, bindings, priority, @"Constrain to Superview");
}

#pragma mark - Stretching
void stretchHorizontallyToSuperview(VIEW_CLASS *view, CGFloat indent, NSUInteger priority)
{
    NSString *format = @"H:|-indent-[view(>=0)]-indent-|";
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"indent":@(indent)};
    addVisualConstraints(format, 0, metrics, bindings, priority, @"Stretch to Superview");
}

void stretchVerticallyToSuperview(VIEW_CLASS *view, CGFloat indent, NSUInteger priority)
{
    NSString *format = @"V:|-indent-[view(>=0)]-indent-|";
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"indent":@(indent)};
    addVisualConstraints(format, 0, metrics, bindings, priority, @"Stretch to Superview");
}


void stretchToSuperview(VIEW_CLASS *view, CGFloat indent, NSUInteger priority)
{
    stretchHorizontallyToSuperview(view, indent, priority);
    stretchVerticallyToSuperview(view, indent, priority);
}

#pragma mark - Sizing
void constrainViewSizePrivate(VIEW_CLASS *view, CGSize size, NSUInteger priority, NSString *relation)
{
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"width":@(size.width), @"height":@(size.height), @"priority":@(priority)};
    
    for (NSString *format in @[
         [NSString stringWithFormat:@"H:[view(%@width@priority)]", relation],
         [NSString stringWithFormat:@"V:[view(%@height@priority)]", relation],
         ])
        addVisualConstraints(format, 0, metrics, bindings, priority, @"View Size");
}

void constrainViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority)
{
    constrainViewSizePrivate(view, size, priority, @"==");
}

void constrainMinimumViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority)
{
    constrainViewSizePrivate(view, size, priority, @">=");
}

void constrainMaximumViewSize(VIEW_CLASS *view, CGSize size, NSUInteger priority)
{
    constrainViewSizePrivate(view, size, priority, @"<=");
}

#pragma mark - Rows and Columns
void buildLineWithSpacing(NSArray *views, NSLayoutFormatOptions alignment, NSString *spacing, NSUInteger priority)
{
    if (!views.count)
        return;
    
    VIEW_CLASS *view1, *view2;
    NSInteger axis = IS_HORIZONTAL_ALIGNMENT(alignment);
    NSString *axisString = (axis == 0) ? @"H:" : @"V:";
    
    NSString *format = [NSString stringWithFormat:@"%@[view1]%@[view2]", axisString, spacing];
    
    for (NSUInteger i = 1; i < views.count; i++)
    {
        view1 = views[i-1];
        view2 = views[i];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view1, view2);
        addVisualConstraints(format, alignment, nil, bindings, priority, @"Build Line");
    }
}

void buildLine(NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority)
{
    buildLineWithSpacing(views, alignment, @"-", priority);
}

void pseudoDistributeCenters(NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority)
{
    if (!views.count)
        return;
    
    if (alignment == 0)
        return;
    
    // Check the alignment for vertical or horizontal placement
    BOOL horizontal = IS_HORIZONTAL_ALIGNMENT(alignment);
    
    // Placement is orthogonal to that alignment
    NSLayoutAttribute placementAttribute = horizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeCenterX;
    NSLayoutAttribute endAttribute = horizontal ? NSLayoutAttributeCenterY : NSLayoutAttributeRight;
    
    // Cast from NSLayoutFormatOptions to NSLayoutAttribute
    NSLayoutAttribute alignmentAttribute = attributeForAlignment(alignment);
    
    // Iterate through the views
    NSLayoutConstraint *constraint;
    for (NSUInteger i = 0; i < views.count; i++)
    {
        VIEW_CLASS *view = views[i];
        CGFloat multiplier = ((CGFloat) i + 0.5) / ((CGFloat) views.count);
        
        // Install the item position
        constraint = [NSLayoutConstraint
                      constraintWithItem:view
                      attribute:placementAttribute
                      relatedBy:NSLayoutRelationEqual
                      toItem:view.superview
                      attribute:endAttribute
                      multiplier: multiplier
                      constant: 0];
        [constraint install:priority];
        
        // Install alignment
        constraint = [NSLayoutConstraint
                      constraintWithItem:views[0]
                      attribute:alignmentAttribute
                      relatedBy:NSLayoutRelationEqual
                      toItem: view
                      attribute:alignmentAttribute
                      multiplier:1
                      constant:0];
        [constraint install:priority];
    }
}

void pseudoDistributeWithSpacers(VIEW_CLASS *superview, NSArray *views, NSLayoutFormatOptions alignment, NSUInteger priority)
{
    // You pin the first and last items wherever you want
    
    // Must pass views, superview, non-zero alignment
    if (!views.count) return;
    if (!superview) return;
    if (alignment == 0) return;
    
    // Build disposable spacers
    NSMutableArray *spacers = [NSMutableArray array];
    for (NSUInteger i = 0; i < views.count; i++)
    {
        [spacers addObject:[[VIEW_CLASS alloc] init]];
        [spacers[i] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [superview addSubview:spacers[i]];
    }
    
    BOOL horizontal = IS_HORIZONTAL_ALIGNMENT(alignment);
    VIEW_CLASS *firstspacer = spacers[0];
    
    // No sizing restriction
    //    NSString *format = [NSString stringWithFormat:@"%@:[view1][spacer(==firstspacer)][view2]", horizontal ? @"V" : @"H"];
    
    // Equal sizing restriction
    NSString *format = [NSString stringWithFormat:@"%@:[view1][spacer(==firstspacer)][view2(==view1)]", horizontal ? @"V" : @"H"];
    
    // Lay out the row or column
    for (NSUInteger i = 1; i < views.count; i++)
    {
        VIEW_CLASS *view1 = views[i-1];
        VIEW_CLASS *view2 = views[i];
        VIEW_CLASS *spacer = spacers[i-1];
        
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view1, view2, spacer, firstspacer);
        
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:alignment metrics:nil views:bindings];
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install:priority];
    }
}

#pragma mark - Alignment
void alignView(VIEW_CLASS *view, NSLayoutAttribute attribute, NSInteger inset, NSUInteger priority)
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:attribute relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:attribute multiplier:1 constant:inset];
    [constraint install:priority];
}

void centerView(VIEW_CLASS *view, NSUInteger priority)
{
    alignView(view, NSLayoutAttributeCenterX, 0, priority);
    alignView(view, NSLayoutAttributeCenterY, 0, priority);
}

void centerViewX(VIEW_CLASS *view, NSUInteger priority)
{
    alignView(view, NSLayoutAttributeCenterX, 0, priority);
}

void centerViewY(VIEW_CLASS *view, NSUInteger priority)
{
    alignView(view, NSLayoutAttributeCenterY, 0, priority);
}

#pragma mark - Position

// NOTE! This uses Left to position the view, and not Leading
// For this reason, you cannot generate a format from this constraint
// An exact position should not be overriden by internationalization
NSLayoutConstraint *constraintPositioningViewX(VIEW_CLASS *view, CGFloat x)
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeLeft multiplier:1 constant:x];
    return constraint;
}

NSLayoutConstraint *constraintPositioningViewY(VIEW_CLASS *view, CGFloat y)
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view.superview attribute:NSLayoutAttributeTop multiplier:1 constant:y];
    return constraint;
}

NSArray *constraintsPositioningView(VIEW_CLASS *view, CGPoint point)
{
    return @[
             constraintPositioningViewX(view, point.x),
             constraintPositioningViewY(view, point.y),
             ];
}

void positionView(VIEW_CLASS *view, CGPoint point, NSUInteger priority)
{
    for (NSLayoutConstraint *constraint in constraintsPositioningView(view, point))
        [constraint install:priority];
}

void pin(VIEW_CLASS *view, NSString *format)
{
    addVisualConstraints(format, 0, nil, @{@"view":view}, LayoutPriorityRequired, nil);
}

void pinWithPriority(VIEW_CLASS *view, NSString *format, NSString *name, int priority)
{
    addVisualConstraints(format, 0, nil, @{@"view":view}, priority, name);
}

#pragma mark - Contrast View

void loadContrastViewsOntoView(VIEW_CLASS *aView)
{
    // Create a pair of contrast views to highlight placement
    VIEW_CLASS *contrastView;
    UIColor *bgColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3f];
    NSLayoutConstraint *constraint;
    
    // First, cover left half of the parent
    contrastView = [[VIEW_CLASS alloc] init];
    contrastView.nametag = @"Contrast View Vertical";
    contrastView.backgroundColor = bgColor;
    [aView addSubview:contrastView];
    contrastView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Stretch vertically and pin left
    stretchVerticallyToSuperview(contrastView, 0, LayoutPriorityRequired);
    alignView(contrastView, NSLayoutAttributeLeft, 0, LayoutPriorityRequired);
    
    // Constrain width to half of parent
    constraint = [NSLayoutConstraint constraintWithItem:contrastView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0.0f];
    [constraint install];
    
    // Then cover bottom half of parent
    contrastView = [[VIEW_CLASS alloc] init];
    contrastView.nametag = @"Contrast View Horizontal";
    contrastView.backgroundColor = bgColor;
    [aView addSubview:contrastView];
    contrastView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Stretch horizontally and pin bottom
    stretchHorizontallyToSuperview(contrastView, 0, LayoutPriorityRequired);
    alignView(contrastView, NSLayoutAttributeBottom, 0, LayoutPriorityRequired);
    
    // Constrain height to half of parent
    constraint = [NSLayoutConstraint constraintWithItem:contrastView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:aView attribute:NSLayoutAttributeHeight multiplier:0.5f constant:0.0f];
    [constraint install];
}





