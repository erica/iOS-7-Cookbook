/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#define DATAPATH [NSHomeDirectory() stringByAppendingFormat:@"/Library/data.txt"]
#define SYSBARBUTTON(ITEM, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:self action:SELECTOR]
#define SYSBARBUTTON_TARGET(ITEM, TARGET, SELECTOR) [[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR]

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UITextViewDelegate>
@end

@implementation TestBedViewController
{
	UITextView *textView;
	UIToolbar *toolbar;
    
    NSArray *currentVerticalConstraints;
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
    UIBarButtonItem *undoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemUndo, self, @selector(undo));
    undoItem.enabled = canUndo;
    [items addObject:undoItem];
	[items addObject:spacer];
    
	BOOL canRedo = [textView.undoManager canRedo];
    UIBarButtonItem *redoItem = SYSBARBUTTON_TARGET(UIBarButtonSystemItemRedo, self, @selector(redo));
    redoItem.enabled = canRedo;
    [items addObject:redoItem];
	[items addObject:spacer];
    
	[items addObject:SYSBARBUTTON(UIBarButtonSystemItemFlexibleSpace, nil)];
	[items addObject:BARBUTTON(@"Done", @selector(leaveKeyboardMode))];
    
	toolbar.items = items;
}

// Call undo on the undoManager and update toolbar buttons
- (void)undo
{
    [textView.undoManager undo];
    [self loadAccessoryView];
}

// Call redo on the undoManager and update toolbar buttons
- (void)redo
{
    [textView.undoManager redo];
    [self loadAccessoryView];
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
- (void)clearText { textView.text = @""; }

// Update TextView Height
- (void)adjustToBottomInset:(CGFloat)offset
{
    if (currentVerticalConstraints)
        [self.view removeConstraints:currentVerticalConstraints];
    
    currentVerticalConstraints =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView(>=0)]-bottomMargin-|" options:0 metrics:@{@"bottomMargin":@(offset)} views:@{@"textView":textView}];
    [self.view addConstraints:currentVerticalConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{[self.view layoutIfNeeded];}];
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

    [self adjustToBottomInset:kbounds.size.height];
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
