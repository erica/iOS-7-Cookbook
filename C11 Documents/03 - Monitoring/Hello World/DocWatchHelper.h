/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#define kDocumentChanged	@"DocumentsFolderContentsDidChangeNotification"

@interface DocWatchHelper : NSObject
@property (strong) NSString *path;
+ (id)watcherForPath:(NSString *)aPath;
@end
