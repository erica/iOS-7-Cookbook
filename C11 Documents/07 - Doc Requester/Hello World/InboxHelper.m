/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "InboxHelper.h"

@implementation InboxHelper
+ (NSString *)findAlternativeNameForPath: (NSString *) path
{
    NSString *ext = path.pathExtension;
    NSString *base = [path stringByDeletingPathExtension];
    
    for (int i = 1; i < 999; i++) // we have limits here
    {
        NSString *dest = [NSString stringWithFormat:@"%@-%d.%@", base, i, ext];
        if (![[NSFileManager defaultManager] fileExistsAtPath:dest])
            return dest;
    }
    
    NSLog(@"Exhausted possible names for file %@. Bailing.", path.lastPathComponent);
    return nil;
}

+ (void)checkAndProcessInbox
{
    NSError *error;
    BOOL success;
    BOOL isDir;
    
    // Does the inbox folder exist? If not, we're done here.
    if (![[NSFileManager defaultManager] fileExistsAtPath:INBOX_PATH isDirectory:&isDir])
        return;
    
    // It exists. Is it a dir?
    if (!isDir)
    {
        success = [[NSFileManager defaultManager] removeItemAtPath:INBOX_PATH error:&error];
        if (!success)
        {
            NSLog(@"Error deleting Inbox file (not directory): %@", error.localizedFailureReason);
            return;
        }
    }
    
    // Load the array of files
    NSArray *fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:INBOX_PATH error:&error];
    if (!fileArray)
    {
        NSLog(@"Error reading contents of Inbox: %@", error.localizedFailureReason);
        return;
    }
    
    // Process each file
    NSUInteger initialCount = fileArray.count;
    for (NSString *filename in fileArray)
    {
        NSString *source = [INBOX_PATH stringByAppendingPathComponent:filename];
        NSString *dest = [DOCUMENTS_PATH stringByAppendingPathComponent:filename];
        
        // Is the file already there?
        BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:dest];
        if (exists)
            dest = [self findAlternativeNameForPath:dest];
        
        if (!dest)
        {
            NSLog(@"Error. File name conflict could not be resolved for %@. Bailing", filename);
            continue;
        }
        
        success = [[NSFileManager defaultManager] moveItemAtPath:source toPath:dest error:&error];
        if (!success)
        {
            NSLog(@"Error moving file %@ to Documents from Inbox: %@", filename, error.localizedFailureReason);
            continue;
        }
    }
    
    // Inbox should now be empty
    fileArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:INBOX_PATH error:&error];
    if (!fileArray)
    {
        NSLog(@"Error reading contents of Inbox: %@", error.localizedFailureReason);
        return;
    }
    
    if (fileArray.count)
    {
        NSLog(@"Error clearing out inbox. %d items still remain", fileArray.count);
        return;
    }
    
    // Remove the inbox
    success = [[NSFileManager defaultManager] removeItemAtPath:INBOX_PATH error:&error];
    if (!success)
    {
        NSLog(@"Error removing inbox: %@", error.localizedFailureReason);
        return;
    }
    
    NSLog(@"Moved %d items from the Inbox to the Documents folder", initialCount);
}
@end
