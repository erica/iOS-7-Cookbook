/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import CoreMotion;

@interface UIDevice (Orientation) 
- (float)orientationAngleRelativeToOrientation:(UIDeviceOrientation)someOrientation;
+ (NSString *)orientationString:(UIDeviceOrientation)orientation;

@property (nonatomic, readonly) BOOL isLandscape;
@property (nonatomic, readonly) BOOL isPortrait;
@property (nonatomic, readonly) NSString *orientationString;
@property (nonatomic, readonly) float orientationAngle;
@property (nonatomic, readonly) UIDeviceOrientation acceleratorBasedOrientation;

@end
