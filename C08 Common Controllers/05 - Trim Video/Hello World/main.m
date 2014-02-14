/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MobileCoreServices;
@import MediaPlayer;
@import AVFoundation;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController
{
    UIPopoverController *popover;
    NSURL *playbackURL;
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
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:playbackURL];
    player.moviePlayer.allowsAirPlay = YES;
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    
    [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
     }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerLoadStateDidChangeNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         if ((player.moviePlayer.loadState & MPMovieLoadStatePlayable) != 0)
             [player.moviePlayer performSelector:@selector(play) withObject:nil afterDelay:1.0f];
     }];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
	if (error)
    {
        NSLog(@"Error saving video: %@", error.localizedFailureReason);
        return;
    }
    
    // Make video available to play
    self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, @selector(playMovie));
}

- (void)saveVideo:(NSURL *)mediaURL
{
    // check if video is compatible with album and save
	BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaURL.path);
	if (compatible)
    {
        playbackURL = mediaURL;
		UISaveVideoAtPathToSavedPhotosAlbum(mediaURL.path, self, @selector(video:didFinishSavingWithError:contextInfo:), NULL);
    }
    
}

- (void)trimVideo:(NSDictionary *)info
{
	// recover video URL
	NSURL *mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:mediaURL options:nil];
    
    // Create a trimmed version of the path
    NSString *urlPath = mediaURL.path;
    NSString *extension = urlPath.pathExtension;
    NSString *base = [urlPath stringByDeletingPathExtension];
    NSString *newPath = [NSString stringWithFormat:@"%@-trimmed.%@", base, extension];
    NSLog(@"newPath: %@", newPath);
    NSURL *fileURL = [NSURL fileURLWithPath:newPath];
    
    // Set the trim range
    CGFloat editingStart = [info[@"_UIImagePickerControllerVideoEditingStart"] floatValue];
    CGFloat editingEnd = [info[@"_UIImagePickerControllerVideoEditingEnd"] floatValue];
    CMTime startTime = CMTimeMakeWithSeconds(editingStart, 1);
    CMTime endTime = CMTimeMakeWithSeconds(editingEnd, 1);
    CMTimeRange exportRange = CMTimeRangeFromTimeToTime(startTime, endTime);
    
    // Establish the export session
    AVAssetExportSession *session = [AVAssetExportSession exportSessionWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = fileURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    session.timeRange = exportRange;
    
    // Perform the export
    [session exportAsynchronouslyWithCompletionHandler:^()
     {
         if (session.status == AVAssetExportSessionStatusCompleted)
             [self saveVideo:fileURL];
         else if (session.status == AVAssetExportSessionStatusFailed)
             NSLog(@"AV export session failed");
         else
             NSLog(@"Export session status: %d", session.status);
     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self performDismiss];
    [self trimVideo:info];
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
    picker.allowsEditing = YES;
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
