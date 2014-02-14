/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;

typedef enum
{
    GridRowAlignmentNone,
    GridRowAlignmentTop,
    GridRowAlignmentCenter,
    GridRowAlignmentBottom,
} GridRowAlignment;

@interface GridLayout : UICollectionViewFlowLayout

@property (nonatomic) GridRowAlignment alignment;

/* 
// If you want to subclass UICollectionViewLayout directly add these properties
@property (nonatomic) CGSize footerReferenceSize;
@property (nonatomic) CGSize headerReferenceSize;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat minimumInteritemSpacing;
@property (nonatomic) CGFloat minimumLineSpacing;
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
@property (nonatomic) UIEdgeInsets sectionInset;
*/
@end
