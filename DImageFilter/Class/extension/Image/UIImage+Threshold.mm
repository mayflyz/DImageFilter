//
//  UIImage+Threshold.m
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "UIImage+Threshold.h"

#import "UIImage+MatOperate.h"

@implementation UIImage (Threshold)
/**
 *  生成灰度图
 *
 *  @return 灰度图片
 */
- (UIImage *)grayImage{
    cv::Mat grayMate = self.CVGrayscaleMat;
    UIImage *grayImage = [[self class] imageWithCVMat:grayMate];
    
    return grayImage;
}

/**
 *  二值化
 *  ************************************************
 *  下面是标记监测管道的处理流程：
 *   1.把输入的图像转化成灰度图像。
 *   2.进行二进制阈值操作（Perform binary threshold operation）。
 *   3.检测图像轮廓。
 *   4.搜索可能的标记。
 *   5.检测并解码标记。
 *   6.模拟出标记的三维姿态（形状）
 *  ************************************************
 *   @return 二值化后的图片
 */
- (UIImage *)binaryzation{
    /*
     openCV二值化过程：
     1.Src的UIImage ->  Src的IplImage
     2.设置Src的IplImage的ImageROI
     3.创建新的dstImage1的IplImage，并复制Src的IplImage
     
     4.dstImage1的IplImage转换成cvMat形式的matImage
     */
    cv::Mat matImage = self.CVMat;
    cv::Mat greymat;
    
    //5.cvtColor函数对matImage进行灰度处理, 取得IplImage形式的灰度图像
    cv::cvtColor(self.CVMat, greymat, CV_BGR2GRAY); //转换成灰色
    
    //6.使用灰度后的IplImage形式图像，用OSTU算法算阈值：threshold
    IplImage grey = greymat;
    unsigned char* dataImage = (unsigned char*)grey.imageData;
    int threshold = OTSU(dataImage, grey.width, grey.height);
    printf("阈值：%d\n",threshold);
    
    return [self binaryzationWithThresh:threshold];
}

- (UIImage *)binaryzationWithThresh:(int)value{
    UIImage *destImg;
    if (value < 0)  value = 0;
    if (value > 250)    value = 250;
    
    /*
     openCV二值化过程：
     1.Src的UIImage ->  Src的IplImage
     2.设置Src的IplImage的ImageROI
     3.创建新的dstImage1的IplImage，并复制Src的IplImage
     
     4.dstImage1的IplImage转换成cvMat形式的matImage
     */
    cv::Mat matImage = self.CVMat;
    cv::Mat greymat;
    
    //5.cvtColor函数对matImage进行灰度处理, 取得IplImage形式的灰度图像
    cv::cvtColor(self.CVMat, greymat, CV_BGR2GRAY); //转换成灰色
    
    //7.利用阈值算得新的cvMat形式的图像
    cv::Mat matBinary;
    cv::threshold(greymat, matBinary, value, 255, cv::THRESH_BINARY);
    
    //8.cvMat形式的图像转UIImage
    destImg = [[self class] imageWithCVMat:matBinary];
    
    return destImg;
}

/**
 *  创建直方图
 */
