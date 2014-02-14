/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;

typedef void(^AlertViewBlock)(void);

@interface BlockAlertView : UIAlertView <UIAlertViewDelegate>
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;
- (NSInteger)setCancelButtonWithTitle:(NSString *)title actionBlock:(AlertViewBlock)block;
- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(AlertViewBlock)block;
@end
