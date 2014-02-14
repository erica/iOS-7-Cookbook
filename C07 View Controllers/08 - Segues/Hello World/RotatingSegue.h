/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;
@class RotatingSegue;

@protocol RotatingSegueDelegate <NSObject>
- (void) segueDidComplete;
@end

// Two-way segue allows you to move in either direction
// Informal delegate sends segueDidComplete message

@interface RotatingSegue : UIStoryboardSegue
@property (assign) BOOL goesForward;
@property (assign) UIViewController <RotatingSegueDelegate> *delegate;
@end
