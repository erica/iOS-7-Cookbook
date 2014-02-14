/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - KeyInputToolbar

@interface KeyInputToolbar: UIToolbar <UIKeyInput>
@end

@implementation KeyInputToolbar
{
	NSMutableString *string;
}

// Is there text available that can be deleted
- (BOOL)hasText
{
	if (!string || !string.length) return NO;
	return YES;
}

// Reload the toolbar with the string
- (void)update
{
	NSMutableArray *theItems = [NSMutableArray array];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[theItems addObject:BARBUTTON(string, @selector(becomeFirstResponder))];
	[theItems addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	
	self.items = theItems;
}

// Insert new text into the string
- (void)insertText:(NSString *)text
{
	if (!string) string = [NSMutableString string];
	[string appendString:text];
	[self update];
}

// Delete one character
- (void)deleteBackward
{
	// Super caution, even if hasText reports YES
	if (!string)
	{
		string = [NSMutableString string];
		return;
	}
	
	if (!string.length)
		return;
	
	// Remove a character
	[string deleteCharactersInRange:NSMakeRange(string.length - 1, 1)];
	[self update];
}

// When becoming first responder, send out a notification to that effect
- (BOOL)becomeFirstResponder
{
    BOOL result = [super becomeFirstResponder];
    if (result)
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"KeyInputToolbarDidBecomeFirstResponder" object:nil]];
    return result;
}

- (BOOL)canBecomeFirstResponder
{
	return YES;
}

// Do not use this in App Store code, kids. Allows you to force Hardware keyboard only interaction
/* - (void)disableOnscreenKeyboard
 {
 void *gs = dlopen("/System/Library/PrivateFrameworks/GraphicsServices.framework/GraphicsServices", RTLD_LAZY);
 int (*kb)(BOOL yorn) = (int (*)(BOOL))dlsym(gs, "GSEventSetHardwareKeyboardAttached");
 kb(YES);
 dlclose(gs);
 } */


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// [self disableOnscreenKeyboard]; // App Store unsafe
	[self becomeFirstResponder];
}
@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    KeyInputToolbar *keyInputToolbar;
}

- (void)done:(id)sender
{
    [keyInputToolbar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create the custom view
	keyInputToolbar = [[KeyInputToolbar alloc] initWithFrame:CGRectZero];
	[self.view addSubview:keyInputToolbar];

    // Set constraints
    PREPCONSTRAINTS(keyInputToolbar);
    CONSTRAIN_HEIGHT(keyInputToolbar, 44);
    STRETCH_VIEW_H(self.view, keyInputToolbar);
    ALIGN_VIEW_TOP_CONSTANT(self.view, keyInputToolbar, 60);
    
    keyInputToolbar.userInteractionEnabled = YES;
    
    // Show a "Done" button on iPhone-like interfaces when
    // the custom view becomes first responder
    [[NSNotificationCenter defaultCenter] addObserverForName:@"KeyInputToolbarDidBecomeFirstResponder" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification){
        if (!IS_IPAD)
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
