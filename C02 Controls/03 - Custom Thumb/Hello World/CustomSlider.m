/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CustomSlider.h"
#import "Thumb.h"

@implementation CustomSlider
{
    float previousValue;
}

// Update the thumb images as needed
- (void)updateThumb
{
	// Only update the thumb when registering significant changes, i.e. 10%
	if ((self.value < 0.98) && (ABS(self.value - previousValue) < 0.1f)) return;
	
	// create a new custom thumb image and use it for the highlighted state
    UIImage *customimg = thumbWithLevel(self.value);
	[self setThumbImage: customimg forState: UIControlStateHighlighted];
	previousValue = self.value;
}

// Expand the slider to accommodate the bigger thumb
- (void)startDrag:(UISlider *)aSlider
{
	self.frame = CGRectInset(self.frame, 0.0f, -30.0f);
}

// At release, shrink the frame back to normal
- (void)endDrag:(UISlider *)aSlider
{
    self.frame = CGRectInset(self.frame, 0.0f, 30.0f);
}

- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        // Initialize slider settings
        previousValue = CGFLOAT_MIN;
        self.value = 0.0f;
        
        [self setThumbImage:simpleThumb() forState:UIControlStateNormal];
        
        // Create the callbacks for touch, move, and release
        [self addTarget:self action:@selector(startDrag:) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(updateThumb) forControlEvents:UIControlEventValueChanged];
        [self addTarget:self action:@selector(endDrag:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    
    return self;
}

+ (id)slider
{
    CustomSlider *slider = [[CustomSlider alloc] initWithFrame:(CGRect){.size=CGSizeMake(200.0f, 40.0f)}];
    
    return slider;
}
@end
