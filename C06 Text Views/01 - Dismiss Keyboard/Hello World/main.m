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
@property (weak, nonatomic) IBOutlet UITextField *leftTextField;
//@property (weak, nonatomic) IBOutlet UITextField *rightTextField;
@end

@implementation TestBedViewController
{
     UITextField *centerTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Create a text field by hand
	centerTextField = [[UITextField alloc] init];
	[self.view addSubview:centerTextField];
    
    // Place the text field centered below the other fields
    PREPCONSTRAINTS(centerTextField);
    CONSTRAIN_SIZE(centerTextField, 31.0f, 97.0f);
    CENTER_VIEW_H(self.view, centerTextField);
    CONSTRAIN_VIEWS(self.view, @"V:[_leftTextField]-15-[centerTextField]", NSDictionaryOfVariableBindings(_leftTextField, centerTextField));
	
    // Update all text fields, including those defined in interface builder,
	// to set the delegate, return key type, and several other useful traits
	for (UIView *view in self.view.subviews)
	{
		if ([view isKindOfClass:[UITextField class]])
		{
            UITextField *aTextField = (UITextField *)view;
            aTextField.delegate = self;
            
            aTextField.returnKeyType = UIReturnKeyDone;
            aTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            aTextField.borderStyle = UITextBorderStyleRoundedRect;
            aTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            aTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            
            aTextField.font = [UIFont fontWithName:@"Futura" size:12.0f];
            aTextField.placeholder = @"Placeholder";
		}
	}
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UINavigationBar appearance] setTintColor:COOKBOOK_PURPLE_COLOR];
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
