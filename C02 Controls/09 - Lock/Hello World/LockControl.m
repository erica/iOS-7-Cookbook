/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "LockControl.h"
#import "Utility.h"

#import "ConstraintUtilities-Install.h"
#import "ConstraintUtilities-Layout.h"
#import "ConstraintUtilities-Matching.h"
#import "ConstraintUtilities-Description.h"
#import "NSObject-Description.h"
#import "NSObject-Nametag.h"

#define THUMB_POSITION_TAG  @"Thumb Location"

@implementation LockControl
{
    UIImageView *lockView;
    UIImageView *trackView;
    UIImageView *thumbView;
}

#pragma mark - Layout

+ (BOOL)requiresConstraintBasedLayout
{
    return YES;
}

- (void)updateConstraints
{
    // Not generally needed here
    [super updateConstraints];
}

- (void)layoutConstraints
{
    NSLayoutConstraint *constraint;
    
    // Self
    constrainViewSize(self, CGSizeMake(256, 256), 1000); // fixed size

    // Lock
    centerViewX(lockView, 1000);
    constraint = [NSLayoutConstraint constraintWithItem:lockView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.35f constant:0];
    [constraint install:1000];
    
    // Track
    centerViewX(trackView, 1000);
    constraint = [NSLayoutConstraint constraintWithItem:trackView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:0.8f constant:0];
    [constraint install:1000];
    
    // Thumb
    centerViewY(thumbView, 1000);
    CGFloat thumbInset = thumbView.image.size.width / 2;
    for (NSString *format in @[
         @"H:|-(>=inset)-[view]",
         @"H:[view]-(>=inset)-|",
         ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:NSLayoutFormatAlignAllCenterY metrics:@{@"inset":@(thumbInset)} views:@{@"view":thumbView}];
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install:1000];
    }    
    constraint = CONSTRAINT_POSITION_LEADING(thumbView, 0);
    constraint.nametag = THUMB_POSITION_TAG;
    [constraint install:500];
}

- (void)buildView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3f];
    self.layer.cornerRadius = 32;
    self.layer.masksToBounds = YES;
    
    lockView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lockClosed"]];
    lockView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:lockView];

    trackView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"track"]];
    trackView.contentMode = UIViewContentModeCenter;
    trackView.translatesAutoresizingMaskIntoConstraints = NO;
    HUG(trackView, 1000);
    [self addSubview:trackView];
    
    thumbView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"thumb"]];
    thumbView.translatesAutoresizingMaskIntoConstraints = NO;
    [trackView addSubview:thumbView];
    
    [self layoutConstraints];
}

#pragma mark - Creation

- (instancetype)initWithFrame:(CGRect)aFrame
{
    if (!(self = [super initWithFrame:aFrame])) return self;
	self.backgroundColor = [UIColor clearColor];
    _value = 1;
    [self buildView];
    return self;
}

+ (id)controlWithTarget:(id)target
{
	LockControl *control = [[self alloc] init];
    [control addTarget:target action:@selector(lockDidUpdate:) forControlEvents:UIControlEventValueChanged];
    return control;
}

#pragma mark - UIControl

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Test touches for start conditions
	CGPoint touchPoint = [touch locationInView:self];
    CGRect largeTrack = CGRectInset(trackView.frame, -20.0f, -20.0f);
    if (!CGRectContainsPoint(largeTrack, touchPoint))
        return NO;
    touchPoint = [touch locationInView:trackView];
    CGRect largeThumb = CGRectInset(thumbView.frame, -20.0f, -20.0f);
    if (!CGRectContainsPoint(largeThumb, touchPoint))
        return NO;
    
    // Begin tracking
	[self sendActionsForControlEvents:UIControlEventTouchDown];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Strayed too far out?
    CGPoint touchPoint = [touch locationInView:self];
    CGRect largeTrack = CGRectInset(trackView.frame, -20.0f, -20.0f);
    if (!CGRectContainsPoint(largeTrack, touchPoint))
    {
        // Reset on failed attempt
        [UIView animateWithDuration:0.2f animations:^(){
            NSLayoutConstraint *constraint = [trackView constraintNamed:THUMB_POSITION_TAG];
            constraint.constant = 0;
            [trackView layoutIfNeeded];
        }];
        return NO;
    }

    // Track the user moment by updating the thumb
	touchPoint = [touch locationInView:trackView];
    [UIView animateWithDuration:0.1f animations:^(){
        NSLayoutConstraint *constraint = [trackView constraintNamed:THUMB_POSITION_TAG];
        constraint.constant = touchPoint.x;
        [trackView layoutIfNeeded];
    }];    
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Test if touch ended with unlock
	CGPoint touchPoint = [touch locationInView:trackView];
    if (touchPoint.x > trackView.frame.size.width * 0.75f)
    {
        // Complete by unlocking
        _value = 0;
        self.userInteractionEnabled = NO;
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        
        // Fade away and remove
        [UIView animateWithDuration:0.5f animations:^(){self.alpha = 0.0f;} completion:^(BOOL finished){[self removeFromSuperview];}];
    }
    else
    {
        // Reset on failed attempt
        [UIView animateWithDuration:0.5f animations:^(){
            NSLayoutConstraint *constraint = [trackView constraintNamed:THUMB_POSITION_TAG];
            constraint.constant = 0;
            [trackView layoutIfNeeded];
        }];
    }
    
    if (CGRectContainsPoint(trackView.bounds, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
}


- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
