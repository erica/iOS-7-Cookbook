/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

#import "VIDEOkit.h"

#define SAFE_PERFORM_WITH_ARG(THE_OBJECT, THE_SELECTOR, THE_ARG) (([THE_OBJECT respondsToSelector:THE_SELECTOR]) ? [THE_OBJECT performSelector:THE_SELECTOR withObject:THE_ARG] : nil)
#define SCREEN_CONNECTED	([UIScreen screens].count > 1)

@implementation VIDEOkit
{
	UIImageView *baseView;
}

- (void)setupExternalScreen
{
	// Check for missing screen
	if (!SCREEN_CONNECTED) return;
	
	// Set up external screen
	UIScreen *secondaryScreen = [UIScreen screens][1];
	UIScreenMode *screenMode = [[secondaryScreen availableModes] lastObject];
	CGRect rect = (CGRect){.size = screenMode.size};
	NSLog(@"Extscreen size: %@", NSStringFromCGSize(rect.size));
	
	// Create new outputWindow
	self.outputWindow = [[UIWindow alloc] initWithFrame:CGRectZero];
	_outputWindow.screen = secondaryScreen;
	_outputWindow.screen.currentMode = screenMode; // Thanks Scott Lawrence
	[_outputWindow makeKeyAndVisible];
	_outputWindow.frame = rect;

	// Add base video view to outputWindow
	baseView = [[UIImageView alloc] initWithFrame:rect];
	baseView.backgroundColor = [UIColor darkGrayColor];
	[_outputWindow addSubview:baseView];

	// Restore primacy of main window
	[_delegate.view.window makeKeyAndVisible];
}

- (void)updateScreen
{
	// Abort if the screen has been disconnected
	if (!SCREEN_CONNECTED && _outputWindow)
		self.outputWindow = nil;
	
	// (Re)initialize if there's no output window
	if (SCREEN_CONNECTED && !_outputWindow)
		[self setupExternalScreen];
	
	// Abort if we have encountered some weird error
	if (!self.outputWindow) return;
	
	// Go ahead and update
    SAFE_PERFORM_WITH_ARG(_delegate, @selector(updateExternalView:), baseView);
}

- (void)screenDidConnect: (NSNotification *) notification
{
    NSLog(@"Screen connected");
    UIScreen *screen = [[UIScreen screens] lastObject];
    
    if (_displayLink)
    {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        self.displayLink = nil;
    }
    
    self.displayLink = [screen displayLinkWithTarget:self selector:@selector(updateScreen)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)screenDidDisconnect: (NSNotification *) notification
{
	NSLog(@"Screen disconnected.");
    if (_displayLink)
    {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_displayLink invalidate];
        self.displayLink = nil;
    }
}

- (instancetype)init
{
	self = [super init];
    if (self)
    {
        // Handle output window creation
        if (SCREEN_CONNECTED)
            [self screenDidConnect:nil];
        
        // Register for connect/disconnect notifications
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidConnect:) name:UIScreenDidConnectNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenDidDisconnect:) name:UIScreenDidDisconnectNotification object:nil];
    }
	return self;
}

- (void)dealloc
{
    [self screenDidDisconnect:nil];
	self.outputWindow = nil;
}

+ (VIDEOkit *)sharedInstance
{
    static dispatch_once_t predicate;
    static VIDEOkit *sharedInstance = nil;
    dispatch_once(&predicate, ^{
        sharedInstance = [[VIDEOkit alloc] init];
    });
	return sharedInstance;
}

+ (void)startupWithDelegate:(UIViewController <VIDEOkitDelegate> *)aDelegate
{
    [[self sharedInstance] setDelegate:aDelegate];
}
@end
