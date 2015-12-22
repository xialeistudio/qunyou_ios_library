//
//  UIUtil.h
//  IOS
//
//  Created by xialeistudio on 15/11/30.
//  Copyright © 2015年 Group Friend Information. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol UIUtilImageDelegate <NSObject>
/**
 *  选择图片回调
 *
 *  @param info 图片数据
 */
- (void)didSelectImage:(NSDictionary *)info;

@end

@interface UIUtil : NSObject
        <UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIAlertViewDelegate> {
    id <UIUtilImageDelegate> imageDelegate;
}
/**
 * 单例
 */
+ (instancetype)sharedInstance;


/**
 * 保存图片到沙箱
 */
+ (NSString *)storeImageToSandbox:(UIImage *)image
        :(CGFloat)quality;

/**
 * 选择图片
 */
- (BOOL)selectPicture
        :(UIImagePickerControllerSourceType)sourceType
        :(UIViewController <UIUtilImageDelegate> *)viewController
        :(NSError **)error;

/**
 * 调整图片尺寸
 */
+ (UIImage *)scaleImage:(UIImage *)image
                  scale:(float)scaleSize;

/**
 * 自定义长宽
 */
+ (UIImage *)resizeImage:(UIImage *)image
                   width:(float)width
                  height:(float)height;

/**
 * 存储图片到图库
 */
+ (void)storeImageToPhotoAlbum:(UIImage *)image;

/**
 * 截屏
 */
+ (UIImage *)screenShot:(UIView *)view;

/**
 * 导航栏透明
 */
+ (void)transparentNavigationBar:(UINavigationBar *)navigationBar;

/**
 * 隐藏键盘
 */
+ (void)hideKeyboardWithView:(UIView *)view;

/**
 * Alert
 */
- (void)    showAlert:(UIViewController *)viewController
            withTitle:(NSString *)title
          withMessage:(NSString *)message
    withOkActionTitle:(NSString *)okTitle
withCancelActionTitle:(NSString *)cancelTitle
         withOkAction:(void (^)(UIAlertAction *action))okAction
     withCancelAction:(void (^)(UIAlertAction *action))cancelAction;
@end
