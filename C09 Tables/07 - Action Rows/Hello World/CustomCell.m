/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import QuartzCore;
#import "CustomCell.h"
#import "Utility.h"

@implementation CustomCell
{
    UIButton *titleButton;
    UIButton *alertButton;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.backgroundColor = [UIColor darkGrayColor];
        
        titleButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [titleButton setTitle:@"Title" forState:UIControlStateNormal];
        titleButton.tag = CustomCellActionTitle;
        [self.contentView addSubview:titleButton];
        PREPCONSTRAINTS(titleButton);
        CENTER_VIEW_V(self.contentView, titleButton);
        ALIGN_VIEW_LEFT_CONSTANT(self.contentView, titleButton, 40);
        
        alertButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [alertButton setTitle:@"Alert" forState:UIControlStateNormal];
        alertButton.tag = CustomCellActionAlert;
        [self.contentView addSubview:alertButton];
        PREPCONSTRAINTS(alertButton);
        CENTER_VIEW_V(self.contentView, alertButton);
        ALIGN_VIEW_RIGHT_CONSTANT(self.contentView, alertButton, -40);
    }
    return self;
}

- (void)setActionTarget:(id<CustomCellActionTarget>)target
{
    if ([target respondsToSelector:@selector(buttonPushed:)])
    {
        [titleButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [titleButton addTarget:target action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [alertButton removeTarget:nil action:NULL forControlEvents:UIControlEventTouchUpInside];
        [alertButton addTarget:target action:@selector(buttonPushed:) forControlEvents:UIControlEventTouchUpInside];
    }
}
@end
