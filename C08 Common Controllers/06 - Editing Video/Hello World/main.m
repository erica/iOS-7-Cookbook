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

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIVideoEditorControllerDelegate>
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
    NSURL *mediaURL;
}

#pragma mark - Saving
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error)
    {
        NSLog(@"Error saving video: %@", error.localizedFailureReason);
        return;
    }
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)saveVideo
{
    // check if video is compatible with album and save
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
	if (compatible)
    {
		UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
}

#pragma mark - Utility
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

#pragma mark - Video Editor Controller
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath
{
    [self performDismiss];
    mediaURL = [NSURL URLWithString:editedVideoPath];
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Save", @selector(saveVideo));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
}

- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error
{
    [self performDismiss];
    mediaURL = nil;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
    self.navigationItem.leftBarButtonItem = nil;
    
    NSLog(@"Video edit failed: %@", error.localizedFailureReason);
}

- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor
{
    [self performDismiss];
    mediaURL = nil;
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)editMedia
{
    if (popover) return;
    
	if (![UIVideoEditorController canEditVideoAtPath:mediaURL.path])
	{
		self.title = @"Cannot Edit Video";
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
		return;
	}
	
	UIVideoEditorController *editor = [[UIVideoEditorController alloc] init];
	editor.videoPath = mediaURL.path;
	editor.delegate = self;
    [self presentViewController:editor];
}

#pragma mark - Image Picker
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performDismiss];
    popover = nil;
    mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Edit", @selector(editMedia));
}


// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performDismiss];
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (void)pickVideo
{
    if (popover) return;
    
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
	picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    
    [self presentViewController:picker];
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Video editing not available on sim
    if (!TARGET_IPHONE_SIMULATOR)
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick", @selector(pickVideo));
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
