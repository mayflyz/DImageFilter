//
//  GLVMainDealVC.m
//  DImageFilter
//
//  Created by tony on 6/27/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLVMainDealVC.h"
#import "Macro.h"

#import "MenuHrizontal.h"
#import "GLVMenuView.h"
#import "UIImage+OpenCV.h"

@interface GLVMainDealVC ()<MenuHrizontalDelegate, GLVMenuViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) MenuHrizontal *menuView;
@property (nonatomic, strong) GLVMenuView *subMenuView;

@end

@implementation GLVMainDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = TRUE;
    [self menuInfoInit];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 2*Padding20, ScreenWidth - 2*Padding20)];
    self.imageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    [self.view addSubview:self.imageView];
    self.imageView.image = self.srcImg;
    
    self.bottomView.hidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuInfoInit{
    NSArray *menuValue = @[@{@"title" : @"灰度化", @"image" : @""},
                           @{@"title" : @"二值化", @"image" : @""},
                           @{@"title" : @"形态学", @"image" : @""},
                           @{@"title" : @"滤波", @"image" : @""},
                           @{@"title" : @"骨架", @"image" : @""}];
    NSMutableArray *menuArr = [NSMutableArray new];
    for (int i = 0; i < menuValue.count; i++) {
        NSDictionary *menuDic = [menuValue objectAtIndex:i];
        
        NSDictionary *item = @{NOMALKEY : @"normal",
                               HEIGHTKEY : @"helight",
                               TITLEKEY : [menuDic objectForKey:@"title"],
                               TITLEWIDTH : @(100)};
        [menuArr addObject:item];
    }
    
    self.menuView = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, ScreenHeight - 30, ScreenWidth, 30) ButtonItems:menuArr];
    self.menuView.delegate = self;
    [self.view addSubview:self.menuView];
}

#pragma mark --MenuHrizontalDelegate
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    switch (aIndex) {
        case 0:
            [self showGrayMenu];
            break;
        case 1:
            [self showBinaryMenu];
            break;
        case 2:
            [self showMorphologyMenu];
            break;
        case 3:
            [self showEdgeMenu];
            break;
        case 4:
            [self showSmoothingMenu];
            break;
        case 5:
            [self showSkeletonMenu];
            break;
        default:
            break;
    }
}
#pragma mark -- 菜单选择
- (void)showGrayMenu{
    NSArray *grayMenu = @[@{@"title" : @"灰度图", @"image" : @"icon_cat_07", @"operateType":@(GrayFilter), @"showSlider" : @"0"},
                          @{@"title" : @"直方图", @"image" : @"icon_cat_08", @"operateType":@(GrayHist), @"showSlider" : @"0"},
                          @{@"title" : @"均衡化", @"image" : @"icon_cat_09", @"operateType":@(GrayEqual), @"showSlider" : @"0"},
                          @{@"title" : @"直方图均衡化", @"image" : @"icon_cat_10", @"operateType":@(GrayHistEqual), @"showSlider" : @"0"}
                          ];
    [self showMenuViewWithArr:grayMenu];
}

- (void)showBinaryMenu{
    NSArray *binMenu = @[@{@"title" : @"迭代法", @"image" : @"icon_cat_01", @"operateType":@(BinaryDetech), @"showSlider" : @"0"},
                         @{@"title" : @"OTSU法", @"image" : @"icon_cat_02", @"operateType":@(BinaryOTSU), @"showSlider" : @"0"},
                         @{@"title" : @"熵阈值", @"image" : @"icon_cat_03", @"operateType":@(BinaryMaxEntropy), @"showSlider" : @"0"},
                         @{@"title" : @"全局阈值", @"image" : @"icon_cat_04", @"operateType":@(BinaryGlobal), @"showSlider" : @"0"},
                         @{@"title" : @"自定义阈值", @"image" : @"icon_cat_05", @"operateType":@(BinaryCustom)}
                         ];
    [self showMenuViewWithArr:binMenu];
}

/**
 *  形态学菜单
 */
- (void)showMorphologyMenu{
    NSArray *morphology = @[@{@"title" : @"腐蚀", @"image" : @"icon_cat_11", @"operateType":@(MorphologyErosion)},
                            @{@"title" : @"膨胀", @"image" : @"icon_cat_12", @"operateType":@(MorphologyDilate)},
                            @{@"title" : @"开运算", @"image" : @"icon_cat_13", @"operateType":@(MorphologyOpen)},
                            @{@"title" : @"闭运算", @"image" : @"icon_cat_14", @"operateType":@(MorphologyClose)},
                            @{@"title" : @"形态学梯度", @"image" : @"icon_cat_15", @"operateType":@(MorphologyGradient)},
                            @{@"title" : @"顶帽", @"image" : @"icon_cat_16", @"operateType":@(MorphologyTopHat)},
                            @{@"title" : @"黑帽", @"image" : @"icon_cat_17", @"operateType":@(MorphologyBlackHat)}
                            ];
    [self showMenuViewWithArr:morphology];
}

