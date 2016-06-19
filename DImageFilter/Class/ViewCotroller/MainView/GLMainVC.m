//
//  GLMainVC.m
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMainVC.h"

#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "SCRecorderHeader.h"

#import "GLFilterImageVC.h"

@interface GLMainVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SCRecorderDelegate>{
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
}


@property (weak, nonatomic) IBOutlet UIView *previewView;
@property (strong, nonatomic) SCRecorderToolsView *focusView;
@property (weak, nonatomic) IBOutlet UIButton *flipCamerBtn;
@property (weak, nonatomic) IBOutlet UIButton *albumsBtn;
@property (weak, nonatomic) IBOutlet UIButton *takePhotoBtn;

@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@end

@implementation GLMainVC

#pragma mark -- life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    UIView *preview = self.previewView;
    _recorder.previewView = preview;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [_recorder stopRunning];
}

- (void)dealloc{
    _recorder.previewView = nil;
}

#pragma mark -- Event
- (IBAction)flipCamerEvent:(id)sender {
    [_recorder switchCaptureDevices];
}

- (IBAction)albumsEvent:(id)sender {
    if (!self.imagePickerController) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;  //图片选择，只选择一个
        self.imagePickerController.allowsEditing = FALSE;
        self.imagePickerController.delegate = self;
    }
    
    [self presentViewController:self.imagePickerController animated:true completion:nil];
}

- (IBAction)takePhotoEvent:(id)sender {
    [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            [self showPhotoWithImage:image];
        } else {
            [self showAlertViewWithTitle:@"Failed to capture photo" message:error.localizedDescription];
        }
    }];

}

- (void)showPhotoWithImage:(UIImage *)image{
    GLFilterImageVC *filterVC = [[GLFilterImageVC alloc] init];
    filterVC.originImg = image;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterVC];
    [self presentViewController:nav animated:NO completion:^{
        
    }];
}

// 用户选中图片之后的回调
- (void)imagePickerController: (UIImagePickerController *)picker didFinishPickingMediaWithInfo: (NSDictionary *)info{
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
    
    // 获得编辑过的图片
    UIImage *image = [info objectForKey: @"UIImagePickerControllerOriginalImage"];
        
    [self showPhotoWithImage:image];
}

- (void) imagePickerControllerDidCancel: (UIImagePickerController *)picker{
    // 关闭相册界面
    NSLog(@"cancel image picker Control");
    [self dismissViewControllerAnimated:true completion:^{
        
    }];
}

#pragma mark -- SCRecorderDelegate
//- (void)recorder:(SCRecorder *)recorder didSkipVideoSampleBufferInSession:(SCRecordSession *)recordSession {
//    NSLog(@"Skipped video buffer");
//}
//
//- (void)recorder:(SCRecorder *)recorder didReconfigureAudioInput:(NSError *)audioInputError {
//    NSLog(@"Reconfigured audio input: %@", audioInputError);
//}
//
//- (void)recorder:(SCRecorder *)recorder didReconfigureVideoInput:(NSError *)videoInputError {
//    NSLog(@"Reconfigured video input: %@", videoInputError);
//}
//- (void)recorder:(SCRecorder *)recorder didCompleteSession:(SCRecordSession *)recordSession {
////    [self saveAndShowSession:recordSession];
//}
//
//- (void)recorder:(SCRecorder *)recorder didInitializeAudioInSession:(SCRecordSession *)recordSession error:(NSError *)error {
//    if (error == nil) {
//        NSLog(@"Initialized audio in record session");
//    } else {
//        NSLog(@"Failed to initialize audio in record session: %@", error.localizedDescription);
//    }
//}
//
//- (void)recorder:(SCRecorder *)recorder didInitializeVideoInSession:(SCRecordSession *)recordSession error:(NSError *)error {
//    if (error == nil) {
//        NSLog(@"Initialized video in record session");
//    } else {
//        NSLog(@"Failed to initialize video in record session: %@", error.localizedDescription);
//    }
//}
//
//- (void)recorder:(SCRecorder *)recorder didBeginSegmentInSession:(SCRecordSession *)recordSession error:(NSError *)error {
//    NSLog(@"Began record segment: %@", error);
//}
//
//- (void)recorder:(SCRecorder *)recorder didCompleteSegment:(SCRecordSessionSegment *)segment inSession:(SCRecordSession *)recordSession error:(NSError *)error {
//    NSLog(@"Completed record segment at %@: %@ (frameRate: %f)", segment.url, error, segment.frameRate);
////    [self updateGhostImage];
//}

#pragma mark ---
- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}
@end
