/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "ImageCell.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UICollectionViewController
@end

@implementation TestBedViewController
{
    NSArray *wordArray;
    NSMutableDictionary *artDictionary;
}

#pragma mark Utility

- (NSString *)itemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *subArray = wordArray[indexPath.section];
    return subArray[indexPath.row];
}

- (UIImage *)imageForString:(NSString *)aString
{
    NSArray *fontFamilies = [UIFont familyNames];
    NSString *fontName = fontFamilies[rand() % fontFamilies.count];
    CGFloat fontSize = (IS_IPAD ? 18.0f : 12.0f) + (rand() % 20);
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    
    UIImage *image = stringImageTinted(aString, font, 10.0f);
    return image;
}

#pragma mark Flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        NSString *item = [self itemAtIndexPath:indexPath];
        image = [self imageForString:item];
        artDictionary[indexPath] = image;
    }
    
    return image.size;
}

#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return wordArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *subArray = wordArray[section];
    return subArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	ImageCell *cell = (ImageCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    NSString *item = [self itemAtIndexPath:indexPath];
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        image = [self imageForString:item];
        artDictionary[indexPath] = image;
    }
    cell.imageView.image = image;
    cell.contentView.frame = (CGRect){.size = image.size};
    
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
    if (!(self = [super initWithCollectionViewLayout:layout])) return nil;
    
    wordArray = @[[@"lorem ipsum dolor sit amet consectetur adipiscing elit" componentsSeparatedByString:@" "],
                  [@"cras varius ultricies elit" componentsSeparatedByString:@" "],
                  [@"a tincidunt sem vehicula in" componentsSeparatedByString:@" "],
                  [@"nullam pellentesque elit nec ligula ultrices vitae ultricies erat interdum" componentsSeparatedByString:@" "],
                  [@"integer ut elit aliquam eros fermentum ornare vel vitae erat" componentsSeparatedByString:@" "],
                  [@"pellentesque habitant morbi tristique senectus" componentsSeparatedByString:@" "],
                  [@"enenatis tincidunt lorem sed suscipit" componentsSeparatedByString:@" "]];
    artDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    srand(time(NULL));
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = YES;
    
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Reload", @selector(action));
}

- (void)action
{
    artDictionary = [NSMutableDictionary dictionary];
    [self.collectionView reloadData];
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
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 50.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.itemSize = CGSizeMake(50.0f, 50.0f);
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
