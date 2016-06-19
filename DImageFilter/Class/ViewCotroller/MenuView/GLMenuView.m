//
//  GLMenuView.m
//  DImageFilter
//
//  Created by tony on 6/19/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLMenuView.h"
#import "GLMenuItem.h"

@interface GLMenuView ()<GLMenuItemDelegate>

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
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *menuDic = [arr objectAtIndex:i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        btn.frame = CGRectMake(100 + i*menuWidth, CGRectGetHeight(self.frame) - 30, menuWidth, 30);
        btn.layer.borderWidth = 1.f;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [btn setTitle:[menuDic objectForKey:@"title"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(firstMenuClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    if (arr.count >= 1) {
        [self refreshSubMenuWithIndex:0];
    }
}

- (IBAction)firstMenuClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    [self refreshSubMenuWithIndex:btn.tag];
}

- (void)refreshSubMenuWithIndex:(NSInteger)index{
    if (index < 0 || index > ([self.menuArr count] - 1))    return;
    
    NSDictionary *menuDic = [self.menuArr objectAtIndex:index];
    NSArray *subMenu = [menuDic objectForKey:@"subMenu"];
    for (int i=0; i<[subMenu count]; i++) {
        NSDictionary *itemDic = [subMenu objectAtIndex:i];
        NSString *imgName = [itemDic objectForKey:@"imageName"];
        UIImage *menuImg = [UIImage imageNamed:(imgName ? imgName : @"")];
        GLMenuItem *item = [[GLMenuItem alloc] initWithFrame:CGRectMake(i*menuWidth, 0, menuWidth, CGRectGetHeight(self.bounds) - 30) withImage:menuImg title:[itemDic objectForKey:@"title"]];
        item.itemInfo = itemDic;
        item.delegate = self;
        [self addSubview:item];
    }
}

#pragma mark -- GLMenuItemDelegate
- (void)menuItemSelect:(id)itemInfo{
    if ([itemInfo isKindOfClass:[NSDictionary class]]) {
        
    }
}
@end
