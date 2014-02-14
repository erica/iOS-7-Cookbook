/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

UIImage *blockImage(NSString *aString)
{
    UIFont *font = [UIFont fontWithName:@"Futura" size:96.0f];
    CGSize size = [aString sizeWithAttributes:@{ NSFontAttributeName : font }];
    size.width += 40.0f;
    size.height += 40.0f;
    
	UIGraphicsBeginImageContext(size);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGRect bounds = (CGRect){.size = size};
    
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    
    [[UIColor blackColor] set];
    bounds = CGRectInset(bounds, 8.0f, 8.0f);
	CGContextAddRect(context, bounds);
    CGContextSetLineWidth(context, 8.0f);
    CGContextStrokePath(context);
    
    bounds = CGRectInset(bounds, 8.0f, 8.0f);
    
    NSDictionary * attributes = @{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : font};
    [aString drawInRect:bounds withAttributes:attributes];
 
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

