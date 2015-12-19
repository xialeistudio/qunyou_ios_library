//
//  RegexTool.m
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import "RegexTool.h"

@implementation RegexTool
/**
 * 检测电话是否合法
 */
+ (BOOL)isPhone:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^(\\+\\d+)?\\d+?$"];
    return [predicate evaluateWithObject:string];
}

/**
 * 检测邮箱是否合法
 */
+ (BOOL)isEmail:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^\\w+((\\-\\w+)|(\\.\\w+))@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$"];
    return [predicate evaluateWithObject:string];
}
@end
