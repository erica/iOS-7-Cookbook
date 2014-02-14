/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "UIBezierPath+Points.h"
#import "Geometry.h"
#import "Utility.h"


#define SHOWDEBUG YES

// Calculate and return least bounding rectangle
#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]


#pragma mark - Helper Functions

CGRect boundingRect(NSArray *points)
{
    CGRect rect = CGRectZero;
    CGRect ptRect;
    
    for (NSUInteger i = 0; i < points.count; i++)
    {
        CGPoint pt = POINT(i);
        ptRect = CGRectMake(pt.x, pt.y, 0.0f, 0.0f);
        rect = (CGRectEqualToRect(rect, CGRectZero)) ? ptRect : CGRectUnion(rect, ptRect);
    }
    return rect;
}

CGRect testForCircle(NSArray *points, NSDate *firstTouchDate)
{
    if (points.count < 2)
    {
        if (SHOWDEBUG) NSLog(@"Too few points (2) for circle");
        return CGRectZero;
    }
    
    // Test 1: duration tolerance
    float duration = [[NSDate date] timeIntervalSinceDate:firstTouchDate];
    if (SHOWDEBUG) NSLog(@"Transit duration: %0.2f", duration);
    
    float maxDuration = 2.0f;
    if (duration > maxDuration) // allows longer time for use in simulator
    {
        if (SHOWDEBUG) NSLog(@"Excessive touch duration: %0.2f seconds vs %0.1f seconds", duration, maxDuration);
        return CGRectZero;
    }
    
    // Test 2: The number of direction changes should be limited to near 4
    int inflections = 0;
    for (NSUInteger i = 2; i < (points.count - 1); i++)
    {
        float deltx = dx(POINT(i), POINT(i-1));
        float delty = dy(POINT(i), POINT(i-1));
        float px = dx(POINT(i-1), POINT(i-2));
        float py = dy(POINT(i-1), POINT(i-2));
        
        if ((sign(deltx) != sign(px)) || (sign(delty) != sign(py)))
            inflections++;
    }
    
    if (inflections > 5)
    {
        if (SHOWDEBUG) NSLog(@"Excessive number of inflections (%d vs 4). Fail.", inflections);
        return CGRectZero;
    }
    
    // Test 3: The start and end points must be between some number of points of each other
    float tolerance = [[[UIApplication sharedApplication] keyWindow] bounds].size.width / 3.0f;
    if (distance(POINT(0), POINT(points.count - 1)) > tolerance)
    {
        if (SHOWDEBUG) NSLog(@"Start and end points too far apart. Fail.");
        return CGRectZero;
    }
    
    // Test 4: Count the distance traveled in degrees.
    CGRect circle = boundingRect(points);
    CGPoint center = GEORectGetCenter(circle);
    float distance = ABS(acos(dotproduct(pointWithOrigin(POINT(0), center), pointWithOrigin(POINT(1), center))));
    for (NSUInteger i = 1; i < (points.count - 1); i++)
        distance += ABS(acos(dotproduct(pointWithOrigin(POINT(i), center), pointWithOrigin(POINT(i+1), center))));
    
    float transitTolerance = distance - 2 * M_PI;
    
    if (transitTolerance < 0.0f) // fell short of 2 PI
    {
        if (transitTolerance < - (M_PI / 4.0f)) // 45 degrees or more
        {
            if (SHOWDEBUG) NSLog(@"Transit was too short, under 315 degrees");
            return CGRectZero;
        }
    }
    
    if (transitTolerance > M_PI) // additional 180 degrees
    {
        if (SHOWDEBUG) NSLog(@"Transit was too long, over 540 degrees");
        return CGRectZero;
    }
    
    return circle;
}


#pragma mark - TouchTrackerView

@interface TouchTrackerView : UIView
- (void) clear;
@end

@implementation TouchTrackerView
{
    UIBezierPath *path;
    NSDate *firstTouchDate;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.multipleTouchEnabled = NO;
    }
    return self;
}

- (void)clear
{
    path = nil;
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    path = [UIBezierPath bezierPath];
    path.lineWidth = IS_IPAD? 8.0f : 4.0f;
    
    UITouch *touch = [touches anyObject];
    [path moveToPoint:[touch locationInView:self]];
    
    firstTouchDate = [NSDate date];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    [path addLineToPoint:[touch locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawRect:(CGRect)rect
{
    [COOKBOOK_PURPLE_COLOR set];
    [path stroke];
    
    NSArray * points = [path points];
    CGRect circle = testForCircle(points, firstTouchDate);
    if (!CGRectEqualToRect(CGRectZero, circle))
    {
        [[UIColor redColor] set];
        UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:circle];
        circlePath.lineWidth = 6.0f;
        [circlePath stroke];
        
        CGRect  centerBit = GEORectAroundCenter(GEORectGetCenter(circle), 4.0f, 4.0f);
        UIBezierPath *centerPath = [UIBezierPath bezierPathWithOvalInRect:centerBit];
        [centerPath fill];
    }
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[TouchTrackerView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self clear];
}

- (void)clear
{
    [(TouchTrackerView *)self.view clear];
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
