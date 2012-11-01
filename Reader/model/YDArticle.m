//
//  YDArticle.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDArticle.h"
#import "GTMNSString+HTML.h"
#import "TFHpple.h"

@implementation YDArticle (Private)

- (void)parse {

    // Parse the HTML data
    NSData *data    = [[NSData alloc] initWithContentsOfFile:self.path];
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:data];
    
    // Get the title elements
    NSArray *titleTags       = [parser searchWithXPathQuery:@"//title"];
    if (titleTags.count > 0) {
        TFHppleElement *titleTag = [titleTags objectAtIndex:0];
        if (titleTag.content != nil && [titleTag.content isEqualToString:@""] == NO) {
            self.title = titleTag.content;
        }
    }
    
    // Get the meta tags
    NSArray *metaTags = [parser searchWithXPathQuery:@"//meta"];
    for (TFHppleElement *metaTag in metaTags) {
        if ([[[metaTag.attributes valueForKey:@"name"] lowercaseString] isEqualToString:@"author"] == YES) {
            self.author = [metaTag.attributes valueForKey:@"content"];
        }
    }
    
    // Update the image paths
    
    
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
        _title  = [_name stringByDeletingPathExtension];
        _author = @"";
        
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
