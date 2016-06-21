//
//  GLMenuView.m
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMenuView.h"
#import "GLMenuItem.h"
#import "MenuHrizontal.h"

@interface GLMenuView ()<GLMenuItemDelegate,MenuHrizontalDelegate>

@property (nonatomic, strong) MenuHrizontal *menuView;
@property (nonatomic, strong) UIScrollView *subMenuScrollView;

@end

@implementation GLMenuView

- (instancetype)initWithFrame:(CGRect)frame menuArr:(NSMutableArray *)menuArr{
    if (self = [super initWithFrame:frame]) {
        self.menuArr = [menuArr copy];
        [self menuInitWithArr:self.menuArr];
    }
    
    return self;
}

const int menuWidth = 100;
- (void)menuInitWithArr:(NSArray *)arr{
    if (arr.count == 0) {
        return;
    }
    
    
    NSMutableArray *menuArr = [NSMutableArray new];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *menuDic = [arr objectAtIndex:i];
        
        NSDictionary *item = @{NOMALKEY : @"normal",
                               HEIGHTKEY : @"helight",
                               TITLEKEY : [menuDic objectForKey:@"title"],
                               TITLEWIDTH : @(menuWidth)};
        [menuArr addObject:item];
    }
    
    self.menuView = [[MenuHrizontal alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - 30, CGRectGetWidth(self.bounds), 30) ButtonItems:menuArr];
    self.menuView.delegate = self;
    [self addSubview:self.menuView];
    
    self.subMenuScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - 30)];
    self.subMenuScrollView.scrollEnabled = TRUE;
    [self addSubview:self.subMenuScrollView];
    
    if (arr.count >= 1) {
        [self.menuView clickButtonAtIndex:0];
    }
}

//- (IBAction)firstMenuClick:(id)sender{
//    UIButton *btn = (UIButton *)sender;
//    
//    [self refreshSubMenuWithIndex:btn.tag];
//}

- (void)refreshSubMenuWithIndex:(NSInteger)index{
    if (index < 0 || index > ([self.menuArr count] - 1))    return;
 
    for (UIView *subView in self.subMenuScrollView.subviews) {
        [subView removeFromSuperview];
    }
    
    NSDictionary *menuDic = [self.menuArr objectAtIndex:index];
    NSArray *subMenu = [menuDic objectForKey:@"subMenu"];
    for (int i=0; i<[subMenu count]; i++) {
        NSDictionary *itemDic = [subMenu objectAtIndex:i];
        NSString *imgName = [itemDic objectForKey:@"imageName"];
        UIImage *menuImg = [UIImage imageNamed:(imgName.length > 0 ? imgName : @"icon_menu")];
        GLMenuItem *item = [[GLMenuItem alloc] initWithFrame:CGRectMake(i*menuWidth, 0, menuWidth, CGRectGetHeight(self.subMenuScrollView.bounds)) withImage:menuImg title:[itemDic objectForKey:@"title"]];
        item.itemInfo = itemDic;
        item.delegate = self;
        [self.subMenuScrollView addSubview:item];
    }
    self.subMenuScrollView.contentSize = CGSizeMake(600, CGRectGetHeight(self.subMenuScrollView.bounds));
    self.subMenuScrollView.contentOffset = CGPointZero;
}

#pragma mark --MenuHrizontalDelegate
- (void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    [self refreshSubMenuWithIndex:aIndex];
}

#pragma mark -- GLMenuItemDelegate
- (void)menuItemSelect:(id)itemInfo{
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(menuItemSelect:)]) {
            [self.delegate menuItemSelect:itemInfo];
        }
    }
}
@end
