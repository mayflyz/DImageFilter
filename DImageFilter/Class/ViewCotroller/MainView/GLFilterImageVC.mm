//
//  GLFilterImageVC.m
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLFilterImageVC.h"

#import "UIView+Frame.h"

#import "GLMenuView.h"
#import "UIImage+OpenCV.h"

typedef NS_ENUM(NSInteger, OperateType) {
    GraySplitR = 10001,
    GraySplitG = 10002,
    GraySplitB = 10003,
    GrayMaxValue = 10004,
    GrayAVG = 10005,    //平均值法
    GrayWeightAVG = 10006,    //加权平均值法
    Binary,
};

@interface GLFilterImageVC ()<GLMenuItemDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) UIImageView *filterImageView;

@property (nonatomic, strong) GLMenuView *menuView;

@end

@implementation GLFilterImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    {"title":, "subMenu":{"title":,"imageName":,@"operateType":}}
    
    _menuView = [[GLMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds) - 100, CGRectGetWidth(self.view.bounds), 100) menuArr:[self menuDataSourceInit]];
    _menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    _filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.height - self.menuView.height)];
    _filterImageView.image = self.originImg;
    [self.view addSubview:_filterImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---GLMenuItemDelegate
- (void)menuItemSelect:(id)menuInfo{
    if ([menuInfo isKindOfClass:[NSDictionary class]]) {
        NSDictionary *value = (NSDictionary *)menuInfo;
        NSInteger operateType = [[value objectForKey:@"operateType"] integerValue];
        UIImage *dstImage;
        switch (operateType) {
            case GraySplitR:
            case GraySplitG:
            case GraySplitB:
            case GrayMaxValue:
            case GrayAVG:
            case GrayWeightAVG:
            {
                int type = (operateType%10 - 1);
                dstImage = [self.originImg grayImageWithType:type];
            }
                break;
            default:
                break;
        }
        
        self.filterImageView.image = dstImage;
    }
}

- (NSMutableArray *)menuDataSourceInit{
    NSDictionary *greyMenu =  @{@"title" : @"灰度化",
                                @"subMenu" : @[
                                        @{@"title" : @"分量法R",@"imageName":@"",@"operateType":@(GraySplitR)},
                                        @{@"title" : @"分量法G",@"imageName":@"",@"operateType":@(GraySplitG)},
                                        @{@"title" : @"分量法B",@"imageName":@"",@"operateType":@(GraySplitB)},
                                        @{@"title" : @"最大值法",@"imageName":@"",@"operateType":@(GrayMaxValue)},
                                        @{@"title" : @"平均值法",@"imageName":@"",@"operateType":@(GrayAVG)},
                                        @{@"title" : @"加权平均法",@"imageName":@"",@"operateType":@(GrayWeightAVG)}
                                        ]};
    NSDictionary *binMenu = @{@"title" : @"二值化",
                              @"subMenu" :@[
                                      @{@"title" : @"迭代法",@"imageName":@"",@"operateType":@(1)},
                                      @{@"title" : @"OTSU法",@"imageName":@"",@"operateType":@(1)},
                                      @{@"title" : @"熵阈值",@"imageName":@"",@"operateType":@(1)},
                                      @{@"title" : @"全局阈值",@"imageName":@"",@"operateType":@(1)}
                                      ]};
    
    NSMutableArray *menuArr = [@[greyMenu, binMenu] mutableCopy];
    
    return menuArr;
}

@end
