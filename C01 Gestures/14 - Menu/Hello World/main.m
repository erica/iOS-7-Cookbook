/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - DragView

@interface DragView : UIImageView
@end

@implementation DragView
{
    CGPoint startLocation;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)popSelf
{
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeScale(1.5f, 1.5f);} completion:^(BOOL done){
        [UIView animateWithDuration:0.1f animations:^(){self.transform = CGAffineTransformIdentity;}];
    }];
}

- (void)rotateSelf
{
    // This is harder than it looks
    [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeRotation(M_PI * .95);} completion:^(BOOL done){
        [UIView animateWithDuration:0.25f animations:^(){self.transform = CGAffineTransformMakeRotation(M_PI * 1.5);} completion:^(BOOL done){self.transform = CGAffineTransformIdentity;
        }];
    }];
}

- (void)ghostSelf
{
    [UIView animateWithDuration:1.25f animations:^(){self.alpha = 0.0f;} completion:^(BOOL done){
        [UIView animateWithDuration:1.25f animations:^(){} completion:^(BOOL done){
            [UIView animateWithDuration:0.5f animations:^(){self.alpha = 1.0f;}];
        }];
    }];
}

- (void)pressed:(UILongPressGestureRecognizer *)recognizer
{
    if (![self becomeFirstResponder])
    {
        NSLog(@"Could not become first responder");
        return;
    }
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    UIMenuItem *pop = [[UIMenuItem alloc] initWithTitle:@"Pop" action:@selector(popSelf)];
    UIMenuItem *rotate = [[UIMenuItem alloc] initWithTitle:@"Rotate" action:@selector(rotateSelf)];
    UIMenuItem *ghost = [[UIMenuItem alloc] initWithTitle:@"Ghost" action:@selector(ghostSelf)];
    [menu setMenuItems:@[pop, rotate, ghost]];
    
    [menu setTargetRect:self.bounds inView:self];
    menu.arrowDirection = UIMenuControllerArrowDown;
    [menu update];
    [menu setMenuVisible:YES];
}

- (instancetype)initWithImage:(UIImage *)anImage
{
	self = [super initWithImage:anImage];
    if (self)
    {
        self.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressed:)];
        [self addGestureRecognizer:pressRecognizer];
    }
	return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
	// Calculate and store offset, and pop view into front if needed
	startLocation = [[touches anyObject] locationInView:self];
	[self.superview bringSubviewToFront:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
	// Calculate offset
	CGPoint pt = [[touches anyObject] locationInView:self];
	float dx = pt.x - startLocation.x;
	float dy = pt.y - startLocation.y;
	CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
	
	// Set new location
	self.center = newcenter;
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // Provide a "Randomize" button
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Randomize", @selector(layoutFlowers));

    NSInteger maxFlowers = 12; // number of flowers to add
    NSArray *flowerArray = @[@"blueFlower.png", @"pinkFlower.png", @"orangeFlower.png"];
    
    // Add the flowers
	for (NSUInteger i = 0; i < maxFlowers; i++)
	{
		NSString *whichFlower = [flowerArray objectAtIndex:(random() % flowerArray.count)];
		DragView *flowerDragger = [[DragView alloc] initWithImage:[UIImage imageNamed:whichFlower]];
		[self.view addSubview:flowerDragger];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self layoutFlowers];
}

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Check for any off-screen flowers and move them into place
    
    CGFloat halfFlower = 32.0f;
    CGRect targetRect = CGRectInset(self.view.bounds, halfFlower * 2, halfFlower * 2);
    targetRect = CGRectOffset(targetRect, halfFlower, halfFlower);
    
    for (UIView *flowerDragger in self.view.subviews)
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
    CGSize insetSize = CGRectInset(self.view.bounds, 2*halfFlower, 2*halfFlower).size;
    
    // Return a random position within the inset bounds
    CGFloat randomX = random() % ((int)insetSize.width) + halfFlower;
    CGFloat randomY = random() % ((int)insetSize.height) + halfFlower;
    return CGPointMake(randomX, randomY);
}

- (void)layoutFlowers
{
    // Move every flower into a new random place
    [UIView animateWithDuration:0.3f animations: ^(){
        for (UIView *flowerDragger in self.view.subviews)
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
