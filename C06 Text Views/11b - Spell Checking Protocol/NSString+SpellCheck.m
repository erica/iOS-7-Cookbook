//
//  NSString+SpellCheck.m
//  Hello World
//
//  Created by Rich Wardwell on 11/11/13.
//  Copyright (c) 2013 Erica Sadun. All rights reserved.
//

#import "NSString+SpellCheck.h"

@implementation NSString (SpellCheck)

- (BOOL)isSpelledCorrectly
{
    UITextChecker *checker = [[UITextChecker alloc] init];
    NSRange checkRange = NSMakeRange(0, self.length);
    NSString *language = [[NSLocale currentLocale]
                          objectForKey:NSLocaleLanguageCode];
    NSRange range = [checker rangeOfMisspelledWordInString:self
                                                     range: checkRange startingAt:0 wrap:NO
                                                  language:language];
    return (range.location == NSNotFound);
}

@end
