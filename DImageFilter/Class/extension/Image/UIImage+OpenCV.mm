//
//  UIImage+OpenCV.m
//  ImageFilter
//
//  Created by tony on 5/18/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "UIImage+OpenCV.h"

static void ProviderReleaseDataNOP(void *info, const void *data, size_t size)
{
    // Do not release memory
    return;
}


@implementation UIImage (Convert)

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
@end



@implementation UIImage (Threshold)
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
    UIImage *destImg;
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
    
    //7.利用阈值算得新的cvMat形式的图像
    cv::Mat matBinary;
    cv::threshold(greymat, matBinary, threshold, 255, cv::THRESH_BINARY);
    
    //8.cvMat形式的图像转UIImage
    destImg = [[self class] imageWithCVMat:matBinary];
    
    return destImg;
}

/**
 *  创建直方图
 */
- (UIImage *)grayHistImg{
    const int channels[1]={0};
    const int histSize[1]={256};
    float hranges[2]={0,255};
    const float* ranges[1]={hranges};
    cv::MatND hist;
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
    cv::calcHist(&srcMat, 1, channels, cv::Mat(), hist, 1, histSize, ranges);
    
    cv::Mat dstMat = getHistImg(hist);
    
    return [[self class] imageWithCVMat:dstMat];
}

