//
//  UIImage+FaceRecognizer.h
//  DImageFilter
//
//  Created by tony on 5/26/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (FaceRecognizer)

- (NSArray*)facePointDetect;

- (UIImage*)faceDetect;

- (UIImage*)circleDetect;

@end
