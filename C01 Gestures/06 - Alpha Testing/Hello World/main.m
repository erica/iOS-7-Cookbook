/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - Helper Functions

// Return the alpha byte offset
static NSUInteger alphaOffset(NSUInteger x, NSUInteger y, NSUInteger w){return y * w * 4 + x * 4 + 0;}



// Return a byte array of image
NSData *getBitmapFromImage(UIImage *sourceImage)
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


#pragma mark - DragView

@interface DragView : UIImageView
@end

@implementation DragView
{
    CGPoint previousLocation;
    NSData * data;
}

- (instancetype)initWithImage:(UIImage *)anImage
{
    self = [super initWithImage:anImage];
    if (self)
    {
        self.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        self.gestureRecognizers = @[panRecognizer];
        data = getBitmapFromImage(anImage);
    }
    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	if (!CGRectContainsPoint(self.bounds, point)) return NO;
    
    Byte *bytes = (Byte *) data.bytes;
    uint offset = alphaOffset(point.x, point.y, self.image.size.width);
    return (bytes[offset] > 85);
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Promote the touched view
    [self.superview bringSubviewToFront:self];
    
    // Remember original location
    previousLocation = self.center;
}

- (void)handlePan:(UIPanGestureRecognizer *)uigr
{
	CGPoint translation = [uigr translationInView:self.superview];
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
@property (nonatomic, strong) UIView *bgView;
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Provide a "Randomize" button
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Randomize", @selector(layoutFlowers));
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bgView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.bgView];
    
    NSUInteger maxFlowers = 12; // number of flowers to add
    NSArray *flowerArray = @[@"blueFlower.png", @"pinkFlower.png", @"orangeFlower.png"];
    
    // Add the flowers
	for (NSUInteger i = 0; i < maxFlowers; i++)
	{
		NSString *whichFlower = [flowerArray objectAtIndex:(random() % flowerArray.count)];
		DragView *flowerDragger = [[DragView alloc] initWithImage:[UIImage imageNamed:whichFlower]];
		[self.bgView addSubview:flowerDragger];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.bgView.frame = CGRectInset(self.view.bounds, 0.0f, 0.0f); // full frame
    [self layoutFlowers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.bgView.frame = CGRectInset(self.view.bounds, 64.0f, 64.0f);
    
    // Check for any off-screen flowers and move them into place
    
    CGFloat halfFlower = 32.0f;
    CGRect targetRect = CGRectInset(self.bgView.bounds, halfFlower * 2, halfFlower * 2);
    targetRect = CGRectOffset(targetRect, halfFlower, halfFlower);
    
    for (UIView *flowerDragger in self.bgView.subviews)
    {
        if (!CGRectContainsPoint(targetRect, flowerDragger.center))
        {
            [UIView animateWithDuration:0.3f animations:
             ^(){flowerDragger.center = [self randomFlowerPosition];}];
        }
    }
}

- (CGPoint)randomFlowerPosition
{
    CGFloat halfFlower = 32.0f; // half of the size of the flower
    
    // The flower must be placed fully within the view. Inset accordingly
    CGSize insetSize = CGRectInset(self.bgView.bounds, 2*halfFlower, 2*halfFlower).size;
    
    // Return a random position within the inset bounds
    CGFloat randomX = random() % ((int)insetSize.width) + halfFlower;
    CGFloat randomY = random() % ((int)insetSize.height) + halfFlower;
    return CGPointMake(randomX, randomY);
}

- (void)layoutFlowers
{
    // Move every flower into a new random place
    [UIView animateWithDuration:0.3f animations: ^(){
        for (UIView *flowerDragger in self.bgView.subviews)
        {
            flowerDragger.center = [self randomFlowerPosition];
        }
    }];
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
