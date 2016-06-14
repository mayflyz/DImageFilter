//
//  GLMatSkeleton.h
//  DImageFilter
//
//  Created by tony on 6/14/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "opencv2/opencv.hpp"

@interface GLMatSkeleton : NSObject

@end


/**
 *  将IPL_DEPTH_8U型二值图像进行细化
 *
 *  @param src    原始IPL_DEPTH_8U型二值图像
 *  @param dst    目标存储空间，必须事先分配好，且和原图像大小类型一致
 *  @param intera 迭代次数
 */
void cvThin(cv::Mat& src, cv::Mat& dst, int intera = 1);

/**
 *  hilditch细化算法
 */
void hilditchThin(cv::Mat& src, cv::Mat& dst);

/**
 *  Rosenfeld细化算法
 */
void rosenfeldThin(cv::Mat& src, cv::Mat& dst);

/**
 *  通过形态学腐蚀和开操作得到骨架
 */
void morphThin(cv::Mat& src, cv::Mat& dst);