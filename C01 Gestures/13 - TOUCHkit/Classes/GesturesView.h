
#import <UIKit/UIKit.h>

@interface GesturesView : UIView

@property (nonatomic, retain) IBOutletCollection(UIGestureRecognizer) NSArray *gestureRecognizers;

@end
