//
// Created by xialeistudio on 15/12/22.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "NSString+Compatibility.h"


@implementation NSString (Compatibility)
- (BOOL)containsStringCompatibility:(NSString *)str {
    if (![self respondsToSelector:@selector(containsString:)]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", str];
        return [predicate evaluateWithObject:self];
    } else {
        return [self containsString:str];
    }
}


@end