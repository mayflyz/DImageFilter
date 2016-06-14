//
//  GLMatSkeleton.m
//  DImageFilter
//
//  Created by tony on 6/14/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMatSkeleton.h"

using namespace cv;

#define BLACK 0
#define WHITE 255
#define GRAY 128

@implementation GLMatSkeleton


@end


/**
 *  将IPL_DEPTH_8U型二值图像进行细化，Zhang的快速并行细化算法，从算法原理上，我们可以知道，算法是基于像素8邻域的形状来决定是否删除当前像素。
 *
 *  @param src    原始IPL_DEPTH_8U型二值图像
 *  @param dst    目标存储空间，必须事先分配好，且和原图像大小类型一致
 *  @param intera 迭代次数
 */
void cvThin(cv::Mat& src, cv::Mat& dst, int intera)
{
    if(src.type()!=CV_8UC1)
    {
        printf("只能处理二值或灰度图像\n");
        return;
    }
    //非原地操作时候，copy src到dst
    if(dst.data!=src.data)
    {
        src.copyTo(dst);
    }
    
    int i, j, n;
    int width, height;
    width = src.cols -1;
    //之所以减1，是方便处理8邻域，防止越界
    height = src.rows -1;
    int step = src.step;
    int  p2,p3,p4,p5,p6,p7,p8,p9;
    uchar* img;
    bool ifEnd;
    int A1;
    cv::Mat tmpimg;
    
    //n表示迭代次数, 生成算子
    for(n = 0; n<intera; n++){
        dst.copyTo(tmpimg);
        ifEnd = false;
        img = tmpimg.data;
        
        for(i = 1; i < height; i++){
            img += step;
            for(j =1; j<width; j++){
                uchar* p = img + j;
                A1 = 0;
                if( p[0] > 0){
                    if(p[-step]==0&&p[-step+1]>0){ //p2,p3 01模式
                        A1++;
                    }
                    
                    if(p[-step+1]==0&&p[1]>0){  //p3,p4 01模式
                        A1++;
                    }
                    
                    if(p[1]==0&&p[step+1]>0){   //p4,p5 01模式
                        A1++;
                    }
                    
                    if(p[step+1]==0&&p[step]>0){    //p5,p6 01模式
                        A1++;
                    }
                    
                    if(p[step]==0&&p[step-1]>0){     //p6,p7 01模式
                        A1++;
                    }
                    
                    if(p[step-1]==0&&p[-1]>0){   //p7,p8 01模式
                        A1++;
                    }
                    
                    if(p[-1]==0&&p[-step-1]>0){     //p8,p9 01模式
                        A1++;
                    }
                    
                    if(p[-step-1]==0&&p[-step]>0){   //p9,p2 01模式
                        A1++;
                    }
                    
                    p2 = p[-step]>0?1:0;
                    p3 = p[-step+1]>0?1:0;
                    p4 = p[1]>0?1:0;
                    p5 = p[step+1]>0?1:0;
                    p6 = p[step]>0?1:0;
                    p7 = p[step-1]>0?1:0;
                    p8 = p[-1]>0?1:0;
                    p9 = p[-step-1]>0?1:0;
                    
                    if((p2+p3+p4+p5+p6+p7+p8+p9)>1 && (p2+p3+p4+p5+p6+p7+p8+p9)<7  &&  A1==1)
                    {
                        if((p2==0||p4==0||p6==0)&&(p4==0||p6==0||p8==0)) //p2*p4*p6=0 && p4*p6*p8==0
                        {
                            dst.at<uchar>(i,j) = 0; //满足删除条件，设置当前像素为0
                            ifEnd = true;
                        }
                    }
                }
            }
        }
        
        dst.copyTo(tmpimg);
        img = tmpimg.data;
        for(i = 1; i < height; i++){
            img += step;
            for(j =1; j<width; j++){
                A1 = 0;
                uchar* p = img + j;
                if( p[0] > 0){
                    if(p[-step]==0&&p[-step+1]>0){  //p2,p3 01模式
                        A1++;
                    }
                    
                    if(p[-step+1]==0&&p[1]>0){   //p3,p4 01模式
                        A1++;
                    }
                    
                    if(p[1]==0&&p[step+1]>0){    //p4,p5 01模式
                        A1++;
                    }
                    
                    if(p[step+1]==0&&p[step]>0){     //p5,p6 01模式
                        A1++;
                    }
                    
                    if(p[step]==0&&p[step-1]>0){     //p6,p7 01模式
                        A1++;
                    }
                    
                    if(p[step-1]==0&&p[-1]>0){       //p7,p8 01模式
                        A1++;
                    }
                    
                    if(p[-1]==0&&p[-step-1]>0){     //p8,p9 01模式
                        A1++;
                    }
                    
                    if(p[-step-1]==0&&p[-step]>0){      //p9,p2 01模式
                        A1++;
                    }
                    
                    p2 = p[-step]>0?1:0;
                    p3 = p[-step+1]>0?1:0;
                    p4 = p[1]>0?1:0;
                    p5 = p[step+1]>0?1:0;
                    p6 = p[step]>0?1:0;
                    p7 = p[step-1]>0?1:0;
                    p8 = p[-1]>0?1:0;
                    p9 = p[-step-1]>0?1:0;
                    
                    if((p2+p3+p4+p5+p6+p7+p8+p9)>1 && (p2+p3+p4+p5+p6+p7+p8+p9)<7  &&  A1==1)
                    {
                        if((p2==0||p4==0||p8==0)&&(p2==0||p6==0||p8==0)) //p2*p4*p8=0 && p2*p6*p8==0
                        {
                            dst.at<uchar>(i,j) = 0; //满足删除条件，设置当前像素为0
                            ifEnd = true;
                        }
                    }
                }
            }
        }
        
        //如果两个子迭代已经没有可以细化的像素了，则退出迭代
        if(!ifEnd) break;
    }
}

