//
//  GLImageOperate.m
//  DImageFilter
//
//  Created by tony on 6/9/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLImageOperate.h"

@implementation GLImageOperate

- (Mat)addMatFirst:(Mat)src1 second:(Mat)src2{
    Mat dstMat;
    add(src1, src2, dstMat);
    
    return dstMat;
}

- (Mat)MatAddValue:(int)value Mat:(Mat)srcMat{
    int cols = srcMat.cols;
    int rows = srcMat.rows;
    
    Mat dstMat;
    for (int i = 0; i < rows; i++) {
        
        for (int j=0; j< cols; j++) {
            
        }
    }
    
    return dstMat;
}

/**
 *  图像大小变换
 *
 *  @param srcMat 原图矩阵
 *  @param type   图像插值类型，0——最近邻插值， 1——双线性插值， 2——立方插值
 */
- (Mat)cvReSize:(Mat)srcMat interType:(int)type{
    Mat dstMat;
    /**
     *  interpolation
     插值方法:
     CV_INTER_NN - 最近邻插值,
     CV_INTER_LINEAR - 双线性插值 (缺省使用)
     CV_INTER_AREA - 使用象素关系重采样。当图像缩小时候，该方法可以避免波纹出现。当图像放大时，类似于 CV_INTER_NN 方法..
     CV_INTER_CUBIC - 立方插值.
     */
    cvResize(&srcMat, &dstMat, CV_INTER_NN);
    
    return dstMat;
}

/**
 *  矩阵平移， 原图像不变
 *
 *  @param srcMat 原矩阵
 *  @param dx     X方向平移
 *  @param dy     Y方向平移
 */
- (Mat)translateTransform:(Mat)srcMat X:(int)dx Y:(int)dy{
    
//    CV_ASSERT(srcMat.depth() == CV_8U);
    
    Mat dstMat;
    const int rows = srcMat.rows;
    const int cols = srcMat.cols;
    dstMat.create(rows, cols, srcMat.type());
    
    Vec3b *p;
    for (int i=0; i< rows; i++) {
        p = dstMat.ptr<Vec3b>(i);
        for (int j=0; j < cols; j++) {
            //平移后坐标映射到原图像
            int x = j - dx;
            int y = i - dy;
            //保证映射后的坐标在原图像范围内
            if (x >= 0 && y >= 0 && x < cols && y < rows)
                p[j] = srcMat.ptr<Vec3b>(y)[x];
        }
    }
    
    return dstMat;
}

//平移后图像的大小变化
- (Mat)translateSizeChangeTransform:(Mat)srcMat X:(int)dx Y:(int)dy{
    
    //    CV_ASSERT(srcMat.depth() == CV_8U);
    
    Mat dstMat;
    const int rows = srcMat.rows + abs(dy);;
    const int cols = srcMat.cols + abs(dx);
    
    dstMat.create(rows, cols, srcMat.type());
    
    Vec3b *p;
    for (int i=0; i< rows; i++) {
        p = dstMat.ptr<Vec3b>(i);
        for (int j=0; j < cols; j++) {
            //平移后坐标映射到原图像
            int x = j - dx;
            int y = i - dy;
            
            //保证映射后的坐标在原图像范围内
            if (x >= 0 && y >= 0 && x < cols && y < rows)
                p[j] = srcMat.ptr<Vec3b>(y)[x];
        }
    }
    
    return dstMat;
}


/**
 * 水平镜像, 在水平镜像变换时，遍历了整个图像，然后根据映射关系对每个像素都做了处理。
 * 实际上，水平镜像变换就是将图像坐标的列换到右边，右边的列换到左边，是可以以列为单位做变换的。同样垂直镜像变换也如此，可以以行为单位进行变换。
 *
 *  @param srcMat 原图像矩阵
 *
 *  @return 处理后的矩阵
 */
