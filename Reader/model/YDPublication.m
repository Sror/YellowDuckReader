//
//  YDPublication.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "YDPublication.h"

@implementation YDPublication (Private)

- (void)parse {
    
    // Get the path to the metadata file
    NSString *metaFile = [self.publicationPath stringByAppendingPathComponent:@"book.json"];
    
    // Parse the metafile
    NSError *error = nil;
    NSData *metaData = [NSData dataWithContentsOfFile:metaFile];
    NSDictionary *metaInfo = [NSJSONSerialization JSONObjectWithData:metaData
                                                             options:kNilOptions
                                                               error:&error
                              ];
    if (metaInfo == nil) {
        NSLog(@"Parse Error: %@", error);
        self.parseError = error;
        return;
    }

    // Parse the properties
    self.title    = [metaInfo valueForKey:@"title"];
    self.contents = [metaInfo valueForKey:@"contents"];
    NSLog(@"%@, %d article(s)", self.title, self.contents.count);
    
}

@end

@implementation YDPublication

- (id)initWithPublication:(NSString*)publicationPath {
    self = [super init];
    if (self) {
        
        // Assign the variables
        _publicationPath = publicationPath;
        
        // Set the default variables
        _title    = @"";
        _contents = [NSArray array];
        
        // Parse the publication
        [self parse];
        
    }
    return self;
}

- (NSString*)articleAtIndex:(int)index {
    return [self.contents objectAtIndex:index];
}

- (int)indexOfArticle:(NSString*)articleName {
    int index = -1;
    for (NSString *article in self.contents) {
        index++;
        if ([article isEqualToString:articleName]) {
            return index;
        }
    }
    return index;
}


@end
