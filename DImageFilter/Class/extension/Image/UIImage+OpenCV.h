//
//  UIImage+OpenCV.h
//  ImageFilter
//
//  Created by tony on 5/18/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "opencv2/opencv.hpp"

@interface UIImage (Convert)

@property (nonatomic, readonly) cv::Mat CVMat;
@property (nonatomic, readonly) cv::Mat CVGrayscaleMat;

@property (nonatomic, readonly) IplImage *plImage;


+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
+ (UIImage *)imageWIthIplImage:(const IplImage *)plImage;

-(id)initWithCVMat:(const cv::Mat&)cvMat;


@end

/**
 *  图片二值化处理扩展
 */
@interface UIImage (Threshold)

/**
 *  大津法取阈值
 *
 *  @param pImageData 图像数据
 *  @param nWidth     图像宽度
 *  @param nHeight    图像高度
 *  @param nWidthStep 图像行大小
 *
 *  @return 阈值
 */
int  OTSU(unsigned char* pGrayImg , int iWidth , int iHeight);

- (UIImage *)grayImage;

- (UIImage *)binaryzation;
@end

/**
 *  图像滤波处理
 */
@interface UIImage (Filter)
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

@interface UIImage (Morphology)

/**
 *  腐蚀
 */
- (UIImage *)erodeOperation;

/**
 *  腐蚀
 *
 *  @param size 内核算子
 */
- (UIImage *)erodeOperationWithSize:(int)size;

/**
 *  膨胀
 *
 */
- (UIImage *)dilateOperation;

/**
 *  膨胀,默认算子为3
 *
 *  @param size 内核算子
 */
- (UIImage *)dilateOperationWithSize:(int)size;

/**
 *  图像开运算,默认算子为3
 */
- (UIImage *)openOperation;

/**
 *  图像开运算
 *
 *  @param size 内核算子
 */
- (UIImage *)openOperationWithSize:(int)size;

/**
 *  图像闭运算,默认算子为3
 */
- (UIImage *)closeOperation;

/**
 *  图像闭运算
 *
 *  @param size 内核算子
 */
- (UIImage *)closeOperationWithSize:(int)size;

/**
 *  顶帽运算,默认算子为3
 */
- (UIImage *)topHatOperation;

/**
 *  顶帽运算
 *
 *  @param size 内核算子
 */
- (UIImage *)topHatOperationWithSize:(int)size;

/**
 *  黑帽运算,默认算子为3
 */
- (UIImage *)blackHatOperation;

/**
 *  黑帽运算
 *
 *  @param size 内核算子
 */
- (UIImage *)blackHatOperationWithSize:(int)size;

- (UIImage *)floodFill;
@end