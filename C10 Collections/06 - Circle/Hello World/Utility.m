/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

UIImage *circleInBlock(CGFloat aSize)
{
    CGSize size = CGSizeMake(aSize, aSize);
    CGRect bounds = (CGRect){.size = size};
    CGRect inset = CGRectInset(bounds, aSize * 0.25, aSize * 0.25);
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[[UIColor blackColor] colorWithAlphaComponent:0.5f] set];
    CGContextFillEllipseInRect(context, inset);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

UIColor *randomColor()
{
    return [UIColor colorWithRed:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                           green:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                            blue:(0.5f + 0.5f*(rand() % 255) / 255.0f)
                           alpha:1.0f];
}

