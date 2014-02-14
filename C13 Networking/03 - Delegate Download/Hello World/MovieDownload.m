/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "MovieDownload.h"

@implementation MovieDownload

- (instancetype)initWithURL:(NSURL *)movieURL downloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    self = [super init];
    if (self)
    {
        _movieURL = movieURL;
        _downloadTask = downloadTask;
    }
    return self;
}

// A local file path for copying our temporary file
- (NSString *)localPath
{
    NSString * localPath = [NSString stringWithFormat:@"%@/Documents/%@", NSHomeDirectory(), [self.movieURL lastPathComponent]];
    return localPath;
}

// Display name in UI
- (NSString *)movieName
{
    return [self.movieURL lastPathComponent];
}

// Status string based on progress from download task
- (NSString *)statusString
{
    int64_t kReceived = self.downloadTask.countOfBytesReceived / 1024;
    int64_t kExpected = self.downloadTask.countOfBytesExpectedToReceive / 1024;
    NSString *statusString = [NSString stringWithFormat:@"%lldk of %lldk", kReceived, kExpected];
    return statusString;
}

// Progress percentage from download task
- (double)progress
{
    double progress = (double) self.downloadTask.countOfBytesReceived / (double) self.downloadTask.countOfBytesExpectedToReceive;
    return progress;
}
@end