/**
 *  边缘检测菜单
 */
- (void)showEdgeMenu{
    NSArray *edgeMenu = @[@{@"title" : @"sobel算子", @"image" : @"icon_cat_18", @"operateType":@(EdgeSobel)},
                          @{@"title" : @"canny算子", @"image" : @"icon_cat_19", @"operateType":@(EdgeCanny)},
                          @{@"title" : @"Laplace算子", @"image" : @"icon_cat_01", @"operateType":@(EdgeLaplace)},
                          @{@"title" : @"scharr算子", @"image" : @"icon_cat_02", @"operateType":@(EdgeScharr)},
                          @{@"title" : @"Roberts算子", @"image" : @"icon_cat_03", @"operateType":@(EdgeRoberts)},
                          @{@"title" : @"Prewitt算子", @"image" : @"icon_cat_04", @"operateType":@(EdgePrewitt)}
                          ];
    
    [self showMenuViewWithArr:edgeMenu];
}

/**
 *  滤波菜单
 */
- (void)showSmoothingMenu{
    NSArray *smoothingMenu = @[@{@"title" : @"方框滤波", @"image" : @"icon_cat_05", @"operateType":@(SmoothBoxBlur)},
                               @{@"title" : @"均值滤波", @"image" : @"icon_cat_06", @"operateType":@(SmoothBlur)},
                               @{@"title" : @"高斯滤波", @"image" : @"icon_cat_07", @"operateType":@(SmoothGussianBlur)},
                               @{@"title" : @"中值滤波", @"image" : @"icon_cat_08", @"operateType":@(SmoothMedianBlur)},
                               @{@"title" : @"双边滤波", @"image" : @"icon_cat_09", @"operateType":@(SmoothBilatelBlur)}
                               ];
    [self showMenuViewWithArr:smoothingMenu];
}

/**
 *  骨架菜单
 */
- (void)showSkeletonMenu{
    NSArray *sketetonMenu = @[@{@"title" : @"距离转换", @"image" : @"icon_cat_10", @"operateType":@(SkeletonDistanceTransform), @"showSlider" : @"0"},
                              @{@"title" : @"hilditch细化", @"image" : @"icon_cat_11", @"operateType":@(SkeletonHilditch), @"showSlider" : @"0"},
                              @{@"title" : @"Rosenfeld细化", @"image" : @"icon_cat_12", @"operateType":@(SkeletonRosenfeld), @"showSlider" : @"0"},
                              @{@"title" : @"形态学骨架", @"image" : @"icon_cat_13", @"operateType":@(SkeletonMorph), @"showSlider" : @"0"}
                              ];
    [self showMenuViewWithArr:sketetonMenu];
}


- (void)showMenuViewWithArr:(NSArray *)menuArr{
    if (self.subMenuView) {
        [self.subMenuView removeFromSuperview];
    }
    
    self.subMenuView = [[GLVMenuView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 130, ScreenWidth, 100) withMenuItem:menuArr];
    self.subMenuView.delegate = self;
    [self.view addSubview:self.subMenuView];
    [self.subMenuView itemSelectAtIndex:0];
}


#pragma mark - GLMenuViewDelegate
- (void)itemInfoChange:(id)itemInfo sliderValue:(NSInteger)value{
    NSString *typeStr = [[itemInfo objectForKey:@"operateType"] stringValue];
    NSLog(@"itemInfo %@, value: %@", itemInfo, @(value));
    
    if ([typeStr hasPrefix:@"100"]) {
        [self grayWithType:[typeStr integerValue]];
    }else if ([typeStr hasPrefix:@"200"]){
        [self binaryWithType:[typeStr integerValue] sliderValue:value];
    }else if ([typeStr hasPrefix:@"300"]){
        [self morphologyWithType:[typeStr integerValue] sliderValue:value];
    }else if ([typeStr hasPrefix:@"400"]){
        [self edgeWithType:[typeStr integerValue] sliderValue:value];
    }else if ([typeStr hasPrefix:@"500"]){
        [self smoothingType:[typeStr integerValue] sliderValue:value];
    }else if ([typeStr hasPrefix:@"600"]){
        [self skeletonType:[typeStr integerValue] sliderValue:value];
    }
}

/**
 *  灰度处理图像
 */
- (void)grayWithType:(NSInteger)type{
    switch (type) {
        case GrayFilter:
        {
            self.imageView.image = [self.srcImg grayImage];
        }
            break;
        case GrayHist:
        {
            self.imageView.image = [self.srcImg grayHistImg];
        }
            break;
        case GrayEqual:
        {
            self.imageView.image = [self.srcImg equalHistImg];
        }
            break;
        case GrayHistEqual:
        {
            self.imageView.image = [self.srcImg histogramEqualization];
        }
            break;
        default:
            break;
    }
}

