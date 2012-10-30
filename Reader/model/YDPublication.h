//
//  YDPublication.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YDArticle;

@interface YDPublication : NSObject

@property (nonatomic,strong) NSString *path;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *articles;

- (id)initWithPath:(NSString*)path;

- (YDArticle*)articleWithName:(NSString*)name;
- (NSString*)articleAtIndex:(int)index;
- (int)indexOfArticle:(NSString*)articleName;

@end
