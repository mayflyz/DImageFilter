//
//  UIImage+Threshold.h
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Threshold)

- (UIImage *)grayImage;

/**
 *  获取二进制图，使用OSTU值作为阈值
 */
- (UIImage *)binaryzation;

//0——R分量，1——G分量，2——B分量，3——最大值法，4——平均值法，5——加权平均值法
- (UIImage *)grayImageWithType:(int)type;

/**
 *  寻找最大熵阈值
 */
- (UIImage *)binaryzationWithMaxEntropy;

/**
 *  基本全局阈值法生成二值图像
 */
- (UIImage *)binaryzationWithWithGlobalThrehold;

/**
 *  迭代法生成二值图像
 */
- (UIImage *)binaryzationWithWithDetech;

/**
 *  使用自定义阈值作为分隔
 *
 *  @param value 使用阈值
 */
- (UIImage *)binaryzationWithThresh:(int)value;

/**
 *  图片灰度直方图，返回生成的灰度直方图图片
 */
- (UIImage *)grayHistImg;

- (UIImage *)colorHistImg;

- (UIImage *)equalHistImg;
/**
 *  直方图均衡化
 */
- (UIImage *)histogramEqualization;

#pragma mark ---------

/**
 *  Sobel算子处理
 */
- (UIImage *)sobelOperation;

/**
 *  Sobel算子, Sobel算子可以直接计算Gx 、Gy可以检测到边的存在，以及从暗到亮，从亮到暗的变化。仅计算| Gx |，产生最强的响应是正交 于x轴的边； | Gy |则是正交于y轴的边。
 *
 *  @param value 
 */
- (UIImage *)sobelWithScale:(int)value;

#pragma mark ------------
- (UIImage *)cannyWithThreshold:(int)value;

- (UIImage *)LaplaceWithSize:(int)value;

- (UIImage *)scharrWithScale:(int)value;

- (UIImage *)robertsEdge;

- (UIImage *)prewittEdge;
@end
