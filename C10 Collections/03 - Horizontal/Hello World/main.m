/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"


#pragma mark - InsetCollectionView

@interface InsetCollectionView : UIView <UICollectionViewDataSource>
@property (strong, readonly) UICollectionView *collectionView;
@end

@implementation InsetCollectionView

#pragma mark Data Source

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 100;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
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
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
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

#pragma mark Setup

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(40.0f, 10.0f, 40.0f, 10.0f);
        layout.minimumLineSpacing = 10.0f;
        layout.minimumInteritemSpacing = 10.0f;
        layout.itemSize = CGSizeMake(100.0f, 100.0f);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor darkGrayColor];
        _collectionView.allowsMultipleSelection = YES;
        _collectionView.dataSource = self;
        
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        [self addSubview:_collectionView];
        
        PREPCONSTRAINTS(_collectionView);
        CONSTRAIN(self, _collectionView, @"H:|[_collectionView(>=0)]|");
        CONSTRAIN(self, _collectionView, @"V:|-20-[_collectionView(>=0)]-20-|");
    }
    return self;
}
@end


#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    InsetCollectionView *cv;
}

#pragma mark Setup

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    cv = [[InsetCollectionView alloc] initWithFrame:CGRectZero];
    cv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cv];
    
    PREPCONSTRAINTS(cv);
    CONSTRAIN(self.view, cv, @"H:|[cv(>=0)]|");
    CONSTRAIN(self.view, cv, @"V:|-[cv(==220)]");
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
