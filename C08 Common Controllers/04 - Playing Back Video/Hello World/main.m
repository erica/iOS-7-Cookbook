/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MobileCoreServices;
@import MediaPlayer;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UIPopoverControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
    NSURL *mediaURL;
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

// Popover was dismissed
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

- (void)playMovie
{
    // play
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaURL];
    player.moviePlayer.allowsAirPlay = YES;
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemCamera, @selector(recordVideo));
         [[NSNotificationCenter defaultCenter] removeObserver:self];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         if ((player.moviePlayer.loadState & MPMovieLoadStatePlayable) != 0)
             [player.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:1.0f];
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performDismiss];
    
	// recover video URL
	mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, @selector(playMovie));
}

// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self performDismiss];
}

- (void)recordVideo
{
    if (popover) return;
    
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
