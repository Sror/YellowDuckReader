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
#import "NSMutableString+Additions.h"
#import <QuartzCore/QuartzCore.h>

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
    
    // Configure the web view
    self.articleView.scalesPageToFit    = NO;
    self.articleView.scrollView.bounces = NO;
    self.articleView.suppressesIncrementalRendering = YES;
    self.articleView.delegate           = self;
    
    // Add a shadow to the top bar
    self.lblMagazine.layer.masksToBounds = NO;
    self.lblMagazine.layer.shadowRadius  = 4;
    self.lblMagazine.layer.shadowOpacity = 0.5;
    self.lblMagazine.layer.shadowColor   = [[UIColor blackColor] CGColor];
    self.lblMagazine.layer.shadowOffset  = CGSizeZero;
    //self.lblMagazine.layer.shadowPath    = [[UIBezierPath bezierPathWithRect:self.lblMagazine.bounds] CGPath];
    
    // Load the first article
    [self loadArticleWithIndex:0 fromPublication:self.publication];
    
}

- (void)loadArticleWithIndex:(int)articleIndex fromPublication:(YDPublication*)publication {
    YDArticle *article = [publication.articles objectAtIndex:articleIndex];
    [self loadArticle:article fromPublication:publication];
}

- (void)loadArticle:(YDArticle*)article fromPublication:(YDPublication*)publication {

    // Show that we are loading
    NSLog(@"Loading %@ from %@", article, publication);
    self.currentArticle = article;
    
    // Clear the previous contents
    // See: http://stackoverflow.com/questions/2933315/clear-uiwebview-content-upon-dismissal-of-modal-view-iphone-os-3-0
    [self.articleView stringByEvaluatingJavaScriptFromString:@"document.open();document.close();"];
    
    // Load the HTML
    [self.articleView loadHTMLString:article.html
                             baseURL:article.url
     ];
    
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
        
        // Build temp array and dictionary
        NSArray *tempArray = [request.URL.absoluteString componentsSeparatedByString:@"?"];
        NSMutableDictionary *queryDictionary = [[NSMutableDictionary alloc] init];
        
        // Check array count to see if we have parameters to query
        if ([tempArray count] == 2) {
            NSArray *keyValuePairs = [[tempArray objectAtIndex:1] componentsSeparatedByString:@"&"];
            for (NSString *queryString in keyValuePairs) {
                NSArray *keyValuePair = [queryString componentsSeparatedByString:@"="];
                if (keyValuePair.count == 2) {
                    [queryDictionary setObject:[keyValuePair objectAtIndex:1] forKey:[keyValuePair objectAtIndex:0]];
                }
            }
        }
        
        // Parse the different parts of the URL
        NSString *email   = ([tempArray objectAtIndex:0]) ? [tempArray objectAtIndex:0] : [request.URL resourceSpecifier];
        NSString *subject = [queryDictionary objectForKey:@"subject"];
        NSString *body    = [queryDictionary objectForKey:@"body"];
        
        // Check if we can send mail
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
            mailer.mailComposeDelegate    = self;
            mailer.modalPresentationStyle = UIModalPresentationPageSheet;
            
            mailer.toRecipients = @[[email stringByReplacingOccurrencesOfString:@"mailto:" withString:@""]];
            mailer.subject      = [subject stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [mailer setMessageBody:[body stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] isHTML:NO];
            
            // Show the view
            [self presentViewController:mailer animated:YES completion:nil];
            
        } else {
            
            // Check if the system can handle a mailto link
            if ([[UIApplication sharedApplication] canOpenURL:request.URL]) {
                [[UIApplication sharedApplication] openURL:request.URL];
            } else {
                // Display error message
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                                message:@"Your device doesn't support the sending of emails!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil
                                      ];
                [alert show];
            }
        }
        
        // Don't follow the link
        return NO;

    }

    // Internal URL
    if ([request.URL.absoluteString hasPrefix:self.publication.baseURL.absoluteString]) {
        NSString *articleName = request.URL.absoluteString.lastPathComponent;
        YDArticle *article    = [self.publication articleWithName:articleName];
        [self startLoadingArticle:article];
        [self.viewDeckController willLoadArticle:article];
        return YES;
    }

    // Normal URL, should open the embedded web browser
    if ([request.URL.scheme isEqual:@"http"] == YES || [request.URL.scheme isEqual:@"https"] == YES) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }

    /*
    if ([request.URL.scheme isEqualToString:@"file"]) {
        NSString *articleName = request.URL.absoluteString.lastPathComponent;
        YDArticle *article    = [self.publication articleWithName:articleName];
        [self startLoadingArticle:article];
        [self.viewDeckController willLoadArticle:article];
        return YES;
    }
    */
    
    // Follow the link
    return YES;
    
}

- (void)webViewDidStartLoad:(UIWebView*)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView*)webView {
    [self stopLoading];
    
    // Inject the JavaScript API
    NSString *bridgeJSPath = [[NSBundle mainBundle] pathForResource:@"bridge" ofType:@"js"];
    NSString *bridgeJSData = [NSString stringWithContentsOfFile:bridgeJSPath encoding:NSUTF8StringEncoding error:nil];
    if (bridgeJSData) {
        [self.articleView stringByEvaluatingJavaScriptFromString:bridgeJSData];
    }
    
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
    //self.lblMagazine.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.lblMagazine.bounds] CGPath];
}

#pragma mark - Helper functions

- (IBAction)showMenu:(id)sender {
    [self configureContentsView];
    [self.viewDeckController toggleLeftViewAnimated:YES];
}

- (void)startLoadingArticle:(YDArticle*)article {
    self.btnShare.enabled        = NO;
    self.articleView.alpha       = 0;
    self.loadingIndicator.hidden = NO;
    self.lblArticleTitle.text    = article.title;
    [self.loadingIndicator startAnimating];
}

- (void)stopLoading {
    self.btnShare.enabled        = YES;
    self.loadingIndicator.hidden = YES;
    [self.loadingIndicator stopAnimating];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.articleView.scrollView.scrollsToTop = YES; // NOT WORKING
    self.articleView.alpha       = 1;
}

- (void)configureContentsView {

    // Calculate the size of the contents view
    int screenWidth  = self.view.bounds.size.width;
    int contentWidth = 10;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        contentWidth = screenWidth - 320;
    } else {
        if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            contentWidth = screenWidth - 320;
        }
    }

    // Set the size
    self.viewDeckController.leftSize = contentWidth;

}

- (IBAction)showShareSheet:(id)sender {

    NSArray* dataToShare = @[self.currentArticle.title, self.currentArticle.author];
    
    UIActivityViewController* activityViewController = [[UIActivityViewController alloc] initWithActivityItems:dataToShare
                                                                                         applicationActivities:nil
                                                        ];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.shareController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
        [self.shareController presentPopoverFromRect:self.btnShare.frame
                                              inView:self.view
                            permittedArrowDirections:UIPopoverArrowDirectionUp
                                            animated:YES
         ];
    } else {
        [self presentViewController:activityViewController
                           animated:YES
                         completion:nil
         ];
    }
    
}

@end
