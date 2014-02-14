/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "TreeNode.h"

// String stripper utility macro
#define STRIP(X)	[X stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

@implementation TreeNode
#pragma mark Create and Initialize TreeNodes
+ (TreeNode *) treeNode
{
    TreeNode *node = [[self alloc] init];
    node.children = [NSMutableArray array];
	return node;
}

#pragma mark TreeNode type routines
- (BOOL) isLeaf
{
	return (self.children.count == 0);
}

- (BOOL) hasLeafValue
{
	return (self.leafvalue != nil);
}

#pragma mark TreeNode data recovery routines
// Return an array of child keys. No recursion
- (NSArray *) keys
{
	NSMutableArray *results = [NSMutableArray array];
	for (TreeNode *node in self.children) [results addObject:node.key];
	return results;
}

// Return an array of child keys with depth-first recursion.
- (NSArray *) allKeys
{
	NSMutableArray *results = [NSMutableArray array];
	for (TreeNode *node in self.children) 
	{
		[results addObject:node.key];
		[results addObjectsFromArray:node.allKeys];
	}
	return results;
}

- (NSArray *) uniqArray: (NSArray *) anArray
{
	NSMutableArray *array = [NSMutableArray array];
	for (id object in [anArray sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)])
		if (![[array lastObject] isEqualToString:object]) [array addObject:object];
	return array;
}

// Return a sorted, uniq array of child keys. No recursion
- (NSArray *) uniqKeys
{
	return [self uniqArray:[self keys]];
}

// Return a sorted, uniq array of child keys. With depth-first recursion
- (NSArray *) uniqAllKeys
{
	return [self uniqArray:[self allKeys]];
}

// Return an array of child leaves. No recursion
- (NSArray *) leaves
{
	NSMutableArray *results = [NSMutableArray array];
	for (TreeNode *node in self.children)
        if (node.leafvalue)
            [results addObject:node.leafvalue];
	return results;
}

// Return an array of child leaves with depth-first recursion.
- (NSArray *) allLeaves
{
	NSMutableArray *results = [NSMutableArray array];
	for (TreeNode *node in self.children) 
	{
		if (node.leafvalue)
            [results addObject:node.leafvalue];
		[results addObjectsFromArray:node.allLeaves];
	}
	return results;
}

#pragma mark TreeNode search and retrieve routines

// Return the first child that matches the key, searching recursively breadth first
- (TreeNode *) nodeForKey: (NSString *) aKey
{
	TreeNode *result = nil;
	for (TreeNode *node in self.children) 
		if ([node.key isEqualToString: aKey])
		{
			result = node;
			break;
		}
	if (result) return result;
	for (TreeNode *node in self.children)
	{
		result = [node nodeForKey:aKey];
		if (result) break;
	}
	return result;
}

// Return the first leaf whose key is a match, searching recursively breadth first
- (NSString *) leafForKey: (NSString *) aKey
{
	TreeNode *node = [self nodeForKey:aKey];
	return node.leafvalue;
}

// Return all children that match the key, including recursive depth first search.
- (NSMutableArray *) nodesForKey: (NSString *) aKey
{
	NSMutableArray *result = [NSMutableArray array];
	for (TreeNode *node in self.children) 
	{
		if ([node.key isEqualToString: aKey]) [result addObject:node];
		[result addObjectsFromArray:[node nodesForKey:aKey]];
	}
	return result;
}

// Return all leaves that match the key, including recursive depth first search.
- (NSMutableArray *) leavesForKey: (NSString *) aKey
{
	NSMutableArray *result = [NSMutableArray array];
	for (TreeNode *node in [self nodesForKey:aKey]) 
		if (node.leafvalue)
			[result addObject:node.leafvalue];
	return result;
}

// Follow a key path that matches each first found branch, returning object
- (TreeNode *) nodeForKeys: (NSArray *) keys
{
	if (keys.count == 0) return self;
	
	NSMutableArray *nextArray = [NSMutableArray arrayWithArray:keys];
	[nextArray removeObjectAtIndex:0];
	
	for (TreeNode *node in self.children)
	{
		if ([node.key isEqualToString:[keys objectAtIndex:0]])
			return [node nodeForKeys:nextArray];
	}
	
	return nil;
}

// Follow a key path that matches each first found branch, returning leaf
- (NSString *) leafForKeys: (NSArray *) keys
{
	TreeNode *node = [self nodeForKeys:keys];
	return node.leafvalue;
}

#pragma mark output utilities
// Print out the tree
- (void) dumpAtIndent: (int) indent into:(NSMutableString *) outstring
{
	for (int i = 0; i < indent; i++) [outstring appendString:@"--"];
	
	[outstring appendFormat:@"[%2d] Key: %@ ", indent, _key];
	if (self.leafvalue) [outstring appendFormat:@"(%@)", STRIP(self.leafvalue)];
	[outstring appendString:@"\n"];
	
	for (TreeNode *node in self.children) [node dumpAtIndent:indent + 1 into: outstring];
}

- (NSString *) dumpString
{
	NSMutableString *outstring = [[NSMutableString alloc] init];
	[self dumpAtIndent:0 into:outstring];
	return outstring;
}

#pragma mark conversion utilities
// When you're sure you're the parent of all leaves, transform to a dictionary
- (NSMutableDictionary *) dictionaryForChildren
{
	NSMutableDictionary *results = [NSMutableDictionary dictionary];
	
	for (TreeNode *node in self.children)
		if (node.hasLeafValue) [results setObject:node.leafvalue forKey:node.key];
	
	return results;
}

#pragma mark invocation forwarding
// Invocation Forwarding lets node act like array
- (id)forwardingTargetForSelector:(SEL)sel 
{ 
	if ([self.children respondsToSelector:sel]) return self.children; 
	return nil;
}

// Extend selector compliance
- (BOOL)respondsToSelector:(SEL)aSelector
{
	if ( [super respondsToSelector:aSelector] )	return YES;
	if ([self.children respondsToSelector:aSelector]) return YES;
	return NO;
}

// Allow posing as NSArray class for children
- (BOOL)isKindOfClass:(Class)aClass
{
	if (aClass == [TreeNode class]) return YES;
	if ([super isKindOfClass:aClass]) return YES;
	if ([self.children isKindOfClass:aClass]) return YES;
	
	return NO;
}
@end