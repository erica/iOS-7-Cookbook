/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import CoreFoundation;
@import Foundation;
#import "TreeNode.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>
+ (XMLParser *)sharedInstance;
- (TreeNode *)parseXMLFromURL:(NSURL *)url;
- (TreeNode *)parseXMLFromData:(NSData*)data;
@end

