//
//  GLMeunItem.m
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMenuItem.h"

@interface GLMenuItem ()

@property (nonatomic, strong) UIImageView *menuImgView;
@property (nonatomic, strong) UILabel *subLineInfo;

@end

@implementation GLMenuItem

- (instancetype)init{
    if (self = [super init]) {
        [self addGestureEvent];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image title:(NSString *)title{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.menuImgView];
        [self addSubview:self.subLineInfo];
        
        [self setMenuImage:image];
        [self setTitleInfo:title];
        [self addGestureEvent];
    }
    
    return self;
}

#pragma mark --
- (void)addGestureEvent{
    _selected = FALSE;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizerHandler:)];
    [self addGestureRecognizer:recognizer];
}

- (void)setMenuImage:(UIImage *)image{
    self.menuImgView.image = image;
}

- (void)setTitleInfo:(NSString *)title{
    self.subLineInfo.text = title;
}

- (void)setSelected:(BOOL)selected{
    _selected = selected;
    
    if (selected) {
        self.subLineInfo.textColor = [UIColor blackColor];
    }else{
        self.subLineInfo.textColor = [UIColor orangeColor];
    }
}

- (void)tapRecognizerHandler:(UIGestureRecognizer *)recognizer{
    if (self.delegate && [self.delegate respondsToSelector:@selector(menuItemSelect:)]) {
        [self.delegate menuItemSelect:self.itemInfo];
    }
}

#pragma mark -- control init
- (UIImageView *)menuImgView{
    if (_menuImgView == nil) {
        _menuImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 21)];
    }
    
    return _menuImgView;
}

- (UILabel *)subLineInfo{
    if (_subLineInfo == nil) {
        _subLineInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 21, CGRectGetWidth(self.bounds), 21)];
        _subLineInfo.textAlignment = NSTextAlignmentCenter;
        _subLineInfo.font = [UIFont systemFontOfSize:12.f];
        _subLineInfo.backgroundColor = [UIColor clearColor];
        _subLineInfo.textColor = [UIColor blackColor];
    }
    
    return _subLineInfo;
}

@end
