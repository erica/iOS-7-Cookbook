/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import AssetsLibrary;
@import MessageUI;
@import MobileCoreServices;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UISwitch *editSwitch;
    
    UIPopoverController *popover;
}

#pragma mark - Utility
- (void)performDismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
    // Modal works best
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

#pragma mark - Assets Library
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

#pragma mark - Email
- (NSString *)mimeTypeForExtension:(NSString *)ext
{
    // Request the UTI via the file extension
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef) ext, NULL);
    if (!UTI) return nil;
    
    // Request the MIME file type via the UTI,
    // may return nil for unrecognized MIME types
    
    NSString *mimeType = (__bridge_transfer NSString *) UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    
    return mimeType;
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    [self performDismiss];
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail was cancelled");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail was saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail was sent");
            break;
        default:
            break;
    }
}

- (void)sendImage
{
    UIImage *image = imageView.image;
    if (!image) return;
    
    // Customize the e-mail
    MFMailComposeViewController *mcvc = [[MFMailComposeViewController alloc] init];
    mcvc.mailComposeDelegate = self;
    [mcvc setSubject:@"Here’s a great photo!"];
    NSString *body = @"<h1>Check this out</h1>\
    <p>I snapped this image from the\
    <code><b>UIImagePickerController</b></code>.</p>";
    [mcvc setMessageBody:body isHTML:YES];
    [mcvc addAttachmentData:UIImageJPEGRepresentation(image, 1.0f)
                   mimeType:@"image/jpeg" fileName:@"pickerimage.jpg"];
    
    // Present the e-mail composition controller
    [self presentViewController:mcvc];
}

#pragma mark - Image Picker
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
    {
        imageView.image = image;
        if ([MFMailComposeViewController canSendMail])
            self.navigationItem.leftBarButtonItems = @[BARBUTTON(@"Mail", @selector(sendImage))];
    }
    
    [self performDismiss];
}

// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

- (void)snapImage
{
    // Create and initialize the picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    picker.allowsEditing = editSwitch.isOn;
    picker.delegate = self;
    
    [self presentViewController:picker];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(self.view, imageView);
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemCamera, @selector(snapImage));
        
        // Setup title view with Edits: ON/OFF
        editSwitch = [[UISwitch alloc] init];
        UILabel * editLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
        editLabel.text = @"Edits";
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:editLabel], [[UIBarButtonItem alloc] initWithCustomView:editSwitch]];
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
