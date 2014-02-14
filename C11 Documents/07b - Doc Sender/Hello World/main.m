/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UIDocumentInteractionControllerDelegate>
@end

@implementation TestBedViewController
{
    UIDocumentInteractionController *dic;
    NSURL *fileURL;
}

#pragma mark QuickLook
- (UIViewController *) documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

- (UIView *) documentInteractionControllerViewForPreview:(UIDocumentInteractionController *)controller
{
    return self.view;
}

- (CGRect) documentInteractionControllerRectForPreview:(UIDocumentInteractionController *)controller
{
    return self.view.frame;
}

#pragma mark DIC

- (void) dismissIfNeeded
{
    // Proactively dismiss any visible popover
    if (dic)
        [dic dismissMenuAnimated:YES];
}

- (void) documentInteractionControllerDidDismissOptionsMenu: (UIDocumentInteractionController *) controller
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    dic = nil;
}

- (void)action
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    dic = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
    dic.delegate = self;
    [dic presentOptionsMenuFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BookCover"]];
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(self.view, imageView);
    
    self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemAction, @selector(action));
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/BookCover.jpg"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        UIImage *image = [UIImage imageNamed:@"BookCover"];
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        [data writeToFile:filePath atomically:YES];
    }
    fileURL = [NSURL fileURLWithPath:filePath];
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
