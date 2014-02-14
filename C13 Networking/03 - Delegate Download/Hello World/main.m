/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
@import MediaPlayer;
#import "Utility.h"
#import "MovieDownload.h"

// Large Movie (35 MB)
#define LARGE_MOVIE @"http://www.archive.org/download/BettyBoopCartoons/Betty_Boop_More_Pep_1936_512kb.mp4"

// Medium movie (8 MB)
#define MEDIUM_MOVIE @"http://www.archive.org/download/mother_goose_little_miss_muffet/mother_goose_little_miss_muffet_512kb.mp4"

// Short movie (3 MB)
#define SMALL_MOVIE @"http://www.archive.org/download/Drive-inSaveFreeTv/Drive-in--SaveFreeTv_512kb.mp4"

#pragma mark - TestBedViewController

@interface TestBedViewController : UITableViewController <NSURLSessionDownloadDelegate>
@end

@implementation TestBedViewController
{
    NSMutableArray *movieDownloads;
    NSURLSession *session;
    UIProgressView *progressBarView;
    MPMoviePlayerViewController * player;
    BOOL downloading;
}

#pragma mark - NSURLSessionDownloadDelegate

// Handle download completion from the task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSInteger index = [self movieDownloadIndexForDownloadTask:downloadTask];
    if (index < 0) return;
    MovieDownload *movieDownload = movieDownloads[index];
    
    // Copy temporary file
    NSError * error;
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:[NSURL fileURLWithPath:[movieDownload localPath]] error:&error];
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    // Required delegate method
}

// Handle task completion
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
    if (error)
        NSLog(@"Task %@ failed: %@", task, error);
    
    // Update UI
    [progressBarView setProgress:0 animated:NO];
    self.navigationItem.title = @"";
    downloading = NO;
    
    // This method is called after downloadTask didFinishDownloading - task state is prepared (unlike didFinishDownloading)
    [self.tableView reloadData];
}

// Handle progress update from the task
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSInteger index = [self movieDownloadIndexForDownloadTask:downloadTask];
    if (index < 0) return;
    MovieDownload *movieDownload = movieDownloads[index];
    
    // Update UI
    [progressBarView setProgress:movieDownload.progress animated:YES];
    self.navigationItem.title = movieDownload.statusString;
}

#pragma mark - UITableViewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = 1;
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rowCount = movieDownloads.count;
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Reset the cell UI
    cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    [cell.textLabel setEnabled:YES];
    [cell.detailTextLabel setEnabled:YES];
    
    // Set the text label to the file name
    cell.textLabel.text =  [movieDownloads[indexPath.row] movieName];
    
    // Acquire the appropriate download task and check its state
    NSURLSessionDownloadTask * downloadTask = [movieDownloads[indexPath.row] downloadTask];
    if (downloadTask.state == NSURLSessionTaskStateCompleted)
    {
        cell.detailTextLabel.text = @"Ready to Play";
    }
    else if (downloadTask.state == NSURLSessionTaskStateRunning)
    {
        cell.detailTextLabel.text = @"Downloading...";
    }
    else if (downloadTask.state == NSURLSessionTaskStateSuspended)
    {
        // If a download is already in progress, disable suspended cells.
        // For design reasons, we're only allowing one download to proceed at a time.
        if (downloading)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.textLabel setEnabled:NO];
            [cell.detailTextLabel setEnabled:NO];
        }
        
        if (downloadTask.countOfBytesReceived > 0)
        {
            cell.detailTextLabel.text = @"Download Paused";
        }
        else
        {
            cell.detailTextLabel.text = @"Not Started";
        }
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Acquire the appropriate downloadTask and respond appropriately to the user's selection
    NSURLSessionDownloadTask * downloadTask = [movieDownloads[indexPath.row] downloadTask];
    if (downloadTask.state == NSURLSessionTaskStateCompleted)
    {
        // Download is complete.  Play movie.
        NSURL *movieURL = [NSURL fileURLWithPath:[movieDownloads[indexPath.row] localPath]];
        [self playMovieAtURL:movieURL];
    }
    else if (downloadTask.state == NSURLSessionTaskStateSuspended)
    {
        // If suspended and not already downloading, resume transfer.
        if (!downloading)
        {
            [downloadTask resume];
            downloading = YES;
        }
    }
    else if (downloadTask.state == NSURLSessionTaskStateRunning)
    {
        // If already downloading, pause the transfer.
        [downloadTask suspend];
        downloading = NO;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

#pragma mark - Movie Download Handling & UI

// Helper method to get the index of a MovieDownload from the array based on downloadTask.
- (NSInteger)movieDownloadIndexForDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSInteger foundIndex = -1;
    NSInteger index = 0;
    for (MovieDownload * movieDownload in movieDownloads)
    {
        if (movieDownload.downloadTask == downloadTask)
        {
            foundIndex = index;
            break;
        }
        index++;
    }
    return foundIndex;
}

// Play move at the provided URL
- (void)playMovieAtURL:(NSURL *)url
{
    // Instantiate movie player with location of downloaded file
    player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    player.moviePlayer.controlStyle = MPMovieControlStyleFullscreen;
    player.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
    player.moviePlayer.allowsAirPlay = YES;
    [player.moviePlayer prepareToPlay];
    
    [self presentMoviePlayerViewControllerAnimated:player];
}

- (void)addMovieDownload:(NSString *)urlString
{
    NSURL * url = [NSURL URLWithString:urlString];
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * downloadTask = [session downloadTaskWithRequest:request];
                                                                                
    MovieDownload * movieDownload = [[MovieDownload alloc] initWithURL:url downloadTask:downloadTask];
    [movieDownloads addObject:movieDownload];
}

// Reset the UI, session and tasks
- (void)reset
{
    for (MovieDownload * movieDownload in movieDownloads)
    {
        // Cancel each task
        NSURLSessionDownloadTask * downloadTask = movieDownload.downloadTask;
        [downloadTask cancel];
        
        // Remove any existing data
        if ([[NSFileManager defaultManager] fileExistsAtPath:movieDownload.localPath])
        {
            NSError *error;
            if (![[NSFileManager defaultManager] removeItemAtPath:movieDownload.localPath error:&error])
                NSLog(@"Error removing existing data: %@", error.localizedFailureReason);
        }
    }
    
    // Cancel all tasks and invalidate the session (also releasing the delegate)
    [session invalidateAndCancel];
    session = nil;
    
    // Create a new configuration and session specifying this object as the delegate
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    // Create the MovieDownload objects
    movieDownloads = [[NSMutableArray alloc] init];
    [self addMovieDownload:SMALL_MOVIE];
    [self addMovieDownload:MEDIUM_MOVIE];
    [self addMovieDownload:LARGE_MOVIE];

    // Reset the UI
    [progressBarView setProgress:0 animated:NO];
    self.navigationItem.title = @"";
    downloading = NO;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Reset", @selector(reset));
    
    // Setup the progress bar in the navigation bar
    progressBarView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressBarView.frame = CGRectMake(0, 0, self.navigationController.navigationBar.frame.size.width, 4);
    [self.navigationController.navigationBar addSubview:progressBarView];
    
    [self reset];
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
