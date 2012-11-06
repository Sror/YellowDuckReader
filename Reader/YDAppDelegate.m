//
//  YDAppDelegate.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDAppDelegate.h"
#import "YDPublication.h"
#import "YDPublicationViewController.h"
//#import "SDURLCache.h"
#import "YDCachingURLProtocol.h"

@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

//    // Set the URL cache
//    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024     // 1MB mem cache
//                                                         diskCapacity:1024*1024*500 // 5MB disk cache
//                                                             diskPath:[SDURLCache defaultCachePath]
//                            ];
//    urlCache.allowCachingResponsesToNonCachedRequests = YES;
//    urlCache.minCacheInterval = 0;
//    urlCache.ignoreMemoryOnlyStoragePolicy = YES;
//    [NSURLCache setSharedURLCache:urlCache];

    [NSURLProtocol registerClass:[YDCachingURLProtocol class]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Load the publication
    //NSString *publicationPath  = [[NSBundle mainBundle] pathForResource:@"Publication" ofType:@""];
    NSURL *publicationURL      = [NSURL URLWithString:@"http://pieter.web.shphosting.com/publications/sample1/publication.json"];
    YDPublication *publication = [[YDPublication alloc] initWithURL:publicationURL];

    // Load the main controller
    self.viewController = [[YDPublicationViewController alloc] initWithPublication:publication];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
    
}

- (void)applicationWillResignActive:(UIApplication*)application {
}

- (void)applicationDidEnterBackground:(UIApplication*)application {
}

- (void)applicationWillEnterForeground:(UIApplication*)application {
}

- (void)applicationDidBecomeActive:(UIApplication*)application {
}

- (void)applicationWillTerminate:(UIApplication*)application {
}

@end
