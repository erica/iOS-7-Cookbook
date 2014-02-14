/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 BSD License for anything not specifically marked as developed by a third party.
 Apple's code excluded.
 */

#import <UIKit/UIKit.h>
#include <sys/socket.h>
#include <netinet/in.h>

@protocol ReachabilityWatcher <NSObject>
- (void) reachabilityChanged;
@end

@interface UIDevice (Reachability)
+ (NSString *)stringFromAddress: (const struct sockaddr *)address;
+ (BOOL)addressFromString:(NSString *)IPAddress address:(struct sockaddr_in *)address;
+ (NSData *)dataFromAddress:(struct sockaddr_in)address;
+ (NSString *)addressFromData:(NSData *)addressData;
+ (NSString *)portFromData:(NSData *)addressData;

// Retrieve connectivity info
- (NSString *)hostname;
- (NSString *)getIPAddressForHost:(NSString *)theHost;
- (NSString *)localIPAddress;
- (NSString *)localWiFiIPAddress;
- (NSArray *)localWiFiIPAddresses;

// Availability tests
- (BOOL)hostAvailable:(NSString *)theHost;
- (BOOL)networkAvailable;
- (BOOL)activeWLAN;
- (BOOL)activeWWAN;
- (BOOL)activePersonalHotspot;
- (BOOL)performWiFiCheck;

- (BOOL)scheduleReachabilityWatcher:(id <ReachabilityWatcher>)watcher;
- (void)unscheduleReachabilityWatcher;
@end