/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UITextFieldDelegate>
@end

@implementation TestBedViewController
{
    UITextField *textField;
    UISegmentedControl *segmentedControl;
}

- (void)updateStatus:(NSString *)string
{
	NSPredicate *fpPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES '^[+-]?[0-9]+[\\.]?[0-9]*$'"];
	BOOL match = [fpPredicate evaluateWithObject:string];
	self.title = match ? @"Floating point!" : nil;
}

- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
	if (!string.length)
	{
		[self updateStatus:newString];
		return YES;
	}
    
    NSMutableCharacterSet *cs = [NSMutableCharacterSet characterSetWithCharactersInString:@""];
	[cs formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    
	if ([textField.text rangeOfString:@"."].location == NSNotFound)
		[cs addCharactersInString:@"."];
	
	if (([textField.text rangeOfString:@"+"].location == NSNotFound) &&
		([textField.text rangeOfString:@"-"].location == NSNotFound))
		[cs addCharactersInString:@"+-"];
	
	
	// legal characters check
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:[cs invertedSet]] componentsJoinedByString:@""];
    BOOL basicTest = [string isEqualToString:filtered];
    
	[self updateStatus:basicTest ? newString : textField.text];
    
	return basicTest;
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf
{
    [textField resignFirstResponder];
    return YES;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
    
    // Create a text field by hand
	textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 30.0f)];
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
