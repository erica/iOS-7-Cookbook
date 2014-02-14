/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */


#import "PushButton.h"

#define CAPWIDTH    110.0f
#define INSETS      (UIEdgeInsets){0.0f, CAPWIDTH, 0.0f, CAPWIDTH}
#define BASEGREEN   [[UIImage imageNamed:@"green-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHGREEN   [[UIImage imageNamed:@"green-in.png"] resizableImageWithCapInsets:INSETS]
#define BASERED     [[UIImage imageNamed:@"red-out.png"] resizableImageWithCapInsets:INSETS]
#define PUSHRED     [[UIImage imageNamed:@"red-in.png"] resizableImageWithCapInsets:INSETS]


@implementation PushButton

- (void)zoomButton:(UIButton *)aButton
{
	[UIView animateWithDuration:0.2f
					 animations:^{
						 self.transform = CGAffineTransformMakeScale(1.1f, 1.1f);
					 }];
}

- (void)relaxButton:(UIButton *)aButton
{
	[UIView animateWithDuration:0.2f
					 animations:^{
						 self.transform = CGAffineTransformIdentity;
					 }];
}

- (void)toggleButton:(UIButton *)aButton
{
    self.isOn = !self.isOn;
	if (self.isOn)
	{
		[self setBackgroundImage:BASEGREEN forState:UIControlStateNormal];
		[self setBackgroundImage:PUSHGREEN forState:UIControlStateHighlighted];
        [self setTitle:@"On" forState:UIControlStateNormal];
        [self setTitle:@"On" forState:UIControlStateHighlighted];
	}
	else
	{
		[self setBackgroundImage:BASERED forState:UIControlStateNormal];
		[self setBackgroundImage:PUSHRED forState:UIControlStateHighlighted];
        [self setTitle:@"Off" forState:UIControlStateNormal];
        [self setTitle:@"Off" forState:UIControlStateHighlighted];
	}
    [self relaxButton:self];
}

+ (id)button
{
    PushButton *button = [PushButton buttonWithType:UIButtonTypeCustom];
    
    // Set up the button aligment properties
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	// Set the font and color
	[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
	button.titleLabel.font = [UIFont boldSystemFontOfSize:24.0f];
    
    // Set up the art
    [button setBackgroundImage:BASEGREEN forState:UIControlStateNormal];
    [button setBackgroundImage:PUSHGREEN forState:UIControlStateHighlighted];
    [button setTitle:@"On" forState:UIControlStateNormal];
    [button setTitle:@"On" forState:UIControlStateHighlighted];
    button.isOn = YES;
	
	// Add actions
	[button addTarget:button action:@selector(toggleButton:) forControlEvents: UIControlEventTouchUpInside];
    [button addTarget:button action:@selector(zoomButton:) forControlEvents: UIControlEventTouchDown | UIControlEventTouchDragInside | UIControlEventTouchDragEnter];
	[button addTarget:button action:@selector(relaxButton:) forControlEvents: UIControlEventTouchDragExit | UIControlEventTouchCancel | UIControlEventTouchDragOutside];
    return button;
}

@end
