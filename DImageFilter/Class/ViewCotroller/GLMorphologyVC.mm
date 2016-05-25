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
    UIImage *image = [self.originImg.image dilateOperation];
    
    self.dstImg.image = image;
}

- (IBAction)erodeEvent:(id)sender {
    self.titleInfo.text = @"腐蚀操作";
    UIImage *image = [self.originImg.image erodeOperation];
    
    self.dstImg.image = image;
}

- (IBAction)closeEvent:(id)sender {
    self.titleInfo.text = @"闭操作";
    UIImage *image = [self.originImg.image closeOperation];
    
    self.dstImg.image = image;
}

- (IBAction)openEvent:(id)sender {
    self.titleInfo.text = @"开操作";
    UIImage *image = [self.originImg.image openOperation];
    
    self.dstImg.image = image;
}

- (IBAction)blackHatEvent:(id)sender {
    self.titleInfo.text = @"黑帽操作";
    UIImage *image = [self.originImg.image blackHatOperation];
    
    self.dstImg.image = image;
}

- (IBAction)topHatEvent:(id)sender {
    self.titleInfo.text = @"顶帽操作";
    UIImage *image = [self.originImg.image floodFill];
    
    self.dstImg.image = image;
}
@end
