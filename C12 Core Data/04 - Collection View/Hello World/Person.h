/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;
@import CoreData;


@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * section;
@property (nonatomic, retain) NSString * emailaddress;
@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * givenname;
@property (nonatomic, retain) NSString * middleinitial;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSString * surname;
@property (nonatomic, retain) NSData * imageData;
@property (nonatomic, readonly) NSString * fullname;

@end
