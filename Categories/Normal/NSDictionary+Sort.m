//
// Created by xialeistudio on 15/12/21.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "NSDictionary+Sort.h"


@implementation NSDictionary (Sort)
- (NSComparisonResult)compareByUpdateAt:(NSDictionary *)otherDictionary {
    NSDictionary *temp = self;
    return [otherDictionary[@"update_at"] compare:temp[@"update_at"]];
}


@end