//
//  GLFaceAnimator.m
//  DImageFilter
//
//  Created by tony on 6/7/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLFaceAnimator.h"

@implementation GLFaceAnimator


- (void)detectAndAnimateFaces:(cv::Mat)frame{
    
}

- (cv::Mat)linearBlendingMatFirst:(cv::Mat)srcMat1 matSecond:(cv::Mat)srcMat2 alphaValue:(float)alpha{
    if (alpha < 0 || alpha > 1) {
        alpha = 0.5f;
    }
    
    cv::Mat dstMat;
    
    if (srcMat1.rows != srcMat2.rows && srcMat1.cols != srcMat2.cols) {
        return dstMat;
    }
    
//    进行图像混合加权操作  
    float betaValue = 1 - alpha;
    
    cv::addWeighted(srcMat1, alpha, srcMat2, betaValue, 0.0, dstMat);
    
    return dstMat;
}

@end
