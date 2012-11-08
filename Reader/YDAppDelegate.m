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
//#import "YDCachingURLProtocol.h"

@implementation YDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {

    // Create the main window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Load the publication
    NSString *publicationPath  = [[NSBundle mainBundle] pathForResource:@"publication" ofType:@"json" inDirectory:@"Publication"];
    YDPublication *publication = [[YDPublication alloc] initWithPath:publicationPath];

    // Load the main controller
    self.viewController = [[YDPublicationViewController alloc] initWithPublication:publication];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];

    return YES;
    
}

@end
