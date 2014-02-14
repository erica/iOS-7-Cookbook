/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CustomCell.h"

@implementation CustomCell

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)popSelf
{
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);} completion:^(BOOL done){
        [UIView animateWithDuration:0.1f animations:^(){self.transform = CGAffineTransformIdentity;}];
    }];
}

- (void)rotateSelf
{
    // This is harder than it looks
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeRotation(M_PI * .95);} completion:^(BOOL done){
        [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeRotation(M_PI * 1.5);} completion:^(BOOL done){self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)ghostSelf
{
    [UIView animateWithDuration:1.25f animations:^(){self.alpha = 0.0f;} completion:^(BOOL done){
        [UIView animateWithDuration:1.25f animations:^(){} completion:^(BOOL done){
            [UIView animateWithDuration:0.5f animations:^(){self.alpha = 1.0f;}];
        }];
    }];
}

- (void)colorize
{
    NSNotification *note = [NSNotification notificationWithName:@"ColorizeNotification" object:self.backgroundColor];
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(ghostSelf)) return YES;
    if (action == @selector(popSelf)) return YES;
    if (action == @selector(rotateSelf)) return YES;
    if (action == @selector(colorize)) return YES;
    return NO;
}

- (void)tapped:(UIGestureRecognizer *)uigr
{
    if (uigr.state != UIGestureRecognizerStateRecognized) return;
    
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *pop = [[UIMenuItem alloc] initWithTitle:@"Pop" action:@selector(popSelf)];
    UIMenuItem *rotate = [[UIMenuItem alloc] initWithTitle:@"Rotate" action:@selector(rotateSelf)];
    UIMenuItem *ghost = [[UIMenuItem alloc] initWithTitle:@"Ghost" action:@selector(ghostSelf)];
    UIMenuItem *colorize = [[UIMenuItem alloc] initWithTitle:@"Colorize" action:@selector(colorize)];

    [menu setMenuItems:@[pop, rotate, ghost, colorize]];
    [menu update];
    [menu setTargetRect:self.bounds inView:self];
    [menu setMenuVisible:YES animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        tapRecognizer.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}
@end
