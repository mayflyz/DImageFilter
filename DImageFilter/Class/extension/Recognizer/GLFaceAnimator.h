//
//  GLFaceAnimator.h
//  DImageFilter
//
//  Created by tony on 6/7/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "opencv2/opencv.hpp"

@interface GLFaceAnimator : NSObject

- (void)detectAndAnimateFaces:(cv::Mat)frame;

@end
