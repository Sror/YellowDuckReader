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
#import "YDURLCache.h"

@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    // Set the URL cache
    [NSURLCache setSharedURLCache:[[YDURLCache alloc] init]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Load the publication
    NSString *publicationPath  = [[NSBundle mainBundle] pathForResource:@"book2" ofType:@""];
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
