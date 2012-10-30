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
    
    // Get the path to the metadata file
    NSString *metaFile = [self.path stringByAppendingPathComponent:@"book.json"];
    
    // Parse the metafile
    NSError *error = nil;
    NSData *metaData = [NSData dataWithContentsOfFile:metaFile];
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
        NSString *articlePath = [self.path stringByAppendingPathComponent:articleName];
        YDArticle *article    = [[YDArticle alloc] initWithPath:articlePath];
        [articles addObject:article];
    }
    self.articles = articles;
    
    //self.articles = [metaInfo valueForKey:@"contents"];
    //NSLog(@"%@, %d article(s)", self.title, self.articles.count);
    
}

@end

@implementation YDPublication

- (id)initWithPath:(NSString*)path {
    self = [super init];
    if (self) {
        
        // Assign the variables
        _path = path;
        
        // Set the default variables
        _title    = @"";
        _articles = [NSArray array];
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (NSString*)articleAtIndex:(int)index {
    return [self.articles objectAtIndex:index];
}

- (int)indexOfArticle:(NSString*)articleName {
    int index = -1;
    for (NSString *article in self.articles) {
        index++;
        if ([article isEqualToString:articleName]) {
            return index;
        }
    }
    return index;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Publication: %@ (%d articles)", self.title, self.articles.count];
}

@end
