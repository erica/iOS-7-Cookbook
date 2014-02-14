/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;

#define DOCUMENTS_PATH  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define INBOX_PATH      [DOCUMENTS_PATH stringByAppendingPathComponent:@"Inbox"]

@interface InboxHelper : NSObject
+ (void)checkAndProcessInbox;
@end
