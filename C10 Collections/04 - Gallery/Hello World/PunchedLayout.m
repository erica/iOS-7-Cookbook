/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

#import "PunchedLayout.h"

@implementation PunchedLayout
{
    CGSize boundsSize;
    CGFloat midX;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(void)prepareLayout
{
    [super prepareLayout];
    
    boundsSize = self.collectionView.bounds.size;
    midX = boundsSize.width / 2.0f;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in array)
    {
        attributes.transform3D = CATransform3DIdentity;
        if (!CGRectIntersectsRect(attributes.frame, rect)) continue;
        
        CGPoint contentOffset = self.collectionView.contentOffset;
        CGPoint itemCenter = CGPointMake(attributes.center.x - contentOffset.x, attributes.center.y - contentOffset.y);
                
        CGFloat distance = ABS(midX - itemCenter.x);
        CGFloat normalized = distance / midX;
        normalized = MIN(1.0f, normalized);
        CGFloat zoom = cos(normalized * M_PI_4);
        
        // attributes.zIndex = 1;
        attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0f);
    }
    
    return array;
}
@end