/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TextViewController

@interface TextViewController : UIViewController
@property (nonatomic, readonly) UITextView *textView;
@property (nonatomic, weak) UIActivity *activity;
@end

@implementation TextViewController
- (void)done
{
    [_activity activityDidFinish:YES];
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont fontWithName:@"Futura" size:16.0f];
        _textView.editable = NO;
        
        [self.view addSubview:_textView];
        PREPCONSTRAINTS(_textView);
        STRETCH_VIEW(self.view, _textView);
        
        self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(done));
    }
    return self;
}
@end


#pragma mark - MyActivity

@interface MyActivity : UIActivity
@end

@implementation MyActivity
{
    NSArray *items;
}

- (NSString *)activityType
{
    return @"CustomActivityTypeListItemsAndTypes";
}

- (NSString *)activityTitle
{
    return @"List Items (Cookbook)";
}

- (UIImage *)activityImage
{
    CGFloat targetSize = IS_IPAD ? 72 : 57;
    CGFloat inset = targetSize * 0.15; // 15% inset for art
    
    CGRect rect = CGRectMake(0.0f, 0.0f, targetSize, targetSize);
    UIGraphicsBeginImageContext(rect.size);
    
    rect = CGRectInset(rect, inset, inset);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:4.0f];
    [path stroke];
    
    rect = CGRectInset(rect, 0.0f, inset);
    [@"iOS" drawInRect:rect withAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Futura" size:IS_IPAD ? 18.0f : 12.0f]}];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems
{
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems
{
    items = activityItems;
}

- (UIViewController *)activityViewController
{
    TextViewController *tvc = [[TextViewController alloc] init];
    tvc.activity = self;
    UITextView *textView = tvc.textView;
    
    NSMutableString *string = [NSMutableString string];
    for (id item in items)
        [string appendFormat:@"%@: %@\n", [item class], [item description]];
    textView.text = string;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tvc];
    return nav;
}

@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController <UIActivityItemSource, UIPopoverControllerDelegate>
@end

@implementation TestBedViewController
{
    UIImageView *imageView;
    UIPopoverController *popover;
}

#pragma mark Utility
- (void)presentViewController:(UIViewController *)viewControllerToPresent
{
    if (popover) [popover dismissPopoverAnimated:NO];
    
    if (IS_IPHONE)
	{
        [self presentViewController:viewControllerToPresent animated:YES completion:nil];
	}
	else
	{
        popover = [[UIPopoverController alloc] initWithContentViewController:viewControllerToPresent];
        popover.delegate = self;
        [popover presentPopoverFromBarButtonItem:self.navigationItem.leftBarButtonItem
                        permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

// Popover was dismissed
- (void)popoverControllerDidDismissPopover:(UIPopoverController *)aPopoverController
{
    popover = nil;
}

#pragma mark Activity
- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return imageView.image;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return imageView.image;
}

- (void)action
{
    // Self adopts the UIActivityItemSource Protocol
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[self] applicationActivities:nil];
    
    // Or supply the item(s) directly
    // UIImage *secondImage = [UIImage imageNamed:@"BookCover"];
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image, secondImage] applicationActivities:nil];
    
    // Or roll your own activity
    /* UIImage *secondImage = [UIImage imageNamed:@"BookCover"];
     UIActivity *appActivity = [[MyActivity alloc] init];
     UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image, secondImage] applicationActivities:@[appActivity]]; */
    
    // String
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[@"Hello", @"World"]applicationActivities:nil];
    
    // array, dictionary, date, number, url
    // UIColor *color = [UIColor redColor];
    // NSURL *url = [NSURL URLWithString:@"http://ericasadun.com"];
    // NSArray *testArray = @[@"z", @"y", @"x"];
    // NSDate *date = [NSDate date];
    // NSDictionary *dict = @{@"hello":@"world"};
    // NSDictionary *dict = @{@"Hello":[UIColor greenColor]};
    
    // UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image] applicationActivities:nil];
    
    [self presentViewController:activity];
}

- (void)abc {imageView.image = blockImage(@" abc ");}
- (void)def {imageView.image = blockImage(@" def ");}
- (void)ghi {imageView.image = blockImage(@" ghi ");}

#pragma mark View Setup
- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemAction, @selector(action));
    self.navigationItem.rightBarButtonItems = @[
                                                BARBUTTON(@"ghi", @selector(ghi)),
                                                BARBUTTON(@"def", @selector(def)),
                                                BARBUTTON(@"abc", @selector(abc)),
                                                ];
    
    imageView = [[UIImageView alloc] initWithImage:blockImage(@" abc ")];
    imageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(self.view, imageView);
}

@end


#pragma mark - Application Setup

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@property (nonatomic, strong) UIWindow *window;
@end

@implementation TestBedAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    _window.tintColor = COOKBOOK_PURPLE_COLOR;
    TestBedViewController *tbvc = [[TestBedViewController alloc] init];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tbvc];
    _window.rootViewController = nav;
    [_window makeKeyAndVisible];
    return YES;
}

@end


#pragma mark - main

int main(int argc, char *argv[])
{
    @autoreleasepool
    {
        int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
        return retVal;
    }
}
