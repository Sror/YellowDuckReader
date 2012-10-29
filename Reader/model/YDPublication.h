//
//  YDPublication.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDPublication : NSObject

@property (nonatomic,strong) NSString *publicationPath;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSArray *contents;
@property (nonatomic,strong) NSError *parseError;

- (id)initWithPublication:(NSString*)publicationPath;
- (NSString*)articleAtIndex:(int)index;
- (int)indexOfArticle:(NSString*)articleName;

@end
