//
//  UIImage+Skeleton.h
//  DImageFilter
//
//  Created by tony on 6/14/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImage+MatOperate.h"

@interface UIImage (Skeleton)

- (UIImage *)distanceTransform;

- (UIImage *)skeletonByHilditch;

- (UIImage *)skeletonByRosenfeld;

- (UIImage *)skeletonByMorph;
@end
