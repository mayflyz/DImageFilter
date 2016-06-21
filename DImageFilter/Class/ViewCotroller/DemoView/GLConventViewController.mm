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

@interface GLConventViewController ()<CvVideoCameraDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonnull, strong) CvVideoCamera *videoCamera;

@property (nonatomic, strong) GLFaceDetector *faceDetector;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@end

@implementation GLConventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load image with face
    UIImage* image = [UIImage imageNamed:@"lena.jpg"];
    // Show resulting image
    self.imageView.image = [image faceDetect];
    
    self.videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
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

#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(cv::Mat&)image;
{
    // Do some OpenCV stuff with the image
    cv::Mat image_copy;
    cv::cvtColor(image, image_copy, CV_BGRA2BGR);
    
    // invert image
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, CV_BGR2BGRA);
    
}
#endif


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btn1Event:(id)sender {
    [self.videoCamera start];
    
}

- (IBAction)btn2Event:(id)sender {
    [self.faceDetector startCapture];
}

- (IBAction)btn3Event:(id)sender {
    [self.videoCamera stop];
    [self.faceDetector stopCapture];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqual:@"RecognizeFace"]) {
//        NSAssert([sender isKindOfClass:[UIImage class]],@"RecognizeFace segue MUST be sent with an image");
//        FJFaceRecognitionViewController *frvc = segue.destinationViewController;
//        frvc.inputImage = sender;
//        
//    }
}

@end