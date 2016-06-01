//
//  GLConventViewController.m
//  DImageFilter
//
//  Created by tony on 5/31/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLConventViewController.h"

#import "Masonry.h"
#import "UIImage+OpenCV.h"
#import "UIImage+FaceRecognizer.h"

@interface GLConventViewController ()<>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GLConventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load image with face
    UIImage* image = [UIImage imageNamed:@"circle.jpg"];
    // Show resulting image
    self.imageView.image = [image circleDetect];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn1Event:(id)sender {
}
- (IBAction)btn2Event:(id)sender {
}
- (IBAction)btn3Event:(id)sender {
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end