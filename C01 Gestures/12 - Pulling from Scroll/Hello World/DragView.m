/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "DragView.h"

@implementation DragView
{
    CGPoint previousLocation;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
    self = [super initWithImage:anImage];
    if (self)
	{
		self.userInteractionEnabled = YES;
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
		self.gestureRecognizers = @[pan];
	}
	return self;
}

// Promote touched view
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self.superview bringSubviewToFront:self];
	previousLocation = self.center;
}

// Move view
- (void)handlePan:(UIPanGestureRecognizer *)uigr
{
	CGPoint translation = [uigr translationInView:self.superview];
	self.center = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
	
}

@end
