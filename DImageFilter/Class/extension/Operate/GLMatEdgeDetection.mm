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

/**
 *   迭代法
 *
 *  @param srcImg  灰度图像
 *  @param maxIter 最大迭代次数
 */
+ (int)detechThreshold:(IplImage *)srcImg maxIterat:(int)maxIter{
    //图像信息
    int height = srcImg->height;
    int width = srcImg->width;
    int step = srcImg->widthStep/sizeof(uchar);
    uchar *data = (uchar*)srcImg->imageData;
    
    int iDiffRec =0;       //使用给定阀值确定的亮区与暗区平均灰度差异值, 根据需要返回
    int F[256]={ 0 }; //直方图数组
    int iTotalGray=0;//灰度值和
    int iTotalPixel =0;//像素数和
    Byte bt;//某点的像素值
    
    uchar iThrehold,iNewThrehold;//阀值、新阀值
    uchar iMaxGrayValue=0,iMinGrayValue=255;//原图像中的最大灰度值和最小灰度值
    uchar iMeanGrayValue1,iMeanGrayValue2;
    
    //获取(i,j)的值，存于直方图数组F
    for(int i=0;i<width;i++){
        for(int j=0;j<height;j++){
            bt = data[i*step+j];
            if(bt<iMinGrayValue)
                iMinGrayValue = bt;
            if(bt>iMaxGrayValue)
                iMaxGrayValue = bt;
            F[bt]++;
        }
    }
    
    iThrehold =0;
    iNewThrehold = (iMinGrayValue+iMaxGrayValue)/2;//初始阀值
    iDiffRec = iMaxGrayValue - iMinGrayValue;
    
    for(int a=0;(abs(iThrehold-iNewThrehold)>0.5)&&a<maxIter;a++){      //迭代中止条件
        iThrehold = iNewThrehold;
        //小于当前阀值部分的平均灰度值
        for(int i=iMinGrayValue;i<iThrehold;i++){
            iTotalGray += F[i]*i;//F[]存储图像信息
            iTotalPixel += F[i];
        }
        
        iMeanGrayValue1 = (uchar)(iTotalGray/iTotalPixel);
        //大于当前阀值部分的平均灰度值
        iTotalPixel =0;
        iTotalGray =0;
        for(int j=iThrehold+1;j<iMaxGrayValue;j++){
            iTotalGray += F[j]*j;//F[]存储图像信息
            iTotalPixel += F[j];
        }
        iMeanGrayValue2 = (uchar)(iTotalGray/iTotalPixel);
        
        iNewThrehold = (iMeanGrayValue2+iMeanGrayValue1)/2; //新阀值
        iDiffRec = abs(iMeanGrayValue2 - iMeanGrayValue1);
    }
    
    return iThrehold;
}

/*============================================================================
 = 代码内容：最大熵阈值分割
 ===============================================================================*/
// 计算当前位置的能量熵

#define cvQueryHistValue_1D( hist, idx0 ) \
((float)cvGetReal1D( (hist)->bins, (idx0)))
+ (double)caculateCurrentEntropy:(CvHistogram *)histogram currentThreshold:(int)threshold state:(EntropyState)state{
    int start,end;
    int total =0;
    double cur_entropy =0.0;
    if(state == Back){
        start =0;
        end = threshold;
    }else{
        start = threshold;
        end =256;
    }
    
    for(int i=start;i<end;i++){
        total += (int)cvQueryHistValue_1D(histogram,i);//查询直方块的值 P304
    }
    
    for(int j=start;j<end;j++)
    {
        if((int)cvQueryHistValue_1D(histogram,j)==0)
            continue;
        double percentage = cvQueryHistValue_1D(histogram,j)/total;
        /*熵的定义公式*/
        cur_entropy +=-percentage*logf(percentage);
        /*根据泰勒展式去掉高次项得到的熵的近似计算公式
         cur_entropy += percentage*percentage;*/
    }
    return cur_entropy;
}

//寻找最大熵阈值并分割
+ (int)maxEntropy:(IplImage *)srcImg{
    /**
     *  创建直方图
     *
     *  @param dims             直方图维数的数目
     *  @param sizes      直方图维数尺寸的组数
     *  @param type 直方图的表示格式: CV_HIST_ARRAY 意味着直方图数据表示为多维密集数组 CvMatND; CV_HIST_TREE 意味着直方图数据表示为多维稀疏数组 CvSparseMat.
     */
    int hist_size = 256;
    CvHistogram *hist = cvCreateHist(1, &hist_size, CV_HIST_ARRAY);
    cvCalcHist(&srcImg, hist);
    double maxentropy = -1.0;
    int max_index = -1;
    // 循环测试每个分割点，寻找到最大的阈值分割点
    for (int i=0; i < hist_size; i++) {
       double backValue = [[self class] caculateCurrentEntropy:hist currentThreshold:i state:Back];
        double frontValue = [[self class] caculateCurrentEntropy:hist currentThreshold:i state:Object];
        double cur_entropy = backValue + frontValue;
        
        if(cur_entropy>maxentropy){
            maxentropy = cur_entropy;
            max_index = i;
        }
    }
    
    return max_index;
}

+ (int)basicGlobalThrehold:(IplImage *)srcImg{
    /*基本全局阀值法*/
//    IplImage *basicImg;
//    cvCopy(srcImg, basicImg);
    
    int pg[256],i,threhold;
    for (i=0;i<256;i++) pg[i]=0;
    for (i=0;i<srcImg->imageSize;i++) // 直方图统计
        pg[(Byte)srcImg->imageData[i]]++;
    
    threhold = [[self class] basicGlobalThreshold:pg start:0 end:256];  // 确定阈值
    
    return threhold;
}

/*============================================================================
 = 代码内容：基本全局阈值法
 ==============================================================================*/
+ (int)basicGlobalThreshold:(int *)pg start:(int)start end:(int)end{
    // 基本全局阈值法
    int i,t,t1,t2,k1,k2;
    double u,u1,u2;
    t=0;
    u=0;
    for (i=start;i<end;i++)
    {
        t+=pg[i];
        u+=i*pg[i];
    }
    k2=(int) (u/t); // 计算此范围灰度的平均值
    do
    {
        k1=k2;
        t1=0;
        u1=0;
        for (i=start;i<=k1;i++)
        { // 计算低灰度组的累加和
            t1+=pg[i];
            u1+=i*pg[i];
        }
        t2=t-t1;
        u2=u-u1;
        if (t1)
            u1=u1/t1; // 计算低灰度组的平均值
        else
            u1=0;
        if (t2)
            u2=u2/t2; // 计算高灰度组的平均值
        else
            u2=0;
        k2=(int) ((u1+u2)/2); // 得到新的阈值估计值
    }
    while(k1!=k2); // 数据未稳定，继续
    //cout<<"The Threshold of this Image in BasicGlobalThreshold is:"<<k1<<endl;
    return(k1); // 返回阈值
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
