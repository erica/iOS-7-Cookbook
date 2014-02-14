/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

@interface KeyboardSpacingView : UIView
@end

@implementation KeyboardSpacingView
{
    NSLayoutConstraint *heightConstraint;
}

// Listen for keyboard
- (void)establishNotificationHandlers
{
    // Listen for keyboard appearance
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         // Fetch keyboard frame
         NSDictionary *userInfo = note.userInfo;
         NSTimeInterval  duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
         CGRect keyboardEndFrame = [self.superview convertRect:[userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.window];
         
         //Adjust to window
         CGRect windowFrame = [self.superview convertRect:self.window.frame fromView:self.window];
         CGFloat heightOffset = (windowFrame.size.height - keyboardEndFrame.origin.y) - self.superview.frame.origin.y;
         
         // Update and animate height constraint
         heightConstraint.constant = heightOffset;
         [UIView animateWithDuration:duration animations:^{
             [self.superview layoutIfNeeded];
         }];
     }];
    
    // Listen for keyboard exit
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         // Reset to zero
         NSDictionary *userInfo = note.userInfo;
         NSTimeInterval  duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
         heightConstraint.constant = 0;
         [UIView animateWithDuration:duration animations:^{
             [self.superview layoutIfNeeded];
         }];
     }];
}

// Stretch sides and bottom to superview
- (void)layoutView
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    if (!self.superview) return;
    for (NSString *constraintString in @[@"H:|[view]|", @"V:[view]|"])
    {
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:constraintString
                                options:0 metrics:nil views:@{@"view":self}];
        [self.superview addConstraints:constraints];
    }
    heightConstraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                   multiplier:1.0f constant:0.0f];
    [self addConstraint:heightConstraint];
}

+ (instancetype)installToView:(UIView *)parent
{
    if (!parent) return nil;
    KeyboardSpacingView *view = [[self alloc] init];
    [parent addSubview:view];
    
    [view layoutView];
    [view establishNotificationHandlers];
    return view;
}

@end

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    UITextView *textView;
}

- (void)leaveKeyboardMode
{
	[textView resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	textView.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
	[self.view addSubview:textView];
    PREPCONSTRAINTS(textView);
    STRETCH_VIEW_H(self.view, textView);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note)
     {
         self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(leaveKeyboardMode));
     }];
    
    //Create a spacer
    KeyboardSpacingView *spacer = [KeyboardSpacingView installToView:self.view];
    
    //Place the spacer under the text view
    CONSTRAIN_VIEWS(self.view, @"V:|[textView][spacer]|", NSDictionaryOfVariableBindings(textView, spacer));
    
    NSString * loremIpsum = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"lorem" ofType:@"txt"] encoding:NSASCIIStringEncoding error:nil];
    textView.text = loremIpsum;
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
