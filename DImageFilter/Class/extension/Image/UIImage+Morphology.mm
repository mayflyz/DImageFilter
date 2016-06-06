//
//  UIImage+Morphology.m
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "UIImage+Morphology.h"

#import "UIImage+MatOperate.h"

using namespace cv;

@implementation UIImage (Morphology)
/**
 *  腐蚀
 */
- (UIImage *)erosionOperation{
    return [self erosionType:1 size:1];
}

- (UIImage *)erosionType:(int)type size:(int)value{
    int erosion_type;
    if (type > 2 || type < 0) {
        type = 0;
    }
    
    if (type == 0){ erosion_type = cv::MORPH_RECT;}
    else if (type == 1){  erosion_type = cv::MORPH_CROSS; }
    else if (type == 2){ erosion_type = cv::MORPH_ELLIPSE; }
    
    Mat element = getStructuringElement(erosion_type,
                                        cv::Size(2*value + 1, 2*value+1),
                                        cv::Point(value, value));
    Mat dstMat;
    erode(self.CVMat, dstMat, element);
    
    return [[self class] imageWithCVMat:dstMat];
}

#pragma mark ------------------------------------------
- (UIImage *)dilateOperation{
    return [self dilationWithType:2 size:1];
}

- (UIImage *)dilationWithType:(int)type size:(int)value{
    int dilation_type;
    if (type > 2 || type < 0) {
        type = 0;
    }
    
    if (type == 0){ dilation_type = cv::MORPH_RECT;}
    else if (type == 1){  dilation_type = cv::MORPH_CROSS; }
    else if (type == 2){ dilation_type = cv::MORPH_ELLIPSE; }
    
    Mat element = getStructuringElement(dilation_type,
                                        cv::Size(2*value + 1, 2*value+1),
                                        cv::Point(value, value));
    Mat dstMat;
    dilate(self.CVMat, dstMat, element);
    
    return [[self class] imageWithCVMat:dstMat];
}


#pragma mark ------------------------------------------

- (UIImage *)morphologyWithOperation:(int)operation elementSize:(int)size{
    
    return [self morphologyWithOperation:operation elementType:1 size:size];
}

/**
 *  morphologyEx函数利用基本的膨胀和腐蚀技术，来执行更加高级形态学变换
 *
 *  @param operation 形态学运算的类型,
 *  MORPH_OPEN – 开运算（Opening operation）
 *  MORPH_CLOSE – 闭运算（Closing operation）
 *  MORPH_GRADIENT -形态学梯度（Morphological gradient）
 *  MORPH_TOPHAT - “顶帽”（“Top hat”）
 *  MORPH_BLACKHAT - “黑帽”（“Black hat“）
 *
 *  @return 处理后的图像
 */
- (UIImage *)morphologyWithOperation:(int)operation elementType:(int)type size:(int)value{
    int morphology_type;
    if (type > 2 || type < 0) {
        type = 0;
    }
    
    if (type == 0){ morphology_type = cv::MORPH_RECT;}
    else if (type == 1){  morphology_type = cv::MORPH_CROSS; }
    else if (type == 2){ morphology_type = cv::MORPH_ELLIPSE; }
    
    if (operation < 0 || operation>4) {
        operation = 0;
    }
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，填Mat类的对象即可。图像位深应该为以下五种之一：CV_8U, CV_16U,CV_16S, CV_32F 或CV_64F。
     *  第二个参数，OutputArray类型的dst，即目标图像，函数的输出参数，需要和源图片有一样的尺寸和类型。
     *  第三个参数，int类型的op，表示形态学运算的类型，可以是如下之一的标识符:MORPH_OPEN – 开运算（Opening operation），MORPH_CLOSE – 闭运算（Closing operation）,MORPH_GRADIENT -形态学梯度（Morphological gradient）, MORPH_TOPHAT - “顶帽”（“Top hat”）,MORPH_BLACKHAT - “黑帽”（“Black hat“）
     
     *  第四个参数，InputArray类型的kernel，形态学运算的内核。若为NULL时，表示的是使用参考点位于中心3x3的核。我们一般使用函数 getStructuringElement配合这个参数的使用。getStructuringElement函数会返回指定形状和尺寸的结构元素（内核矩阵）。关于getStructuringElement我们上篇文章中讲过了，这里为了大家参阅方便，再写一遍：
     其中，getStructuringElement函数的第一个参数表示内核的形状，我们可以选择如下三种形状之一:矩形: MORPH_RECT,交叉形: MORPH_CROSS,椭圆形: MORPH_ELLIPSE而getStructuringElement函数的第二和第三个参数分别是内核的尺寸以及锚点的位置。
     */
    
    Mat element = getStructuringElement(morphology_type,
                                        cv::Size(2*value + 1, 2*value+1),
                                        cv::Point(value, value));
    
    cv::Mat dstMat;
    
    morphologyEx(self.CVMat, dstMat, operation, element);
    
    return  [[self class] imageWithCVMat:dstMat];
}
@end
