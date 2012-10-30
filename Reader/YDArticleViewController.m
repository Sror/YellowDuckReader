//
//  YDViewController.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDArticleViewController.h"
#import "YDPublication.h"
#import "YDArticle.h"
#import "YDPublicationViewController.h"

@implementation YDArticleViewController

- (id)initWithPublication:(YDPublication*)publication {
    self = [super initWithNibName:@"YDArticleViewController" bundle:nil];
    if (self) {
        self.publication = publication;
    }
    return self;
}

- (void)viewDidLoad {
    
    // Call the parent function
    [super viewDidLoad];
    
    // Configure the contents view
    [self configureContentsView];
    
//    // Make the webview transparent
//    self.articleView.backgroundColor = [UIColor clearColor];
//    [self.articleView setOpaque:NO];
    
    // Disable bouncing
    for (UIView *subView in self.articleView.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            UIScrollView *indexScrollView = (UIScrollView*)subView;
            indexScrollView.bounces = NO;
            break;
        }
    }
    
    // Make ourselves the web viewer delegate
    self.articleView.delegate = self;
    
    // Load the first article
    [self loadArticleWithIndex:0 fromPublication:self.publication];
    
}

- (void)loadArticleWithIndex:(int)articleIndex fromPublication:(YDPublication*)publication {
    YDArticle *article = [publication.articles objectAtIndex:articleIndex];
    [self loadArticle:article fromPublication:publication];
}

- (void)loadArticle:(YDArticle*)article fromPublication:(YDPublication*)publication {
    NSLog(@"Loading %@ from %@", article, publication);
    self.currentArticle = article;
    NSURL *articleURL = [NSURL fileURLWithPath:article.path];
    [self.articleView loadRequest:[NSURLRequest requestWithURL:articleURL]];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    
    // Callback function
    if ( [request.URL.scheme isEqualToString:@"reader"] ) {
        if ([request.URL.host isEqualToString:@"showTOC"]) {
            [self performSelector:@selector(showMenu:) withObject:nil afterDelay:0.1f];
        }
        return NO;
    }
    
    // iTunes Request
    if ([request.URL.absoluteString hasPrefix:@"http://itunes.apple.com"] == YES) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    // Mailto request
    if ([request.URL.scheme isEqual:@"mailto"]) {
        NSString *recipient = [request.URL.absoluteString substringFromIndex:7];
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate    = self;
		[controller setToRecipients:@[recipient]];
		[self presentViewController:controller animated:YES completion:nil];
        return NO;
    }
    
    // Normal URL, should open the embedded web browser
    if ([request.URL.scheme isEqual:@"http"] == YES || [request.URL.scheme isEqual:@"https"] == YES) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    // Internal URL
    if ([request.URL.scheme isEqualToString:@"file"]) {
        NSString *articleName = request.URL.absoluteString.lastPathComponent;
        YDArticle *article    = [self.publication articleWithName:articleName];
        [self startLoadingArticle:article];
        [self.viewDeckController willLoadArticle:article];
        return YES;
    }
    
    // Follow the link
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self stopLoading];
}

- (void)webView:(UIWebView*)webView didFailLoadWithError:(NSError*)error {
    [self stopLoading];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
	[controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Orientation

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self configureContentsView];
}

#pragma mark - Helper functions

- (IBAction)showMenu:(id)sender {
    [self configureContentsView];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)startLoadingArticle:(YDArticle*)article {
    self.articleView.hidden      = YES;
    self.loadingView.hidden      = NO;
    self.loadingIndicator.hidden = NO;
    self.loadingLabel.text       = article.title;
    self.loadingLabel.hidden     = NO;
    [self.loadingIndicator startAnimating];
}

- (void)stopLoading {
    self.articleView.hidden = NO;
    self.loadingView.hidden = YES;
    [self.loadingIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)configureContentsView {

    // Calculate the size of the contents view
    int screenWidth  = self.view.bounds.size.width;
    int contentWidth = screenWidth - 250;
    
    // Set the size
    self.viewDeckController.leftLedge = contentWidth;

}

@end
