/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "GridLayout.h"

#define INDEXPATH(SECTION, ITEM) [NSIndexPath indexPathForItem:ITEM inSection:SECTION]

/*

 Note: This grid never wraps so never uses line spacing.
 
 */

@implementation GridLayout

#pragma mark Items

// Does a delegate provide individual sizing?
- (BOOL)usesIndividualItemSizing
{
    return [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)];
}

// Return cell size for an item
- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = self.itemSize;
    if ([self usesIndividualItemSizing])
        itemSize = [(id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    return itemSize;
}

#pragma mark Insets

// Individual insets?
- (BOOL)usesIndividualInsets
{
    return [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)];
}

// Return insets for section
- (UIEdgeInsets)insetsForSection:(NSInteger)section
{
    UIEdgeInsets insets = self.sectionInset;
    if ([self usesIndividualInsets])
        insets = [(id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
    return insets;
}

#pragma mark Item Spacing

// Individual item spacing?
- (BOOL)usesIndividualItemSpacing
{
    return [self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:minimumInteritemSpacingForSectionAtIndex:)];
}

// Return spacing for section
- (CGFloat)itemSpacingForSection:(NSInteger)section
{
    CGFloat spacing = self.minimumInteritemSpacing;
    if ([self usesIndividualItemSpacing])
        spacing = [(id <UICollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self minimumInteritemSpacingForSectionAtIndex:section];
    return spacing;
}

#pragma mark Layout Geometry

// Find the tallest subview
- (CGFloat)maxItemHeightForSection:(NSInteger)section
{
    CGFloat maxHeight = 0.0f;
    
    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    for (int i = 0; i < numberOfItems; i++)
    {
        NSIndexPath *indexPath = INDEXPATH(section, i);
        CGSize itemSize = [self sizeForItemAtIndexPath:indexPath];
        maxHeight = MAX(maxHeight, itemSize.height);
    }
    
    return maxHeight;
}

// "Horizontal" row-based extent from the start of the section to its end
- (CGFloat)fullWidthForSection:(NSInteger)section
{
    UIEdgeInsets insets = [self insetsForSection:section];
    CGFloat horizontalInsetExtent = insets.left + insets.right;
    CGFloat collectiveWidth = horizontalInsetExtent;   

    NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
    for (int i = 0; i < numberOfItems; i++)
    {
        NSIndexPath *indexPath = INDEXPATH(section, i);
        CGSize itemSize = [self sizeForItemAtIndexPath:indexPath];

        collectiveWidth += itemSize.width;
        collectiveWidth += [self itemSpacingForSection:section];
    }
    
    collectiveWidth -= [self itemSpacingForSection:section]; // take back one spacer, n-1
    
    return collectiveWidth;
}

// Bounding size for each section
- (CGSize)fullSizeForSection:(NSInteger)section
{
    CGFloat headerExtent = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.headerReferenceSize.width : self.headerReferenceSize.height;
    CGFloat footerExtent =(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.footerReferenceSize.width : self.footerReferenceSize.height;
    
    UIEdgeInsets insets = [self insetsForSection:section];
    CGFloat verticalInsetExtent = insets.top + insets.bottom;
    CGFloat maxHeight = [self maxItemHeightForSection:section];
    
    CGFloat fullHeight = headerExtent + footerExtent + verticalInsetExtent + maxHeight;
    CGFloat fullWidth = [self fullWidthForSection:section];

    return CGSizeMake(fullWidth, fullHeight);
}

// How far is each item offset within the section
- (CGFloat)horizontalInsetForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIEdgeInsets insets = [self insetsForSection:indexPath.section];
    CGFloat horizontalOffset = insets.left;
    
    for (int i = 0; i < indexPath.item; i++)
    {
        CGSize itemSize = [self sizeForItemAtIndexPath:INDEXPATH(indexPath.section, i)];
        horizontalOffset += (itemSize.width + [self itemSpacingForSection:indexPath.section]);
    }
    
    return horizontalOffset;
}

// How far is each item down
- (CGFloat)verticalInsetForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize thisItemSize = [self sizeForItemAtIndexPath:indexPath];
    CGFloat verticalOffset = 0.0f;

    // Previous sections
    for (int i = 0; i < indexPath.section; i++)
        verticalOffset += [self fullSizeForSection:i].height;
    
    // Header
    CGFloat headerExtent = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.headerReferenceSize.width : self.headerReferenceSize.height;
    verticalOffset += headerExtent;
    
    // Top inset
    UIEdgeInsets insets = [self insetsForSection:indexPath.section];
    verticalOffset += insets.top;
    
    // Vertical centering
    CGFloat maxHeight = [self maxItemHeightForSection:indexPath.section];
    CGFloat fullHeight = (maxHeight - thisItemSize.height);
    CGFloat midHeight = fullHeight / 2.0f;

    switch (self.alignment)
    {
        case GridRowAlignmentNone:
        case GridRowAlignmentTop:
            break;
        case GridRowAlignmentCenter:
            verticalOffset += midHeight;
            break;
        case GridRowAlignmentBottom:
            verticalOffset += fullHeight;
            break;
        default:
            break;
    }
    
    return verticalOffset;
}

#pragma mark Layout Attributes

// Provide per-item placement
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGSize thisItemSize = [self sizeForItemAtIndexPath:indexPath];

    CGFloat verticalOffset = [self verticalInsetForItemAtIndexPath:indexPath];
    CGFloat horizontalOffset = [self horizontalInsetForItemAtIndexPath:indexPath];

    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        attributes.frame = CGRectMake(horizontalOffset, verticalOffset, thisItemSize.width, thisItemSize.height);
    else
        attributes.frame = CGRectMake(verticalOffset, horizontalOffset, thisItemSize.width, thisItemSize.height);

	return attributes;
}

// Return full extent
- (CGSize)collectionViewContentSize
{
    NSInteger sections = self.collectionView.numberOfSections;
    
    CGFloat maxWidth = 0.0f;
    CGFloat collectiveHeight = 0.0f;
    
    for (int i = 0; i < sections; i++)
    {
        CGSize sectionSize = [self fullSizeForSection:i];
        collectiveHeight += sectionSize.height;
        maxWidth = MAX(maxWidth, sectionSize.width);
    }
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        return CGSizeMake(maxWidth, collectiveHeight);
    else
        return CGSizeMake(collectiveHeight, maxWidth);
}

// Provide grid layout attributes
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray array];
    for (NSInteger section = 0; section < self.collectionView.numberOfSections; section++)
        for (NSInteger item = 0 ; item < [self.collectionView numberOfItemsInSection: section]; item++)
        {
            UICollectionViewLayoutAttributes *layout = [self layoutAttributesForItemAtIndexPath:INDEXPATH(section, item)];
            [attributes addObject:layout];
        }
    return attributes;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}
@end
