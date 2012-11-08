//
//  YDArticle.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDArticle.h"
#import "NSMutableString+Additions.h"
#import "TFHpple.h"

@implementation YDArticle (Private)

- (void)parse {
    
    // Read the HTML
    self.html = [NSMutableString stringWithContentsOfURL:self.url
                                                encoding:NSUTF8StringEncoding
                                                   error:nil
                 ];

    // Parse the HTML data
    NSData *data    = [[NSData alloc] initWithContentsOfURL:self.url];
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
        
        // Get the name of the meta tag
        NSString *metaTagName    = [[metaTag.attributes valueForKey:@"name"] lowercaseString];
        NSString *metaTagContent = [metaTag.attributes valueForKey:@"content"];
        
        // Parse the author
        if ([metaTagName isEqualToString:@"author"] == YES) {
            self.author = metaTagContent;
        }
        
        // Fix the retina images
        if ([metaTagName isEqualToString:@"replace2x"] == YES) {
            if ([[metaTagContent lowercaseString] isEqualToString:@"true"]) {
                
                
                // Fix the image URLs
                [self.html replaceOccurrencesOfString:@".jpg\"" withString:@"@2x.jpg\""];
                [self.html replaceOccurrencesOfString:@".JPG\"" withString:@"@2x.JPG\""];
                [self.html replaceOccurrencesOfString:@".png\"" withString:@"@2x.png\""];
                [self.html replaceOccurrencesOfString:@".PNG\"" withString:@"@2x.PNG\""];
                
            }
        }
        
    }
    
}

@end

@implementation YDArticle

- (id)initWithURL:(NSURL*)url {
    self = [super init];
    if (self) {
        
        // Assign the variables
        _url  = url;
        _name = url.absoluteString.lastPathComponent;
        
        // Set the default variables
        _title  = [_name stringByDeletingPathExtension];
        _author = @"";
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (BOOL)isEqual:(YDArticle*)article {
    return [article.url.absoluteString isEqualToString:self.url.absoluteString];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<YDArticle: %@>", self.title];
}

@end
