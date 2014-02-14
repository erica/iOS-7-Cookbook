/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "DetailViewController.h"
#import "Utility.h"

#define CONSTRAIN_VISUALLY(FORMAT) [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:(FORMAT) options:0 metrics:nil views:views]]


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

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    [self.view removeConstraints:self.view.constraints];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(imageView, titleLabel, artistLabel, button);
    
    if (IS_IPAD || (UIDeviceOrientationIsPortrait(self.interfaceOrientation)))
    {
        for (UIView *view in @[imageView, titleLabel, artistLabel, button])
            CENTER_VIEW_H(self.view, view);

        CONSTRAIN_VISUALLY(@"V:|-[imageView]-30-[titleLabel(>=0)]-[artistLabel]-15-[button]-(>=0)-|");
    }
    else
    {
        CENTER_VIEW_V(self.view, imageView);
        CONSTRAIN_VISUALLY(@"H:|-[imageView]");
        CONSTRAIN_VISUALLY(@"H:[titleLabel]-15-|");
        CONSTRAIN_VISUALLY(@"H:[artistLabel]-15-|");
        CONSTRAIN_VISUALLY(@"H:[button]-15-|");
        CONSTRAIN_VISUALLY(@"V:|-(>=0)-[titleLabel(>=0)]-[artistLabel]-15-[button]-|");

        // Make sure titleLabel doesn't overlap
        CONSTRAIN_VISUALLY(@"H:[imageView]-(>=0)-[titleLabel]");
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateViewConstraints];
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
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIImage *image = dict[@"large image"];
    imageView = [[UIImageView alloc] initWithImage:image];
    
    titleLabel = [self labelWithTitle:dict[@"name"]];
    artistLabel = [self labelWithTitle:dict[@"artist"]];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:dict[@"price"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buy) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIView *view in @[imageView, titleLabel, artistLabel, button])
    {
        [self.view addSubview:view];
        PREPCONSTRAINTS(view);
    }
    
    // Set aspect ratio for image view
    [imageView addConstraint:[NSLayoutConstraint constraintWithItem:imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:imageView attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0.0f]];
}

@end

