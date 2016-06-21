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

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

typedef NS_ENUM(NSInteger, OperateType) {
    GrayFilter = 1001,
    BinaryMaxEntropy = 2001,   //最大熵阈值
    BinaryGlobal = 2002,   //全局阈值
    BinaryDetech = 2003,   //迭代法
    BinaryOTSU = 2004,   //迭代法
    BinaryCustom = 2005,   //自定义阈值
    MorphologyErosion = 3001,  //腐蚀
    MorphologyDilate = 3002,   //膨胀
    MorphologyOpen = 3003, //开操作
    MorphologyClose = 3004,//闭操作
    MorphologyGradient = 3005,//梯度
    MorphologyTopHat = 3006,//顶帽
    MorphologyBlackHat = 3007,//黑帽
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
    self.title = @"图片处理";
    self.headerView.hidden = TRUE;
   
    _menuView = [[GLMenuView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, ScreenWidth, 100) menuArr:[self menuDataSourceInit]];
    _menuView.delegate = self;
    [self.view addSubview:self.menuView];
    
    _filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - self.menuView.height)];
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
        [self imageFilterWithType:operateType];
    }
}

- (void)imageFilterWithType:(NSInteger)type{
    
    NSString *typeStr = [@(type) stringValue];
    if ([typeStr hasPrefix:@"200"]) {
        [self binaryOperate:type];
        return;
    }
    
    if ([typeStr hasPrefix:@"300"]) {
        [self morphologyOperate:type];
        return;
    }
    
    UIImage *dstImage;
    switch (type) {
        case GrayFilter:
        {
            dstImage = [self.originImg grayImage];
        }
        default:
            break;
    }
    
    self.filterImageView.image = dstImage;
}

- (void)binaryOperate:(NSInteger)type{
    UIImage *dstImage;
    switch (type) {
        case GrayFilter:
        {
            dstImage = [self.originImg grayImage];
        }
            break;
        case BinaryDetech:
            dstImage = [self.originImg binaryzationWithWithDetech];
            break;
        case BinaryOTSU:
            dstImage = [self.originImg binaryzation];
            break;
        case BinaryMaxEntropy:
            dstImage = [self.originImg binaryzationWithMaxEntropy];
            break;
        case BinaryGlobal:
            dstImage = [self.originImg binaryzationWithWithGlobalThrehold];
            break;
            
        default:
            break;
    }
    
    self.filterImageView.image = dstImage;
}

- (void)morphologyOperate:(NSInteger)type{
    UIImage *dstImage;
    switch (type) {
        case MorphologyErosion:
        {
            dstImage = [self.originImg erosionType:1 size:1];
        }
            break;
        case MorphologyDilate:
            dstImage = [self.originImg dilateOperation];
            break;
        case MorphologyOpen:
        case MorphologyClose:
        case MorphologyGradient:
        case MorphologyTopHat:
        case MorphologyBlackHat:
            {
                int operate = type%10 - 3;
                dstImage = [self.originImg morphologyWithOperation:operate elementSize:1];
            }
            break;
            
        default:
            break;
    }
    
    self.filterImageView.image = dstImage;
}

- (NSMutableArray *)menuDataSourceInit{
    NSDictionary *greyMenu =  @{@"title" : @"灰度化",
                                @"subMenu" : @[
                                        @{@"title" : @"分量法R",@"imageName":@"",@"operateType":@(GrayFilter)}
                                        ]};
    NSDictionary *binMenu = @{@"title" : @"二值化",
                              @"subMenu" :@[
                                      @{@"title" : @"迭代法",@"imageName":@"",@"operateType":@(BinaryDetech)},
                                      @{@"title" : @"OTSU法",@"imageName":@"",@"operateType":@(BinaryOTSU)},
                                      @{@"title" : @"熵阈值",@"imageName":@"",@"operateType":@(BinaryMaxEntropy)},
                                      @{@"title" : @"全局阈值",@"imageName":@"",@"operateType":@(BinaryGlobal)},
                                      @{@"title" : @"自定义阈值",@"imageName":@"",@"operateType":@(BinaryCustom)}
                                      ]};
    NSDictionary *morphologyMenu = @{@"title" : @"形态学",
                                     @"subMenu" :@[
                                             @{@"title" : @"腐蚀",@"imageName":@"",@"operateType":@(MorphologyErosion)},
                                             @{@"title" : @"膨胀",@"imageName":@"",@"operateType":@(MorphologyDilate)},
                                             @{@"title" : @"开运算",@"imageName":@"",@"operateType":@(MorphologyOpen)},
                                             @{@"title" : @"闭运算",@"imageName":@"",@"operateType":@(MorphologyClose)},
                                             @{@"title" : @"形态学梯度",@"imageName":@"",@"operateType":@(MorphologyGradient)},
                                             @{@"title" : @"顶帽",@"imageName":@"",@"operateType":@(MorphologyTopHat)},
                                             @{@"title" : @"黑帽",@"imageName":@"",@"operateType":@(MorphologyBlackHat)}
                                             ]};
    
    NSMutableArray *menuArr = [@[greyMenu, binMenu, morphologyMenu] mutableCopy];
    
    return menuArr;
}

@end
