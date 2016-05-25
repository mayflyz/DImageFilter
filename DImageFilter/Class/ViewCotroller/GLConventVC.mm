//
//  GLConventVC.m
//  DImageFilter
//
//  Created by tony on 5/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLConventVC.h"

#import "Masonry.h"
#import "UIImage+OpenCV.h"

@interface GLConventVC ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;

@end

@implementation GLConventVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn1 setTitle:@"gray" forState:UIControlStateNormal];
    self.btn1.backgroundColor = [UIColor orangeColor];
    [self.btn1 addTarget:self action:@selector(grayBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    self.btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.btn2 setTitle:@"Binary" forState:UIControlStateNormal];
    self.btn2.backgroundColor = [UIColor orangeColor];
    [self.btn2 addTarget:self action:@selector(binaryBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.btn1 setFrame: CGRectMake(10, 70, 80, 40)];
    [self.btn2 setFrame:CGRectMake(130, 70, 80, 40)];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 160, 200, 200)];
    self.imageView.image = [UIImage imageNamed:@"lena.jpg"];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
    [self.view addSubview:self.imageView];
//    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.topMargin.mas_offset(10);
//    }];
//    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.topMargin.mas_offset(10);
//    }];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.leftMargin.rightMargin.mas_offset(10);
//    }];
}


- (IBAction)grayBtnEvent:(id)sender{
    UIImage *image = [[UIImage imageNamed:@"lena.jpg"] grayImage];
    self.imageView.image = image;
}

- (IBAction)binaryBtnEvent:(id)sender{
    UIImage *image = [[UIImage imageNamed:@"lena.jpg"] binaryzation];
    self.imageView.image = image;
}

@end
