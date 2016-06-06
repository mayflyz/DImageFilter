//
//  UIImage+Smoothing.h
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+MatOperate.h"

@interface UIImage (Smoothing)

/**
 *  方框滤波
 */
- (UIImage *)boxBlurFilter;

/**
 *   方框滤波
 *
 *  @param size 内核大小
 *
 *  @return 方框滤波后的图像
 */
- (UIImage *)boxBlurFilterWithSize:(int)size;

/**
 *  均值滤波
 */
- (UIImage *)blurFilter;
/**
 *  均值滤波处理
 *
 *  @param size 内核的大小
 *
 *  @return 均值滤波处理后的图片
 */
- (UIImage *)blureFilterWithSize:(int)size;

/**
 *  高斯滤波
 */
- (UIImage *)gaussianBlurFilter;

/**
 *  中值滤波
 */
- (UIImage *)medianFilter;

/**
 *  中值滤波
 *
 *  @param size 孔径的线性尺寸（aperture linear size），注意这个参数必须是大于1的奇数，比如：3，5，7，9 ...
 *
 *  @return 滤波处理函数
 */
- (UIImage *)medianFilterWithkSize:(int)size;

/**
 *  双边滤波
 */
- (UIImage *)bilateralFilter;

@end
