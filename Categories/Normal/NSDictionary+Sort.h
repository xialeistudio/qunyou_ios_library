//
// Created by xialeistudio on 15/12/21.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Sort)
/**
 * 根据键值排序
 */
- (NSComparisonResult)compareByUpdateAt:(NSDictionary *)otherDictionary;
@end