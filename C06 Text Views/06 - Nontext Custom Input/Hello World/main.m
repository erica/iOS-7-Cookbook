/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - FirstReesponderUtility 

@interface UIView (FirstResponderUtility)
+ (UIView *)currentResponder;
@end

@implementation UIView (FirstResponderUtility)

- (UIView *)findFirstResponder
{
	if ([self isFirstResponder]) return self;
	
	for (UIView *view in self.subviews)
	{
		UIView *fr = [view findFirstResponder];
		if (fr) return fr;
	}
	return nil;
}

+ (UIView *)currentResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    return [keyWindow findFirstResponder];
}

@end


#pragma mark - ColorView

@interface ColorView : UIView 
@property (strong) UIView *inputView;
@end

@implementation ColorView

// UITextInput protocol
- (BOOL)hasText {return NO;}
- (void)insertText:(NSString *)text {}
- (void)deleteBackward {}

// First responder support
- (BOOL)canBecomeFirstResponder {return YES;}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {[self becomeFirstResponder];}

// Initialize with user interaction allowed
- (instancetype)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame:aFrame];
    if (self)
    {
        self.backgroundColor = COOKBOOK_PURPLE_COLOR;
        self.userInteractionEnabled = YES;
    }
	return self;
}

@end


#pragma mark - InputToolbar

@interface InputToolbar : UIToolbar <UIInputViewAudioFeedback>
@end

@implementation InputToolbar

- (BOOL)enableInputClicksWhenVisible
{
    return YES;
}

- (void)updateColor:(UIColor *)aColor
{
 	[UIView currentResponder].backgroundColor = aColor;
    [[UIDevice currentDevice] playInputClick];
}

// Color change options
- (void)light:(id)sender {
	[self updateColor:[COOKBOOK_PURPLE_COLOR colorWithAlphaComponent:0.33f]];}
- (void)medium:(id)sender {
	[self updateColor:[COOKBOOK_PURPLE_COLOR colorWithAlphaComponent:0.66f]];}
- (void)dark:(id)sender {
	[self updateColor:COOKBOOK_PURPLE_COLOR];}

// Resign first responder on Done
- (void)done:(id)sender
{
	[[UIView currentResponder] resignFirstResponder];
}

- (instancetype)initWithFrame:(CGRect)aFrame
{
	self = [super initWithFrame: aFrame];
	
    if (self)
    {
        NSMutableArray *theItems = [NSMutableArray array];
        [theItems addObject:BARBUTTON(@"Light", @selector(light:))];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
        [theItems addObject:BARBUTTON(@"Medium", @selector(medium:))];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
        [theItems addObject:BARBUTTON(@"Dark", @selector(dark:))];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
        [theItems addObject:BARBUTTON(@"Done", @selector(done:))];
        self.items = theItems;
	}
	return self;
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    ColorView *colorView;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
	InputToolbar *itb = [[InputToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
    
	colorView = [[ColorView alloc] initWithFrame:CGRectZero];
	colorView.inputView = itb;
    colorView.translatesAutoresizingMaskIntoConstraints = NO;
    colorView.userInteractionEnabled = YES;
    [self.view addSubview:colorView];
    CONSTRAIN(self.view, colorView, @"V:|-40-[colorView(>=0)]-120-|");
    CONSTRAIN(self.view, colorView, @"H:|-40-[colorView(>=0)]-40-|");
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
