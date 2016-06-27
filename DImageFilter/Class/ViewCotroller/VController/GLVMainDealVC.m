//
//  GLVMainDealVC.m
//  DImageFilter
//
//  Created by tony on 6/27/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLVMainDealVC.h"
#import "Macro.h"

#import "QHNavSliderMenu.h"

@interface GLVMainDealVC ()<QHNavSliderMenuDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) QHNavSliderMenu *slideMenu;

@end

@implementation GLVMainDealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self menuInfoInit];
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
    NSMutableArray *titles = [NSMutableArray new];
    NSMutableArray *nomalImgs = [NSMutableArray new];
    for (NSDictionary *value in menuValue) {
        [titles addObject:[value objectForKey:@"title"]];
        [nomalImgs addObject:[value objectForKey:@"image"]];
    }
    
    QHNavSliderMenuStyleModel *model = [QHNavSliderMenuStyleModel new];
    model.menuTitles = titles;
    model.menuImagesNormal = nomalImgs;
    
    self.slideMenu = [[QHNavSliderMenu alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, CGRectGetHeight(self.bottomView.bounds)) andStyleModel:model andDelegate:self showType:QHNavSliderMenuTypeTitleAndImage];
    self.slideMenu.backgroundColor = [UIColor clearColor];
    [self.bottomView addSubview:self.slideMenu];
}

#pragma mark --
- (IBAction)backBtnClick:(id)sender {
    
}

- (IBAction)saveBtnClick:(id)sender {
    
}

@end
