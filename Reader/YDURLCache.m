//
//  YDURLCache.m
//  Reader
//
//  Created by Pieter Claerhout on 02/11/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDURLCache.h"

@implementation YDURLCache

- (NSCachedURLResponse*)cachedResponseForRequest:(NSURLRequest*)request {
    NSLog(@"REQ: %@", request);
    return [super cachedResponseForRequest:request];
}

@end
