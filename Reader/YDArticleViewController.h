//
//  YDViewController.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@class YDPublication;
@class YDArticle;
@class YDPublicationViewController;

@interface YDArticleViewController : UIViewController <UIWebViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic,strong) YDArticle* currentArticle;
@property (nonatomic,strong) YDPublication *publication;
@property (nonatomic,strong) IBOutlet UIWebView *articleView;
@property (nonatomic,strong) IBOutlet UIView *loadingView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic,strong) IBOutlet UILabel *loadingLabel;
@property (nonatomic,strong) YDPublicationViewController *viewDeckController;

- (id)initWithPublication:(YDPublication*)publication;

- (void)loadArticleWithIndex:(int)articleIndex fromPublication:(YDPublication*)publication;
- (void)loadArticle:(YDArticle*)article fromPublication:(YDPublication*)publication;

- (IBAction)showMenu:(id)sender;

@end
