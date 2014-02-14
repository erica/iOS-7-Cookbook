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

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    BOOL success;
    MPMoviePlayerViewController *player;
}

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
    
    NSDate *startDate = [NSDate date];
    
    // Create a URL request with the URL to the movie
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // Create a session configuration and turn off cellular access for this sessions
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = NO;
    
    // Create a session with the custom configuration
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // Create a download task with the the block-based convenience handler to fetch the data
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {

        // Turn off the network activity indicator
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        // Upon an error, reset the UI and short-circuit the movie playback.
        if (error)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            NSLog(@"Failed download.");
            return;
        }
        
        // Copy temporary file
        [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:FILE_LOCATION] error:&error];
        
        NSLog(@"Elapsed time: %0.2f seconds.", [[NSDate date] timeIntervalSinceDate:startDate]);
        
        // Play the movie
        [self playMovie];
    }];
    
    // Begin the download task
    [task resume];
}

// Respond to the user's request to play movie
- (void)action
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

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Play Movie", @selector(action));
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
