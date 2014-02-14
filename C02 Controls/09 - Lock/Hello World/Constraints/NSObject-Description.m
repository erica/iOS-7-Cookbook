/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "NSObject-Description.h"
#import "NSObject-Nametag.h"

@implementation NSObject (DebuggingExtensions)
// Returrn 'Class description : hex memory address'
- (NSString *) objectIdentifier
{
    return [NSString stringWithFormat:@"%@:0x%0x", self.class.description, (int) self];
}

// Nametag or identifier, based on availability
- (NSString *) objectName
{
    if (self.nametag)
        return [NSString stringWithFormat:@"%@:0x%0x", self.nametag, (int) self];
    return [NSString stringWithFormat:@"%@", self.objectIdentifier];
}

NSString *consoleString(NSString *string, NSUInteger maxLength, NSInteger indent)
{
    // Build spacer
    NSMutableString *spacer = [NSMutableString stringWithString:@"\n"];
    for (int i = 0; i < indent; i++)
        [spacer appendString:@" "];    
    
    // Decompose into space-separated items
    NSArray *wordArray = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    NSInteger wordCount = wordArray.count;
    NSInteger index = 0;
    NSInteger lengthOfNextWord = 0;
    
    // Perform decomposition
    NSMutableArray *array = [NSMutableArray array];
	while (index < wordCount)
    {
		NSMutableString *line = [NSMutableString string];
		while (((line.length + lengthOfNextWord + 1) <= maxLength) &&
               (index < wordCount))
        {
	        lengthOfNextWord = [wordArray[index] length];
	        [line appendString:wordArray[index]];
            if (++index < wordCount)
                [line appendString:@" "];
	    }
		[array addObject:line];
	}
    
    return [array componentsJoinedByString:spacer];
}

// Wrapped description
- (NSString *) consoleDescription
{
    return consoleString(self.description, 80, 8);
}
@end

