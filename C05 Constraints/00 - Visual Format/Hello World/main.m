/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import UIKit;
@import QuartzCore;
#import "Utility.h"

#pragma mark - MyLabel
@interface MyLabel : UILabel
@end

@implementation MyLabel

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor darkGrayColor];
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(100, 100);
}

@end

#pragma mark - TestBedViewController

@interface TestBedViewController : UIViewController
@end

@implementation TestBedViewController
{
    NSInteger currentFigure;
    MyLabel * view1;
    MyLabel * view2;
    MyLabel * view3;
    NSMutableArray * constraints;
}

- (void)action
{
    [self layoutFigure:currentFigure];
    currentFigure++;
    if (currentFigure > 8) currentFigure = 0;
}

- (void)layoutFigure:(NSInteger)number
{
    [self.view removeConstraints:constraints];
    [constraints removeAllObjects];
    switch (number) {
        case 0:     // Figure 5-2a
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:[view1][view2]", NSDictionaryOfVariableBindings(view1, view2))];
            break;

        case 1:     // Figure 5-2b
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 1;
            [constraints addObjectsFromArray:CONSTRAINTS(@"V:|[view1]-20-[view2]-20-[view3]", NSDictionaryOfVariableBindings(view1, view2, view3))];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|[view1]", NSDictionaryOfVariableBindings(view1, view2, view3))];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|[view2]", NSDictionaryOfVariableBindings(view1, view2, view3))];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|[view3]", NSDictionaryOfVariableBindings(view1, view2, view3))];
            break;
            
        case 2:     // Figure 5-3
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:[view1]-[view2]", NSDictionaryOfVariableBindings(view1, view2))];
            break;
            
        case 3:     // Figure 5-4
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:[view1]-30-[view2]", NSDictionaryOfVariableBindings(view1, view2))];
            break;
            
        case 4:     // Figure 5-5
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|[view1]-[view2]|", NSDictionaryOfVariableBindings(view1, view2))];
            break;
            
        case 5:     // Figure 5-6
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|-[view1]-[view2]-|", NSDictionaryOfVariableBindings(view1, view2))];
            break;
            
        case 6:     // Figure 5-7
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|-[view1]-(>=0)-[view2]-|", NSDictionaryOfVariableBindings(view1, view2))];
            break;
            
        case 7:     // Figure 5-8
            view1.alpha = 1;
            view2.alpha = 1;
            view3.alpha = 1;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|-[view1]-[view2]-(>=5)-[view3]-|", NSDictionaryOfVariableBindings(view1, view2, view3))];
            break;
            
        case 8:     // Figure 5-9
            view1.alpha = 1;
            view2.alpha = 0;
            view3.alpha = 0;
            [constraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0f constant:0.0f]];
            [constraints addObjectsFromArray:CONSTRAINTS(@"H:|-[view1(>=0)]-|", NSDictionaryOfVariableBindings(view1))];
            break;
            
        default:
            break;
    }
    [self.view addConstraints:constraints];
    [self.view layoutIfNeeded];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = BARBUTTON(@"Action", @selector(action));
    
    constraints = [[NSMutableArray alloc] init];
    
    view1 = [[MyLabel alloc] init];
    view1.text = @"View 1";
    view1.backgroundColor = [UIColor colorWithRed:0.694 green:0.894 blue:0.702 alpha:1];
    PREPCONSTRAINTS(view1);
    [self.view addSubview:view1];
    
    view2 = [[MyLabel alloc] init];
    view2.text = @"View 2";
    view2.backgroundColor = [UIColor colorWithRed:0.694 green:0.710 blue:0.902 alpha:1];
    PREPCONSTRAINTS(view2);
    [self.view addSubview:view2];
    
    view3 = [[MyLabel alloc] init];
    view3.text = @"View 3";
    view3.backgroundColor = [UIColor colorWithRed:0.910 green:0.702 blue:0.698 alpha:1];
    PREPCONSTRAINTS(view3);
    [self.view addSubview:view3];
    
    view1.alpha = 0;
    view2.alpha = 0;
    view3.alpha = 0;
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