/**
 *  端点的连通性检测
 *
 *  @param b 数组
 */
int func_nc8(int *b){
    int n_odd[4] = { 1, 3, 5, 7 };  //四邻域
    int i, j, sum, d[10];
    
    for (i = 0; i <= 9; i++) {
        j = i;
        if (i == 9) j = 1;
        if (abs(*(b + j)) == 1)
        {
            d[i] = 1;
        }
        else
        {
            d[i] = 0;
        }
    }
    sum = 0;
    for (i = 0; i < 4; i++)
    {
        j = n_odd[i];
        sum = sum + d[j] - d[j] * d[j + 1] * d[j + 2];
    }
    return (sum);
}

void hilditchThin(cv::Mat& src, cv::Mat& dst){
    if(src.type()!=CV_8UC1)
    {
        printf("只能处理二值或灰度图像\n");
        return;
    }
    
    //非原地操作时候，copy src到dst
    if(dst.data!=src.data)
    {
        src.copyTo(dst);
    }
    
    //8邻域的偏移量
    int offset[9][2] = {{0,0},{1,0},{1,-1},{0,-1},{-1,-1},
        {-1,0},{-1,1},{0,1},{1,1}};
    //四邻域的偏移量
    int n_odd[4] = { 1, 3, 5, 7 };
    int px, py;
    int b[9];                      //3*3格子的灰度信息
    int condition[6];              //1-6个条件是否满足
    int counter;                   //移去像素的数量
    int i, x, y, copy, sum;
    
    uchar* img;
    int width, height;
    width = dst.cols;
    height = dst.rows;
    img = dst.data;
    int step = dst.step ;
    do
    {
        
        counter = 0;
        
        for (y = 0; y < height; y++)
        {
            
            for (x = 0; x < width; x++)
            {
                
                //前面标记为删除的像素，我们置其相应邻域值为-1
                for (i = 0; i < 9; i++)
                {
                    b[i] = 0;
                    px = x + offset[i][0];
                    py = y + offset[i][1];
                    if (px >= 0 && px < width &&    py >= 0 && py <height)
                    {
                        // printf("%d\n", img[py*step+px]);
                        if (img[py*step+px] == WHITE)
                        {
                            b[i] = 1;
                        }
                        else if (img[py*step+px]  == GRAY)
                        {
                            b[i] = -1;
                        }
                    }
                }
                for (i = 0; i < 6; i++)
                {
                    condition[i] = 0;
                }
                
                //条件1，是前景点
                if (b[0] == 1) condition[0] = 1;
                
                //条件2，是边界点
                sum = 0;
                for (i = 0; i < 4; i++)
                {
                    sum = sum + 1 - abs(b[n_odd[i]]);
                }
                if (sum >= 1) condition[1] = 1;
                
                //条件3， 端点不能删除
                sum = 0;
                for (i = 1; i <= 8; i++)
                {
                    sum = sum + abs(b[i]);
                }
                if (sum >= 2) condition[2] = 1;
                
                //条件4， 孤立点不能删除
                sum = 0;
                for (i = 1; i <= 8; i++)
                {
                    if (b[i] == 1) sum++;
                }
                if (sum >= 1) condition[3] = 1;
                
                //条件5， 连通性检测
                if (func_nc8(b) == 1) condition[4] = 1;
                
                //条件6，宽度为2的骨架只能删除1边
                sum = 0;
                for (i = 1; i <= 8; i++)
                {
                    if (b[i] != -1)
                    {
                        sum++;
                    } else
                    {
                        copy = b[i];
                        b[i] = 0;
                        if (func_nc8(b) == 1) sum++;
                        b[i] = copy;
                    }
                }
                if (sum == 8) condition[5] = 1;
                
                if (condition[0] && condition[1] && condition[2] &&condition[3] && condition[4] && condition[5])
                {
                    img[y*step+x] = GRAY; //可以删除，置位GRAY，GRAY是删除标记，但该信息对后面像素的判断有用
                    counter++;
                    //printf("----------------------------------------------\n");
                    //PrintMat(dst);
                }
            }
        }
        
        if (counter != 0)
        {
            for (y = 0; y < height; y++)
            {
                for (x = 0; x < width; x++)
                {
                    if (img[y*step+x] == GRAY)
                        img[y*step+x] = BLACK;
                    
                }
            }
        }
        
    }while (counter != 0);
    
}

