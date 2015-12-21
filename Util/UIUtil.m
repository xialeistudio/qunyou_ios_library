//
//  UIUtil.m
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import "UIUtil.h"

@implementation UIUtil
/**
 * 单例
 */
+ (instancetype)sharedInstance {
    static UIUtil *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 * 保存图片
 */
+ (NSString *)storeImageToSandbox:(UIImage *)image :(CGFloat)quality {
    NSData *imageData = UIImageJPEGRepresentation(image, quality);
    NSString *name = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".jpg"];
    NSString *path = [NSHomeDirectory() stringByAppendingString:[@"/Documents/" stringByAppendingString:name]];
    [imageData writeToFile:path atomically:NO];
    return path;
}


/**
 *  选择图片
 *
 *  @param sourceType     来源地址
 *  @param viewController 视图
 *  @param error          错误
 *
 *  @return 是否成功
 */
- (BOOL)selectPicture:(UIImagePickerControllerSourceType)sourceType :(UIViewController <UIUtilImageDelegate> *)viewController :(NSError **)error {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSDictionary *info = @{NSLocalizedDescriptionKey : @"UnSupported source type"};
        *error = [NSError errorWithDomain:@"com.xialeistudio.core.UIUtil" code:-1 userInfo:info];
        return NO;
    }

    //委托处理
    imageDelegate = viewController;

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = sourceType;
    picker.allowsEditing = YES;
    picker.delegate = self;
    [viewController presentViewController:picker animated:YES completion:nil];
    return YES;
}

/**
 * 缩放图片
 */
+ (UIImage *)scaleImage:(UIImage *)image scale:(float)scaleSize {
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 自定义尺寸
 */
+ (UIImage *)resizeImage:(UIImage *)image width:(float)width height:(float)height {
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [image drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 * 保存图片到相册
 */
+ (void)storeImageToPhotoAlbum:(UIImage *)image {
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

+ (UIImage *)screenShot:(UIView *)view {
    CGRect rect = view.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (void)transparentNavigationBar:(UINavigationBar *)navigationBar {
    [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = [UIImage new];
    navigationBar.translucent = YES;
}

+ (void)hideKeyboardWithView:(UIView *)view {
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [view addGestureRecognizer:tapGestureRecognizer];
}

+ (void)showAlert:(UIViewController *)viewController withTitle:(NSString *)title withMessage:(NSString *)message withOkActionTitle:(NSString *)okTitle withCancelActionTitle:(NSString *)cancelTitle withOkAction:(void (^)(UIAlertAction *action))okAction withCancelAction:(void (^)(UIAlertAction *action))cancelAction {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:okTitle ? okTitle : @"确定" style:UIAlertActionStyleDefault handler:okAction];
    [alertController addAction:actionOk];
    if (cancelAction) {
        UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:cancelTitle ? cancelTitle : @"取消" style:UIAlertActionStyleDefault handler:cancelAction];
        [alertController addAction:actionCancel];
    }
    [viewController presentViewController:alertController animated:YES completion:nil];
}


+ (void)hideKeyboard {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


/**
 *  取消图片选择回调
 */
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        [imageDelegate didSelectImage:nil];
    }];
}

/**
 * 选择图片回调
 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        [imageDelegate didSelectImage:info];
    }];
}
@end
