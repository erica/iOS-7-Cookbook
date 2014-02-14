/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "

#pragma mark - LimitedTextField

@interface LimitedTextField : UITextField
@end

@implementation LimitedTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UITextRange *range = self.selectedTextRange;
    BOOL hasText = self.text.length > 0;
    
    if (action == @selector(cut:)) return !range.empty;
    if (action == @selector(copy:)) return !range.empty;
    if (action == @selector(select:)) return hasText;
    if (action == @selector(selectAll:)) return hasText;
    if (action == @selector(paste:)) return NO;
    
    return NO;
}

@end

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UITextFieldDelegate>
@end

@implementation TestBedViewController
{
    LimitedTextField *textField;
    UISegmentedControl *segmentedControl;
}

- (BOOL)textField:(UITextField *)aTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
	
    switch (segmentedControl.selectedSegmentIndex)
    {
        case 0: // Alpha only
            [cs addCharactersInString:ALPHA];
            break;
        case 1: // Integers
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            break;
        case 2: // Decimals
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            if ([aTextField.text rangeOfString:@"."].location == NSNotFound)
				[cs addCharactersInString:@"."];
            break;
        case 3: // Alphanumeric
            [cs addCharactersInString:ALPHA];
			[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
            break;
        default:
            break;
    }
	
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:[cs invertedSet]] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    return basicTest;
}

- (void) segmentChanged:(UISegmentedControl *)seg
{
	textField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextField
{
    [aTextField resignFirstResponder];
    return YES;
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Create a text field by hand
	textField = [[LimitedTextField alloc] init];
	textField.placeholder = @"Enter Text";
    [self.view addSubview:textField];
    
    PREPCONSTRAINTS(textField);
    CONSTRAIN(self.view, textField, @"V:|-30-[textField]");
    CONSTRAIN(self.view, textField, @"H:|-[textField(>=0)]-|");
	
    textField.delegate = self;
    textField.returnKeyType = UIReturnKeyDone;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // Add segmented control with entry options
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[@"ABC 123 2.3 A2C" componentsSeparatedByString:@" "]];
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
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
