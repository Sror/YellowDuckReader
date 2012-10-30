//
//  YDContentCell.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDContentCell.h"

@implementation YDContentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    UIFont *interfaceFontBold = [UIFont fontWithName:@"PTSans-Bold" size:15.0];
    self.title.font           = interfaceFontBold;

    UIFont *interfaceFont  = [UIFont fontWithName:@"PTSans-Italic" size:15.0];
    self.author.font       = interfaceFont;
    self.author.textColor  = [UIColor grayColor];
    
}

@end