- (UIImage *)colorHistImg{
    const int channels[3]={0,1,2};
    const int histSize[3]={256,256,256};
    float hranges[2]={0,255};
    const float* ranges[3]={hranges, hranges, hranges};
    cv::MatND hist;
    cv::Mat srcMat = self.CVMat;
    cv::calcHist(&srcMat, 1, channels, cv::Mat(), hist, 1, histSize, ranges);
    
    cv::Mat dstMat = getHistImg(hist);
    
    return [[self class] imageWithCVMat:dstMat];
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

@end

@implementation UIImage (Filter)

/**
 *  方框滤波
 */
- (UIImage *)boxBlurFilter{
    return [self boxBlurFilterWithSize:3];
}

- (UIImage *)boxBlurFilterWithSize:(int)size{
    cv::Mat outMat;
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，填Mat类的对象即可。该函数对通道是独立处理的，且可以处理任意通道数的图片，但需要注意，待处理的图片深度应该为CV_8U, CV_16U, CV_16S, CV_32F 以及 CV_64F之一。
     *  第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。
     *  第三个参数，int类型的ddepth，输出图像的深度，-1代表使用原图深度，即src.depth()。
     *  第四个参数，Size类型的ksize，内核的大小。一般这样写Size( w,h )来表示内核的大小( 其中，w 为像素宽度， h为像素高度)。Size（3,3）就表示3x3的核大小，Size（5,5）就表示5x5的核大小
     *  第五个参数，Point类型的anchor，表示锚点（即被平滑的那个点），注意他有默认值Point(-1,-1)。如果这个点坐标是负值的话，就表示取核的中心为锚点，所以默认值Point(-1,-1)表示这个锚点在核的中心。
     *  第六个参数，bool类型的normalize，默认值为true，一个标识符，表示内核是否被其区域归一化（normalized）了。
     *  第七个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。有默认值BORDER_DEFAULT，我们一般不去管它。
     */
    cv::boxFilter(self.CVMat, outMat, -1, cv::Size(size, size));
    
    return [[self class] imageWithCVMat:outMat];
}

/**
 *  均值滤波
 */
- (UIImage *)blurFilter{
    return [self blureFilterWithSize:3];
}

- (UIImage *)blureFilterWithSize:(int)size{
    cv::Mat outMat;
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，填Mat类的对象即可。该函数对通道是独立处理的，且可以处理任意通道数的图片，但需要注意，待处理的图片深度应该为CV_8U, CV_16U, CV_16S, CV_32F 以及 CV_64F之一。
     *  第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。比如可以用Mat::Clone，以源图片为模板，来初始化得到如假包换的目标图。
     *  第三个参数，Size类型（对Size类型稍后有讲解）的ksize，内核的大小。一般这样写Size( w,h )来表示内核的大小( 其中，w 为像素宽度， h为像素高度)。Size（3,3）就表示3x3的核大小，Size（5,5）就表示5x5的核大小
     *  第四个参数，Point类型的anchor，表示锚点（即被平滑的那个点），注意他有默认值Point(-1,-1)。如果这个点坐标是负值的话，就表示取核的中心为锚点，所以默认值Point(-1,-1)表示这个锚点在核的中心。
     *  第五个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。有默认值BORDER_DEFAULT，我们一般不去管它。
     */
    cv::blur(self.CVMat, outMat, cv::Size(size, size));
    
    return [[self class] imageWithCVMat:outMat];
}

/**
 *  高斯滤波
 */
- (UIImage *)gaussianBlurFilter{
    return [self gaussianBlurFilterWithSize:3];
}

- (UIImage *)gaussianBlurFilterWithSize:(int)size{
    cv::Mat outMat;
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，填Mat类的对象即可。它可以是单独的任意通道数的图片，但需要注意，图片深度应该为CV_8U,CV_16U, CV_16S, CV_32F 以及 CV_64F之一。
     *  第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。比如可以用Mat::Clone，以源图片为模板，来初始化得到如假包换的目标图。
     *  第三个参数，Size类型的ksize高斯内核的大小。其中ksize.width和ksize.height可以不同，但他们都必须为正数和奇数。或者，它们可以是零的，它们都是由sigma计算而来。
     *  第四个参数，double类型的sigmaX，表示高斯核函数在X方向的的标准偏差。
     *  第五个参数，double类型的sigmaY，表示高斯核函数在Y方向的的标准偏差。若sigmaY为零，就将它设为sigmaX，如果sigmaX和sigmaY都是0，那么就由ksize.width和ksize.height计算出来。
     为了结果的正确性着想，最好是把第三个参数Size，第四个参数sigmaX和第五个参数sigmaY全部指定到。
     *  第六个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。注意它有默认值BORDER_DEFAULT。
     */
    cv::GaussianBlur(self.CVMat, outMat, cv::Size(size, size), 0);
    
    return [[self class] imageWithCVMat:outMat];
}

/**
 *  中值滤波
 */
- (UIImage *)medianFilter{
    
    return [self medianFilterWithkSize:25];
}

/**
 *  中值滤波
 */
- (UIImage *)medianFilterWithkSize:(int)size{
    cv::Mat dstMat;
    /**
     *  第一个参数，InputArray类型的src，函数的输入参数，填1、3或者4通道的Mat类型的图像；当ksize为3或者5的时候，图像深度需为CV_8U，CV_16U，或CV_32F其中之一，而对于较大孔径尺寸的图片，它只能是CV_8U。
     *  第二个参数，OutputArray类型的dst，即目标图像，函数的输出参数，需要和源图片有一样的尺寸和类型。我们可以用Mat::Clone，以源图片为模板，来初始化得到如假包换的目标图。
     *  第三个参数，int类型的ksize，孔径的线性尺寸（aperture linear size），注意这个参数必须是大于1的奇数，比如：3，5，7，9 ...
     */
    cv::medianBlur(self.CVMat, dstMat, 25);
    
    return [[self class] imageWithCVMat:dstMat];
}

/**
 *  双边滤波
 */
#pragma goto::有问题
- (UIImage *)bilateralFilter{
    cv::Mat srcMat;
    cv::cvtColor(self.CVMat, srcMat, cv::COLOR_RGB2BGR);    //转换为三通道值
    
    cv::Mat dstMat;
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，需要为8位或者浮点型单通道、三通道的图像。
     *  第二个参数，OutputArray类型的dst，即目标图像，需要和源图片有一样的尺寸和类型。
     *  第三个参数，int类型的d，表示在过滤过程中每个像素邻域的直径。如果这个值我们设其为非正数，那么OpenCV会从第五个参数sigmaSpace来计算出它来。
     *  第四个参数，double类型的sigmaColor，颜色空间滤波器的sigma值。这个参数的值越大，就表明该像素邻域内有更宽广的颜色会被混合到一起，产生较大的半相等颜色区域。
     *  第五个参数，double类型的sigmaSpace坐标空间中滤波器的sigma值，坐标空间的标注方差。他的数值越大，意味着越远的像素会相互影响，从而使更大的区域足够相似的颜色获取相同的颜色。当d>0，d指定了邻域大小且与sigmaSpace无关。否则，d正比于sigmaSpace。
     *  第六个参数，int类型的borderType，用于推断图像外部像素的某种边界模式。注意它有默认值BORDER_DEFAULT。
     */
    cv::bilateralFilter(srcMat, dstMat, 25, 25*2, 25/2);
    
    return [[self class] imageWithCVMat:dstMat];
}

@end


@implementation  UIImage (Morphology)

/**
 *  腐蚀
 */
- (UIImage *)erodeOperation{
    return [self erodeOperationWithSize:3];
}

- (UIImage *)erodeOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_ERODE elementSize:size];
}

