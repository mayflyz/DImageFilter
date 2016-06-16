//
//  GLMatEdgeDetection.h
//  DImageFilter
//
//  Created by tony on 6/16/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "opencv2/opencv.hpp"

using namespace cv;

typedef NS_ENUM(int, EntropyState) {
    Back,
    Object
};

/**
 *   边缘检测处理
 */
@interface GLMatEdgeDetection : NSObject

+ (Mat)binaryzation:(Mat)srcMat;

+ (Mat)binaryzation:(Mat)srcMat threshValue:(int)value;

#pragma mark -------------阈值算法----------------
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

/**
 *  基本全局阀值法
 *
 *  @param srcImg 灰度图
 */
#warning IplImage copy 存在问题
+ (int)basicGlobalThrehold:(IplImage *)srcImg;

+ (int)basicGlobalThreshold:(int *)pg start:(int)start end:(int)end;
/**
 *  寻找最大熵阈值并分割
 *
 *  @param srcImg 灰度图
 */
#error 有误，计算阈值为0
+ (int)maxEntropy:(IplImage *)srcImg;

+ (double)caculateCurrentEntropy:(CvHistogram *)histogram currentThreshold:(int)threshold state:(EntropyState)state;

#pragma mark ----

+ (Mat)prewitt:(Mat)src;

+ (Mat)roberts:(Mat)src;

+ (Mat)distanceTransform:(Mat)srcMat;

@end
