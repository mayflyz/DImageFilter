//
//  GLVMenuView.m
//  DImageFilter
//
//  Created by tony on 7/9/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLVMenuView.h"

#import "UIView+Frame.h"
#import "ASValueTrackingSlider.h"
#import "GLMenuItem.h"
#import "Macro.h"

@interface GLVMenuView ()<ASValueTrackingSliderDelegate, GLMenuItemDelegate>{
    int sliderValue;
    int bottomPosition;
}

@property (nonatomic, strong) ASValueTrackingSlider *slider;

@property (nonatomic, strong) UIScrollView *menuScrollView;

@property (nonatomic, strong) NSArray *itemArr;
@property (nonatomic, strong) id selectItem;

@end

@implementation GLVMenuView

- (instancetype)initWithFrame:(CGRect)frame withMenuItem:(NSArray *)menuArr{
    if (self = [super initWithFrame:frame]) {
        [self contentViewInit];
        [self contentInitWithMenuArr:menuArr];
    }
    
    return self;
}

const int menuVWidth = 100;

- (void)contentViewInit{
    sliderValue = 0;
    
    self.backgroundColor = [UIColor whiteColor];
    self.slider = [[ASValueTrackingSlider alloc] initWithFrame:CGRectMake(Padding20, Padding10, ScreenWidth - 2*Padding20, 20)];
    self.slider.maximumValue = 100;
    [self.slider setMaxFractionDigitsDisplayed:0];
    self.slider.delegate = self;
    self.slider.font = [UIFont fontWithName:@"GillSans-Bold" size:22];
    self.slider.popUpViewAnimatedColors = @[[UIColor purpleColor], [UIColor redColor], [UIColor orangeColor]];
    [self addSubview:self.slider];
    
    bottomPosition = self.bottom;
    self.menuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 60, ScreenWidth, 60)];
    [self addSubview:self.menuScrollView];
}

- (void)contentInitWithMenuArr:(NSArray *)arr{
    if (arr.count <= 0) {
        return;
    }
    
    self.itemArr = arr;
    for (UIView *subView in self.menuScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    for (int i=0; i< arr.count; i++) {
        NSDictionary *itemDic = [arr objectAtIndex:i];
        NSString *imgName = [itemDic objectForKey:@"image"];
        NSString *titleStr = [itemDic objectForKey:@"title"];
        UIImage *menuImg = [UIImage imageNamed:(imgName.length > 0 ? imgName : @"icon_menu")];
        GLMenuItem *item = [[GLMenuItem alloc] initWithFrame:CGRectMake(i*menuVWidth, 0, menuVWidth, CGRectGetHeight(self.menuScrollView.bounds)) withImage:menuImg title:titleStr];
        item.itemInfo = itemDic;
        item.delegate = self;
        [self.menuScrollView addSubview:item];
    }
    
    self.menuScrollView.contentSize = CGSizeMake(menuVWidth * arr.count, CGRectGetHeight(self.menuScrollView.bounds));
    self.menuScrollView.contentOffset = CGPointZero;
    
}

- (void)itemSelectAtIndex:(NSInteger)index{
    if (index < 0 || (index > self.itemArr.count - 1)) {
        index = 0;
    }
    self.selectItem = [self.itemArr objectAtIndex:index];
    [self menuItemSelect:self.selectItem];
}

#pragma mark -- GLMenuItemDelegate
- (void)menuItemSelect:(id)itemInfo{
    for (UIView *view in self.menuScrollView.subviews) {
        if ([view isKindOfClass:[GLMenuItem class]]) {
            GLMenuItem *item = (GLMenuItem *)view;
            if (item.itemInfo == itemInfo) {
                item.selected = true;
            }else{
                item.selected = false;
            }
        }
    }
    self.selectItem = itemInfo;
    sliderValue = ((sliderValue != 0) ? sliderValue : 0);
    
    self.slider.value = 3;
    if ([itemInfo objectForKey:@"showSlider"]) {
        [self refreshViewWithShowSlider:FALSE];
    }else{
        [self refreshViewWithShowSlider:TRUE];
    }
    
    [self updateItemInfo:itemInfo sliderValue:sliderValue];
    
}

- (void)refreshViewWithShowSlider:(BOOL)flag{
    if (flag) {
        self.slider.hidden = FALSE;
        
        self.frame = CGRectMake(self.left, bottomPosition - 100, self.width, 100);
        self.menuScrollView.top = CGRectGetHeight(self.bounds) - 60;
    }else{
        self.slider.hidden = TRUE;
        
        self.frame = CGRectMake(self.left, bottomPosition - (Padding10 + 60) , self.width, Padding10 + 60);
        self.menuScrollView.top = Padding10;
    }
}

#pragma mark ---
- (void)sliderWillDisplayPopUpView:(ASValueTrackingSlider *)slider{
    NSLog(@"sliderWillDisplayPopUpView");
}

- (void)sliderDidHidePopUpView:(ASValueTrackingSlider *)slider{
    sliderValue = [@(slider.value) intValue];
    if (self.selectItem) {
        [self updateItemInfo:self.selectItem sliderValue:sliderValue];
    }
}

#pragma mark -- update Item Info
- (void)updateItemInfo:(id)itemInfo sliderValue:(NSInteger)value{
    if (self.delegate && [self.delegate respondsToSelector:@selector(itemInfoChange:sliderValue:)]) {
        [self.delegate itemInfoChange:itemInfo sliderValue:value];
    }
}
@end
