/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"
#import "CustomCell.h"
#import "CircleLayout.h"


#pragma mark - TestBedViewController

@interface TestBedViewController : UICollectionViewController
@end

@implementation TestBedViewController
{
    NSInteger count;
}

#pragma mark Data source

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)_collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	CustomCell *cell = (CustomCell *)[self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.backgroundColor = randomColor();
    UIImageView *imageView = [[UIImageView alloc] initWithImage:circleInBlock(80.0f)];
    cell.selectedBackgroundView = imageView;
    
	return cell;
}

#pragma mark Editing

- (void)add
{
    [self becomeFirstResponder];
    
    int itemNumber = 0;
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    if (selectedItems.count)
        itemNumber = ((NSIndexPath *)selectedItems[0]).item + 1;
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemNumber inSection:0];
    
    count += 1;
    [self.collectionView performBatchUpdates:^{
        [self.collectionView insertItemsAtIndexPaths:@[itemPath]];
    } completion:^(BOOL done){
        [self.collectionView selectItemAtIndexPath:itemPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = (count < (IS_IPAD ? 20 : 8));
    }];
}

- (void)reenableDeleteButton
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)delete
{
    [self becomeFirstResponder];
    
    if (!count) return;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [self performSelector:@selector(reenableDeleteButton) withObject:nil afterDelay:0.15f];
    
    count -= 1;
    NSArray *selectedItems = [self.collectionView indexPathsForSelectedItems];
    NSInteger itemNumber = selectedItems.count ? ((NSIndexPath *)selectedItems[0]).item : 0;
    NSIndexPath *itemPath = [NSIndexPath indexPathForItem:itemNumber inSection:0];
    
    [self.collectionView performBatchUpdates:^{
        [self.collectionView deleteItemsAtIndexPaths:@[itemPath]];
    } completion:^(BOOL done){
        if (count)
            [self.collectionView selectItemAtIndexPath: [NSIndexPath indexPathForItem:MAX(0, itemNumber - 1) inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionNone];
        self.navigationItem.rightBarButtonItem.enabled = (count != 0);
        self.navigationItem.leftBarButtonItem.enabled = (count < (IS_IPAD ? 20 : 8));
    }];
}

#pragma mark Setup

- (BOOL) canBecomeFirstResponder
{
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.collectionView registerClass:[CustomCell class] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.allowsSelection = YES;
    self.collectionView.allowsMultipleSelection = NO;
    
    self.navigationItem.leftBarButtonItem = BARBUTTON(@"Add", @selector(add));
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Delete", @selector(delete));
    
    self.navigationItem.leftBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.title = @"Double-tap items";
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"ColorizeNotification" object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        UIColor *color = (UIColor *) note.object;
        if (color) self.navigationController.navigationBar.barTintColor = [color colorWithAlphaComponent:0.2f];
    }];
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
    CircleLayout *layout = [[CircleLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10.0f, 10.0f, 50.0f, 10.0f);
    layout.minimumLineSpacing = 10.0f;
    layout.minimumInteritemSpacing = 10.0f;
    layout.itemSize = CGSizeMake(80.0f, 80.0f);
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
