/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "FlipViewController.h"
#import "Utility.h"

#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR] 

@implementation FlipViewController
{
    UINavigationBar  *navbar;
    UIButton *infoButton;
    NSArray *controllers;
    BOOL reversedOrder;
}

// Dismiss the view controller
- (void)done:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!controllers.count)
    {
        NSLog(@"Error: No root view controller");
        return;
    }
    
    // Clean up the Child View Controller
    UIViewController *currentController = (UIViewController *)controllers[0];
    [currentController willMoveToParentViewController:nil];
    [currentController.view removeFromSuperview];
    [currentController removeFromParentViewController];
}

- (void)flip:(id)sender
{
    // Please call only with two controllers;
    if (controllers.count < 2) return;

    // Determine which item is front, which is back
    UIViewController *front =  (UIViewController *)controllers[0];
    UIViewController *back =  (UIViewController *)controllers[1];
    
    // Select the transition direction
    UIViewAnimationOptions transition = reversedOrder ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight;
    
    // Hide the info button until after the flip
    infoButton.alpha = 0.0f;
    
    // Prepare the front for removal, the back for adding
    [front willMoveToParentViewController:nil];
    [self addChildViewController:back];
    
    // Perform the transition
    [self transitionFromViewController:front toViewController:back duration:0.5f options:transition animations:^{} completion:^(BOOL done){
        
        // Bring the Info button back into view
        [self.view bringSubviewToFront:infoButton];
        [UIView animateWithDuration:0.3f animations:^(){
            infoButton.alpha = 1.0f;
        }];
        
        // Finish up transition
        [front removeFromParentViewController];
        [back didMoveToParentViewController:self];
        
        reversedOrder = !reversedOrder;
        controllers = @[back, front];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!controllers.count)
    {
        NSLog(@"Error: No root view controller");
        return;
    }
    
    UIViewController *front = controllers[0];
    UIViewController *back = nil;
    if (controllers.count > 1) back = controllers[1];
    
    [self addChildViewController:front];
    [self.view addSubview:front.view];
    [front didMoveToParentViewController:self];
    
    // Check for presentation and for flippability
    BOOL isPresented = self.isBeingPresented;
    
    // Clean up instance if re-use
    if (navbar || infoButton)
    {
        [navbar removeFromSuperview];
        [infoButton removeFromSuperview];
        navbar = nil;
    }

    // When presented, add a custom navigation bar
    CGFloat navbarHeight = IS_IPHONE ? 64.0 : 44.0;
    if (isPresented)
    {
        navbar = [[UINavigationBar alloc] initWithFrame:CGRectZero];
        [self.view addSubview:navbar];
        PREPCONSTRAINTS(navbar);
        ALIGN_VIEW_TOP(self.view, navbar);
        ALIGN_VIEW_LEFT(self.view, navbar);
        ALIGN_VIEW_RIGHT(self.view, navbar);
        CONSTRAIN_HEIGHT(navbar, navbarHeight);
    }

    // Right button is done when VC is presented
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = isPresented ? SYSBARBUTTON(UIBarButtonSystemItemDone, @selector(done:)) : nil;
    
    // Populate the navigation bar
    if (navbar)
        [navbar setItems:@[self.navigationItem] animated:NO];
    
    // Layout child VC views
    // Using frame layout (vs auto layout) for the enclosing view for simplicity in the transition
    CGFloat verticalOffset = (navbar != nil) ? navbarHeight : 0.0f;
    CGRect destFrame = CGRectMake(0.0f, verticalOffset, self.view.frame.size.width, self.view.frame.size.height - verticalOffset);
    front.view.frame = destFrame;
    back.view.frame = destFrame;

    // Set up info button
    if (controllers.count < 2) return; // our work is done here
    
    // Create the "i" button
    infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight]; // Light & Dark are now the same UI
    infoButton.tintColor = [UIColor whiteColor];
    [infoButton addTarget:self action:@selector(flip:) forControlEvents:UIControlEventTouchUpInside];
    
    // Place "i" button at bottom right of view
    [self.view addSubview:infoButton];
    PREPCONSTRAINTS(infoButton);
    ALIGN_VIEW_RIGHT_CONSTANT(self.view, infoButton, -infoButton.frame.size.width);
    ALIGN_VIEW_BOTTOM_CONSTANT(self.view, infoButton, -infoButton.frame.size.height);
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
}

// Sorry. No, really. Sorry.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (controllers.count < 2) return;
    ((UIViewController *)controllers[1]).view.frame = ((UIViewController *)controllers[0]).view.frame;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (controllers.count < 2) return;
    ((UIViewController *)controllers[1]).view.frame = ((UIViewController *)controllers[0]).view.frame;
}

// Return a newly initialized flip controller
- (instancetype)initWithFrontController:(UIViewController *)front andBackController:(UIViewController *)back
{
    self = [super init];
    if (self)
    {
        if (!front)
        {
            NSLog(@"Error: Attempting to create FlipViewController without a root controller.");
            return self;
        }
        
        if (back)
            controllers = @[front, back];
        else
            controllers = @[front];
        
        reversedOrder = NO;
    }
    return self;
}
@end
