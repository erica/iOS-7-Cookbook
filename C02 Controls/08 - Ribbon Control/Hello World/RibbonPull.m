/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "RibbonPull.h"
@import AudioToolbox;

// Return the alpha byte offset
static NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 0;}

// Return a byte array of image
NSData *getBitmapFromImage (UIImage *sourceImage)
{
    if (!sourceImage) return nil;
    
    // Establish color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        NSLog(@"Error creating RGB color space");
        return nil;
    }
    
    // Establish context
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, (CGBitmapInfo) kCGImageAlphaPremultipliedFirst);
    CGColorSpaceRelease(colorSpace );
    if (context == NULL)
    {
        NSLog(@"Error creating context");
        return nil;
    }
    
    // Draw source into context bytes
    CGRect rect = (CGRect){.size = sourceImage.size};
    CGContextDrawImage(context, rect, sourceImage.CGImage);
    
    // Create NSData from bytes
    NSData *data = [NSData dataWithBytes:CGBitmapContextGetData(context) length:(width * height * 4)];
    CGContextRelease(context);
    
    return data;
}

@implementation RibbonPull
{
    NSData *ribbonData;
    UIImage *ribbonImage;
    UIImageView *pullImageView;
    CGPoint touchDownPoint;
    int wiggleCount;
    UIMotionEffectGroup *motionEffectsGroup;
}

#pragma mark - Object / View initialization

- (instancetype)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
    if (self)
    {
        CGRect f = aFrame;
        f.size = self.intrinsicContentSize;
        self.frame = f;
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = YES;
        
        ribbonImage = [UIImage imageNamed:@"Ribbon.png"];
        ribbonData = getBitmapFromImage(ribbonImage);
        
        pullImageView = [[UIImageView alloc] initWithImage:ribbonImage];
        pullImageView.frame = CGRectMake(10.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
        
        // Add accelerometer-based movement effects
        [self startMotionEffects];
        
        // Initialize a wiggle count to draw attention to the control
        wiggleCount = 0;
        
        [self addSubview:pullImageView];
        [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0f];
    }
    return self;
}


- (CGSize)intrinsicContentSize
{
    return CGSizeMake(80.0f, 175.0f);
}


#pragma mark - Discoverability

- (void)startMotionEffects
{
    UIInterpolatingMotionEffect * motionEffectX = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    UIInterpolatingMotionEffect * motionEffectY = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    motionEffectX.minimumRelativeValue = @-15.0;
    motionEffectX.maximumRelativeValue = @15.0;
    motionEffectY.minimumRelativeValue = @-15.0;
    motionEffectY.maximumRelativeValue = @15.0;
    motionEffectsGroup = [[UIMotionEffectGroup alloc] init];
    motionEffectsGroup.motionEffects = @[motionEffectX, motionEffectY];
    [pullImageView addMotionEffect:motionEffectsGroup];
}

- (void)stopMotionEffects
{
    [pullImageView removeMotionEffect:motionEffectsGroup];
    motionEffectsGroup = nil;
}

- (void)wiggle
{
    if (++wiggleCount > 3) return;
    [self stopMotionEffects];
    [UIView animateWithDuration:0.25f animations:^(){
        pullImageView.center = CGPointMake(pullImageView.center.x, pullImageView.center.y + 10.0f);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.25f animations:^(){
            pullImageView.center = CGPointMake(pullImageView.center.x, pullImageView.center.y - 10.0f);
        } completion:^(BOOL finished) {
            [self startMotionEffects];
        }];
    }];
    
    [self performSelector:@selector(wiggle) withObject:nil afterDelay:4.0f];
}


#pragma mark - Audio Effects

void _systemSoundDidComplete(SystemSoundID ssID, void *clientData)
{
    AudioServicesDisposeSystemSoundID(ssID);
}

- (void)playClick
{
    NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"click" ofType:@"wav"];
    CFURLRef baseURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndpath]);
    
    SystemSoundID sysSound;
    AudioServicesCreateSystemSoundID(baseURL, &sysSound);
    CFRelease(baseURL);
    
    AudioServicesAddSystemSoundCompletion(sysSound, NULL, NULL, _systemSoundDidComplete, NULL);
	AudioServicesPlaySystemSound(sysSound);
}


#pragma mark - Touch Tracking

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    Byte *bytes = (Byte *) ribbonData.bytes;
    
	// Establish touch down event
	CGPoint touchPoint = [touch locationInView:self];
    CGPoint ribbonPoint = [touch locationInView:pullImageView];
    
    uint offset = alphaOffset(ribbonPoint.x, ribbonPoint.y, pullImageView.bounds.size.width);
    
    // Test for containment and alpha
    if (CGRectContainsPoint(pullImageView.frame, touchPoint) &&
        (bytes[offset] > 85))
    {
        [self sendActionsForControlEvents:UIControlEventTouchDown];
        touchDownPoint = touchPoint;
        return YES;
    }
    
    return NO;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    // Once the user has figured this out, don't wiggle any more
    wiggleCount = CGFLOAT_MAX;
    
    CGPoint touchPoint = [touch locationInView:self];
	if (CGRectContainsPoint(self.frame, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchDragInside];
    else 
        [self sendActionsForControlEvents:UIControlEventTouchDragOutside];
    
    // Adjust art
    CGFloat dy = MAX(touchPoint.y - touchDownPoint.y, 0.0f);
    dy = MIN(dy, self.bounds.size.height - 75.0f);
    
    pullImageView.frame = CGRectMake(10.0f, dy + 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
    
    // Detect if travel has been sufficient to trigger everything
    if (dy > 75.0f)
    {
        [self playClick];
        [UIView animateWithDuration:0.3f animations:^(){
            pullImageView.frame = CGRectMake(10.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
        } completion:^(BOOL finished){
            [self sendActionsForControlEvents:UIControlEventValueChanged];
        }];
        return NO; 
    }

	return YES;
}

- (void)endTrackingWithTouch: (UITouch *)touch withEvent:(UIEvent *)event
{
    // Test if touch ended inside or outside
    CGPoint touchPoint = [touch locationInView:self];
    if (CGRectContainsPoint(self.bounds, touchPoint))
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    else 
        [self sendActionsForControlEvents:UIControlEventTouchUpOutside];
    
    [UIView animateWithDuration:0.3f animations:^(){
        pullImageView.frame = CGRectMake(10.0f, 75.0f - ribbonImage.size.height, ribbonImage.size.width, ribbonImage.size.height);
    }];
}


- (void)cancelTrackingWithEvent:(UIEvent *)event
{
	[self sendActionsForControlEvents:UIControlEventTouchCancel];
}
@end
