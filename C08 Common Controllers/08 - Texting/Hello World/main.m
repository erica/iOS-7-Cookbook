/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MessageUI;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIPopoverControllerDelegate, MFMessageComposeViewControllerDelegate>
@end

@implementation TestBedViewController

#pragma mark - Utility
- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
    // Modal is best
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}


#pragma mark - Messaging
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    [self performDismiss];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            NSLog(@"Message was cancelled");
            break;
        case MessageComposeResultFailed:
            NSLog(@"Message failed");
            break;
        case MessageComposeResultSent:
            NSLog(@"Message was sent");
            break;
        default:
            break;
    }
}

- (void)sendMessage
{
    MFMessageComposeViewController *mcvc = [[MFMessageComposeViewController alloc] init];
    mcvc.messageComposeDelegate = self;
    if ([MFMessageComposeViewController canSendAttachments])
        [mcvc addAttachmentData:UIImagePNGRepresentation([UIImage imageNamed:@"BookCover"]) typeIdentifier:@"png" filename:@"bookcover.png"];

    // mcvc.recipients = [NSArray array];
    mcvc.body = @"I'm reading the iOS Developer's Cookbook";
    [self presentViewController:mcvc];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([MFMessageComposeViewController canSendText])
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Send", @selector(sendMessage));
    else
        self.title = @"Cannot send texts";
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
