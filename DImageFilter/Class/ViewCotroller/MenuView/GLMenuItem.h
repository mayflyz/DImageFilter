//
//  GLMeunItem.h
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GLMenuItemDelegate <NSObject>

- (void)menuItemSelect:(id)itemInfo;

@end

@interface GLMenuItem : UIView

@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign) id<GLMenuItemDelegate> delegate;

@property (nonatomic, strong) id itemInfo;

- (instancetype)initWithFrame:(CGRect)frame withImage:(UIImage *)image title:(NSString *)title;

- (void)setMenuImage:(UIImage *)image;

- (void)setTitleInfo:(NSString *)title;

@end
