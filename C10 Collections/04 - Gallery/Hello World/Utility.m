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

UIImage *blockImage()
{
    CGFloat inset = 10.0f;
    CGSize backgroundSize = CGSizeMake(251.0f, 246.0f);
    CGRect bounds = (CGRect){.size = backgroundSize};
    
	UIGraphicsBeginImageContext(backgroundSize);
	CGContextRef context = UIGraphicsGetCurrentContext();

    // Draw white backdrop and frame
	[[UIColor whiteColor] set];
	CGContextAddRect(context, bounds);
	CGContextFillPath(context);
    UIImage *frameImage = [UIImage imageNamed:@"frame"];
    [frameImage drawInRect:bounds];
	    
    // Create a white backdrop
    bounds = CGRectMake(25.0f, 22.0f, 200.0f, 200.0f);
    
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



