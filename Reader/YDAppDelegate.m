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
#import "SDURLCache.h"

@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    // Set the URL cache
    SDURLCache *urlCache = [[SDURLCache alloc] initWithMemoryCapacity:1024*1024     // 1MB mem cache
                                                         diskCapacity:1024*1024*500 // 5MB disk cache
                                                             diskPath:[SDURLCache defaultCachePath]
                            ];
    [NSURLCache setSharedURLCache:urlCache];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Load the publication
    NSString *publicationPath  = [[NSBundle mainBundle] pathForResource:@"Publication" ofType:@""];
    YDPublication *publication = [[YDPublication alloc] initWithPath:publicationPath];

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
