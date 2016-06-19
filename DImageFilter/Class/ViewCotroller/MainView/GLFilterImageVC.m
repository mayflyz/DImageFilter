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

@interface GLFilterImageVC ()

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (nonatomic, strong) UIImageView *filterImageView;

@property (nonatomic, strong) GLMenuView *menuView;

@end

@implementation GLFilterImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    {"title":, "subMenu":{"title":,"imageName":,@"operateType":}}
    
    _menuView = [[GLMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.bounds), CGRectGetWidth(self.view.bounds), 70) menuArr:[self menuDataSourceInit]];
    [self.view addSubview:self.menuView];
    
    _filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.headerView.bottom, self.view.width, self.view.height - self.headerView.height - self.menuView.height)];
    _filterImageView.image = self.originImg;
    [self.view addSubview:_filterImageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)menuDataSourceInit{
    NSDictionary *greyMenu =  @{@"title" : @"灰度化",
                                @"subMenu" : @[
                                        @{@"title" : @"分量法R",@"imageName":@"",@"operateType":@(1)},
                                        @{@"title" : @"分量法G",@"imageName":@"",@"operateType":@(1)},
                                        @{@"title" : @"分量法B",@"imageName":@"",@"operateType":@(1)},
                                        @{@"title" : @"最大值法",@"imageName":@"",@"operateType":@(1)},
                                        @{@"title" : @"平均值法",@"imageName":@"",@"operateType":@(1)},
                                        @{@"title" : @"加权平均法",@"imageName":@"",@"operateType":@(1)}
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
