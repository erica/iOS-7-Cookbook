/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CrayonHandler.h"
#define CRAYON_NAME(CRAYON)	[[CRAYON componentsSeparatedByString:@"#"] objectAtIndex:0]
#define CRAYON_COLOR(CRAYON) getColor([[CRAYON componentsSeparatedByString:@"#"] lastObject])
#define ALPHA	@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"

// Convert a 6-character hex color to a UIColor object
UIColor *getColor(NSString *hexColor)
{
	unsigned int red, green, blue;
	NSRange range;
	range.length = 2;
	
	range.location = 0;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
	range.location = 2;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
	range.location = 4;
	[[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
	
	return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}

@implementation CrayonHandler
{
    NSMutableDictionary *crayonColors;
    NSMutableArray *sectionArray;
}

// Return an array of items that appear in each section
- (NSArray *)itemsInSection: (NSInteger)section
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF beginswith[cd] %@", [self firstLetter:section]];
    return [crayonColors.allKeys filteredArrayUsingPredicate:predicate];
}

// Count of active sections
- (NSInteger)numberOfSections
{
    return sectionArray.count;
}

// Number of items within a section
- (NSInteger)countInSection: (NSInteger)section
{
    return [sectionArray[section] count];
}

// Return the letter that starts each section member's text
- (NSString *)firstLetter: (NSInteger)section
{
    return [[ALPHA substringFromIndex:section] substringToIndex:1];
}

// The one letter section name
- (NSString *)nameForSection: (NSInteger)section
{
    if (![self countInSection:section])
        return nil;
    return [self firstLetter:section];
}

// Color name by index path
- (NSString *)colorNameAtIndexPath:(NSIndexPath *)path
{
    if (path.section >= (NSInteger) sectionArray.count)
        return nil;
    NSArray *currentItems = sectionArray[path.section];
    
    if (path.row >= (NSInteger) currentItems.count)
        return nil;
	NSString *crayon = currentItems[path.row];
    
    return crayon;
}

// Color by index path
- (UIColor *)colorAtIndexPath:(NSIndexPath *)path
{
    NSString *crayon = [self colorNameAtIndexPath:path];
    if (crayon)
        return crayonColors[crayon];
    return nil;
}

// Color by name
- (UIColor *)colorNamed:(NSString *)aColor
{
    return crayonColors[aColor];
}

// For searching
- (NSInteger)filterWithString:(NSString *)filter
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", filter];
	_filteredArray = [[crayonColors allKeys] filteredArrayUsingPredicate:predicate];
    return _filteredArray.count;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // Prepare the crayon color dictionary
        NSString *pathname = [[NSBundle mainBundle]  pathForResource:@"crayons" ofType:@"txt"];
        NSArray *rawCrayons = [[NSString stringWithContentsOfFile:pathname encoding:NSUTF8StringEncoding error:nil] componentsSeparatedByString:@"\n"];
        crayonColors = [NSMutableDictionary dictionary];
        for (NSString *string in rawCrayons)
            [crayonColors setObject:CRAYON_COLOR(string) forKey:CRAYON_NAME(string)];
        
        sectionArray = [NSMutableArray array];
        for (int i = 0; i < 26; i++)
            [sectionArray addObject:[self itemsInSection:i]];
    }
    return self;
}
@end
