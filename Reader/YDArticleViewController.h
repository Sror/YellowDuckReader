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
@property (nonatomic,strong) IBOutlet UILabel *lblMagazine;
@property (nonatomic,strong) IBOutlet UILabel *lblArticleTitle;
@property (nonatomic,strong) IBOutlet UIWebView *articleView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic,strong) YDPublicationViewController *viewDeckController;
@property (nonatomic,strong) UIPopoverController *shareController;
@property (nonatomic,strong) IBOutlet UIButton *btnShare;

- (id)initWithPublication:(YDPublication*)publication;

- (void)loadArticleWithIndex:(int)articleIndex fromPublication:(YDPublication*)publication;
- (void)loadArticle:(YDArticle*)article fromPublication:(YDPublication*)publication;

- (IBAction)showMenu:(id)sender;
- (IBAction)showShareSheet:(id)sender;

@end
