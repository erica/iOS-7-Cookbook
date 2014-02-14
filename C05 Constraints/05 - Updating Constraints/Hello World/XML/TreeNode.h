/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import <CoreFoundation/CoreFoundation.h>

@interface TreeNode : NSObject
@property (nonatomic, assign) 	TreeNode		*parent;
@property (nonatomic, strong) 	NSMutableArray	*children;
@property (nonatomic, strong) 	NSString		*key;
@property (nonatomic, strong) 	NSString		*leafvalue;

@property (nonatomic, readonly) BOOL			isLeaf;
@property (nonatomic, readonly) BOOL			hasLeafValue;

@property (nonatomic, readonly) NSArray			*keys;
@property (nonatomic, readonly) NSArray			*allKeys;
@property (nonatomic, readonly) NSArray			*uniqKeys;
@property (nonatomic, readonly) NSArray			*uniqAllKeys;
@property (nonatomic, readonly) NSArray			*leaves;
@property (nonatomic, readonly) NSArray			*allLeaves;

@property (nonatomic, readonly) NSString		*dumpString;


+ (TreeNode *) treeNode;
- (NSString *) dumpString;

// Leaf Utils
- (BOOL) isLeaf;
- (BOOL) hasLeafValue;
- (NSArray *) leaves;
- (NSArray *) allLeaves;

// Key Utils
- (NSArray *) keys; 
- (NSArray *) allKeys; 
- (NSArray *) uniqKeys;
- (NSArray *) uniqAllKeys;


// Search Utils
- (TreeNode *) nodeForKey: (NSString *) aKey;
- (TreeNode *) nodeForKeys: (NSArray *) keys;
- (NSMutableArray *) nodesForKey: (NSString *) aKey;

- (NSString *) leafForKey: (NSString *) aKey;
- (NSString *) leafForKeys: (NSArray *) keys;
- (NSMutableArray *) leavesForKey: (NSString *) aKey;

// Convert Utils
- (NSMutableDictionary *) dictionaryForChildren;
@end
