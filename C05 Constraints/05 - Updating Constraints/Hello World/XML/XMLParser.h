/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <CoreFoundation/CoreFoundation.h>
#import <Foundation/Foundation.h>
#import "TreeNode.h"

@interface XMLParser : NSObject <NSXMLParserDelegate>
{
	NSMutableArray		*stack;
}
+ (XMLParser *) sharedInstance;
- (TreeNode *) parseXMLFromURL: (NSURL *) url;
- (TreeNode *) parseXMLFromData: (NSData*) data;
@end

