//
//  YDViewController.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YDPublication;

@interface YDViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) YDPublication *publication;
@property (nonatomic,strong) IBOutlet UITableView *tblArticles;

@end
