//
//  YDArticleViewCell.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDArticleViewCell.h"
#import "YDPublication.h"

@implementation YDArticleViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // Add the default web view
        self.articleWebView = [[UIWebView alloc] initWithFrame:self.bounds];

        // Make the webview transparent
        self.articleWebView.backgroundColor = [UIColor clearColor];
        [self.articleWebView setOpaque:NO];

        // Disable bouncing
        for (UIView *subView in self.articleWebView.subviews) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                UIScrollView *indexScrollView = (UIScrollView*)subView;
                indexScrollView.bounces = NO;
                break;
            }
        }

        // Make it resize automatically
        self.articleWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        // Add the view
        [self addSubview:self.articleWebView];

    }
    return self;
}

- (void)loadArticle:(NSString*)articleName fromPublication:(YDPublication*)publication {
    
    NSLog(@"Loading article: %@ from publication: %@", articleName, publication);

//    self.article     = articleName;
//    self.publication = publication;
    
    NSString *articlePath = [publication.publicationPath stringByAppendingPathComponent:articleName];
    NSURL *articleURL     = [NSURL fileURLWithPath:articlePath];
    
    [self.articleWebView loadRequest:[NSURLRequest requestWithURL:articleURL]];
    
    NSLog(@"cell size: %@", NSStringFromCGRect(self.frame));
    NSLog(@"webv size: %@", NSStringFromCGRect(self.articleWebView.frame));
    
}

@end
