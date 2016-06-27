//
//  GLVIndexVC.m
//  DImageFilter
//
//  Created by tony on 6/27/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLVIndexVC.h"
#import "Macro.h"

@interface GLVIndexVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *cameraBtn;
@property (nonatomic, strong) UIButton *albumBtn;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation GLVIndexVC

- (void)viewDidLoad {
    [super viewDidLoad] ;
    // Do any additional setup after loading the view.
    self.cameraBtn.center = CGPointMake(self.view.center.x - ScreenWidth/8, self.view.center.y);
    self.albumBtn.center =CGPointMake(self.view.center.x + ScreenWidth/8, self.view.center.y);

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.albumBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---
- (IBAction)cameraBtnClick:(id)sender{
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.allowsEditing = TRUE;
        self.imagePickerController.delegate = self;
    }
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;  //图片选择，只选择一个
    [self presentViewController:self.imagePickerController animated:true completion:nil];
}

- (IBAction)albumBthClick:(id)sender{
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.allowsEditing = TRUE;
        self.imagePickerController.delegate = self;
    }
    
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  //图片选择，只选择一个
    [self presentViewController:self.imagePickerController animated:true completion:nil];
}


#pragma mark -- UIImagePickerControllerDelegate
// 用户选中图片之后的回调
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    
    // 获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
    
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker{
    // 关闭相册界面
    NSLog(@"cancel image picker Control");
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark ---
- (UIButton *)cameraBtn{
    if (_cameraBtn == nil) {
        _cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cameraBtn.frame = CGRectMake(0, 0, ScreenWidth/4, ScreenWidth/4);
        [_cameraBtn setImage:[UIImage imageNamed:@"icon_camera3"] forState:UIControlStateNormal];
        [_cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _cameraBtn;
}

- (UIButton *)albumBtn{
    if (_albumBtn == nil) {
        _albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _albumBtn.frame = CGRectMake(0, 0, ScreenWidth/4, ScreenWidth/4);
        [_albumBtn setImage:[UIImage imageNamed:@"icon_Album3"] forState:UIControlStateNormal];
        [_albumBtn addTarget:self action:@selector(albumBthClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _albumBtn;
}

@end
