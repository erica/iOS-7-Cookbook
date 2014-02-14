/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - FirstResponderUtility

@interface UIView (FirstResponderUtility)
+ (UIView *)currentResponder;
@end

@implementation UIView (FirstResponderUtility)

- (UIView *)findFirstResponder
{
	if ([self isFirstResponder]) return self;
	
	for (UIView *view in self.subviews)
	{
		UIView *responder = [view findFirstResponder];
        if (responder) return responder;
	}
	return nil;
}

+ (UIView *)currentResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
	return [keyWindow findFirstResponder];
}

@end

#pragma mark - InputToolbar

@interface InputToolbar : UIToolbar
@end

@implementation InputToolbar
{
	UIView *responderView;
}

- (void)insertString:(NSString *)string
{
	if (!responderView || ![responderView isFirstResponder])
	{
		responderView = [UIView currentResponder];
		if (!responderView) return;
	}
	
	if ([responderView isKindOfClass:[UITextView class]])
    {
        UITextView *textView = (UITextView *) responderView;
        NSMutableString *text = [NSMutableString stringWithString:textView.text];
        NSRange range = textView.selectedRange;
        [text replaceCharactersInRange:range withString:string];
		textView.text = text;
        textView.selectedRange = NSMakeRange(range.location + string.length, 0);
    }
	else
		NSLog(@"Cannot insert %@ in unknown class type (%@)",
              string, [responderView class]);
}

// Perform the two insertions
- (void) hello:(id) sender {[self insertString:@"Hello "];}
- (void) world:(id) sender {[self insertString:@"World "];}

- (instancetype)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self)
    {
        NSMutableArray *theItems = [NSMutableArray array];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
        [theItems addObject:BARBUTTON(@"Hello", @selector(hello:))];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
        [theItems addObject:BARBUTTON(@"World", @selector(world:))];
        [theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
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
    UITextView *textView;
    InputToolbar *inputToolbar;
}

- (void)done:(id)sender
{
    [[UIView currentResponder] resignFirstResponder];
	self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    textView = [[UITextView alloc] init];
    textView.font = [UIFont fontWithName:@"Georgia" size:IS_IPAD ? 36.0f : 18.0f];
    [self.view addSubview:textView];
    PREPCONSTRAINTS(textView);
    STRETCH_VIEW(self.view, textView);
    
    inputToolbar = [[InputToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 44.0f)];
    textView.inputView = inputToolbar;
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardDidShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(done:));
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
