/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@end

@implementation TestBedViewController
{
    UIPickerView *picker;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 3; // three columns
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 1000000; // arbitrary and large
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 120.0f;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	NSArray *names = @[@"club", @"diamond", @"heart", @"spade"];
    UIImage *image = [UIImage imageNamed:names[row%4]];
    
    UIImageView *imageView = (UIImageView *) view;
    imageView.image = image;
    
    if (!imageView)
        imageView = [[UIImageView alloc] initWithImage:image];
    
	return imageView;
}

- (void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	NSArray *names = @[@"C", @"D", @"H", @"S"];
	self.title = [NSString stringWithFormat:@"%@•%@•%@",
                  names[[pickerView selectedRowInComponent:0] % 4],
                  names[[pickerView selectedRowInComponent:1] % 4],
                  names[[pickerView selectedRowInComponent:2] % 4]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [picker selectRow:50000 + (rand() % 4) inComponent:0 animated:YES];
	[picker selectRow:50000 + (rand() % 4) inComponent:1 animated:YES];
	[picker selectRow:50000 + (rand() % 4) inComponent:2 animated:YES];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:picker];
    PREPCONSTRAINTS(picker);
    CENTER_VIEW_H(self.view, picker);
    CENTER_VIEW_V(self.view, picker);
    
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
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
