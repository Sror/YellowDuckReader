//
//  NSString+Additions.m
//  Reader
//
//  Created by Pieter Claerhout on 09/05/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "NSString+Additions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Additions)

// Check if the haystack contains the needle
- (BOOL)contains:(NSString*)needle {
	NSRange range = [self rangeOfString:needle];
	return (range.location == NSNotFound) ? NO : YES;
}

// Check if a string is empty
- (BOOL)isEmpty {
	return [self isEqualToString:@""];
}

// Create an sha1 version of a string
- (NSString*)sha1 {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
}

@end
