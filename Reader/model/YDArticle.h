//
//  YDArticle.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDArticle : NSObject

@property (nonatomic,strong) NSURL *url;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *author;
//@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSMutableString *html;

- (id)initWithURL:(NSURL*)url;

@end
