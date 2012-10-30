//
//  YDAppDelegate.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDPublicationViewController;

@interface YDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) YDPublicationViewController *viewController;

@end
