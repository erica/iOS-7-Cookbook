/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;

@protocol VIDEOkitDelegate <NSObject>
- (void)updateExternalView:(UIView *)view;
@end

@interface VIDEOkit : NSObject 
@property (nonatomic, weak)   UIViewController <VIDEOkitDelegate> *delegate;
@property (nonatomic, strong) UIWindow *outputWindow;
@property (nonatomic, strong) CADisplayLink *displayLink;
+ (void)startupWithDelegate:(UIViewController <VIDEOkitDelegate> *)aDelegate;
@end
