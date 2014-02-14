/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "AnimationHelper.h"

@implementation AnimationHelper

#pragma mark - Transform -

+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock
{
    NSLog(@"DEBUG: %f and %f", firstDuration, secondDuration);
    AnimationBlock primaryAnimation = ^(){
        aView.transform = transientTransform;
    };
    
    AnimationBlock secondaryAnimation = ^(){
        aView.transform = finalTransform;
    };
    
    CompletionBlock middleCompletion = ^(BOOL finished) {
        [UIView animateWithDuration:secondDuration animations:secondaryAnimation completion:finishBlock];
    };
    
    AnimationBlock primaryBlock = ^(){
        [UIView animateWithDuration:firstDuration animations: primaryAnimation completion:middleCompletion];
    };
    
    return primaryBlock;
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform completion:(CompletionBlock)finishBlock
{
    return [self viewAnimation:aView viaTransform:transientTransform toTransform:finalTransform withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:finishBlock];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform
{
    return [self viewAnimation:aView viaTransform:transientTransform toTransform:finalTransform withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:nil];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toTransform:(CGAffineTransform)aTransform withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.transform = aTransform;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toTransform:(CGAffineTransform)aTransform
{
    return [self viewAnimation:aView toTransform:aTransform withDuration:DEFAULT_TIME];
}

#pragma mark - Center -

+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock
{
    AnimationBlock primaryAnimation = ^(){
        aView.center = transientCenter;
    };
    
    AnimationBlock secondaryAnimation = ^(){
        aView.center = finalCenter;
    };
    
    CompletionBlock middleCompletion = ^(BOOL finished) {
        [UIView animateWithDuration:secondDuration animations:secondaryAnimation completion:finishBlock];
    };
    
    AnimationBlock primaryBlock = ^(){
        [UIView animateWithDuration:firstDuration animations: primaryAnimation completion:middleCompletion];
    };
    
    return primaryBlock;
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter completion:(CompletionBlock)finishBlock
{
    return [self viewAnimation:aView viaCenter:transientCenter toCenter:finalCenter withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:finishBlock];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter
{
    return [self viewAnimation:aView viaCenter:transientCenter toCenter:finalCenter withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:nil];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toCenter:(CGPoint)aCenter withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.center = aCenter;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toCenter:(CGPoint)aCenter
{
    return [self viewAnimation:aView toCenter:aCenter withDuration:DEFAULT_TIME];
}

#pragma mark - Frame -
+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock
{
    AnimationBlock primaryAnimation = ^(){
        aView.frame = transientFrame;
    };
    
    AnimationBlock secondaryAnimation = ^(){
        aView.frame = finalFrame;
    };
    
    CompletionBlock middleCompletion = ^(BOOL finished) {
        [UIView animateWithDuration:secondDuration animations:secondaryAnimation completion:finishBlock];
    };
    
    AnimationBlock primaryBlock = ^(){
        [UIView animateWithDuration:firstDuration animations: primaryAnimation completion:middleCompletion];
    };
    
    return primaryBlock;
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame completion:(CompletionBlock)finishBlock
{
    return [self viewAnimation:aView viaFrame:transientFrame toFrame:finalFrame withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:finishBlock];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame
{
    return [self viewAnimation:aView viaFrame:transientFrame toFrame:finalFrame withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:nil];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toFrame:(CGRect)aFrame withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.frame = aFrame;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toFrame:(CGRect)aFrame
{
    return [self viewAnimation:aView toFrame:aFrame withDuration:DEFAULT_TIME];
}

#pragma mark - Bounds -
+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock
{
    AnimationBlock primaryAnimation = ^(){
        aView.bounds = transientBounds;
    };
    
    AnimationBlock secondaryAnimation = ^(){
        aView.bounds = finalBounds;
    };
    
    CompletionBlock middleCompletion = ^(BOOL finished) {
        [UIView animateWithDuration:secondDuration animations:secondaryAnimation completion:finishBlock];
    };
    
    AnimationBlock primaryBlock = ^(){
        [UIView animateWithDuration:firstDuration animations: primaryAnimation completion:middleCompletion];
    };
    
    return primaryBlock;
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds completion:(CompletionBlock)finishBlock
{
    return [self viewAnimation:aView viaBounds:transientBounds toBounds:finalBounds withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:finishBlock];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds
{
    return [self viewAnimation:aView viaBounds:transientBounds toBounds:finalBounds withDuration:DEFAULT_TIME andDuration:DEFAULT_TIME completion:nil];
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toBounds:(CGRect)aBounds withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.bounds = aBounds;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toBounds:(CGRect)aBounds
{
    return [self viewAnimation:aView toBounds:aBounds withDuration:DEFAULT_TIME];
}

#pragma mark - Alpha -

+ (AnimationBlock)viewAnimation:(UIView *)aView toAlpha:(CGFloat)anAlphaLevel withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.alpha = anAlphaLevel;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toAlpha:(CGFloat)anAlphaLevel
{
    return [self viewAnimation:aView toAlpha:anAlphaLevel withDuration: DEFAULT_TIME];
}

#pragma mark - Color -

+ (AnimationBlock)viewAnimation:(UIView *)aView toColor:(UIColor *)aColor withDuration:(CGFloat)aDuration
{
    return ^(){
        [UIView animateWithDuration:aDuration animations:^(){
            aView.backgroundColor = aColor;
        }];
    };
}

+ (AnimationBlock)viewAnimation:(UIView *)aView toColor:(UIColor *)aColor
{
    return [self viewAnimation:aView toColor:aColor withDuration: DEFAULT_TIME];
}
@end
