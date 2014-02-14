/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "ColorControl.h"


@implementation ColorControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (void)updateColorFromTouch:(UITouch *)touch
{
	// Calculate hue and saturation
	CGPoint touchPoint = [touch locationInView:self];
	float hue = touchPoint.x / self.frame.size.width;
	float saturation = touchPoint.y / self.frame.size.height;
	
	// Update the color value and change background color
	self.value = [UIColor colorWithHue:hue saturation:saturation brightness:1.0f alpha:1.0f];
	self.backgroundColor = self.value;
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

// Continue tracking touch in control
- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Test if drag is currently inside or outside
	CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.bounds, touchPoint))
    {
        // Update color value
        [self updateColorFromTouch:touch];
        
		[self sendActionsForControlEvents:UIControlEventTouchDragInside];
    }
	else
    {
		[self sendActionsForControlEvents:UIControlEventTouchDragOutside];
	}
    
	return YES;
}

// Start tracking touch in control
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Update color value
	[self updateColorFromTouch:touch];
    
	// Touch Down
	[self sendActionsForControlEvents:UIControlEventTouchDown];
	
	return YES;
}

// End tracking touch
- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	// Test if touch ended inside or outside
	CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.bounds, touchPoint))
    {
        // Update color value
        [self updateColorFromTouch:touch];
        
		[self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
	else
    {
		[self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    }
}

// Handle touch cancel
- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}

@end
