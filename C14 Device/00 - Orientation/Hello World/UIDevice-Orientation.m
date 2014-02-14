/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

// Thanks jweinberg, Emanuele Vulcano, rincewind42, Jonah Williams

#import "UIDevice-Orientation.h"
@import CoreMotion;

@implementation UIDevice (Orientation)
#pragma mark current angle
CGFloat device_angle;

- (void)parseAccelerometerData:(CMAccelerometerData *)accelerometerData
{
    CMAcceleration acceleration = accelerometerData.acceleration;
	CGFloat xx = acceleration.x;
	CGFloat yy = -acceleration.y;
	device_angle = M_PI / 2.0f - atan2(yy, xx);
    
    if (device_angle > M_PI)
        device_angle -= 2 * M_PI;
	
}

- (CGFloat)orientationAngle
{
#if TARGET_IPHONE_SIMULATOR
	switch (self.orientation)
	{
		case UIDeviceOrientationPortrait: 
			return 0.0f;
		case UIDeviceOrientationPortraitUpsideDown:
			return M_PI;
		case UIDeviceOrientationLandscapeLeft: 
			return -(M_PI/2.0f);
		case UIDeviceOrientationLandscapeRight: 
			return (M_PI/2.0f);
		default:
			return 0.0f;
	}
#else
    CMMotionManager * motionManager = [[CMMotionManager alloc] init];
    motionManager.accelerometerUpdateInterval = 0.005;
    [motionManager startAccelerometerUpdates];
    
    // This sleep is a bit of a hack to wait for an update to arrive.  Maintaining
    // the orientation angle method inside the category makes other more natural solutions not viable without
    // a bit more heavy lifting (using the block-based accelerometer method, using semaphores and
    // and some creative dispatching to handle the block synchronously on the main thread and return the
    // the orientationAngle directly without blocking or deadlocking).
    [NSThread sleepForTimeInterval:0.1];
    CMAccelerometerData * data = motionManager.accelerometerData;
    [self parseAccelerometerData:data];
    
    [motionManager stopAccelerometerUpdates];
	return device_angle;
#endif
}

// Limited to the four portrait/landscape options
- (UIDeviceOrientation)acceleratorBasedOrientation
{
    CGFloat baseAngle = self.orientationAngle;
    if ((baseAngle > -M_PI_4) && (baseAngle < M_PI_4))
        return UIDeviceOrientationPortrait;
    if ((baseAngle < -M_PI_4) && (baseAngle > -3 * M_PI_4))
        return UIDeviceOrientationLandscapeLeft;
    if ((baseAngle > M_PI_4) && (baseAngle < 3 * M_PI_4))
        return UIDeviceOrientationLandscapeRight;
    return UIDeviceOrientationPortraitUpsideDown;
}

#pragma mark relative orientation

// Thanks Jonah Williams
- (CGFloat)orientationAngleRelativeToOrientation:(UIDeviceOrientation)someOrientation
{
 	CGFloat dOrientation = 0.0f;
	switch (someOrientation)
	{
		case UIDeviceOrientationPortraitUpsideDown: {dOrientation = M_PI; break;}
		case UIDeviceOrientationLandscapeLeft: {dOrientation = -(M_PI/2.0f); break;}
		case UIDeviceOrientationLandscapeRight: {dOrientation = (M_PI/2.0f); break;}
		default: break;
	}
	
	CGFloat adjustedAngle = fmod(self.orientationAngle - dOrientation, 2.0f * M_PI);
	if (adjustedAngle > (M_PI + 0.01f)) 
        adjustedAngle = (adjustedAngle - 2.0f * M_PI);
	return adjustedAngle;
}

#pragma mark basic orientation from UIDevice's orientation

- (BOOL)isLandscape
{
	return UIDeviceOrientationIsLandscape(self.orientation);
}

- (BOOL)isPortrait
{
	return UIDeviceOrientationIsPortrait(self.orientation);
}

// Transform to real world-readable string for arbitrary orientation
+ (NSString *)orientationString:(UIDeviceOrientation)orientation
{
	switch (orientation)
	{
		case UIDeviceOrientationUnknown: return @"Unknown";
		case UIDeviceOrientationPortrait: return @"Portrait";
		case UIDeviceOrientationPortraitUpsideDown: return @"Portrait Upside Down";
		case UIDeviceOrientationLandscapeLeft: return @"Landscape Left";
		case UIDeviceOrientationLandscapeRight: return @"Landscape Right";
		case UIDeviceOrientationFaceUp: return @"Face Up";
		case UIDeviceOrientationFaceDown: return @"Face Down";
		default: break;
	}
	return nil;
}

// String for current orientaiton
- (NSString *)orientationString
{
    return [UIDevice orientationString:self.orientation];
}
@end