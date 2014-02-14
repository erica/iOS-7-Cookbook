/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "NotificationAlert.h"

@implementation NotificationAlert

+ (void) say:(id)formatstring,...
{
    if (!formatstring) return;
    
    va_list arglist;
    va_start(arglist, formatstring);
    id statement = [[NSString alloc] initWithFormat:formatstring arguments:arglist];
    va_end(arglist);
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:statement message:nil delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [av show];
}

@end
