/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import AudioToolbox;
@import MediaPlayer;
#import "SoundPlayer.h"

@implementation SoundPlayer

void _systemSoundDidComplete(SystemSoundID ssID, void *clientData)
{
    AudioServicesDisposeSystemSoundID(ssID);
}

+ (void) playAndDispose:(NSString *)sound
{
    NSString *sndpath = [[NSBundle mainBundle] pathForResource:sound ofType:@"wav"];
    if ((!sndpath) ||
        (![[NSFileManager defaultManager] fileExistsAtPath:sndpath]))
    {
        NSLog(@"Error: %@.wav not found", sound);
        return;
    }
    
    CFURLRef baseURL = (CFURLRef)CFBridgingRetain([NSURL fileURLWithPath:sndpath]);
    
    SystemSoundID sysSound;
    AudioServicesCreateSystemSoundID(baseURL, &sysSound);
    CFRelease(baseURL);
    
    AudioServicesAddSystemSoundCompletion(sysSound, NULL, NULL, _systemSoundDidComplete, NULL);
    
    if ([MPMusicPlayerController iPodMusicPlayer].playbackState ==  MPMusicPlaybackStatePlaying)
        AudioServicesPlayAlertSound(sysSound);
    else
        AudioServicesPlaySystemSound(sysSound);
}

@end
