//
//  GLShowVC.m
//  DImageFilter
//
//  Created by tony on 5/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLShowVC.h"

#import "Masonry.h"
#import "UIImage+OpenCV.h"

@interface GLShowVC ()
@property (weak, nonatomic) IBOutlet UILabel *tiptitle;
@property (weak, nonatomic) IBOutlet UIImageView *originImg;

@property (weak, nonatomic) IBOutlet UIImageView *dstImg;
@end

@implementation GLShowVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBar.hidden = TRUE;
    self.originImg.image = [UIImage imageNamed:@"lena.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)grayBtnEvent:(id)sender{
    self.tiptitle.text = @"灰度图";
    UIImage *image = [self.originImg.image grayImage];
    self.dstImg.image = image;
}

- (IBAction)binaryBtnEvent:(id)sender{
    self.tiptitle.text = @"二值图";
    UIImage *image = [self.originImg.image binaryzation];
    self.dstImg.image = image;
}

- (IBAction)boxBlurFilterEvent:(id)sender {
    self.tiptitle.text = @"方框滤波";
    UIImage *image = [self.originImg.image boxBlurFilter];
    self.dstImg.image = image;
}

- (IBAction)blurFilterEvent:(id)sender {
    self.tiptitle.text = @"均值滤波";
    UIImage *image = [self.originImg.image blurFilter];
    self.dstImg.image = image;
}

- (IBAction)GaussianBlurEvent:(id)sender {
    self.tiptitle.text = @"高斯滤波";
    UIImage *image = [self.originImg.image gaussianBlurFilter];
    self.dstImg.image = image;
}

- (IBAction)medianFilterEvent:(id)sender {
    self.tiptitle.text = @"中值滤波";
    UIImage *image = [self.originImg.image medianFilter];
    self.dstImg.image = image;
}

- (IBAction)bilateralBlurEvent:(id)sender {
    self.tiptitle.text = @"双边滤波";
    UIImage *image = [self.originImg.image bilateralFilter];
    self.dstImg.image = image;
}
- (IBAction)openEvent:(id)sender {
}
- (IBAction)closeEvent:(id)sender {
}
- (IBAction)topHatEvent:(id)sender {
}
- (IBAction)blackHatEvent:(id)sender {
}
@end
