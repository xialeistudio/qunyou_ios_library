//
// Created by xialeistudio on 15/12/21.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "CommonUtil.h"
#import "NSString+Compatibility.h"


@implementation CommonUtil {

}
+ (NSString *)formatTime:(NSTimeInterval)timestamp withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [formatter stringFromDate:date];
}

+ (NSString *)thumbQiniu:(NSString *)url width:(NSString *)width height:(NSString *)height {
    if ([url containsStringCompatibility:@"qiniudn"] || [url containsStringCompatibility:@"clouddn"] || [url containsStringCompatibility:@"static.ddhigh.com"]) {
        return [NSString stringWithFormat:@"%@?imageView2/1/w/%@/h%@", url, width, height];
    }
    return url;
}

+ (NSString *)thumbQiniu:(id)url width:(NSString *)width height:(NSString *)height type:(NSString *)type {
    if ([url containsStringCompatibility:@"qiniudn"] || [url containsStringCompatibility:@"clouddn"] || [url containsStringCompatibility:@"static.ddhigh.com"]) {
        return [NSString stringWithFormat:@"%@?imageView2/%@/w/%@/h%@", url, type, width, height];
    }
    return url;
}
@end