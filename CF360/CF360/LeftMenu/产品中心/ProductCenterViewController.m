//
//  ProductCenterViewController.m
//  CF360
//
//  Created by junde on 2017/1/12.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "ProductCenterViewController.h"
#import "XinTuoViewController.h"        // 信托
#import "ZiGuanViewController.h"        // 资管
#import "YangGuangViewController.h"     // 阳光私募
#import "SiMuViewController.h"          // 私募股权
#import "BaoXianViewController.h"       // 保险

#define buttonTagBase  1000

@interface ProductCenterViewController ()

@end

@implementation ProductCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全部产品";
    self.view.backgroundColor = [UIColor whiteColor];

    [self setupUI];
}

#pragma mark - 产品分类按钮点击方法
- (void)productButtonClick:(UIButton *)button {
    NSInteger tag = button.tag - buttonTagBase;
    switch (tag) {
        case 0:
        {
            XinTuoViewController *xinTuoVC = [XinTuoViewController new];
            [self.navigationController pushViewController:xinTuoVC animated:YES];
        }
            break;
        case 1:
        {
            ZiGuanViewController *ziGuanVC = [ZiGuanViewController new];
            [self.navigationController pushViewController:ziGuanVC animated:YES];
        }
            break;
        case 2:
        {
            YangGuangViewController *yangGuangVC = [YangGuangViewController new];
            [self.navigationController pushViewController:yangGuangVC animated:YES];
        }
            break;
        case 3:
        {
            SiMuViewController *siMuVC = [SiMuViewController new];
            [self.navigationController pushViewController:siMuVC animated:YES];
        }
            break;
        case 4:
        {
            BaoXianViewController *baoXianVC = [BaoXianViewController new];
            [self.navigationController pushViewController:baoXianVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 设置界面
- (void)setupUI {
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, Width_Screen, Height_Screen - 64)];
    bgView.backgroundColor = [UIColor yh_colorLightGrayCommon];
    [self.view addSubview:bgView];
    
    CGFloat margin = 1;
    CGFloat buttonW = (Width_Screen - 1) / 2;
    CGFloat buttonH = (Height_Screen - 64 - 2) / 3;
    CGRect rect = CGRectMake(0, 0, buttonW, buttonH);
    
    NSInteger row = 3;
    NSInteger col = 2;
    NSArray *imageNames = @[@"pro-xinTuo",@"pro-ziGuan",@"pro-yangGuangSiMu",@"pro-siMuGuQuan",@"pro-baoXian",@"pro-jingQingQiDai"];
    NSInteger index = 0;
    for (NSInteger i = 0; i < row; i++) {
        
        for (NSInteger j = 0; j < col; j++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:imageNames[index]] forState:UIControlStateNormal];
            button.frame = CGRectOffset(rect, (buttonW + margin) * j, (buttonH + margin) * i);
            [bgView addSubview:button];
 
            button.tag = buttonTagBase + index;
            [button addTarget:self action:@selector(productButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            index++;
        }
        
    }
    
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
