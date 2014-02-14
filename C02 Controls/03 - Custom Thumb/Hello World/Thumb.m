/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "Thumb.h"

// Create a thumb image using a grayscale/numeric level
UIImage *thumbWithLevel (float aLevel)
{
    float INSET_AMT = 1.5f;
    CGRect baseRect = CGRectMake(0.0f, 0.0f, 40.0f, 100.0f);
    CGRect thumbRect = CGRectMake(0.0f, 40.0f, 40.0f, 20.0f);
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a filled rect for the thumb
    [[UIColor darkGrayColor] setFill];
    CGContextAddRect(context, CGRectInset(thumbRect, INSET_AMT, INSET_AMT));
    CGContextFillPath(context);
    
    // Outline the thumb
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 2.0f);    
    CGContextAddRect(context, CGRectInset(thumbRect, 2.0f * INSET_AMT, 2.0f * INSET_AMT));
    CGContextStrokePath(context);
    
    // Create a filled ellipse for the indicator
    CGRect ellipseRect = CGRectMake(0.0f, 0.0f, 40.0f, 40.0f);
    [[UIColor colorWithWhite:aLevel alpha:1.0f] setFill];
    CGContextAddEllipseInRect(context, ellipseRect);
    CGContextFillPath(context);
    
    // Label with a number
    NSString *numstring = [NSString stringWithFormat:@"%0.1f", aLevel];
    UIColor *textColor = (aLevel > 0.5f) ? [UIColor blackColor] : [UIColor whiteColor];
    UIFont *font = [UIFont fontWithName:@"Georgia" size:20.0f];
    NSMutableParagraphStyle * style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentCenter;
    NSDictionary * attr = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:style, NSForegroundColorAttributeName:textColor};
    [numstring drawInRect:CGRectInset(ellipseRect, 0.0f, 6.0f) withAttributes:attr];
    
    // Outline the indicator circle
    [[UIColor grayColor] setStroke];
    CGContextSetLineWidth(context, 3.0f);    
    CGContextAddEllipseInRect(context, CGRectInset(ellipseRect, 2.0f, 2.0f));
    CGContextStrokePath(context);
    
    // Build and return the image
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

// Return a base thumb image without the bubble
UIImage *simpleThumb()
{
    float INSET_AMT = 1.5f;
    CGRect baseRect = CGRectMake(0.0f, 0.0f, 40.0f, 100.0f);
    CGRect thumbRect = CGRectMake(0.0f, 40.0f, 40.0f, 20.0f);
    
    UIGraphicsBeginImageContext(baseRect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Create a filled rect for the thumb
    [[UIColor darkGrayColor] setFill];
    CGContextAddRect(context, CGRectInset(thumbRect, INSET_AMT, INSET_AMT));
    CGContextFillPath(context);
    
    // Outline the thumb
    [[UIColor whiteColor] setStroke];
    CGContextSetLineWidth(context, 2.0f);    
    CGContextAddRect(context, CGRectInset(thumbRect, 2.0f * INSET_AMT, 2.0f * INSET_AMT));
    CGContextStrokePath(context);
    
    // Retrieve the thumb
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}