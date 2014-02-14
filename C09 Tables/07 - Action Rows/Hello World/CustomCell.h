/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;

@class CustomCell;

typedef enum
{
    CustomCellActionNone,
    CustomCellActionTitle,
    CustomCellActionAlert,
} CustomCellActions;

@protocol CustomCellActionTarget <NSObject>
- (void) buttonPushed:(UIButton *)sender;
@end

@interface CustomCell : UITableViewCell
- (void)setActionTarget:(id<CustomCellActionTarget>)target;
@end
