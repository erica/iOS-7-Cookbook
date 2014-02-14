/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <Foundation/Foundation.h>

// Helper class to hold information about a movie its corresponding download
@interface MovieDownload : NSObject
@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
@property (nonatomic, readonly) NSString *localPath;
@property (nonatomic, readonly) NSString *movieName;
@property (nonatomic, readonly) NSString *statusString;
@property (nonatomic, readonly) double progress;
- (instancetype)initWithURL:(NSURL *)movieURL downloadTask:(NSURLSessionDownloadTask *)downloadTask;
@end
