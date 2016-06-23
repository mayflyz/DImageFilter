//
//  GLSliderView.m
//  DImageFilter
//
//  Created by tony on 6/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLSliderView.h"

#import "Macro.h"

@interface GLSliderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GLSliderView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self contentViewInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        _titleStr = title;
        [self contentViewInit];
    }
    return self;
}

- (void)setMinvalue:(NSInteger)minvalue{
    _minvalue = minvalue;
    
    [self setSliderLimit];
}

- (void)setMaxValue:(NSInteger)maxValue{
    _maxValue = maxValue;
    [self setSliderLimit];
}

- (void)setTitleStr:(NSString *)titleStr{
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setDelegate:(id<CXSliderDelegate>)delegate{
    _delegate = delegate;
    self.sliderView.delegate = _delegate;
}

- (void)setSliderLimit{
    [self.sliderView setMinimumValue:self.minvalue maximumValue:self.maxValue];
}

- (void)contentViewInit{
    _minvalue = 0;
    _maxValue = 20;
    [self addSubview:self.titleLabel];
    [self addSubview:self.sliderView];
}


- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Padding10, Padding10, CGRectGetWidth(self.bounds) - 2*Padding10, 30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.textColor = [UIColor lightGrayColor];
        
    }
    return _titleLabel;
}

- (CXSlider *)sliderView{
    if (_sliderView == nil) {
        _sliderView = [[CXSlider alloc] initWithFrame:CGRectMake(Padding10, Padding10*2 + 30, CGRectGetWidth(self.bounds) - 2*Padding10, 20)];
        [_sliderView setValueWithValue:1];
    }
    return _sliderView;
}
@end
