//
//  GLMatEdgeDetection.m
//  DImageFilter
//
//  Created by tony on 6/16/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMatEdgeDetection.h"

@implementation GLMatEdgeDetection

+ (Mat)binaryzation:(Mat)srcMat{
    /*
     openCV二值化过程：
     1.Src的UIImage ->  Src的IplImage
     2.设置Src的IplImage的ImageROI
     3.创建新的dstImage1的IplImage，并复制Src的IplImage
     
     4.dstImage1的IplImage转换成cvMat形式的matImage
     */
    cv::Mat matImage = srcMat;
    cv::Mat greymat;
    
    //5.cvtColor函数对matImage进行灰度处理, 取得IplImage形式的灰度图像
    cv::cvtColor(srcMat, greymat, CV_BGR2GRAY); //转换成灰色
    
    //6.使用灰度后的IplImage形式图像，用OSTU算法算阈值：threshold
    IplImage grey = greymat;
    unsigned char* dataImage = (unsigned char*)grey.imageData;
    int threshold = OTSU(dataImage, grey.width, grey.height);
    printf("阈值：%d\n",threshold);
    
    return [[self class] binaryzation:srcMat threshValue:threshold];
}

+ (Mat)binaryzation:(Mat)srcMat threshValue:(int)value{
    if (value < 0)  value = 0;
    if (value > 250)    value = 250;
    /*
     openCV二值化过程：
     1.Src的UIImage ->  Src的IplImage
     2.设置Src的IplImage的ImageROI
     3.创建新的dstImage1的IplImage，并复制Src的IplImage
     
     4.dstImage1的IplImage转换成cvMat形式的matImage
     */
    cv::Mat matImage = srcMat;
    cv::Mat greymat;
    
    //5.cvtColor函数对matImage进行灰度处理, 取得IplImage形式的灰度图像
    cv::cvtColor(matImage, greymat, CV_BGR2GRAY); //转换成灰色
    
    //7.利用阈值算得新的cvMat形式的图像
    cv::Mat matBinary;
    cv::threshold(greymat, matBinary, value, 255, cv::THRESH_BINARY);
    
    return matBinary;
}

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
int  OTSU(unsigned char* pGrayImg , int iWidth , int iHeight)
{
    if((pGrayImg==0)||(iWidth<=0)||(iHeight<=0))return -1;
    int ihist[256];
    int thresholdValue=0; // „–÷µ
    int n, n1, n2 ;
    double m1, m2, sum, csum, fmax, sb;
    int i,j,k;
    memset(ihist, 0, sizeof(ihist));
    n=iHeight*iWidth;
    sum = csum = 0.0;
    fmax = -1.0;
    n1 = 0;
    for(i=0; i < iHeight; i++)
    {
        for(j=0; j < iWidth; j++)
        {
            ihist[*pGrayImg]++;
            pGrayImg++;
        }
    }
    pGrayImg -= n;
    for (k=0; k <= 255; k++)
    {
        sum += (double) k * (double) ihist[k];
    }
    for (k=0; k <=255; k++)
    {
        n1 += ihist[k];
        if(n1==0)continue;
        n2 = n - n1;
        if(n2==0)break;
        csum += (double)k *ihist[k];
        m1 = csum/n1;
        m2 = (sum-csum)/n2;
        sb = (double) n1 *(double) n2 *(m1 - m2) * (m1 - m2);
        if (sb > fmax)
        {
            fmax = sb;
            thresholdValue = k;
        }
    }
    return(thresholdValue);
}

#pragma mark -- edgeDetection
/**
 *  计算输入图像的所有非零元素对其最近零元素的距离
 *
 *  @param srcMat 原图像元素
 */
+ (Mat)distanceTransform:(Mat)srcMat{
    Mat dstMat;
    
    /**
     *  计算输入图像的所有非零元素对其最近零元素的距离
     *  src：輸入圖，8位元單通道(通常為二值化圖)。
     *  dst：輸出圖，32位元單通道浮點數圖，和src的尺寸相同。
     *  distanceType：距離型態，可以選擇CV_DIST_L1、CV_DIST_L2或CV_DIST_C。
     *  maskSize：遮罩尺寸，可以選3、5或CV_DIST_MASK_PRECISE，當 distanceType為CV_DIST_L1或CV_DIST_C，這個參數限制為3(因為3和5的結果相同)。
     */
    distanceTransform(srcMat, dstMat, CV_DIST_L1, 5);
    return dstMat;
}

+ (Mat)prewitt:(Mat)src{
    Mat gray,Kernelx,Kernely;
    
    cvtColor(src, gray, CV_RGB2GRAY);
    
    Kernelx = (Mat_<double>(3,3) << 1, 1, 1, 0, 0, 0, -1, -1, -1);
    Kernely = (Mat_<double>(3,3) << -1, 0, 1, -1, 0, 1, -1, 0, 1);
    
    Mat grad_x, grad_y;
    Mat abs_grad_x, abs_grad_y, grad;
    
    filter2D(gray, grad_x, CV_16S , Kernelx, cv::Point(-1,-1));
    filter2D(gray, grad_y, CV_16S , Kernely, cv::Point(-1,-1));
    convertScaleAbs( grad_x, abs_grad_x );
    convertScaleAbs( grad_y, abs_grad_y );
    
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );
    
    return grad;
}

+ (Mat)roberts:(Mat)src{
    int pixel[4] = {0};
    int rows = src.rows - 1;
    int cols = src.cols - 1;
    
    Mat dst;
    src.copyTo(dst);
    
    //M(x,y) = 根号[(z9-z5)平方+（z8-z6)平方]
    for (int i=0; i<rows; i++) {
        for (int j=0; j<cols; j++) {
            pixel[0] = src.at<uchar>(i,j);
            pixel[1] = src.at<uchar>(i+1,j);
            pixel[2] = src.at<uchar>(i,j+1);
            pixel[3] = src.at<uchar>(i+1,j+1);
            
            dst.at<uchar>(i,j) = sqrt(double((pixel[0] - pixel[3])*(pixel[0] - pixel[3]) + (pixel[1] - pixel[2])*(pixel[1] - pixel[2])));
        }
    }
    
    return dst;
}

@end
