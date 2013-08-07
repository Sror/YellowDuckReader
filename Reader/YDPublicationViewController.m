//
//  YDPublicationViewController.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDPublicationViewController.h"
#import "YDArticleViewController.h"
#import "YDContentsViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation YDPublicationViewController

- (id)initWithPublication:(YDPublication*)publication {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.publication = publication;
        self.delegate    = self;
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.centerController = [[YDArticleViewController alloc] initWithPublication:self.publication];
    self.leftController   = [[YDContentsViewController alloc] initWithPublication:self.publication];
    self.rightController  = nil;
    
    self.viewDeckController.leftSize = 320;
    self.viewDeckController.maxSize  = 320;
    self.viewDeckController.sizeMode = IIViewDeckLedgeSizeMode;

}

- (void)willLoadArticle:(YDArticle*)article {
    YDContentsViewController *contentsViewController = (YDContentsViewController*)self.leftController;
    [contentsViewController highlightArticle:article];
}

- (void)loadArticle:(YDArticle*)article {

    [self closeLeftViewAnimated:YES completion:^(IIViewDeckController *controller, BOOL success) {
        YDArticleViewController *articleViewController = (YDArticleViewController*)self.centerController;
        [articleViewController loadArticle:article fromPublication:self.publication];
    }];
    
}

- (void)viewDeckController:(IIViewDeckController*)viewDeckController applyShadow:(CALayer*)shadowLayer withBounds:(CGRect)rect {
    shadowLayer.masksToBounds = NO;
    shadowLayer.shadowRadius  = 4;
    shadowLayer.shadowOpacity = 0.5;
    shadowLayer.shadowColor   = [[UIColor blackColor] CGColor];
    shadowLayer.shadowOffset  = CGSizeZero;
    shadowLayer.shadowPath    = [[UIBezierPath bezierPathWithRect:rect] CGPath];
}

@end
