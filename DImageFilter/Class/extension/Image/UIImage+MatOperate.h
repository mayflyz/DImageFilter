//
//  UIImage+MatOperate.h
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "opencv2/opencv.hpp"

@interface UIImage (MatOperate)

@property (nonatomic, readonly) cv::Mat CVMat;
@property (nonatomic, readonly) cv::Mat CVGrayscaleMat;

@property (nonatomic, readonly) IplImage *plImage;


+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat;
+ (UIImage *)imageWIthIplImage:(const IplImage *)plImage;

-(id)initWithCVMat:(const cv::Mat&)cvMat;

@end
