/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MobileCoreServices;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
}

- (void)performDismiss
{
    if (IS_IPHONE)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
    {
        [popover dismissPopoverAnimated:YES];
        popover = nil;
    }
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
    if (IS_IPHONE)
	{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
	}
	else
	{
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (BOOL)videoRecordingAvailable
{
    // The source type must be available
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        return NO;
    
    // And the media type must include the movie type
    NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    
    return  [mediaTypes containsObject:(NSString *)kUTTypeMovie];
}


- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (!error)
		self.title = @"Saved!";
	else
        NSLog(@"Error saving video: %@", error.localizedFailureReason);
}

- (void)saveVideo:(NSURL *)mediaURL
{
    // check if video is compatible with album
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
	
	// save
	if (compatible)
		UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performDismiss];
    
	// recover video URL and save data
	NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [self saveVideo:mediaURL];
}


// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performDismiss];
}

- (void)recordVideo
{
    if (popover) return;
    self.title = nil;
    
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
	picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
	picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    
    [self presentViewController:picker];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ([self videoRecordingAvailable])
        self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemCamera, @selector(recordVideo));
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
