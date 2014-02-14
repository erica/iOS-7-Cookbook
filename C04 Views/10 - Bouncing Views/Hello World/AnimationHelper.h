/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

typedef void (^AnimationBlock)(void);
typedef void (^CompletionBlock)(BOOL finished);

#define DEFAULT_TIME [[UIApplication sharedApplication] statusBarOrientationAnimationDuration]

@interface AnimationHelper : NSObject
// transform
+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaTransform:(CGAffineTransform)transientTransform toTransform:(CGAffineTransform)finalTransform;
+ (AnimationBlock)viewAnimation:(UIView *)aView toTransform:(CGAffineTransform)aTransform withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toTransform:(CGAffineTransform)aTransform;

// center
+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaCenter:(CGPoint)transientCenter toCenter:(CGPoint)finalCenter;
+ (AnimationBlock)viewAnimation:(UIView *)aView toCenter:(CGPoint)aCenter withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toCenter:(CGPoint)aCenter;

// frame
+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaFrame:(CGRect)transientFrame toFrame:(CGRect)finalFrame;
+ (AnimationBlock)viewAnimation:(UIView *)aView toFrame:(CGRect)aFrame withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toFrame:(CGRect)aFrame;

// bounds
+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds withDuration:(CGFloat)firstDuration andDuration:(CGFloat)secondDuration completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds completion:(CompletionBlock)finishBlock;
+ (AnimationBlock)viewAnimation:(UIView *)aView viaBounds:(CGRect)transientBounds toBounds:(CGRect)finalBounds;
+ (AnimationBlock)viewAnimation:(UIView *)aView toBounds:(CGRect)aBounds withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toBounds:(CGRect)aBounds;

// Create an animated alpha block
+ (AnimationBlock)viewAnimation:(UIView *)aView toAlpha:(CGFloat)anAlphaLevel withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toAlpha:(CGFloat)anAlphaLevel;

// Create an animated bg color block
+ (AnimationBlock)viewAnimation:(UIView *)aView toColor:(UIColor *)aColor withDuration:(CGFloat)aDuration;
+ (AnimationBlock)viewAnimation:(UIView *)aView toColor:(UIColor *)aColor;
@end