- (UIImage *)grayHistImg{
    const int channels[1]={0};
    float hranges[2]={0,255};
    const float* ranges[1]={hranges};
    cv::MatND hist;
    /// Establish the number of bins
    int histSize = 256;
    
    /**
     *  计算图像直方图像
     *  参数1为输入图像的指针。
     *  nimages：要计算直方图的图像的个数。此函数可以为多图像求直方图，我们通常情况下都只作用于单一图像，所以通常nimages=1。
     *  channels：图像的通道，它是一个数组，如果是灰度图像则channels[1]={0};如果是彩色图像则channels[3]={0,1,2}；如果是只是求彩色图像第2个通道的直方图，则channels[1]={1};
     *  mask：是一个遮罩图像用于确定哪些点参与计算，实际应用中是个很好的参数，默认情况我们都设置为一个空图像，即：Mat()。
     *  hist：计算得到的直方图
     *  dims：得到的直方图的维数，灰度图像为1维，彩色图像为3维。
     *  histSize：直方图横坐标的区间数。如果是10，则它会横坐标分为10份，然后统计每个区间的像素点总和。
     *  ranges：这是一个二维数组，用来指出每个区间的范围。
     */
    cv::Mat srcMat = self.CVMat;
    cv::Mat b_hist, g_hist, r_hist;
    cv::vector<cv::Mat> rgb_planes;
    cv::split(srcMat, rgb_planes);
    cv::calcHist(&rgb_planes[0], 1, channels, cv::Mat(), b_hist, 1, &histSize, ranges);
    cv::calcHist(&rgb_planes[1], 1, channels, cv::Mat(), g_hist, 1, &histSize, ranges);
    cv::calcHist(&rgb_planes[2], 1, channels, cv::Mat(), r_hist, 1, &histSize, ranges);
    
    // Draw the histograms for B, G and R
    int hist_w = 512; int hist_h = 400;
    int bin_w = cvRound((double) hist_w/histSize);
    
    cv::Mat histImage(hist_h, hist_w, CV_8UC3, cv::Scalar( 0,0,0) );
    
    /// Normalize the result to [ 0, histImage.rows ]
    normalize(b_hist, b_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat());
    normalize(g_hist, g_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat());
    normalize(r_hist, r_hist, 0, histImage.rows, cv::NORM_MINMAX, -1, cv::Mat());
    
    for (int i=1; i < histSize; i++) {
        cv::line(histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(b_hist.at<float>(i-1)) ),
                 cv::Point( bin_w*(i), hist_h - cvRound(b_hist.at<float>(i)) ),
                 cv::Scalar( 255, 0, 0), 2, 8, 0 );
        cv::line(histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(g_hist.at<float>(i-1)) ),
                 cv::Point( bin_w*(i), hist_h - cvRound(g_hist.at<float>(i)) ),
                 cv::Scalar( 0, 255, 0), 2, 8, 0 );
        cv::line(histImage, cv::Point( bin_w*(i-1), hist_h - cvRound(r_hist.at<float>(i-1)) ),
                 cv::Point( bin_w*(i), hist_h - cvRound(r_hist.at<float>(i)) ),
                 cv::Scalar( 0, 0, 255), 2, 8, 0);
    }
    
    return [[self class] imageWithCVMat:histImage];
}

- (UIImage *)colorHistImg{
    
    
    return nil;//[[self class] imageWithCVMat:dstMat];
}

cv::Mat getHistImg(const cv::MatND& hist)
{
    double maxVal=0;
    double minVal=0;
    
    //找到直方图中的最大值和最小值
    minMaxLoc(hist,&minVal,&maxVal,0,0);
    int histSize=hist.rows;
    cv::Mat histImg(histSize,histSize,CV_8U,cv::Scalar(255));
    // 设置最大峰值为图像高度的90%
    int hpt=static_cast<int>(0.9*histSize);
    
    for(int h=0;h<histSize;h++)
    {
        float binVal=hist.at<float>(h);
        int intensity=static_cast<int>(binVal*hpt/maxVal);
        line(histImg,cv::Point(h,histSize),cv::Point(h,histSize-intensity),cv::Scalar::all(0));
    }
    
    return histImg;
}

/**
 *  直方图均衡化
 */
- (UIImage *)histogramEqualization{
    cv::Mat srcMat, dstMat;
    cvtColor(self.CVMat, srcMat, CV_BGR2GRAY);
    cv::equalizeHist(srcMat, dstMat);
    
    return [[self class] imageWithCVMat:dstMat];
}

