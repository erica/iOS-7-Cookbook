/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

const NSUInteger kMaxCircles = 12;
const NSInteger kInsetAmount = 4;
const CGFloat kHalfCircle = 48.0f;
const CGFloat kSideLength = 96.0f;


#pragma mark - DragView

@interface DragView : UIImageView
@end

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
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	CGPoint pt;
	float halfSide = kSideLength / 2.0f;
	
	// normalize with centered origin
	pt.x = (point.x - halfSide) / halfSide;
	pt.y = (point.y - halfSide) / halfSide;
	
	// x^2 + y^2 = radius
	float xsquared = pt.x * pt.x;
	float ysquared = pt.y * pt.y;
	
	// If the radius < 1, the point is within the clipped circle
	if ((xsquared + ysquared) < 1.0) return YES;
	return NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    previousLocation = self.center;
}

- (void)handlePan:(UIPanGestureRecognizer *)gestureRecognizer
{
	CGPoint translation = [gestureRecognizer translationInView:self.superview];
	CGPoint newcenter = CGPointMake(previousLocation.x + translation.x, previousLocation.y + translation.y);
	
	// Bound movement into parent bounds
	float halfx = CGRectGetMidX(self.bounds);
	newcenter.x = MAX(halfx, newcenter.x);
	newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
	
	float halfy = CGRectGetMidY(self.bounds);
	newcenter.y = MAX(halfy, newcenter.y);
	newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
	
	// Set new location
	self.center = newcenter;
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

#define RANDOMLEVEL	((random() % 128) / 256.0f)

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor blackColor];
    
    // Add the circles to random points on the screen
    for (NSUInteger i = 0; i < kMaxCircles; i++)
    {
        DragView *dragger = [[DragView alloc] initWithImage:[self createImage]];
        dragger.center = [self randomPosition:self.interfaceOrientation];
        dragger.tag = 100 + i;
        //dragger.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:dragger];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [UIView animateWithDuration:duration animations:^{
        for (NSUInteger i = 0; i < kMaxCircles; i++)
        {
            DragView *dragger = (DragView *) [self.view viewWithTag:100 + i];
            dragger.center = [self randomPosition:toInterfaceOrientation];
        }
    }];
}

- (UIImage *)createImage
{
	UIColor *color = [UIColor colorWithRed:RANDOMLEVEL green:RANDOMLEVEL blue:RANDOMLEVEL alpha:1.0f];
    
    CGSize size = CGSizeMake(kSideLength, kSideLength);
	CGRect rect = (CGRect){.size = size};
    
	UIGraphicsBeginImageContext(size);
    
	// Create a filled ellipse
	[color setFill];
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
    [path fill];
	
	// Outline the circle a couple of times
    [[UIColor whiteColor] setStroke];
    path = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, kInsetAmount, kInsetAmount)];
    [path appendPath:[UIBezierPath bezierPathWithOvalInRect:CGRectInset(rect, 2*kInsetAmount, 2*kInsetAmount)]];
    [path stroke];
	
	UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return theImage;
}

// Updated for orientation sensitivity, per request by Antoine
- (CGPoint)randomPosition:(UIInterfaceOrientation)orientation
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    CGFloat max = fmaxf(rect.size.width, rect.size.height);
    CGFloat min = fminf(rect.size.width, rect.size.height);
    
    CGFloat destw = min;
    CGFloat desth = max;
    if (UIInterfaceOrientationIsLandscape(orientation)) {destw = max; desth = min;}
    
    
    CGFloat x = random() % ((int)(destw - 2 * kHalfCircle)) + kHalfCircle;
    CGFloat y = random() % ((int)(desth - 2 * kHalfCircle)) + kHalfCircle;
    return CGPointMake(x, y);
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end


#pragma mark - main

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}
