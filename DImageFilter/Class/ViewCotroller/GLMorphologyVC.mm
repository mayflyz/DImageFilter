//
//  GLMorphologyVC.m
//  DImageFilter
//
//  Created by tony on 5/24/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMorphologyVC.h"

#import "UIImage+OpenCV.h"

@interface GLMorphologyVC ()
@property (weak, nonatomic) IBOutlet UIImageView *originImg;

@property (weak, nonatomic) IBOutlet UILabel *titleInfo;
@property (weak, nonatomic) IBOutlet UIImageView *dstImg;
@end

@implementation GLMorphologyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.originImg.image = [UIImage imageNamed:@"lena.jpg"];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)valueChange:(id)sender {
    UISlider *slider = (UISlider *)sender;
    CGFloat value = slider.value;
    int size = value*50;
    
//    self.dstImg.image = [self.originImg.image erosionType:2 size:size];
//    self.dstImg.image = [self.originImg.image dilationWithType:1 size:size];
//    self.dstImg.image = [self.originImg.image morphologyWithOperation:4 elementSize:size];
    self.dstImg.image = [self.originImg.image scharrWithScale:size];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)dilateEvent:(id)sender {
    self.titleInfo.text = @"膨胀操作";
    UIImage *image = [self.originImg.image scharrWithPrewitt];
    
    self.dstImg.image = image;
}

- (IBAction)erodeEvent:(id)sender {
    self.titleInfo.text = @"腐蚀操作";
    UIImage *image = [self.originImg.image sobelWithScale:3];
    
    self.dstImg.image = image;
}

- (IBAction)closeEvent:(id)sender {
    self.titleInfo.text = @"闭操作";
    UIImage *image = [self.originImg.image morphologyWithOperation:1 elementSize:1];
    
    self.dstImg.image = image;
}

- (IBAction)openEvent:(id)sender {
    self.titleInfo.text = @"开操作";
    UIImage *image = [self.originImg.image morphologyWithOperation:0 elementSize:1];
    
    self.dstImg.image = image;
}

- (IBAction)blackHatEvent:(id)sender {
    self.titleInfo.text = @"黑帽操作";
    UIImage *image = [self.originImg.image morphologyWithOperation:3 elementSize:1];
    
    self.dstImg.image = image;
}

- (IBAction)topHatEvent:(id)sender {
    self.titleInfo.text = @"顶帽操作";
    UIImage *image = [self.originImg.image morphologyWithOperation:4 elementSize:1];
    
    self.dstImg.image = image;
}
@end
