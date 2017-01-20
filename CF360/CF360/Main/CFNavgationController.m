//
//  CFNavgationController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFNavgationController.h"

@interface CFNavgationController ()

@end

@implementation CFNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条颜色
    [self.navigationBar setBarTintColor:[UIColor yh_colorNavYellowCommon]];
    // 设置左右 items 的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    // 设置title的颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
