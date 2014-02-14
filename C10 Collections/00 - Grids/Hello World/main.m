/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UICollectionViewController
@property (nonatomic, assign) BOOL useHeaders;
@property (nonatomic, assign) BOOL useFooters;
@property (nonatomic, assign) NSInteger numberOfSections;
@property (nonatomic, assign) NSInteger itemsInSection;
@end

@implementation TestBedViewController

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    if (self)
    {
        self.useFooters = NO;
        self.useHeaders = NO;
        self.numberOfSections = 1;
        self.itemsInSection = 1;
    }
    return self;
}

#pragma mark Flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return self.useHeaders ? CGSizeMake(60.0f, 30.0f) : CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return self.useFooters ? CGSizeMake(60.0f, 30.0f) : CGSizeZero;
}

#pragma mark Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemsInSection;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.numberOfSections;
}

- (UIImageView *)viewForIndexPath:(NSIndexPath *)indexPath
{
    NSString *string = [NSString stringWithFormat:@"S%d(%d)", indexPath.section, indexPath.item];
    UIImage *image = blockStringImage(string, 16.0f);
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    return imageView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)aCollectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectedBackgroundView = [[UIView alloc] init];
    cell.selectedBackgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
    
    if ([cell viewWithTag:999])
        [[cell viewWithTag:999] removeFromSuperview];
    
    UIImageView *imageView = [self viewForIndexPath:indexPath];
    imageView.tag = 999;
    
    [cell.contentView addSubview:imageView];
    PREPCONSTRAINTS(imageView);
    STRETCH_VIEW(cell.contentView, imageView);
    
	return cell;
}

- (UILabel *)labelForString:(NSString *)string
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 5.0f, 50.0f, 30.0f)];
    label.text = string;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Futura" size:14.0f];
    label.tag = 999;
    return label;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)aCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader)
    {
        UICollectionReusableView *header = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor blackColor];
        if (![header viewWithTag:999])
            [header addSubview:[self labelForString:@"Header"]];
        return header;
    }
    
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footer = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor darkGrayColor];
        if (![footer viewWithTag:999])
            [footer addSubview:[self labelForString:@"Footer"]];
        return footer;
    }
    
    return nil;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsMultipleSelection = YES;
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
    layout.itemSize = CGSizeMake(50.0f, 50.0f);
	TestBedViewController *tbvc = [[TestBedViewController alloc] initWithCollectionViewLayout:layout];
    tbvc.edgesForExtendedLayout = UIRectEdgeNone;

    // Figure 10-1a
    layout.sectionInset = UIEdgeInsetsMake(25.0f, 25.0f, 25.0f, 25.0f);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    tbvc.numberOfSections = 100;
    tbvc.itemsInSection = 12;
    
    // Figure 10-1b
    //layout.sectionInset = UIEdgeInsetsMake(10.0f, 25.0f, 40.0f, 25.0f);
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //tbvc.numberOfSections = 100;
    //tbvc.itemsInSection = 12;
    
    // Figure 10-2*
    //layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //tbvc.numberOfSections = 1;
    //tbvc.itemsInSection = 12;
    
    // Figure 10-2b
    //layout.minimumLineSpacing = 50.0f;
    
    // Figure 10-2c
    //layout.minimumInteritemSpacing = 30.0f;
    
    // Figure 10-3*
    //layout.sectionInset = UIEdgeInsetsMake(50.0f, 10.0f, 30.0f, 10.0f);
    //tbvc.numberOfSections = 100;
    //tbvc.itemsInSection = 12;
    //tbvc.useHeaders = YES;
    //tbvc.useFooters = YES;
    
    // Figure 10-3a/b
    //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    // Figure 10-3c/d
    //layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
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
