/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "PullView.h"
#import "DragView.h"


// Pull-out-an-Image View for use in scroll view

#define DX(p1, p2)	(p2.x - p1.x)
#define DY(p1, p2)	(p2.y - p1.y)

const NSInteger kSwipeDragMin = 16;
const NSInteger kDragLimitMax = 12;

typedef enum {
	TouchUnknown,
	TouchSwipeLeft,
	TouchSwipeRight,
	TouchSwipeUp,
	TouchSwipeDown,
} SwipeTypes;

@implementation PullView
{
    DragView * dragView;
    BOOL gestureWasHandled;
    int pointCount;
    CGPoint startPoint;
    NSUInteger touchType;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
	self = [super initWithImage:anImage];
	if (self)
    {
		self.userInteractionEnabled = YES;
		UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        pan.delegate = self;
		self.gestureRecognizers = @[pan];
	}
	return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
	// Only deal with scroll view superviews
	if (![self.superview isKindOfClass:[UIScrollView class]]) return;
    
	// Extract super views
	UIView *supersuper = self.superview.superview;
	UIScrollView *scrollView = (UIScrollView *) self.superview;
	
	// Calculate location of touch
	CGPoint touchLocation = [gestureRecognizer locationInView:supersuper];
	
	if (gestureRecognizer.state == UIGestureRecognizerStateBegan) 
	{
		// Initialize recognizer
		gestureWasHandled = NO;
		pointCount = 1;
		startPoint = touchLocation;
	}
	
    if (gestureRecognizer.state == UIGestureRecognizerStateChanged) 
    {
        pointCount++;
        
        // Calculate whether a swipe has occured
        float dx = DX(touchLocation, startPoint);
        float dy = DY(touchLocation, startPoint);
        
        // Detect known swipe-types
        BOOL finished = YES;
        if ((dx > kSwipeDragMin) && (ABS(dy) < kDragLimitMax)) // hswipe left
            touchType = TouchSwipeLeft;
        else if ((-dx > kSwipeDragMin) && (ABS(dy) < kDragLimitMax)) // hswipe right
            touchType = TouchSwipeRight;
        else if ((dy > kSwipeDragMin) && (ABS(dx) < kDragLimitMax)) // vswipe up
            touchType = TouchSwipeUp;
        else if ((-dy > kSwipeDragMin) && (ABS(dx) < kDragLimitMax)) // vswipe down
            touchType = TouchSwipeDown;
        else
            finished = NO;
        
        // If unhandled and a downward swipe, produce a new draggable view
        if (!gestureWasHandled && finished && (touchType == TouchSwipeDown))
        {
            dragView = [[DragView alloc] initWithImage:self.image];
            dragView.center = touchLocation;
            dragView.backgroundColor = [UIColor clearColor];
            [supersuper addSubview:dragView];
            scrollView.scrollEnabled = NO;
            gestureWasHandled = YES;
        }
        else if (gestureWasHandled)
        {
            // allow continued dragging after detection
            dragView.center = touchLocation;
        }
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        // ensure that the scroll view returns to scrollable
        if (gestureWasHandled)
            scrollView.scrollEnabled = YES;
    }
}

@end 



