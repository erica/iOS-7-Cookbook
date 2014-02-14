/*
 
 Erica Sadun, http://ericasadun.com
 iOS 7 Cookbook
 Use at your own risk. Do no harm.
 
 */

@import Foundation;
@import MobileCoreServices;

NSString *uuid();

NSString *preferredExtensionForUTI(NSString *aUTI);
NSString *preferredMimeTypeForUTI(NSString *aUTI);
NSString *preferredUTIForExtension(NSString *ext);
NSString *preferredUTIForMIMEType(NSString *mime);

NSArray *allExtensions(NSString *aUTI);
NSArray *allMIMETypes(NSString *aUTI);

NSDictionary *utiDictionary(NSString *aUTI);
NSArray *conformanceArray(NSString *aUTI);

NSArray *allUTIsForExtension(NSString *ext);

BOOL pathPointsToLikelyUTIMatch(NSString *path, CFStringRef theUTI);

// You can add any number of these as desired.
BOOL pathPointsToLikelyImage(NSString *path);
BOOL pathPointsToLikelyAudio(NSString *path);