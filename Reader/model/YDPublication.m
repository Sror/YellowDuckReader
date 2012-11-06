//
//  YDPublication.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDPublication.h"
#import "YDArticle.h"

@implementation YDPublication (Private)

- (void)parse {
    
    // Set the base url
    self.baseURL = [[NSURL alloc] initWithString:@".." relativeToURL:self.url].absoluteURL;
    
    // Get the path to the metadata file
    //NSString *metaFile = [self.path stringByAppendingPathComponent:@"publication.json"];
    
    // Parse the metafile
    NSError *error = nil;
    NSData *metaData = [NSData dataWithContentsOfURL:self.url];
    NSDictionary *metaInfo = [NSJSONSerialization JSONObjectWithData:metaData
                                                             options:kNilOptions
                                                               error:&error
                              ];
    if (metaInfo == nil) {
        NSLog(@"Parse Error: %@", error);
        return;
    }

    // Parse the properties
    self.title    = [metaInfo valueForKey:@"title"];
    
    // Parse the list of articles
    NSMutableArray *articles = [NSMutableArray arrayWithCapacity:0];
    for (NSString *articleName in [metaInfo valueForKey:@"contents"]) {
//        NSString *articlePath = [self.path stringByAppendingPathComponent:articleName];
        NSURL *articleURL  = [NSURL URLWithString:[[self.url.absoluteString stringByDeletingLastPathComponent] stringByAppendingPathComponent:articleName]];
        YDArticle *article = [[YDArticle alloc] initWithURL:articleURL];
        [articles addObject:article];
    }
    self.articles = articles;
    
}

@end

@implementation YDPublication

- (id)initWithPath:(NSString*)path {
    self = [super init];
    if (self) {
        
        // Assign the variables
        //_path = path;
        _url = [NSURL fileURLWithPath:path];
        
        // Set the default variables
        _title    = @"";
        _articles = [NSArray array];
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (id)initWithURL:(NSURL*)url {
    self = [super init];
    if (self) {
        
        // Assign the variables
        _url = url;
        
        // Set the default variables
        _title    = @"";
        _articles = [NSArray array];
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (YDArticle*)articleWithName:(NSString*)articleName {
    for (YDArticle *article in self.articles) {
        if ([article.name isEqualToString:articleName]) {
            return article;
        }
    }
    return nil;
}

- (YDArticle*)articleAtIndex:(int)index {
    return [self.articles objectAtIndex:index];
}

- (int)indexOfArticle:(NSString*)articleName {
    int index = -1;
    for (YDArticle *article in self.articles) {
        index++;
        if ([article.name isEqualToString:articleName]) {
            return index;
        }
    }
    return index;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<YDPublication: %@>", self.title];
}

@end
