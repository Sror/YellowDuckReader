//
//  NSMutableString+Additions.h
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (Additions)

- (NSUInteger)replaceOccurrencesOfString:(NSString*)target withString:(NSString*)replacement;

@end
