//
//  GLMenuView.h
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GLMenuItem.h"

/**
 *  该自定义控件给出通用的简单菜单处理，菜单的样式如下：
 *  ******   ******   ******   ******
 *  *    *   *    *   *    *   *    *
 *  *文字 *   * 文字*  *    *   *    *
 *  ******   ******   ******   ******
 *   文字       文字      文字     文字
 *  {"title":, "subMenu":{"title":,"imageName":,@"operateType":}}
 */


@interface GLMenuView : UIView
/**
 *  数组中放置字典，字典中的存放主菜单名，及子菜单数组，子菜单数组包含用到的图片，名字以及对应操作的code码，此作为处理的标识
 */
@property (nonatomic, strong) NSMutableArray *menuArr;

@property (nonatomic, assign) id<GLMenuItemDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame menuArr:(NSMutableArray *)menuArr;

- (void)itemSelectAtIndex:(NSInteger)index;
@end