- (UIImage *)equalHistImg{
    IplImage *eqlImage = cvCreateImage(cvGetSize(self.plImage), self.plImage->depth, 3);
    
    //分别均衡化每个信道
    IplImage *redImage = cvCreateImage(cvGetSize(self.plImage),self.plImage->depth,1);
    IplImage *greenImage = cvCreateImage(cvGetSize(self.plImage),self.plImage->depth,1);
    IplImage *blueImage = cvCreateImage(cvGetSize(self.plImage),self.plImage->depth,1);
    cvSplit(self.plImage,blueImage,greenImage,redImage,NULL);
    
    cvEqualizeHist(redImage,redImage);
    cvEqualizeHist(greenImage,greenImage);
    cvEqualizeHist(blueImage,blueImage);
    //均衡化后的图像
    cvMerge(blueImage,greenImage,redImage,NULL,eqlImage);
    
    return [[self class] imageWIthIplImage:eqlImage];
}

#pragma mark ------------ Sobel derivatives ------------ 
- (UIImage *)sobelOperation{
    return [self sobelWithScale:1];
}

/**
 *  Sobel算子
 *
 *  @param value Scale 值
 */
- (UIImage *)sobelWithScale:(int)value{
    int scale = value;
    int delta = 0;
    int ddepth = CV_16S;
    
    cv::Mat srcMat;
    cv::Mat grayMat = self.CVGrayscaleMat;
    cv::Mat grad;
    cv::GaussianBlur(self.CVMat, srcMat, cv::Size(3,3), 0);
    
//    Generate grad_x and grad_y
    cv::Mat grad_x, grad_y;
    cv::Mat abs_grad_x, abs_grad_y;
    
//    Gradient X
//    Scharr( src_gray, grad_x, ddepth, 1, 0, scale, delta, BORDER_DEFAULT );
    /**
     *  第三个参数，int类型的ddepth，输出图像的深度，支持如下src.depth()和ddepth的组合：
     *      若src.depth() = CV_8U, 取ddepth =-1/CV_16S/CV_32F/CV_64F
     *      若src.depth() = CV_16U/CV_16S, 取ddepth =-1/CV_32F/CV_64F
     *      若src.depth() = CV_32F, 取ddepth =-1/CV_32F/CV_64F
     *      若src.depth() = CV_64F, 取ddepth = -1/CV_64F
     *  第四个参数，int类型dx，x 方向上的差分阶数。
     *  第五个参数，int类型dy，y方向上的差分阶数。
     *  第六个参数，int类型ksize，有默认值3，表示Sobel核的大小;必须取1，3，5或7。
     *  第七个参数，double类型的scale，计算导数值时可选的缩放因子，默认值是1，表示默认情况下是没有应用缩放的。我们可以在文档中查阅getDerivKernels的相关介绍，来得到这个参数的更多信息。
     */
    cv::Sobel(grayMat, grad_x, ddepth, 1, 0, 3, scale, delta);
    convertScaleAbs( grad_x, abs_grad_x );
    
    /// Gradient Y
    //Scharr( src_gray, grad_y, ddepth, 0, 1, scale, delta, BORDER_DEFAULT );
    cv::Sobel(grayMat, grad_y, ddepth, 0, 1, 3, scale, delta);
    convertScaleAbs( grad_y, abs_grad_y );
    
    /// Total Gradient (approximate)
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );

    
    return [[self class] imageWithCVMat:grad];
}

#pragma mark ------------- Canny -------------------
/*  ************************************
 *  Canny 的目标是找到一个最优的边缘检测算法
 * *********************************** */
- (UIImage *)cannyWithThreshold:(int)value{
//    转成灰度图，降噪，用canny，最后将得到的边缘作为掩码，拷贝原图到效果图上，得到彩色的边缘图
    cv::Mat dstMat;
    cv::Mat grayMat;
    cv::blur(self.CVMat, dstMat, cv::Size(3,3));
    
    /**
     *  第一个参数，InputArray类型的image，输入图像，即源图像，填Mat类的对象即可，且需为单通道8位图像。
     *  第二个参数，OutputArray类型的edges，输出的边缘图，需要和源图片有一样的尺寸和类型。
     *  第三个参数，double类型的threshold1，第一个滞后性阈值。
     *  第四个参数，double类型的threshold2，第二个滞后性阈值。
     *  第五个参数，int类型的apertureSize，表示应用Sobel算子的孔径大小，其有默认值3。
     *  第六个参数，bool类型的L2gradient，一个计算图像梯度幅值的标识，有默认值false。
     */
    cv::Canny(dstMat, dstMat, value, value*3);
    
    return [[self class] imageWithCVMat:dstMat];
}

