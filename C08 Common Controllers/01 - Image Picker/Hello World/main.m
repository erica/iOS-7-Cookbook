/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import AssetsLibrary;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UISwitch *editSwitch;
    
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
        // Workaround to an Apple crasher when asking for asset library authorization with a popover displayed
        ALAssetsLibrary * assetsLibrary = [[ALAssetsLibrary alloc] init];
        ALAuthorizationStatus authStatus;
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_0)
            authStatus = [ALAssetsLibrary authorizationStatus];
        else
            authStatus = ALAuthorizationStatusAuthorized;
        
        if (authStatus == ALAuthorizationStatusAuthorized)
        {
            popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
            popover.delegate = self;
            [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
        else if (authStatus == ALAuthorizationStatusNotDetermined)
        {
            // Force authorization
            [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                // If authorized, catch the final iteration and display popover
                if (group == nil)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
                        popover.delegate = self;
                        [popover presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
                    });
                *stop = YES;
            } failureBlock:nil];
        }
	}
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (void)loadImageFromAssetURL:(NSURL *)assetURL into:(UIImage **)image
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset)
    {
        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
        CGImageRef cgImage = [assetRepresentation CGImageWithOptions:nil];
        CFRetain(cgImage); // Thanks Oliver Drobnik
        if (image) *image = [UIImage imageWithCGImage:cgImage];
        CFRelease(cgImage);
    };
    
    ALAssetsLibraryAccessFailureBlock failure = ^(NSError *__strong error)
    {
        NSLog(@"Error retrieving asset from url: %@", error.localizedFailureReason);
    };
    
    [library assetForURL:assetURL resultBlock:resultsBlock failureBlock:failure];
}

// Update image and for iPhone, dismiss the controller
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Use the edited image if available
    UIImage __autoreleasing *image = info[UIImagePickerControllerEditedImage];
    
    // If not, grab the original image
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    
    NSURL *assetURL = info[UIImagePickerControllerReferenceURL];
    if (!image && !assetURL)
    {
        NSLog(@"Cannot retrieve an image from the selected item. Giving up.");
    }
    else if (!image)
    {
        NSLog(@"Retrieving from Assets Library");
        [self loadImageFromAssetURL:assetURL into:&image];
    }
    
    if (image)
        imageView.image = image;
    
    if (IS_IPHONE)
        [self performDismiss];
}

// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performDismiss];
}

- (void)pickImage
{
    if (popover) return;
    
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    picker.allowsEditing = editSwitch.isOn;
    picker.delegate = self;
    
    [self presentViewController:picker];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(self.view, imageView);
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Pick Image", @selector(pickImage));
    
    // Setup title view with Edits: ON/OFF
    editSwitch = [[UISwitch alloc] init];
    UILabel * editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
    editLabel.text = @"Edits";
    self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:editLabel], [[UIBarButtonItem alloc] initWithCustomView:editSwitch]];
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
