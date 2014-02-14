/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

UIColor *randomColor()
{
    return [UIColor colorWithRed:((rand() % 255) / 255.0f)
                           green:((rand() % 255) / 255.0f)
                            blue:((rand() % 255) / 255.0f)
                           alpha:0.3f];
}

CGRect centerRectInRect(CGRect rect, CGRect mainRect)
{
    return CGRectOffset(rect,
						CGRectGetMidX(mainRect)-CGRectGetMidX(rect),
						CGRectGetMidY(mainRect)-CGRectGetMidY(rect));
}

UIImage *stringImageTinted(NSString *string, UIFont *aFont, CGFloat side)
{
    CGSize imageSize = CGSizeMake(side, side);
    CGSize baseSize = [string sizeWithAttributes:@{NSFontAttributeName : aFont}];
    
    CGRect bounds = (CGRect){.size = imageSize};
    CGRect stringBounds = (CGRect){.size = baseSize};
    
    CGRect insetRect = centerRectInRect(stringBounds, bounds);
    
	UIGraphicsBeginImageContext(imageSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    // Tint a random color over the white backdrop
    [randomColor() set];
    CGContextAddRect(context, bounds);
    CGContextFillPath(context);
    
    // Draw a black edge
    [[UIColor blackColor] set];
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, 10.0f);
    CGContextStrokePath(context);
    
    // Draw the string in black
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary * attributes = @{NSFontAttributeName : aFont, NSParagraphStyleAttributeName : paragraphStyle, NSForegroundColorAttributeName : [UIColor blackColor]};
    [string drawInRect:insetRect withAttributes:attributes];
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
