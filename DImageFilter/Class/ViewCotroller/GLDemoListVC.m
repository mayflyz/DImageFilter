//
//  GLDemoListVC.m
//  DImageFilter
//
//  Created by tony on 5/23/16.
//  Copyright © 2016 sjtu. All rights reserved.
//

#import "GLDemoListVC.h"
#import "GLShowVC.h"
#import "GLMorphologyVC.h"

@interface GLDemoListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation GLDemoListVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"openCV Demo";
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.dataArr = [@[@{@"key" : @"图像转换", @"value" : @1},
                      @{@"key" : @"图像集合操作", @"value" : @2},
                      @{@"key" : @"图像开闭操作", @"value" : @1}] mutableCopy];
}


#pragma mark --
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSDictionary *item = [self.dataArr objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"key"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *item = [self.dataArr objectAtIndex:indexPath.row];
    NSInteger number = [item[@"value"] integerValue];
    switch (number) {
        case 1:
            {
                GLShowVC *vc = [[GLShowVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 2:
            {
                GLMorphologyVC *vc = [[GLMorphologyVC alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
            break;
        case 3:
            {
            
            }
            break;
        default:
            break;
    }
}

@end
