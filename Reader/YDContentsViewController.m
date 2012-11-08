//
//  YDContentsViewController.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDContentsViewController.h"
#import "YDPublication.h"
#import "YDArticle.h"
#import "YDContentCellLarge.h"
#import "YDPublicationViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation YDContentsViewController

- (id)initWithPublication:(YDPublication *)publication {
    self = [super initWithNibName:@"YDContentsViewController" bundle:nil];
    if (self) {
        self.publication = publication;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UINib *contentCellNib = [UINib nibWithNibName:@"YDContentCell" bundle:nil];
    [self.contentsTable registerNib:contentCellNib forCellReuseIdentifier:@"YDContentCell"];
    
//    UIFont *interfaceFont = [UIFont fontWithName:@"PT Sans" size:17.0];
//    self.lblMagazine.font = interfaceFont;
    
    self.lblMagazine.layer.masksToBounds = NO;
    self.lblMagazine.layer.shadowRadius  = 4;
    self.lblMagazine.layer.shadowOpacity = 0.5;
    self.lblMagazine.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.lblMagazine.layer.shadowOffset  = CGSizeZero;
    self.lblMagazine.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:self.lblMagazine.bounds] CGPath];

}

#pragma mark - UITableViewDataSource

- (int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.publication.articles.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    YDContentCellLarge *cell = [tableView dequeueReusableCellWithIdentifier:@"YDContentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    YDArticle *article  = [self.publication.articles objectAtIndex:indexPath.row];
    cell.title.text     = article.title;
    cell.author.text    = article.author;
    if ([article isEqual:self.currentArticle]) {
        cell.title.textColor  = [UIColor blackColor];
        cell.author.textColor = [UIColor blackColor];
    } else {
        cell.title.textColor  = [UIColor grayColor];
        cell.author.textColor = [UIColor grayColor];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return 60;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YDArticle *article = [self.publication.articles objectAtIndex:indexPath.row];
    [self.viewDeckController loadArticle:article];
}

#pragma mark - Helpers

- (void)highlightArticle:(YDArticle*)article {
    self.currentArticle = article;
    [self.contentsTable reloadData];
}

@end
