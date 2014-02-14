/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "SwitchedImageViewController.h"
@implementation SwitchedImageViewController
{
    IBOutlet UISwitch *s;
    IBOutlet UIImageView *iv;
}

- (void) switchChanged: (UISwitch *) aSwitch
{
    iv.alpha = aSwitch.isOn ? 1.0f : 0.5f;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    iv.alpha = 0.5f;
}

@end
