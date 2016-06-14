//
//  UIImage+Skeleton.m
//  DImageFilter
//
//  Created by tony on 6/14/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "UIImage+Skeleton.h"
#import "GLMatSkeleton.h"

@implementation UIImage (Skeleton)

- (UIImage *)distanceTransform{
    cv::Mat binaryMat = [GLImageOperate binaryzation:self.CVMat];
    cv::Mat dstMat = [GLImageOperate distanceTransform:binaryMat];
    
    return [[self class] imageWithCVMat:dstMat];
}

- (UIImage *)skeletonByHilditch{
    cv::Mat binaryMat = [GLImageOperate binaryzation:self.CVMat];
    cv::Mat dstMat;
    hilditchThin(binaryMat, dstMat);
    
    return [[self class] imageWithCVMat:dstMat];
}

- (UIImage *)skeletonByRosenfeld{
    cv::Mat binaryMat = [GLImageOperate binaryzation:self.CVMat];
    cv::Mat dstMat;
    rosenfeldThin(binaryMat, dstMat);
    
    return [[self class] imageWithCVMat:dstMat];
}

- (UIImage *)skeletonByMorph{
    cv::Mat binaryMat = [GLImageOperate binaryzation:self.CVMat];
    cv::Mat dstMat;
    morphThin(binaryMat, dstMat);
    
    return [[self class] imageWithCVMat:dstMat];
}
@end
