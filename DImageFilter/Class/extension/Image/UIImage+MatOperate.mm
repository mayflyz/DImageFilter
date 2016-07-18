//
//  UIImage+MatOperate.m
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "UIImage+MatOperate.h"

@implementation UIImage (MatOperate)


/**
 *   OpenCV 中同常用 cv::Mat 表示图片， 此函数把iOS中的图片转为OpenCV中彩色图的表示。
 *
 *  @return Mat矩阵
 */
- (cv::Mat)CVMat{
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return cvMat;
}

/**
 *  获取OPenCV的灰度图
 */
-(cv::Mat)CVGrayscaleMat
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channel
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNone |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

- (IplImage *)plImage{
    // Getting CGImage from UIImage
    CGImageRef imageRef = self.CGImage;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    // Creating temporal IplImage for drawing
    IplImage *iplimage_ = cvCreateImage(cvSize(cols,rows), IPL_DEPTH_8U, 4);
    // Creating CGContext for temporal IplImage
    CGContextRef contextRef = CGBitmapContextCreate(
                                                    iplimage_->imageData, iplimage_->width, iplimage_->height,
                                                    iplimage_->depth, iplimage_->widthStep,
                                                    colorSpace, kCGImageAlphaPremultipliedLast|kCGBitmapByteOrderDefault
                                                    );
    // Drawing CGImage to CGContext
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    // Creating result IplImage
    IplImage *retImg = cvCreateImage(cvGetSize(iplimage_), IPL_DEPTH_8U, 3);
    cvCvtColor(iplimage_, retImg, CV_RGBA2BGR);
    cvReleaseImage(&iplimage_);
    
    return retImg;
}

/**
 *  把OpenCV中的Mat转换为UIImage图
 */
+ (UIImage *)imageWithCVMat:(const cv::Mat&)cvMat
{
    return [[UIImage alloc] initWithCVMat:cvMat];
}

- (id)initWithCVMat:(const cv::Mat&)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize() * cvMat.total()];
    
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1)
    {
        colorSpace = CGColorSpaceCreateDeviceGray();
    }
    else
    {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                     // Width
                                        cvMat.rows,                                     // Height
                                        8,                                              // Bits per component
                                        8 * cvMat.elemSize(),                           // Bits per pixel
                                        cvMat.step[0],                                  // Bytes per row
                                        colorSpace,                                     // Colorspace
                                        kCGImageAlphaNone | kCGBitmapByteOrderDefault,  // Bitmap info flags
                                        provider,                                       // CGDataProviderRef
                                        NULL,                                           // Decode
                                        false,                                          // Should interpolate
                                        kCGRenderingIntentDefault);                     // Intent
    
    self = [self initWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return self;
}

+ (UIImage *)imageWIthIplImage:(const IplImage *)plImage{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    // Allocating the buffer for CGImage
    NSData *data = [NSData dataWithBytes:plImage->imageData length:plImage->imageSize];
    CGDataProviderRef provider =
    CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    // Creating CGImage from chunk of IplImage
    CGImageRef imageRef = CGImageCreate(
                                        plImage->width, plImage->height,
                                        plImage->depth, plImage->depth * plImage->nChannels, plImage->widthStep,
                                        colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault,
                                        provider, NULL, false, kCGRenderingIntentDefault
                                        );
    // Getting UIImage from CGImage
    UIImage *ret = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    return ret;
}

- (UIImage *)spicedsaltWithNum:(int)num{
    cv::Mat dstmat = self.CVMat;
    salt(dstmat, num);
    pepper(dstmat, num);
    
    return [[self class] imageWithCVMat:dstmat];
}

//盐噪声
void salt(cv::Mat image, int n) {
    
    int i,j;
    for (int k=0; k<n/2; k++) {
        
        // rand() is the random number generator
        i = std::rand()%image.cols; // % 整除取余数运算符,rand=1022,cols=1000,rand%cols=22
        j = std::rand()%image.rows;
        
        if (image.type() == CV_8UC1) { // gray-level image
            
            image.at<uchar>(j,i)= 255; //at方法需要指定Mat变量返回值类型,如uchar等
            
        } else if (image.type() == CV_8UC3) { // color image
            
            image.at<cv::Vec3b>(j,i)[0]= 255; //cv::Vec3b为opencv定义的一个3个值的向量类型
            image.at<cv::Vec3b>(j,i)[1]= 255; //[]指定通道，B:0，G:1，R:2
            image.at<cv::Vec3b>(j,i)[2]= 255;
        }
    }
}

//椒噪声
void pepper(cv::Mat image, int n) {
    
    int i,j;
    for (int k=0; k<n; k++) {
        
        // rand() is the random number generator
        i = std::rand()%image.cols; // % 整除取余数运算符,rand=1022,cols=1000,rand%cols=22
        j = std::rand()%image.rows;
        
        if (image.type() == CV_8UC1) { // gray-level image
            
            image.at<uchar>(j,i)= 0; //at方法需要指定Mat变量返回值类型,如uchar等
            
        } else if (image.type() == CV_8UC3) { // color image
            
            image.at<cv::Vec3b>(j,i)[0]= 0; //cv::Vec3b为opencv定义的一个3个值的向量类型
            image.at<cv::Vec3b>(j,i)[1]= 0; //[]指定通道，B:0，G:1，R:2
            image.at<cv::Vec3b>(j,i)[2]= 0;   
        }  
    }  
}
@end
