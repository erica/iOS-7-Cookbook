/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;
#import "XMLParser.h"

@class DataManager;

@protocol DataManagerDelegate <NSObject>
- (void)dataIsReady:(DataManager *)dataManager;
@end

@interface DataManager : NSObject
@property (nonatomic, weak) NSObject<DataManagerDelegate> *delegate;
@property (nonatomic, readonly) NSMutableArray *entries;
- (void)loadData;
@end
