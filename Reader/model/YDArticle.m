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
    NSLog(@"%@", self.path);
    
    // Get the title elements
    NSArray *titleTags       = [parser searchWithXPathQuery:@"//title"];
    if (titleTags.count > 0) {
        TFHppleElement *titleTag = [titleTags objectAtIndex:0];
        NSLog(@"T: %@", [titleTag content]);
        if (titleTag.content != nil && [titleTag.content isEqualToString:@""] == NO) {
            self.title = titleTag.content;
        }
    }
    
    // Get the meta tags
    NSArray *metaTags = [parser searchWithXPathQuery:@"//meta"];
    for (TFHppleElement *metaTag in metaTags) {
        NSLog(@"M: %@", metaTag.attributes);
        if ([[metaTag.attributes valueForKey:@"name"] isEqualToString:@"author"] == YES) {
            NSLog(@"%@", metaTag);
        }
    }
    
    /*
    // Read the HTML
    NSString *html = [NSString stringWithContentsOfFile:self.path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil
                      ];
    
    // Parse the HTML
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
    if (error) {
        NSLog(@"Error: %@", error);
        return;
    }
    
    // Get the head element
    HTMLNode *head = parser.head;
    
    // Parse the title
    HTMLNode *titleTag = [head findChildTag:@"title"];
    if ([titleTag.contents isEqualToString:@""] == NO) {
        self.title = titleTag.contents;
    }
    
    // Parse the author
    NSArray *metaTags = [parser.html findChildTags:@"meta"];
    NSLog(@"%d %@", metaTags.count, self.name);
    for (HTMLNode *metaTag in metaTags) {
        if ([[[metaTag getAttributeNamed:@"name"] lowercaseString] isEqualToString:@"author"]) {
            self.author = [metaTag getAttributeNamed:@"content"];
        }
    }
    */

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
