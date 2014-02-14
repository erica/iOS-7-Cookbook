/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "Geometry.h"

CGPoint GEORectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

CGRect GEORectAroundCenter(CGPoint center, float dx, float dy)
{
    return CGRectMake(center.x - dx, center.y - dy, dx * 2, dy * 2);
}

CGRect GEORectCenteredInRect(CGRect rect, CGRect mainRect)
{
    CGFloat dx = CGRectGetMidX(mainRect)-CGRectGetMidX(rect);
    CGFloat dy = CGRectGetMidY(mainRect)-CGRectGetMidY(rect);
    return CGRectOffset(rect, dx, dy);
}

CGPoint GEOPointOffset(CGPoint aPoint, CGFloat dx, CGFloat dy)
{
    return CGPointMake(aPoint.x + dx, aPoint.y + dy);
}

// Equality Test - Shamelessly stolen from Sam "Svlad" Marshall
BOOL floatEqual(CGFloat a, CGFloat b)
{
    return (fabs(a-b) < FLT_EPSILON);
}

// Degrees from radians
CGFloat degrees(CGFloat radians)
{
    return radians * 180.0f / M_PI;
}

// Radians from degrees
CGFloat radians(CGFloat degrees)
{
    return degrees * M_PI / 180.0f;
}

// Return dot product of two vectors normalized
CGFloat dotproduct (CGPoint v1, CGPoint v2)
{
    CGFloat dot = (v1.x * v2.x) + (v1.y * v2.y);
    CGFloat a = ABS(sqrt(v1.x * v1.x + v1.y * v1.y));
    CGFloat b = ABS(sqrt(v2.x * v2.x + v2.y * v2.y));
    dot /= (a * b);
    
    return dot;
}

// Return distance between two points
CGFloat distance (CGPoint p1, CGPoint p2)
{
    CGFloat dx = p2.x - p1.x;
    CGFloat dy = p2.y - p1.y;
    
    return sqrt(dx*dx + dy*dy);
}

CGFloat dx(CGPoint p1, CGPoint p2)
{
    return p2.x - p1.x;
}

CGFloat dy(CGPoint p1, CGPoint p2)
{
    return p2.y - p1.y;
}

NSInteger sign(CGFloat x)
{
    return (x < 0.0f) ? (-1) : 1;
}

// Return a point with respect to a given origin
CGPoint pointWithOrigin(CGPoint pt, CGPoint origin)
{
    return CGPointMake(pt.x - origin.x, pt.y - origin.y);
}
