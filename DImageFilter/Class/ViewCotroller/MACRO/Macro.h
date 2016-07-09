//
//  Macro.h
//  DImageFilter
//
//  Created by tony on 6/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define Padding10   10
#define Padding20   20
#define padding30   30


typedef NS_ENUM(NSInteger, OperateType) {
    GrayFilter = 1001,  //灰度化
    GrayHist = 1002,    //灰度直方图
    GrayEqual = 1003,   //灰度均衡化
    GrayHistEqual = 1004,   //直方图均衡化
    Gray = 1002,    //灰度直方图
    BinaryMaxEntropy = 2001,   //最大熵阈值
    BinaryGlobal = 2002,   //全局阈值
    BinaryDetech = 2003,   //迭代法
    BinaryOTSU = 2004,   //迭代法
    BinaryCustom = 2005,   //自定义阈值
    BinMorphologyErosion = 2101,    //二值腐蚀
    BinMorphologyDilate = 2102,     //二值膨胀
    BinMorphologyOpen = 2103,       //二值开操作
    BinMorphologyClose = 2104,      //二值闭操作
    MorphologyErosion = 3001,  //腐蚀
    MorphologyDilate = 3002,   //膨胀
    MorphologyOpen = 3003, //开操作
    MorphologyClose = 3004,//闭操作
    MorphologyGradient = 3005,//梯度
    MorphologyTopHat = 3006,//顶帽
    MorphologyBlackHat = 3007,//黑帽
    EdgeSobel = 4001,
    EdgeCanny = 4002,
    EdgeLaplace = 4003,
    EdgeScharr = 4004,
    EdgeRoberts = 4005,
    EdgePrewitt = 4006,
    SmoothBoxBlur = 5001,   //方框滤波
    SmoothBlur = 5002,  //均值滤波
    SmoothGussianBlur = 5003,  //高斯滤波
    SmoothMedianBlur = 5004,   //中值滤波
    SmoothBilatelBlur = 5005,  //双边滤波
    SkeletonDistanceTransform = 6001,  //
    SkeletonHilditch = 6002,
    SkeletonRosenfeld = 6003,
    SkeletonMorph = 6004,
};

#endif /* Macro_h */
