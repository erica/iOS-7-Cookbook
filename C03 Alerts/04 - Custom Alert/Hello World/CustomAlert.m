/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CustomAlert.h"
#import "Utility.h"

typedef void (^CustomAnimationBlock)(void);
typedef void (^CustomCompletionAnimationBlock)(BOOL finished);

@implementation CustomAlert
{
    UIView *contentView;
}

#pragma mark - Utility

- (void)observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context
{
    if ([keyPath isEqualToString:@"bounds"])
        contentView.frame = self.bounds;
}

#pragma mark - Instance Creation and Initialization

- (void)internalCustomAlertInitializer
{
    // Add size observer
    [self addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:NULL];
    
    // Constraint the size and width based on the initial frame
    self.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSString *constraintString in @[@"V:[self(==height)]", @"H:[self(==width)]"])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:@{@"width":@(width), @"height":@(height)} views:NSDictionaryOfVariableBindings(self)];
        [self addConstraints:constraints];
    }
    [self layoutIfNeeded];

    // Add a content view for auto layout
    contentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:contentView];
    contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    // Add layer styling
    self.layer.borderColor = [UIColor blackColor].CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = 20;
    self.clipsToBounds = YES;
    
    // Create label
    _label = [[UILabel alloc] init];
    [contentView addSubview:_label];
    _label.translatesAutoresizingMaskIntoConstraints = NO;
    _label.numberOfLines = 0;
    _label.textAlignment = NSTextAlignmentCenter;
    
    // Create button
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [contentView addSubview:_button];
    _button.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Layout subviews on content view
    for (NSString *constraintString in @[@"V:|-[_label]-[_button]-|", @"H:|-[_label]-|", @"H:|-[_button]-|"])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:constraintString options:0 metrics:nil views:NSDictionaryOfVariableBindings(_button, _label)];
        [contentView addConstraints:constraints];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return self;
    [self internalCustomAlertInitializer];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (!(self = [super initWithCoder:aDecoder])) return self;
    [self internalCustomAlertInitializer];
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"bounds"];
}

#pragma mark - Presentation and Dismissal

- (void)centerInSuperview
{
    if (!self.superview)
    {
        NSLog(@"Error: Attempting to present without superview");
        return;
    }
    
    NSArray *constraintArray = [self.superview.constraints copy];
    for (NSLayoutConstraint *constraint in constraintArray)
    {
        if ((constraint.firstItem == self) || (constraint.secondItem == self))
            [self.superview removeConstraint:constraint];
    }
    [self.superview addConstraints:CONSTRAINTS_CENTERING(self)];
}

- (void)show
{
    self.transform = CGAffineTransformMakeScale(FLT_EPSILON, FLT_EPSILON);
    [self centerInSuperview];
    
    CustomAnimationBlock expandBlock = ^{self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);};
    CustomAnimationBlock identityBlock = ^{self.transform = CGAffineTransformIdentity;};
    CustomCompletionAnimationBlock completionBlock = ^(BOOL done){[UIView animateWithDuration:0.3f animations:identityBlock];};
    [UIView animateWithDuration:0.5f animations:expandBlock completion:completionBlock];
}

- (void)dismiss
{
    CustomAnimationBlock expandBlock = ^{self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);};
    CustomAnimationBlock shrinkBlock = ^{self.transform = CGAffineTransformMakeScale(FLT_EPSILON, FLT_EPSILON);};
    CustomCompletionAnimationBlock completionBlock = ^(BOOL done){[UIView animateWithDuration:0.3f animations:shrinkBlock];};
    
    [UIView animateWithDuration:0.5f animations:expandBlock completion:completionBlock];
}
@end
