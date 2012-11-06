//
//  NSString+Additions.h
//  Reader
//
//  Created by Pieter Claerhout on 09/05/12.
//  Copyright (c) 2012 Twixl media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Additions)

- (BOOL)contains:(NSString*)needle;
- (BOOL)isEmpty;
- (NSString*)sha1;

@end
