//
//  YDArticle.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDArticle.h"
#import "GTMNSString+HTML.h"

@implementation YDArticle (Private)

- (void)parse {

    // Read the HTML
    NSString *html = [NSString stringWithContentsOfFile:self.path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil
                      ];
    
    // Find the title in the HTML
    NSRange r = [html rangeOfString:@"<title>"];
    if (r.location != NSNotFound) {
        NSRange r1 = [html rangeOfString:@"</title>"];
        if (r1.location != NSNotFound) {
            if (r1.location > r.location) {
                NSString *title = [html substringWithRange:NSMakeRange(NSMaxRange(r), r1.location - NSMaxRange(r))];
                self.title = [title gtm_stringByUnescapingFromHTML];
            }
        }
    }

}

@end

@implementation YDArticle

- (id)initWithPath:(NSString*)path {
    self = [super init];
    if (self) {
        
        // Assign the variables
        _path = path;
        _name = path.lastPathComponent;
        
        // Set the default variables
        _title = @"";
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (BOOL)isEqual:(YDArticle*)article {
    return [article.path isEqualToString:self.path];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<YDArticle: %@>", self.title];
}

@end
