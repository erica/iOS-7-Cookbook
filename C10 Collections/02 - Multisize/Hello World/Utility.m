/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

UIImage *stringImageTinted(NSString *string, UIFont *aFont, CGFloat inset)
{
    CGSize baseSize = [string sizeWithAttributes:@{NSFontAttributeName : aFont}];
    CGSize adjustedSize = CGSizeMake(baseSize.width + inset * 2, baseSize.height + inset * 2);
    
	UIGraphicsBeginImageContext(adjustedSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop
    CGRect bounds = (CGRect){.size = adjustedSize};
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    // Tint a random color over the white backdrop
    [[UIColor colorWithRed:((rand() % 255) / 255.0f)
                     green:((rand() % 255) / 255.0f)
                      blue:((rand() % 255) / 255.0f)
                     alpha:0.5f] set];
    CGContextAddRect(context, bounds);
    CGContextFillPath(context);

    // Draw a black edge
    [[UIColor blackColor] set];
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, inset);
    CGContextStrokePath(context);

    // Draw the string in black
    CGRect insetBounds = CGRectInset(bounds, inset, inset);
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attributes = @{NSFontAttributeName : aFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]};
    [string drawInRect:insetBounds withAttributes:attributes];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}


