/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;

@interface CircleLayout : UICollectionViewFlowLayout
- (void) rotateBy: (CGFloat) theta; // intermediate
- (void) rotateTo: (CGFloat) theta; // finished
- (void) scaleTo: (CGFloat) factor;
@end