/**
 *  膨胀
 *
 */
- (UIImage *)dilateOperation{
    return [self dilateOperationWithSize:3];
}

- (UIImage *)dilateOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_DILATE elementSize:size];
}

- (UIImage *)openOperation{
    return [self openOperationWithSize:3];
}

- (UIImage *)openOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_OPEN elementSize:size];
}

- (UIImage *)closeOperation{
    return [self closeOperationWithSize:3];
}

- (UIImage *)closeOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_CLOSE elementSize:size];
}

- (UIImage *)topHatOperation{
    return [self topHatOperationWithSize:3];
}

- (UIImage *)topHatOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_TOPHAT elementSize:size];
}

- (UIImage *)blackHatOperation{
    return [self blackHatOperationWithSize:3];
}

- (UIImage *)blackHatOperationWithSize:(int)size{
    return [self morphologyExWithType:cv::MORPH_BLACKHAT elementSize:size];
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
- (UIImage *)morphologyExWithType:(int)operation elementSize:(int)size{
    cv::Mat dstMat;
    
    int g_nStructElementSize = size; //结构元素(内核矩阵)的尺寸
    //获取自定义核
    cv::Mat element = cv::getStructuringElement(cv::MORPH_RECT,
                                                cv::Size(2*g_nStructElementSize+1,2*g_nStructElementSize+1),
                                                cv::Point(g_nStructElementSize, g_nStructElementSize ));
    
    /**
     *  第一个参数，InputArray类型的src，输入图像，即源图像，填Mat类的对象即可。图像位深应该为以下五种之一：CV_8U, CV_16U,CV_16S, CV_32F 或CV_64F。
     *  第二个参数，OutputArray类型的dst，即目标图像，函数的输出参数，需要和源图片有一样的尺寸和类型。
     *  第三个参数，int类型的op，表示形态学运算的类型，可以是如下之一的标识符:MORPH_OPEN – 开运算（Opening operation），MORPH_CLOSE – 闭运算（Closing operation）,MORPH_GRADIENT -形态学梯度（Morphological gradient）, MORPH_TOPHAT - “顶帽”（“Top hat”）,MORPH_BLACKHAT - “黑帽”（“Black hat“）
     
     *  第四个参数，InputArray类型的kernel，形态学运算的内核。若为NULL时，表示的是使用参考点位于中心3x3的核。我们一般使用函数 getStructuringElement配合这个参数的使用。getStructuringElement函数会返回指定形状和尺寸的结构元素（内核矩阵）。关于getStructuringElement我们上篇文章中讲过了，这里为了大家参阅方便，再写一遍：
     其中，getStructuringElement函数的第一个参数表示内核的形状，我们可以选择如下三种形状之一:矩形: MORPH_RECT,交叉形: MORPH_CROSS,椭圆形: MORPH_ELLIPSE而getStructuringElement函数的第二和第三个参数分别是内核的尺寸以及锚点的位置。
     

     */
    cv::morphologyEx(self.CVMat, dstMat, operation, element);
    
    return [[self class] imageWithCVMat:dstMat];
}


- (UIImage *)floodFill{
    cv::floodFill(self.CVGrayscaleMat, cv::Point(50,50), cv::Scalar(155, 255, 255));
    //    cv::floodFill(self.CVMat, <#InputOutputArray mask#>, <#Point seedPoint#>, <#Scalar newVal#>)
    
    return [[self class] imageWithCVMat:self.CVMat];
}
@end