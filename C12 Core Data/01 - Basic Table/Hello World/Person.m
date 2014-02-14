/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "Person.h"


@implementation Person

@dynamic section;
@dynamic emailaddress;
@dynamic gender;
@dynamic givenname;
@dynamic middleinitial;
@dynamic occupation;
@dynamic surname;

- (NSString *)fullname
{
    return [NSString stringWithFormat:@"%@ %@", self.givenname, self.surname];
}
@end
