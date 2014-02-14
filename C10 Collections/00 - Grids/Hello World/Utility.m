/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

void drawString(CGRect rect, UIFont *font, UIColor *color, NSString *string)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [color set];
    CGPoint corePoint = rect.origin;
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{NSForegroundColorAttributeName : color, NSFontAttributeName : font, NSParagraphStyleAttributeName : paragraphStyle};
    [string drawAtPoint:corePoint withAttributes:attributes];
    
    CGContextRestoreGState(context);
}

void fillRectWithColor(UIColor *color, CGRect bounds)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [color set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    CGContextRestoreGState(context);
}

void strokeRectWithColorAndWidth(UIColor *color, CGFloat width, CGRect bounds)
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    [color set];
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, width);
    CGContextStrokePath(context);
    
    CGContextRestoreGState(context);
}

UIImage *stringImage(NSString *string, UIFont *font, CGFloat inset, UIColor *color)
{
    CGSize baseSize = [string sizeWithAttributes:@{ NSFontAttributeName : font }];
    CGSize adjustedSize = CGSizeMake(baseSize.width + inset * 2, baseSize.height + inset * 2);
    
    // Start drawing
    //UIGraphicsBeginImageContext(adjustedSize);
    UIGraphicsBeginImageContextWithOptions(adjustedSize, NO, [UIScreen mainScreen].scale);
    
    // Draw backdrop
    CGRect bounds = (CGRect){.size = adjustedSize};
    fillRectWithColor([UIColor whiteColor], bounds);
    fillRectWithColor(color, bounds);
    
    // Draw a black edge
    strokeRectWithColorAndWidth([UIColor blackColor], inset, bounds);
    
    // Draw the string in black
    CGRect insetBounds = CGRectInset(bounds, inset, inset);
    drawString(insetBounds, font, [UIColor blackColor], string);
    
    // Return new image
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

UIImage *blockStringImage(NSString *string, float size)
{
    UIFont *font = [UIFont fontWithName:@"Futura" size:size];
    return stringImage(string, font, 10.0f, [UIColor whiteColor]);
}
