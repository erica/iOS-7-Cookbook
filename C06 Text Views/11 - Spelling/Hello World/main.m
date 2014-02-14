/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#define BARBUTTON(TITLE, SELECTOR) [[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]

#define DATAPATH [NSHomeDirectory() stringByAppendingFormat:@"/Library/data.txt"]


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UITextViewDelegate>
@end

@implementation TestBedViewController
{
	UITextView *textView;
	UIToolbar *toolbar;
    
    UITextChecker *textChecker;
	int textOffset;
    
    NSArray *currentVerticalConstraints;
}

// Find the next error
- (void)nextMisspelling:(id)sender
{
	if (![textView isFirstResponder])
		[textView becomeFirstResponder];
    
	NSRange entireRange = NSMakeRange(0, textView.text.length);
	NSRange range = [textChecker rangeOfMisspelledWordInString:textView.text range:entireRange startingAt:textOffset wrap:YES language:@"en"];
    
	if (range.location != NSNotFound)
    {
		textOffset = range.location + range.length;
        textView.selectedRange = range;
    }
	else
		textOffset = 0;
}

// Store data out to file
- (void)archiveData
{
	[textView.text writeToFile:DATAPATH atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

// Update the undo and redo button states
- (void)textViewDidChange:(UITextView *)textView
{
	[self loadAccessoryView];
}

// Choose which items to enable and disable on the toolbar
- (void)loadAccessoryView
{
	NSMutableArray *items = [NSMutableArray array];
	UIBarButtonItem *spacer = SYSBARBUTTON(UIBarButtonSystemItemFixedSpace, nil);
	spacer.width = 40.0f;
    
	BOOL canUndo = [textView.undoManager canUndo];
    UIBarButtonItem *undoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, textView.undoManager, @selector(undo));
    undoItem.enabled = canUndo;
    [items addObject:undoItem];
	[items addObject:spacer];
    
	BOOL canRedo = [textView.undoManager canRedo];
    UIBarButtonItem *redoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, textView.undoManager, @selector(redo));
    redoItem.enabled = canRedo;
    [items addObject:redoItem];
	[items addObject:spacer];
    
	[items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:BARBUTTON(@"Done", @selector(leaveKeyboardMode))];
    
	toolbar.items = items;
}

// Returns a plain accessory view
- (UIToolbar *)accessoryView
{
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 44.0f)];
	toolbar.tintColor = [UIColor darkGrayColor];
	return toolbar;
}

// Respond to the two accessory buttons
- (void)leaveKeyboardMode { [textView resignFirstResponder];	[self archiveData];}
- (void)clearText { [textView setText:@""]; }

// Check for use of hardware keyboard
- (BOOL) isUsingHardwareKeyboard:(CGRect)kbounds
{
	CGFloat startPoint = toolbar.superview.frame.origin.y;
	CGFloat endHeight = startPoint + kbounds.size.height;
	CGFloat viewHeight = self.view.window.frame.size.height;
	BOOL usingHardwareKeyboard = endHeight > viewHeight;
    return usingHardwareKeyboard;
}

// Update TextView Height
- (void)adjustToBottomInset:(CGFloat)offset
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
    currentVerticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(>=0)]-bottomMargin-|" options:0 metrics:@{@"bottomMargin":@(offset)} views:@{@"textView":textView}];
    [self.view addConstraints:currentVerticalConstraints];
}

// Respond to Keyboard Frame Changes
- (void)updateTextViewBounds:(NSNotification *)notification
{
	if (![textView isFirstResponder])	 // no keyboard
	{
        [self adjustToBottomInset:0.0f];
        return;
	}
    
	CGRect kbounds;
	[(NSValue *)[notification.userInfo objectForKey:@"UIKeyboardBoundsUserInfoKey"] getValue:&kbounds];
    
    BOOL isUsingHardware = [self isUsingHardwareKeyboard:kbounds];
    [self adjustToBottomInset: (isUsingHardware) ? toolbar.bounds.size.height: kbounds.size.height];
    [self loadAccessoryView];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create text view
    textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set its basic properties
	textView.font = [UIFont fontWithName:@"Georgia" size:(IS_IPAD) ? 24.0f : 14.0f];
    textView.inputAccessoryView = [self accessoryView];
    textView.delegate = self;
    
    // Add and constrain the view
    [self.view addSubview:textView];
    CONSTRAIN(self.view, textView, @"H:|[textView(>=0)]|");
    [self adjustToBottomInset:0.0f];
    
    // Load any existing string
    if ([[NSFileManager defaultManager] fileExistsAtPath:DATAPATH])
    {
        NSString *string = [NSString stringWithContentsOfFile:DATAPATH encoding:NSUTF8StringEncoding error:nil];
		textView.text = string;
    }
    
    // Subscribe to keyboard changes
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextViewBounds:) name:UIKeyboardDidChangeFrameNotification object:nil];
    
    textChecker = [[UITextChecker alloc] init];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Next Misspelling", @selector(nextMisspelling:));
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
