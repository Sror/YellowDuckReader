//
//  YDArticleViewCell.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDPublication;

@interface YDArticleViewCell : UITableViewCell

//@property (nonatomic,strong) YDPublication *publication;
//@property (nonatomic,strong) NSString *article;
@property (nonatomic,strong) UIWebView *articleWebView;

- (void)loadArticle:(NSString*)articleName fromPublication:(YDPublication*)publication;

@end
