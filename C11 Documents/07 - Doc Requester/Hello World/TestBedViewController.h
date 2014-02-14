/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <QuickLook/QuickLook.h>
#import "QLItem.h"

@interface TestBedViewController : UITableViewController <QLPreviewControllerDataSource>
- (void) scanDocs;
@end

