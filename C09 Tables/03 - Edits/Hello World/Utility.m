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
                           alpha:0.5f];
}

UIImage *stringImage(NSString *string, UIFont *aFont, CGFloat inset)
{
    CGSize baseSize = [string sizeWithAttributes:@{ NSFontAttributeName : aFont }];
    CGSize adjustedSize = CGSizeMake(baseSize.width + inset * 2, baseSize.height + inset * 2);
    
	UIGraphicsBeginImageContext(adjustedSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop
    CGRect bounds = (CGRect){.size = adjustedSize};
	[[UIColor whiteColor] set];
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
    NSDictionary * attributes = @{NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : aFont, NSParagraphStyleAttributeName : paragraphStyle};
    [string drawInRect:insetBounds withAttributes:attributes];

	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

UIImage *blockImage(CGFloat side)
{
    CGFloat inset = 10.0f;
    CGSize backgroundSize = CGSizeMake(side, side);
    CGRect bounds = (CGRect){.size = backgroundSize};
    
	UIGraphicsBeginImageContext(backgroundSize);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw white backdrop and frame
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    UIImage *frameImage = [UIImage imageNamed:@"frame.png"];
    [frameImage drawInRect:bounds];
    
    // Create a white backdrop
    bounds = (CGRect){.size = backgroundSize};
    
    // Prepare for the inset children
    CGRect insetBounds = CGRectInset(bounds, inset, inset);
    int numChildren = 4 + rand() % 4;
    
    for (int i = 0; i < numChildren; i++)
    {
        [randomColor() set];
        CGFloat randX = insetBounds.origin.x + (insetBounds.size.width * .7) * (rand() % 1000) / 1000.0f;
        CGFloat dx = insetBounds.size.width - randX;
        CGFloat randW = dx * (0.5f + (rand() % 1000) / 2000.0f);
        
        CGFloat randY = insetBounds.origin.y + (insetBounds.size.height * .7) * (rand() % 1000) / 1000.0f;
        CGFloat dy = insetBounds.size.height - randY;
        CGFloat randH = dy * (0.5f + (rand() % 1000) / 2000.0f);
        
        // Add the tinted child view
        CGRect childBounds = CGRectMake(randX, randY, randW, randH);
        CGContextAddEllipseInRect(context, childBounds);
        CGContextFillPath(context);
        
        [[UIColor blackColor] set];
        CGContextAddEllipseInRect(context, childBounds);
        CGContextSetLineWidth(context, 3.0f);
        CGContextStrokePath(context);
    }
    
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}