- (Mat)mirrorHTransmit:(Mat)srcMat{
    Mat dstMat;
    dstMat.create(srcMat.rows, srcMat.cols, srcMat.type());
    
    int rows = srcMat.rows;
    int cols = srcMat.cols;
    
    switch (srcMat.channels()) {
        case 1:
            {
                const uchar *origal;
                uchar *p;
                for (int i = 0; i < rows; i++){
                    origal = srcMat.ptr<uchar>(i);
                    p = dstMat.ptr<uchar>(i);
                    for (int j = 0; j < cols; j++){
                        p[j] = origal[cols - 1 - j];
                    }
                }
            }
            break;
        case 3:
            {
                const Vec3b *origal3;
                Vec3b *p3;
                for (int i = 0; i < rows; i++) {
                    origal3 = srcMat.ptr<Vec3b>(i);
                    p3 = dstMat.ptr<Vec3b>(i);
                    for(int j = 0; j < cols; j++){
                        p3[j] = origal3[cols - 1 - j];
                    }
                }
            }
            break;
        default:
            break;
    }
    
    return dstMat;
}

/**
 *  垂直镜像处理
 */
- (Mat)mirrorVTransmit:(Mat)srcMat{
    Mat dstMat;
    dstMat.create(srcMat.rows, srcMat.cols, srcMat.type());
    
    int rows = srcMat.rows;
    for (int i=0; i < rows; i++) {
        srcMat.row(rows -i -1).copyTo(dstMat.row(i));   //从原图像中取出第i行，并将其复制到目标图像。
    }
    
    return dstMat;
}

//图像旋转变换（原尺寸）
- (IplImage *)rotateImageWithSrcImage:(IplImage *)srcImg degree:(int)degree{
    //旋转中心为图像中心
    CvPoint2D32f center;
    center.x = float(srcImg->width/2.0+0.5);
    center.y = float(srcImg->height/2.0+0.5);
    
    IplImage *dstImg;
    
    //计算二维旋转的仿射变换矩阵
    float m[6];
    CvMat M = cvMat(2, 3, CV_32F, m);
    cv2DRotationMatrix(center, degree,1, &M);
    
    
    
    cvWarpAffine(srcImg,dstImg, &M);    //变换图像，并用默认色填充其余值
//    cvWarpAffine(srcImg,dstImg, &M, CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS, cvScalarAll(0));   //变换图像，并用黑色填充其余值

    return dstImg;
}


//旋转图像内容不变，尺寸相应变大
IplImage* rotateImage2(IplImage* img, int degree)
{
    double angle = degree  * CV_PI / 180.;
    double a = sin(angle), b = cos(angle);
    int width=img->width, height=img->height;
    //旋转后的新图尺寸
    int width_rotate= int(height * fabs(a) + width * fabs(b));
    int height_rotate=int(width * fabs(a) + height * fabs(b));
    IplImage* img_rotate = cvCreateImage(cvSize(width_rotate, height_rotate), img->depth, img->nChannels);
    cvZero(img_rotate);
    //保证原图可以任意角度旋转的最小尺寸
    int tempLength = sqrt((double)width * width + (double)height *height) + 10;
    int tempX = (tempLength + 1) / 2 - width / 2;
    int tempY = (tempLength + 1) / 2 - height / 2;
    IplImage* temp = cvCreateImage(cvSize(tempLength, tempLength), img->depth, img->nChannels);
    cvZero(temp);
    //将原图复制到临时图像tmp中心
    cvSetImageROI(temp, cvRect(tempX, tempY, width, height));
    cvCopy(img, temp, NULL);
    cvResetImageROI(temp);
    //旋转数组map
    // [ m0  m1  m2 ] ===>  [ A11  A12   b1 ]
    // [ m3  m4  m5 ] ===>  [ A21  A22   b2 ]
    float m[6];
    int w = temp->width;
    int h = temp->height;
    m[0] = b;
    m[1] = a;
    m[3] = -m[1];
    m[4] = m[0];
    // 将旋转中心移至图像中间
    m[2] = w * 0.5f;
    m[5] = h * 0.5f;
    CvMat M = cvMat(2, 3, CV_32F, m);
    cvGetQuadrangleSubPix(temp, img_rotate, &M);
    cvReleaseImage(&temp);
    return img_rotate;
}

@end
