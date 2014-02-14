/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@class LockControl;

@import Foundation;

@protocol LockOwner <NSObject>
- (void)lockDidUpdate:(LockControl *)sender;
@end

@interface LockControl : UIControl
@property (nonatomic, readonly, assign) BOOL value;
+ (id)controlWithTarget:(id <LockOwner>)target;
@end
