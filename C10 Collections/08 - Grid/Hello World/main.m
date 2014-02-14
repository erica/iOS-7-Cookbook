/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "GridLayout.h"
#import "ImageCell.h"
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UICollectionViewController
@end

@implementation TestBedViewController
{
    NSMutableDictionary *artDictionary;
    UIFont *baseFont;
}

#pragma mark Flow layout

#define BASE_SIZE   200.0f

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(BASE_SIZE, BASE_SIZE);
    //return CGSizeMake(BASE_SIZE + 20.0f * indexPath.item, BASE_SIZE + 20.0f * indexPath.item);
}

#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 7;
    // return 1 + section; // for stairstep
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ImageCell *cell = (ImageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    CGFloat size = BASE_SIZE; //  + 20.0f * indexPath.item;
    
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        NSString *indexString = [NSString stringWithFormat:@"[S%d, I%d]", indexPath.section, indexPath.item];
        image = stringImageTinted(indexString, baseFont, size);
        artDictionary[indexPath] = image;
    }
    
    cell.imageView.image = image;
    
	return cell;
}

#pragma mark Delegate methods

- (void)collectionView:(UICollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected %@", indexPath);
    self.title = [NSString stringWithFormat:@"%d items selected", [aCollectionView indexPathsForSelectedItems].count];
}

- (void)collectionView:(UICollectionView *)aCollectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Deselected %@", indexPath);
    self.title = [NSString stringWithFormat:@"%d items selected", [aCollectionView indexPathsForSelectedItems].count];
}

#pragma mark Setup

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        artDictionary = [NSMutableDictionary dictionary];
        baseFont = [UIFont fontWithName:@"Futura" size: IS_IPAD? 18.0f : 24.0f];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = NO;
    self.collectionView.allowsSelection = NO;
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
    
    srand(time(NULL));
    GridLayout *layout = [[GridLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    layout.minimumInteritemSpacing = 20.0f;
    layout.alignment = GridRowAlignmentCenter;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
	TestBedViewController *tbvc = [[TestBedViewController alloc] initWithCollectionViewLayout:layout];
    
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
