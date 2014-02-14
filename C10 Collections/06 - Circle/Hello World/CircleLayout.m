/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "CircleLayout.h"

@implementation CircleLayout
{
    NSInteger numberOfItems;
    CGPoint centerPoint;
    CGFloat radius;
    
    NSMutableArray *insertedIndexPaths;
    NSMutableArray *deletedIndexPaths;
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    numberOfItems = [self.collectionView numberOfItemsInSection:0];
    centerPoint = CGPointMake(size.width / 2.0f, size.height / 2.0f);
    radius = MIN(size.width, size.height) / 3.0f;
    
    insertedIndexPaths = [NSMutableArray array];
    deletedIndexPaths = [NSMutableArray array];
}

// Fix the content size to the frame size
- (CGSize)collectionViewContentSize
{
    return self.collectionView.frame.size;
}

// Calculate position for each item
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    CGFloat progress = (float) path.item / (float) numberOfItems;
    CGFloat theta = 2.0f * M_PI * progress;
    CGFloat xPosition = centerPoint.x + radius * cos(theta);
    CGFloat yPosition = centerPoint.y + radius * sin(theta);
    attributes.size = [self itemSize];
    attributes.center = CGPointMake(xPosition, yPosition);
    return attributes;
}

// Calculate layouts
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger index = 0 ; index < numberOfItems; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
    }
    return attributes;
}

#pragma mark - Animated updates

// Build insertion and deletion collections from updates
- (void)prepareForCollectionViewUpdates:(NSArray *)updates
{
    [super prepareForCollectionViewUpdates:updates];
    
    for (UICollectionViewUpdateItem* updateItem in updates)
    {
        if (updateItem.updateAction == UICollectionUpdateActionInsert)
            [insertedIndexPaths addObject:updateItem.indexPathAfterUpdate];
        else if (updateItem.updateAction == UICollectionUpdateActionDelete)
            [deletedIndexPaths addObject:updateItem.indexPathBeforeUpdate];
    }
}

// Establish starting attributes for added item
- (UICollectionViewLayoutAttributes *)insertionAttributesForItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = centerPoint;
    return attributes;
}

// Establish ending attributes for deleted item
- (UICollectionViewLayoutAttributes *)deletionAttributesForItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
    attributes.alpha = 0.0;
    attributes.center = centerPoint;
    attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
    return attributes;
}

// Handle insertion animation for all items
- (UICollectionViewLayoutAttributes*)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath*)indexPath
{
    NSLog(@"INSERT");
    return [insertedIndexPaths containsObject:indexPath] ? [self insertionAttributesForItemAtIndexPath:indexPath] : [super initialLayoutAttributesForAppearingItemAtIndexPath:indexPath];
}

// Handle deletion animation for all items
- (UICollectionViewLayoutAttributes*)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath*)indexPath
{
    return [deletedIndexPaths containsObject:indexPath] ? [self deletionAttributesForItemAtIndexPath:indexPath] : [super finalLayoutAttributesForDisappearingItemAtIndexPath:indexPath];
}
@end