/**
 *  Rosenfeld细化算法
 */
void rosenfeldThin(cv::Mat& src, cv::Mat& dst){
    if(src.type()!=CV_8UC1){
        printf("只能处理二值或灰度图像\n");
        return;
    }
    
    //非原地操作时候，copy src到dst
    if(dst.data!=src.data)
    {
        src.copyTo(dst);
    }
    
    int i, j, n;
    int width = src.cols -1;    //之所以减1，是方便处理8邻域，防止越界
    int height = src.rows -1;
    int step = src.step;
    
    int  p2,p3,p4,p5,p6,p7,p8,p9;
    uchar *img;
    bool ifEnd;
    cv::Mat tmpimg;
    int dir[4] = {-step, step, 1, -1};
    
    while(1){
        //分四个子迭代过程，分别对应北，南，东，西四个边界点的情况
        ifEnd = false;
        for(n =0; n < 4; n++){
            dst.copyTo(tmpimg);
            img = tmpimg.data;
            for(i = 1; i < height; i++){
                img += step;
                for(j =1; j<width; j++){
                    uchar* p = img + j;
                    //如果p点是背景点或者且为方向边界点，依次为北南东西，继续循环
                    if(p[0]==0||p[dir[n]]>0) continue;
                    p2 = p[-step]>0?1:0;
                    p3 = p[-step+1]>0?1:0;
                    p4 = p[1]>0?1:0;
                    p5 = p[step+1]>0?1:0;
                    p6 = p[step]>0?1:0;
                    p7 = p[step-1]>0?1:0;
                    p8 = p[-1]>0?1:0;
                    p9 = p[-step-1]>0?1:0;
                    
                    //8 simple判定
                    int is8simple = 1;
                    if(p2==0&&p6==0){
                        if((p9==1||p8==1||p7==1)&&(p3==1||p4==1||p5==1))    is8simple = 0;
                    }
                    
                    if(p4==0&&p8==0){
                        if((p9==1||p2==1||p3==1)&&(p5==1||p6==1||p7==1))    is8simple = 0;
                    }
                    
                    if(p8==0&&p2==0){
                        if(p9==1&&(p3==1||p4==1||p5==1||p6==1||p7==1))  is8simple = 0;
                    }
                    
                    if(p4==0&&p2==0){
                        if(p3==1&&(p5==1||p6==1||p7==1||p8==1||p9==1))  is8simple = 0;
                    }
                    
                    if(p8==0&&p6==0){
                        if(p7==1&&(p3==9||p2==1||p3==1||p4==1||p5==1))  is8simple = 0;
                    }
                    
                    if(p4==0&&p6==0){
                        if(p5==1&&(p7==1||p8==1||p9==1||p2==1||p3==1))  is8simple = 0;
                    }
                    
                    int adjsum;
                    adjsum = p2 + p3 + p4+ p5 + p6 + p7 + p8 + p9;
                    
                    //判断是否是邻接点或孤立点,0,1分别对于那个孤立点和端点
                    if(adjsum!=1&&adjsum!=0&&is8simple==1){
                        dst.at<uchar>(i,j) = 0; //满足删除条件，设置当前像素为0
                        ifEnd = true;
                    }
                }
            }
        }
        
        if(!ifEnd) break;   //已经没有可以细化的像素了，则退出迭代
    }
}

/**
 *  通过形态学腐蚀和开操作得到骨架
 */
void morphThin(cv::Mat& src, cv::Mat& dst)
{
    
    
    if(src.type()!=CV_8UC1)
    {
        printf("只能处理二值或灰度图像\n");
        return;
    }
    //非原地操作时候，copy src到dst
    if(dst.data!=src.data)
    {
        src.copyTo(dst);
    }
    
    cv::Mat skel(dst.size(), CV_8UC1, cv::Scalar(0));
    cv::Mat temp(dst.size(), CV_8UC1);
    
    cv::Mat element = cv::getStructuringElement(cv::MORPH_CROSS, cv::Size(3, 3));
    bool done;
    do
    {
        cv::morphologyEx(dst, temp, cv::MORPH_OPEN, element);
        cv::bitwise_not(temp, temp);
        cv::bitwise_and(dst, temp, temp);
        cv::bitwise_or(skel, temp, skel);
        cv::erode(dst, dst, element);
        
        double max;
        cv::minMaxLoc(dst, 0, &max);
        done = (max == 0);
    } while (!done);
    
    dst = skel;
    
}
/*
 *  常用的迭代算法包括：Hilditch、Pavlidis、Rosenfeld细化算法以及基于索引表查询的细化算法等等。
 *  Hilditch算法使用于二值图像，该算法是并行串行结合的算法。
 *  Pavlidis算法通过并行和串行混合处理来实现，用位运算进行特定模式的匹配，所得的骨架是8连接的，用于0－1二值图像。
 *  Rosenfeld算法是一种并行细化算法，所得的骨架形态是8－连接的，使用于0－1二值图像。
 */