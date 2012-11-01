//
//  NSMutableString+Additions.m
//  Reader
//
//  Created by Pieter Claerhout on 29/10/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import "NSMutableString+Additions.h"

@implementation NSMutableString (Additions)

- (NSUInteger)replaceOccurrencesOfString:(NSString*)target withString:(NSString*)replacement {
    if (self == nil) {
        return 0;
    }
	return [self replaceOccurrencesOfString:target
								 withString:replacement
								    options:NSLiteralSearch
            
									  range:NSMakeRange(0, [self length])
	 ];
}

@end
