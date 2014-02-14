/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "QLItem.h"

@implementation QuickItem
- (NSString *)previewItemTitle
{
    return [_path lastPathComponent];
}

- (NSURL *)previewItemURL
{
    return [NSURL fileURLWithPath:_path];
}
@end

