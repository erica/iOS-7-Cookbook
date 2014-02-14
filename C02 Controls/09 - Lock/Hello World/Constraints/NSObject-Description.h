/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <Foundation/Foundation.h>

@interface NSObject (DebuggingExtensions)
@property (nonatomic, readonly) NSString *objectIdentifier;
@property (nonatomic, readonly) NSString *objectName;
@property (nonatomic, readonly) NSString *consoleDescription;
@end

