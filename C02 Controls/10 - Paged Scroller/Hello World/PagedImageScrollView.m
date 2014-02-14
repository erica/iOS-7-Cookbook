/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "PagedImageScrollView.h"
#import "Utility.h"

@implementation PagedImageScrollView
{
    UIView * layoutContentView;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.showsHorizontalScrollIndicator = YES;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        layoutContentView = [UIView new];
        [self addSubview:layoutContentView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = self.bounds.size;
    size.width *= self.images.count;
    self.contentSize = size;
}

- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    layoutContentView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
}

- (void)setImages:(NSArray *)images
{
    _images = images;
    CGSize size = self.bounds.size;
    size.width *= self.images.count;
    self.contentSize = size;
    
    layoutContentView.frame = CGRectMake(0, 0, size.width, size.height);
    [layoutContentView removeConstraints:layoutContentView.constraints];
    for (UIView * v in layoutContentView.subviews)
    {
        [v removeFromSuperview];
    }
    
    NSMutableArray * imageViews = [[NSMutableArray alloc] init];
    for (UIImage * image in self.images)
    {
        UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [layoutContentView addSubview:imageView];
        PREPCONSTRAINTS(imageView);
        ALIGN_VIEW_TOP(layoutContentView, imageView);
        [self addConstraint:CONSTRAINT_MATCHING_HEIGHT(imageView, self)];
        [self addConstraint:CONSTRAINT_MATCHING_WIDTH(imageView, self)];
        [imageViews addObject:imageView];
    }
 
    UIView * leftView = nil;
    for (UIView * view in imageViews)
    {
        if (leftView)
                [layoutContentView addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:leftView attribute:NSLayoutAttributeRight multiplier:1.0f constant:0]];
        else
            ALIGN_VIEW_LEFT(layoutContentView, view);
        leftView = view;
    }
}

@end
