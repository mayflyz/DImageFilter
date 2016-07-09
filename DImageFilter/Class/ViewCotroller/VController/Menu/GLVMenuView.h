//
//  GLVMenuView.h
//  VDataProcess
//
//  Created by tony on 7/6/16.
//  Copyright © 2016 V. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLVMenuViewDelegate <NSObject>

- (void)itemInfoChange:(id)itemInfo sliderValue:(NSInteger)value;

@end


@interface GLVMenuView : UIView

@property (nonatomic, assign) id<GLVMenuViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame withMenuItem:(NSArray *)menuArr;

- (void)itemSelectAtIndex:(NSInteger)index;
@end
