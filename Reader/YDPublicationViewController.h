//
//  YDPublicationViewController.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "IIViewDeckController.h"

@class YDPublication;
@class YDArticle;

@interface YDPublicationViewController : IIViewDeckController

@property (nonatomic,strong) YDPublication *publication;

- (id)initWithPublication:(YDPublication*)publication;

- (void)willLoadArticle:(YDArticle*)article;
- (void)loadArticle:(YDArticle*)article;

@end
