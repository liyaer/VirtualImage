//
//  UIImage+BlurImage.h
//  VirtualImage
//
//  Created by 杜文亮 on 2017/10/24.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *   高斯模糊效果
 
     区别:
         效果:第一种Core Image设置模糊之后会在周围产生白边（所以能看到图片缩小的迹象），vImage使用不存在任何问题；
         性能:图像模糊处理属于复杂的计算，大部分图片模糊选择的是vImage，性能最佳
 */

#import <UIKit/UIKit.h>

@interface UIImage (BlurImage)

+(UIImage *)coreBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

+(UIImage *)boxBlurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;

@end
