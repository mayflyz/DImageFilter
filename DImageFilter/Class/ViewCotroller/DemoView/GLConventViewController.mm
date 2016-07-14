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
#import <opencv2/highgui/cap_ios.h>
#import "GLFaceDetector.h"
#import "GLMatEdgeDetection.h"

typedef NS_ENUM(NSInteger, DetectorType) {
    DetectorTypeNone,
    DetectorTypeGray,
    DetectorTypeEdge
};

@interface GLConventViewController ()<CvVideoCameraDelegate>{
    AVCaptureDevicePosition position;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonnull, strong) CvVideoCamera *videoCamera;

@property (nonatomic, strong) GLFaceDetector *faceDetector;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) DetectorType type;

@end

@implementation GLConventViewController
- (instancetype)init{
    if (self = [super init]) {
        _type = DetectorTypeNone;
        position = AVCaptureDevicePositionFront;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load image with face
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = position;
    self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    self.videoCamera.delegate = self;
    self.videoCamera.defaultFPS = 30;
    self.videoCamera.grayscaleMode = NO;
    
    self.faceDetector = [[GLFaceDetector alloc] initWithCameraView:self.imageView scale:2.0];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handleTap:)];
    
    [self.view addGestureRecognizer:_tapGestureRecognizer];
    self.view.userInteractionEnabled = YES;

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.faceDetector startCapture];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.videoCamera stop];
    [self.faceDetector stopCapture];
}

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image;
{
    // Do some OpenCV stuff with the image
    if (self.type == DetectorTypeGray) {
        Mat dst;
        cvtColor(image,dst,CV_RGB2GRAY);
        dst.copyTo(image);
    }else if(self.type == DetectorTypeEdge){
        Mat dst = [GLMatEdgeDetection binaryzation:image];
        dst.copyTo(image);
    }else{
        
    }
    
}
#endif
- (IBAction)switchCamera:(id)sender {
    [self.videoCamera stop];
    if (position == AVCaptureDevicePositionFront) {
        position = AVCaptureDevicePositionBack;
    }else{
        position = AVCaptureDevicePositionFront;
    }
    self.videoCamera.defaultAVCaptureDevicePosition = position;
    [self.videoCamera start];
}

- (IBAction)dismissView:(id)sender {
    [self.navigationController popViewControllerAnimated:TRUE];
}

- (IBAction)grayDealEvent:(id)sender {
    if (_type != DetectorTypeGray) {
        _type = DetectorTypeGray;
    }else{
        _type = DetectorTypeNone;
        [self.faceDetector startCapture];
    }
}

- (IBAction)edgeDealEvent:(id)sender {
    if (_type != DetectorTypeEdge) {
        _type = DetectorTypeEdge;
        [self.videoCamera start];
        [self.faceDetector stopCapture];
    }else{
        _type = DetectorTypeNone;
        [self.videoCamera stop];
        [self.faceDetector startCapture];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSURL *)faceModelFileURL {
    NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *documentsURL = [paths lastObject];
    NSURL *modelURL = [documentsURL URLByAppendingPathComponent:@"face-model.xml"];
    return modelURL;
}

- (void)handleTap:(UITapGestureRecognizer *)tapGesture {
    NSArray *detectedFaces = [self.faceDetector.detectedFaces copy];
    CGSize windowSize = self.view.bounds.size;
    for (NSValue *val in detectedFaces) {
        CGRect faceRect = [val CGRectValue];
        
        CGPoint tapPoint = [tapGesture locationInView:nil];
        //scale tap point to 0.0 to 1.0
        CGPoint scaledPoint = CGPointMake(tapPoint.x/windowSize.width, tapPoint.y/windowSize.height);
        if(CGRectContainsPoint(faceRect, scaledPoint)){
            NSLog(@"tapped on face: %@", NSStringFromCGRect(faceRect));
            UIImage *img = [self.faceDetector faceWithIndex:[detectedFaces indexOfObject:val]];
            [self performSegueWithIdentifier:@"RecognizeFace" sender:img];
        }
        else {
            NSLog(@"tapped on no face");
        }
    }
}

@end