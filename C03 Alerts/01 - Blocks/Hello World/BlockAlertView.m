/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "BlockAlertView.h"

@implementation BlockAlertView
{
    __weak id <UIAlertViewDelegate> externalDelegate;
    NSMutableDictionary * actionBlocks;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        actionBlocks = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message
{
    return [super initWithTitle:title message:message delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
}

- (NSInteger)setCancelButtonWithTitle:(NSString *)title actionBlock:(AlertViewBlock)block
{
    if (!title) return -1;
    NSInteger index = [self addButtonWithTitle:title actionBlock:block];
    self.cancelButtonIndex = index;
    return index;
}

- (NSInteger)addButtonWithTitle:(NSString *)title actionBlock:(AlertViewBlock)block
{
    if (!title) return -1;
    NSInteger index = [self addButtonWithTitle:title];
    if (block)
    {
        actionBlocks[@(index)] = [block copy];
    }
    return index;
}

- (id<UIAlertViewDelegate>)delegate
{
	return externalDelegate;
}

- (void)setDelegate:(id)delegate
{
    if (delegate == nil)
    {
        [super setDelegate:nil];
        externalDelegate = nil;
    }
    if (delegate == self)
    {
        [super setDelegate:self];
    }
    else
    {
        externalDelegate = delegate;
    }
}

#pragma mark - UIAlertViewDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < (NSInteger)actionBlocks.allValues.count)
    {
        AlertViewBlock actionBlock = actionBlocks[@(buttonIndex)];
        if (actionBlock)
        {
            actionBlock();
        }
    }
}

@end
