/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "MIMEHelper.h"

#define STRINGEQ(X,Y) ([X caseInsensitiveCompare:Y] == NSOrderedSame)

static NSDictionary *mimeTypes;

void initializeMimeTypeDictionary()
{
    NSError *error;
    NSString *mimefile = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ApacheMIMETypes" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    if (!mimefile)
    {
        NSLog(@"Could not read in mime type file: %@", error.localizedFailureReason);
        return;
    }
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *lines = [mimefile componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *eachLine in lines)
    {
        NSString *line = [eachLine stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (line.length < 2) continue;
        if ([line hasPrefix:@"#"]) continue;
        NSArray *items = [line componentsSeparatedByString:@"\t"];
        if (items.count < 2) continue;
        
        NSString *mimeType = [items objectAtIndex:0];
        NSArray *extensions = [[items lastObject] componentsSeparatedByString:@" "];
        for (NSString *extension in extensions)
            dict[extension] = mimeType;
    }
    
    mimeTypes = dict;
}

NSString *mimeForExtension(NSString *extension)
{
    if (!mimeTypes)
        initializeMimeTypeDictionary();
    return mimeTypes[[extension lowercaseString]];
}
