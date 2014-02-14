/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "ReflectingView.h"
#import "PunchedLayout.h"

#pragma mark - TestBedViewController

@interface TestBedViewController : UICollectionViewController
@end

@implementation TestBedViewController
{
    NSMutableDictionary *artDictionary;
}

#pragma mark Flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(251.0f, 246.0f);
}

#pragma mark Data source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 20;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    UIImage *image = artDictionary[indexPath];
    if (!image)
    {
        image = blockImage();
        artDictionary[indexPath] = image;
    }
    
    cell.backgroundColor = [UIColor clearColor];
    if (![cell.contentView viewWithTag:99])
    {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.tag = 98;
        
        ReflectingView *rv = [[ReflectingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, imageView.frame.size.width, imageView.frame.size.height + 20.0f)];
        [rv setupReflection];
        rv.tag = 99;
        
        [cell.contentView addSubview:rv];
        [rv addSubview:imageView];
    }
    
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:98];
    imageView.image = image;
    
	return cell;
}

#pragma mark Setup

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        artDictionary = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    
    self.collectionView.backgroundColor = [UIColor blackColor];
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
    
    PunchedLayout *layout = [[PunchedLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 80.0f, 100.0f, 10.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
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
