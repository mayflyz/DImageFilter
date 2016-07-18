//
//  BaseOperatorVC.m
//  DImageFilter
//
//  Created by tony on 7/16/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "BaseOperatorVC.h"
#import "Macro.h"
#import "GLMatTransform.h"
#import "UIImage+OpenCV.h"

typedef NS_ENUM(NSInteger, TransformType) {
    TransformTypeAdjust = 1,
    TransformTypeTransform,
    TransformTypeRotate
};

@interface BaseOperatorVC (){
    NSInteger type;
    float value1;
    int value2;
}


@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UISlider *slider1;
@property (weak, nonatomic) IBOutlet UISlider *slider2;

@property (nonatomic, strong) UIImageView *filterImageView;

@end

@implementation BaseOperatorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    CGFloat width = ScreenWidth - 2*Padding20;
    _filterImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Padding20, Padding20, width, width)];
    _filterImageView.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    _filterImageView.image = self.originImg;
    [self.view addSubview:_filterImageView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = TRUE;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)adjustEvent:(id)sender {
    type = TransformTypeAdjust;
    self.title1.text = @"对比度:50";
    self.title2.text = @"亮度:100";
    
    self.slider1.maximumValue = 50;
    self.slider2.maximumValue = 100;
    value1 = 1;
    value2 = 1;
}

- (IBAction)transformEvent:(id)sender{
    type = TransformTypeTransform;
    
    self.slider1.maximumValue = 200;
    self.slider2.maximumValue = 200;
    self.title1.text = @"X: 200";
    self.title2.text = @"Y: 200";
}
- (IBAction)degreeEvent:(id)sender {
    type = TransformTypeRotate;
    self.title1.text = @"角度:max 360";
    self.title2.text = @"";
    self.slider1.maximumValue = 360;
}

- (void)imageDeal{
    switch (type) {
        case TransformTypeAdjust:
            {
                Mat src = [GLMatTransform adjustMat:[self.originImg CVMat] contrast:1.2 Bright:10];
                self.filterImageView.image = [UIImage imageWithCVMat:src];
            }
            break;
        case TransformTypeTransform:
            {
               Mat src = [GLMatTransform translateTransform:[self.originImg CVMat] X:(int)value1 Y:value2];
                self.filterImageView.image = [UIImage imageWithCVMat:src];
            }
            break;
        case TransformTypeRotate:
            {
                
               IplImage *srcPl =  [GLMatTransform rotateImageWithSrcImage2:[self.originImg plImage] degree:(int)value1];
                self.filterImageView.image = [UIImage imageWIthIplImage:srcPl];
            }
            break;
            
        default:
            break;
    }
}

- (IBAction)valueChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    if (slider == self.slider1) {
        value1 = slider.value;
    }else{
        value2 = slider.value;
    }
    
    [self imageDeal];
}
@end
