//
// Created by xialeistudio on 15/12/19.
// Copyright (c) 2015 Group Friend Information. All rights reserved.
//

#import "AppUtil.h"


@implementation AppUtil {

}
+ (NSString *)getAppVersion {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
}

+ (NSString *)getAppBuild {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"];
}

+ (void)openAppStore:(NSString *)appID {
    NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (id)loadMutableDataFromLocal:(NSString *)key {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return data?[NSKeyedUnarchiver unarchiveObjectWithData:data]:nil;
}

+ (void)storeMutableDataToLocal:(id)data forKey:(NSString *)key {
    NSData *_data = [NSKeyedArchiver archivedDataWithRootObject:data];
    [[NSUserDefaults standardUserDefaults] setObject:_data forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end