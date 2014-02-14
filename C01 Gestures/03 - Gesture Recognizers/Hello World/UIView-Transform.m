/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "UIView-Transform.h"

// e.g. NSLog(@"Xscale: %f YScale: %f Rotation: %f", self.xscale, self.yscale, self.rotation * (180 / M_PI));

@implementation UIView (Transform)

- (CGFloat)scaleX
{
    CGAffineTransform t = self.transform;
    return sqrt(t.a * t.a + t.c * t.c);
}

- (CGFloat)scaleY
{
    CGAffineTransform t = self.transform;
    return sqrt(t.b * t.b + t.d * t.d);
}

- (CGFloat)rotation
{
    CGAffineTransform t = self.transform;
    return atan2f(t.b, t.a); 
}

@end
