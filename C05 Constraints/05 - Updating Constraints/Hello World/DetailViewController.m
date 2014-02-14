/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "DetailViewController.h"
#import "Utility.h"

@implementation DetailViewController
{
    NSDictionary *dict;
    UIImageView *imageView;
    UILabel *titleLabel;
    UILabel *artistLabel;
    UIButton *button;
}

- (instancetype)initWithDictionary:(NSDictionary *)aDictionary
{
    self = [super init];
    if (self)
    {
        dict = aDictionary;
    }
    return self;
}

// Only works on-device. Invalid in simulator.
- (void)buy
{
    NSString *address = dict[@"address"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:address]];
}

- (void)updateViewControllerConstraints
{
    [self.view removeConstraints:self.view.constraints];
    
    NSDictionary *bindings = NSDictionaryOfVariableBindings(imageView, titleLabel, artistLabel, button);
    
    if (IS_IPAD || UIDeviceOrientationIsPortrait(self.interfaceOrientation) || (self.interfaceOrientation == UIDeviceOrientationUnknown))
    {
        for (UIView *view in @[imageView, titleLabel, artistLabel, button])
        {
            CENTER_VIEW_H(self.view, view);
        }
        CONSTRAIN_VIEWS(self.view, @"V:|-80-[imageView]-30-[titleLabel(>=0)]-[artistLabel]-15-[button]-(>=0)-|", bindings);
    }
    else
    {
        // Center image view on left
        CENTER_VIEW_V(self.view, imageView);

        // Lay out remaining views
        CONSTRAIN(self.view, imageView, @"H:|-[imageView]");
        CONSTRAIN(self.view, titleLabel, @"H:[titleLabel]-15-|");
        CONSTRAIN(self.view, artistLabel, @"H:[artistLabel]-15-|");
        CONSTRAIN(self.view, button, @"H:[button]-15-|");
        CONSTRAIN_VIEWS(self.view, @"V:|-(>=0)-[titleLabel(>=0)]-[artistLabel]-15-[button]-|", bindings);

        // Make sure titleLabel doesn't overlap
        CONSTRAIN_VIEWS(self.view, @"H:[imageView]-(>=0)-[titleLabel]", bindings);
    }
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateViewControllerConstraints];
}

- (UILabel *)labelWithTitle:(NSString *)aTitle
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = aTitle;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Futura" size:20.0f];
    label.numberOfLines = 999;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = dict[@"large image"];
    imageView = [[UIImageView alloc] initWithImage:image];
    
    titleLabel = [self labelWithTitle:dict[@"name"]];
    artistLabel = [self labelWithTitle:dict[@"artist"]];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:dict[@"price"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *view in @[imageView, titleLabel, artistLabel, button])
    {
        [self.view addSubview:view];
        PREPCONSTRAINTS(view);
    }
    
    // Set aspect ratio for image view
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
    
    // Set initial constraints
    [self updateViewControllerConstraints];
}

@end

