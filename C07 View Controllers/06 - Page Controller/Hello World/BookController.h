/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import <UIKit/UIKit.h>

// Used for storing the most recent book page used
#define DEFAULTS_BOOKPAGE   @"BookControllerMostRecentPage"

typedef enum
{
    BookLayoutStyleBook, // side by side in landscape
    BookLayoutStyleFlipBook, // side by side in portrait
    BookLayoutStyleHorizontalScroll,
    BookLayoutStyleVerticalScroll,
} BookLayoutStyle;

@protocol BookControllerDelegate <NSObject>
- (id)viewControllerForPage:(NSInteger)pageNumber;
@optional
- (NSInteger)numberOfPages; // primarily for scrolling layouts
- (void)bookControllerDidTurnToPage:(NSNumber *)pageNumber;
@end

@interface BookController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
+ (instancetype)bookWithDelegate:(id<BookControllerDelegate>)theDelegate;
+ (instancetype)bookWithDelegate:(id<BookControllerDelegate>)theDelegate style:(BookLayoutStyle)aStyle;
- (void)moveToPage:(NSUInteger)requestedPage;
- (NSInteger)currentPage;

@property (nonatomic, weak) id <BookControllerDelegate> bookDelegate;
@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) BookLayoutStyle layoutStyle;
@end