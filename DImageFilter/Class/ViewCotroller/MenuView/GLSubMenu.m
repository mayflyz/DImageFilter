//
//  GLSubMenu.m
//  DImageFilter
//
//  Created by tony on 7/4/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLSubMenu.h"

#import "HUMSlider.h"
#import "MenuHrizontal.h"

@interface GLSubMenu ()

@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) HUMSlider *slider;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic, strong) MenuHrizontal *menuHrizontal;


@end

@implementation GLSubMenu

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)contentInitWithProgress:(BOOL)isHas{
    
}

@end