/**
 *  二值图像处理
 */
- (void)binaryWithType:(NSInteger)type sliderValue:(NSInteger)value{
    switch (type) {
        case BinaryMaxEntropy:
        {
            self.imageView.image = [self.srcImg binaryzationWithMaxEntropy];
        }
            break;
        case BinaryGlobal:
        {
            self.imageView.image = [self.srcImg binaryzationWithWithGlobalThrehold];
        }
            break;
            
        case BinaryDetech:
        {
            self.imageView.image = [self.srcImg binaryzationWithWithDetech];
        }
            break;
        case BinaryOTSU:
        {
            self.imageView.image = [self.srcImg binaryzation];
        }
            break;
        case BinaryCustom:
        {
            if (value == 0) {
                self.imageView.image = [self.srcImg binaryzation];
            }else{
                self.imageView.image = [self.srcImg binaryzationWithThresh:(int)value];
            }
        }
            break;
        default:
            break;
    }
}

- (void)morphologyWithType:(NSInteger)type sliderValue:(NSInteger)value{
    int size = (value == 0 ? 2 : (int)value);
    
    switch (type) {
        case MorphologyErosion:
        {
            self.imageView.image = [self.srcImg erosionType:1 size:size];
        }
            break;
        case MorphologyDilate:
        {
            self.imageView.image = [self.srcImg dilationWithType:1 size:size];
        }
            break;
        case MorphologyOpen:
        {
            self.imageView.image = [self.srcImg morphologyWithOperation:0 elementSize:size];
        }
            break;
        case MorphologyClose:
        {
            self.imageView.image = [self.srcImg morphologyWithOperation:1 elementSize:size];
        }
            break;
        case MorphologyGradient:
        {
            self.imageView.image = [self.srcImg morphologyWithOperation:2 elementSize:size];
        }
            break;
        case MorphologyTopHat:
        {
            self.imageView.image = [self.srcImg morphologyWithOperation:3 elementSize:size];
        }
            break;
        case MorphologyBlackHat:
        {
            self.imageView.image = [self.srcImg morphologyWithOperation:4 elementSize:size];
        }
            break;
            
        default:
            break;
    }
}

- (void)edgeWithType:(NSInteger)type sliderValue:(NSInteger)value{
    int size = (value == 0 ? 3 : (int)value);
    switch (type) {
        case EdgeSobel:
        {
            self.imageView.image = [self.srcImg sobelWithScale:size];
        }
            break;
        case EdgeCanny:
        {
            self.imageView.image = [self.srcImg cannyWithThreshold:size];
        }
            break;
        case EdgeLaplace:
        {
            self.imageView.image = [self.srcImg LaplaceWithSize:size];
        }
            break;
        case EdgeScharr:
        {
            self.imageView.image = [self.srcImg scharrWithScale:size];
        }
            break;
        case EdgeRoberts:
        {
            self.imageView.image = [self.srcImg robertsEdge];
        }
            break;
        case EdgePrewitt:
        {
            self.imageView.image = [self.srcImg prewittEdge];
        }
            break;
        default:
            break;
    }
}

- (void)smoothingType:(NSInteger)type sliderValue:(NSInteger)value{
    int size = [self value:(int)value defaultValue:3];
    switch (type) {
        case SmoothBoxBlur:
        {
            self.imageView.image = [self.srcImg boxBlurFilterWithSize:size];
        }
            break;
        case SmoothBlur:
        {
            self.imageView.image = [self.srcImg blureFilterWithSize:size];
        }
            break;
        case SmoothGussianBlur:
        {
            self.imageView.image = [self.srcImg gaussianBlurFilterWithSize:size];
        }
            break;
        case SmoothMedianBlur:
        {
            self.imageView.image = [self.srcImg medianFilterWithkSize:size];
        }
            break;
        case SmoothBilatelBlur:
        {
            self.imageView.image = [self.srcImg bilateralFilterWithSie:size];
        }
            break;
        default:
            break;
    }
}

- (void)skeletonType:(NSInteger)type sliderValue:(NSInteger)value{
    switch (type) {
        case SkeletonDistanceTransform:
        {
            self.imageView.image = [self.srcImg distanceTransform];
        }
            break;
        case SkeletonHilditch:
        {
            self.imageView.image = [self.srcImg skeletonByHilditch];
        }
            break;
        case SkeletonRosenfeld:
        {
            self.imageView.image = [self.srcImg skeletonByRosenfeld];
        }
            break;
        case SkeletonMorph:
        {
            self.imageView.image = [self.srcImg skeletonByMorph];
        }
            break;
        default:
            break;
    }
}

- (int)value:(int)value defaultValue:(int)defaultValue{
    int retValue = (value == 0 ? defaultValue : value);
    
    return retValue;
}

#pragma mark --
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)saveBtnClick:(id)sender {
    
}

@end
