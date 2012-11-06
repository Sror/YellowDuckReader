//
//  YDCachingURLProtocol.m
//  Reader
//
//  Created by Pieter Claerhout on 09/05/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDCachingURLProtocol.h"
#import "NSString+Additions.h"

#pragma mark - Statics

static NSString *const YD_CACHING_URL_HEADER       = @"X-YDCache";
static NSString *const YD_CACHING_URL_KEY_DATA     = @"data";
static NSString *const YD_CACHING_URL_KEY_RESPONSE = @"response";

#pragma mark - YDCachedData

@interface YDCachedData : NSObject <NSCoding>

@property (nonatomic,strong) NSData *data;
@property (nonatomic,strong) NSURLResponse *response;

@end

#pragma mark - YDCachingURLProtocol

@interface YDCachingURLProtocol ()

@property (nonatomic,strong) NSURLRequest *request;
@property (nonatomic,strong) NSURLConnection *connection;
@property (nonatomic,strong) NSMutableData *data;
@property (nonatomic,strong) NSURLResponse *response;

- (void)appendData:(NSData*)newData;

@end

#pragma mark - YDCachingURLProtocol

@implementation YDCachingURLProtocol

//@synthesize request = _request;
//@synthesize connection = _connection;
//@synthesize data = _data;
//@synthesize response = _response;


+ (BOOL)canInitWithRequest:(NSURLRequest*)request {
    if ([request.URL.scheme isEqualToString:@"http"] && [request valueForHTTPHeaderField:YD_CACHING_URL_HEADER] == nil) {
        return YES;
    }
    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request{
    return request;
}

- (id)initWithRequest:(NSURLRequest*)request cachedResponse:(NSCachedURLResponse*)cachedResponse client:(id <NSURLProtocolClient>)client {
    NSMutableURLRequest *myRequest = [request mutableCopy];
    [myRequest setValue:@"" forHTTPHeaderField:YD_CACHING_URL_HEADER];
    self = [super initWithRequest:myRequest
                   cachedResponse:cachedResponse
                           client:client
            ];

    if (self) {
        self.request = myRequest;
    }
    return self;
}

- (NSString*)cachePathForRequest:(NSURLRequest*)aRequest {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    return [cachesPath stringByAppendingPathComponent:[aRequest.URL.absoluteString.sha1 stringByAppendingPathExtension:@"plist"]];
}

- (void)startLoading {
    YDCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:self.request]];
    if (cache) {
        NSData *data            = cache.data;
        NSURLResponse *response = cache.response;
        [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
        [self.client URLProtocol:self didLoadData:data];
        [self.client URLProtocolDidFinishLoading:self];
    } else {
        NSURLConnection *connection = [NSURLConnection connectionWithRequest:self.request delegate:self];
        [self setConnection:connection];
    }
}

- (void)stopLoading {
    [self.connection cancel];
}

#pragma mark - NSURLDelegate

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [self.client URLProtocol:self didLoadData:data];
    [self appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error{
    [self.client URLProtocol:self didFailWithError:error];
    self.connection = nil;
    self.data       = nil;
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response {
    self.response = response;
    [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    
    [self.client URLProtocolDidFinishLoading:self];

    NSString *cachePath = [self cachePathForRequest:self.request];
    YDCachedData *cache = [[YDCachedData alloc] init];
    cache.response = self.response;
    cache.data     = self.data;
    [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];

    self.connection = nil;
    self.data       = nil;

}

- (void)appendData:(NSData*)newData {
    if (self.data == nil) {
        self.data = [[NSMutableData alloc] initWithData:newData];
    } else {
        [self.data appendData:newData];
    }
}

@end

#pragma mark - YDCachedData

@implementation YDCachedData

- (void)encodeWithCoder:(NSCoder*)aCoder {
    [aCoder encodeObject:self.data forKey:YD_CACHING_URL_KEY_DATA];
    [aCoder encodeObject:self.response forKey:YD_CACHING_URL_KEY_RESPONSE];
}

- (id)initWithCoder:(NSCoder*)aDecoder {
    self = [super init];
    if (self != nil) {
        self.data     = [aDecoder decodeObjectForKey:YD_CACHING_URL_KEY_DATA];
        self.response = [aDecoder decodeObjectForKey:YD_CACHING_URL_KEY_RESPONSE];
    }
    return self;
}

@end