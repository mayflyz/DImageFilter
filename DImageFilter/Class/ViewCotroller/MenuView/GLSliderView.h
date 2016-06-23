//
//  GLSliderView.h
//  DImageFilter
//
//  Created by tony on 6/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CXSlider.h"

@interface GLSliderView : UIView

@property (nonatomic, strong) NSString *titleStr;

@property (nonatomic, strong) CXSlider *sliderView;
@property (nonatomic, assign) NSInteger minvalue;
@property (nonatomic, assign) NSInteger maxValue;

@property (nonatomic, assign) id<CXSliderDelegate>  delegate;

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title;

@end
