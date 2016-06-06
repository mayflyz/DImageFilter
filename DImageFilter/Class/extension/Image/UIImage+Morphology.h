//
//  UIImage+Morphology.h
//  DImageFilter
//
//  Created by tony on 6/5/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Morphology)

#pragma mark --- Erosion Operation Begin
/**
 *  默认腐蚀操作，算子为3，类型为MORPH_CROSS
 */
- (UIImage *)erosionOperation;

/**
 *  图像腐蚀
 *
 *  @param type  腐蚀类型，0..2，0表示RECT, 1表示CROSS, 2表示MORPH_ELLIPSE
 *  @param value 内核算子大小，中心点为算子大小，职位期望算子的一半
 */
- (UIImage *)erosionType:(int)type size:(int)value;

#pragma mark --- Dilate Operation Begin
/**
 *  膨胀
 *
 */
- (UIImage *)dilateOperation;

/**
 *  膨胀
 *
 *  @param type  腐蚀类型，0..2，0表示RECT, 1表示CROSS, 2表示MORPH_ELLIPSE
 *  @param value 内核算子
 */
- (UIImage *)dilationWithType:(int)type size:(int)value;


#pragma mark -- Opening, Closing, Morphological Gradient,  Top Hat, Black Hat
/**
 *  图像形态学操作，开运算，闭运算，形态学梯度，顶帽操作，黑猫操作
 *
 *  @param operation 使用0...4表示这些操作，0——开，1——闭，2——梯度，3——顶帽，4——黑帽
 *  @param size      内核算子， 算子强度为(value*2+1)
 */
- (UIImage *)morphologyWithOperation:(int)operation elementSize:(int)size;

/**
 *  图像形态学操作，开运算，闭运算，形态学梯度，顶帽操作，黑猫操作
 *
 *  @param operation 使用0...4表示这些操作，0——开，1——闭，2——梯度，3——顶帽，4——黑帽
 *  @param type      腐蚀类型，0..2，0表示RECT, 1表示CROSS, 2表示MORPH_ELLIPSE
 *  @param value     内核算子， 算子强度为(value*2+1)
 */
- (UIImage *)morphologyWithOperation:(int)operation elementType:(int)type size:(int)value;

@end
