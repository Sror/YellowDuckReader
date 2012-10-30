//
//  YDContentsViewController.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDPublication;
@class YDArticle;
@class YDPublicationViewController;

@interface YDContentsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) YDPublication *publication;
@property (nonatomic,strong) YDArticle *currentArticle;
@property (nonatomic,strong) IBOutlet UILabel *lblMagazine;
@property (nonatomic,strong) IBOutlet UITableView *contentsTable;
@property (nonatomic,strong) YDPublicationViewController *viewDeckController;

- (id)initWithPublication:(YDPublication*)publication;
- (void)highlightArticle:(YDArticle*)article;

@end