#pragma mark ------------- Laplace -------------------
- (UIImage *)LaplaceWithSize:(int)value{

    cv::Mat srcMat;
    cv::Mat grayMat;
    cv::Mat grad;
    cv::GaussianBlur(self.CVMat, srcMat, cv::Size(3,3), 0);
    cvtColor(srcMat, grayMat, CV_RGB2GRAY);
    
    
    cv::Mat dstMat;
    // 先使用 3x3内核来降噪
    blur(grayMat, dstMat, cv::Size(3,3));
    /**
     * 运行我们的Canny算子
     *  第一个参数，InputArray类型的image，输入图像，即源图像，填Mat类的对象即可，且需为单通道8位图像。
     *  第二个参数，OutputArray类型的edges，输出的边缘图，需要和源图片有一样的尺寸和通道数。
     *  第三个参数，int类型的ddept，目标图像的深度。
     *  第四个参数，int类型的ksize，用于计算二阶导数的滤波器的孔径尺寸，大小必须为正奇数，且有默认值1。
     *  第五个参数，double类型的scale，计算拉普拉斯值的时候可选的比例因子，有默认值1。
     *  第六个参数，double类型的delta，表示在结果存入目标图（第二个参数dst）之前可选的delta值，有默认值0。
     *  第七个参数， int类型的borderType，边界模式，默认值为BORDER_DEFAULT。这个参数可以在官方文档中borderInterpolate()处得到更详细的信息。
     */
    Canny(dstMat, dstMat, value, value*3, 3 );
    
    //使用Canny算子输出的边缘图g_cannyDetectedEdges作为掩码，来将原图g_srcImage拷到目标图g_dstImage中
    return [[self class] imageWithCVMat:dstMat];
}

#pragma mark ------------- Scharr边缘检测 -------------------
- (UIImage *)scharrWithScale:(int)value{
    int scale = value;
    int delta = 0;
    int ddepth = CV_16S;
    
    cv::Mat srcMat;
    cv::Mat grayMat = self.CVGrayscaleMat;
    cv::Mat grad;
    cv::GaussianBlur(self.CVMat, srcMat, cv::Size(3,3), 0);
    
    //    Generate grad_x and grad_y
    cv::Mat grad_x, grad_y;
    cv::Mat abs_grad_x, abs_grad_y;
    
    /**
     *  第三个参数，int类型的ddepth，输出图像的深度，支持如下src.depth()和ddepth的组合：
     *      若src.depth() = CV_8U, 取ddepth =-1/CV_16S/CV_32F/CV_64F
     *      若src.depth() = CV_16U/CV_16S, 取ddepth =-1/CV_32F/CV_64F
     *      若src.depth() = CV_32F, 取ddepth =-1/CV_32F/CV_64F
     *      若src.depth() = CV_64F, 取ddepth = -1/CV_64F
     *  第四个参数，int类型dx，x 方向上的差分阶数。
     *  第五个参数，int类型dy，y方向上的差分阶数。
     *  第六个参数，int类型ksize，有默认值3，表示Sobel核的大小;必须取1，3，5或7。
     *  第七个参数，double类型的scale，计算导数值时可选的缩放因子，默认值是1，表示默认情况下是没有应用缩放的。我们可以在文档中查阅getDerivKernels的相关介绍，来得到这个参数的更多信息。
     */
    Scharr(grayMat, grad_x, ddepth, 1, 0, scale, delta);   //Gradient X
    convertScaleAbs(grad_x, abs_grad_x);
    
    Scharr( grayMat, grad_y, ddepth, 0, 1, scale, delta);   // Gradient Y
    convertScaleAbs( grad_y, abs_grad_y );
    
    /// Total Gradient (approximate)
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );
    
    return [[self class] imageWithCVMat:grad];
}


#pragma mark ------------- OTSU -------------------
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
@end