/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MediaPlayer;
#import "Utility.h"

// Large Movie (35 MB)
#define LARGE_MOVIE @"http://www.archive.org/download/BettyBoopCartoons/Betty_Boop_More_Pep_1936_512kb.mp4"

// Short movie (3 MB)
#define SMALL_MOVIE @"http://www.archive.org/download/Drive-inSaveFreeTv/Drive-in--SaveFreeTv_512kb.mp4"

// Fake address
#define FAKE_MOVIE @"http://www.idontbelievethisisavalidurlforthisexample.com"

// Current URL to test
#define MOVIE_URL   [NSURL URLWithString:LARGE_MOVIE]

// Location to copy the downloaded item
#define FILE_LOCATION	[NSHomeDirectory() stringByAppendingString:@"/Documents/Movie.mp4"]

@interface TestBedViewController : UIViewController <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) UILabel * statusLabel;
@end

@implementation TestBedViewController
{
    BOOL success;
    MPMoviePlayerViewController *player;
    UIProgressView *progressView;
    NSURLSession *session;
}

#pragma mark - NSURLSessionDownloadDelegate

// Handle download completion from the task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"Downloaded completed");
    
    // Turn off the network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // Copy temporary file
    NSError *error;
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:FILE_LOCATION] error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // Update UI
        player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:FILE_LOCATION]];
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Play Movie", @selector(playMovie));
        self.statusLabel.text = @"Download Completed";
    });
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Required delegate method
}

// Handle progress update from the task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    double progress = (double) (totalBytesWritten/1024) / (double) (totalBytesExpectedToWrite/1024);
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressView setProgress:progress animated:NO];
        self.statusLabel.text = @"Download Progressing...";
    });
}

// Handle task completion
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error)
        {
            NSLog(@"Task %@ failed: %@", task, error);
            self.statusLabel.text = @"Download Failed";
        }
        else
        {
            NSLog(@"Task %@ completed", task);
            [progressView setProgress:1 animated:NO];
            self.statusLabel.text = @"Download Completed";
        }
    });
}

#pragma mark -

- (void)playMovie
{
    // Instantiate movie player with location of downloaded file
    player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:FILE_LOCATION]];
    [player.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    player.moviePlayer.allowsAirPlay = YES;
    [player.moviePlayer prepareToPlay];
    
    // Listen for finish state
    [[NSNotificationCenter defaultCenter] addObserverForName:MPMoviePlayerPlaybackDidFinishNotification object:player.moviePlayer queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *notification)
     {
         [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
         self.navigationItem.rightBarButtonItem.enabled = YES;
     }];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}

// Performa an asynchronous download
- (void)downloadMovie:(NSURL *)url
{
    // Turn on network activity indicator
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.statusLabel.text = @"Download Started";
    
    // Create a URL request with the URL to the movie
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a download task with the the block-based convenience handler to fetch the data
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request];
    
    // Begin the download task
    [task resume];
}

// Respond to the user's request to play movie
- (void)startDownload
{
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    // Stop any existing movie playback
    [player.moviePlayer stop];
    player = nil;
    
    // Remove any existing data
    if ([[NSFileManager defaultManager] fileExistsAtPath:FILE_LOCATION])
    {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:FILE_LOCATION error:&error])
            NSLog(@"Error removing existing data: %@", error.localizedFailureReason);
    }
    
    // Fetch the data
    [self downloadMovie:MOVIE_URL];
}

- (void)exitApp
{
    abort();
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Download Movie", @selector(startDownload));
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Exit App", @selector(exitApp));
    
    // Create a session configuration passing in the session ID
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfiguration:@"CoreiOSBackgroundID"];
    configuration.discretionary = YES;
    
    // Create a session with the custom configuration
    session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:nil];
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [self.view addSubview:progressView];
    PREPCONSTRAINTS(progressView);
    STRETCH_VIEW_H(self.view, progressView);
    ALIGN_VIEW_TOP_CONSTANT(self.view, progressView, 100);
    
    UILabel * label = [[UILabel alloc] init];
    label.text = @"Not Started";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    PREPCONSTRAINTS(label);
    CENTER_VIEW(self.view, label);
    STRETCH_VIEW_H(self.view, label);
    self.statusLabel = label;
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate
{
    TestBedViewController *tbvc;
}

- (void)presentNotification
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.alertBody = @"Download Complete!";
    localNotification.alertAction = @"Background Transfer";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    localNotification.applicationIconBadgeNumber = 1;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    application.applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    tbvc.view.backgroundColor = [UIColor greenColor];
    tbvc.statusLabel.text = @"BACKGROUND DOWNLOAD COMPLETED!";
    [self presentNotification];
    completionHandler();
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    tbvc = [[TestBedViewController alloc] init];
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
