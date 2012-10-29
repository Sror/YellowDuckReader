//
//  YDViewController.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDViewController.h"
#import "YDPublication.h"
#import "YDArticleViewCell.h"

@interface YDViewController ()

@end

@implementation YDViewController

- (void)viewDidLoad {
    
    // Call the parent function
    [super viewDidLoad];

    // Get the path to the publication
    NSString *publicationPath = [[NSBundle mainBundle] pathForResource:@"book" ofType:@""];
    self.publication          = [[YDPublication alloc] initWithPublication:publicationPath];
    
    // Register the table view cell
    [self.tblArticles registerClass:[YDArticleViewCell class] forCellReuseIdentifier:@"articleTableCell"];
    self.tblArticles.scrollEnabled = NO;
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return self.publication.contents.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
        
    static NSString *CellIdentifier = @"articleTableCell";
    
    YDArticleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                              forIndexPath:indexPath
                               ];
    NSString *article = [self.publication articleAtIndex:indexPath.row];
    [cell loadArticle:article fromPublication:self.publication];
    
    return cell;

}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    int rowHeight = [UIScreen mainScreen].bounds.size.height;
    if (UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation])) {
        rowHeight = [UIScreen mainScreen].bounds.size.width;
    }
    return rowHeight - 20;
}

#pragma mark - Rotation Handling

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"remembering the current article");
    NSLog(@"%@", self.tblArticles.visibleCells);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    NSLog(@"reloading the data for orientation: %d", [[UIDevice currentDevice] orientation]);
    [self.tblArticles reloadData];
    NSLog(@"activating the current article");
}
@end
