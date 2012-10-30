//
//  YDPublicationViewController.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDPublicationViewController.h"
#import "YDArticleViewController.h"
#import "YDContentsViewController.h"

@implementation YDPublicationViewController

- (id)initWithPublication:(YDPublication*)publication {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.publication = publication;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.centerController = [[YDArticleViewController alloc] initWithPublication:self.publication];
    self.leftController   = [[YDContentsViewController alloc] initWithPublication:self.publication];
    self.rightController  = nil;
    
}

- (void)willLoadArticle:(YDArticle*)article {
    YDContentsViewController *contentsViewController = (YDContentsViewController*)self.leftController;
    [contentsViewController highlightArticle:article];
}

- (void)loadArticle:(YDArticle*)article {
    
    YDArticleViewController *articleViewController = (YDArticleViewController*)self.centerController;
    [articleViewController loadArticle:article fromPublication:self.publication];
    
    [self closeLeftViewAnimated:YES];
    
}

@end
