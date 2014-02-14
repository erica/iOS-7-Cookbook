/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

@interface CustomAlert : UINavigationBar
@property (nonatomic, readonly) UILabel *label;
@property (nonatomic, readonly) UIButton *button;
- (void) show;
- (void) dismiss;
@end
