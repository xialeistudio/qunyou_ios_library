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
        <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    id <UIUtilImageDelegate> imageDelegate;
}
/**
 * 单例
 */
+ (instancetype)sharedInstance;

/**
 * 保存图片到沙箱
 */
- (NSString *)storeImageToSandbox:(UIImage *)image
        :(CGFloat)quality;

/**
 *  选择图片
 *
 *  @param sourceType     来源类型
 *  @param viewController 视图
 *  @param error          错误
 *
 *  @return 是否出错
 */
- (BOOL)selectPicture
        :(UIImagePickerControllerSourceType)sourceType
        :(UIViewController <UIUtilImageDelegate> *)viewController
        :(NSError **)error;

/**
 * 调整图片尺寸
 */
-(UIImage *)scaleImage:(UIImage *)image
                   scale:(float)scaleSize;

/**
 * 自定义长宽
 */
-(UIImage *)resizeImage:(UIImage *)image
                  width:(float)width
                 height:(float)height;

/**
 * 存储图片到图库
 */
-(void)storeImageToPhotoAlbum:(UIImage *)image;

/**
 * 截屏
 */
-(UIImage *) screenShot:(UIView *)view;
@end
