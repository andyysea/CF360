//
//  HotProductViewCell.m
//  CF360
//
//  Created by junde on 2017/2/7.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "HotProductViewCell.h"

@implementation HotProductViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        [self setupUI];
    }
    return self;
}

#pragma mark - 设置界面
- (void)setupUI {
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView.backgroundColor = [UIColor redColor];
    // 1> 底部视图
    UIView *bgView = [[UIView alloc] init]; // 这里直接设置frame没有效果,因为代理方法设置的cell大小后走,所以应该添加约束或者在重写模型set方法中把frame再设置一遍
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderWidth = 0.4;
    bgView.layer.borderColor = [UIColor yh_colorNavYellowCommon].CGColor;
    [self.contentView addSubview:bgView];
    
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
    
    // 2> 添加图片
    UIImageView *pictureView = [[UIImageView alloc] init];
    pictureView.image = [UIImage imageNamed:@"qwe123"];
    [bgView addSubview:pictureView];
    
    [pictureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(1);
        make.right.equalTo(@-1);
        make.height.mas_offset(150);
    }];
    
    // 3> 产品名称,分销/包销,热销,推荐
    UILabel *productNameLabel = [[UILabel alloc] init];
    productNameLabel.font = [UIFont systemFontOfSize:16];
    productNameLabel.text = @"乐视体育";
    [productNameLabel sizeToFit];
    [bgView addSubview:productNameLabel];
    
    [productNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@12);
        make.top.equalTo(@7);
    }];
    
    // 分销/包销
    UILabel *saleTypeLabel = [[UILabel alloc] init];
    saleTypeLabel.backgroundColor = [UIColor yh_colorNavYellowCommon];
    saleTypeLabel.font = [UIFont systemFontOfSize:12];
    saleTypeLabel.textColor = [UIColor whiteColor];
    saleTypeLabel.layer.cornerRadius = 3;
    saleTypeLabel.layer.masksToBounds = YES;
    saleTypeLabel.text = @"分销";
    [saleTypeLabel sizeToFit];
    [bgView addSubview:saleTypeLabel];
    
    [saleTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(productNameLabel.mas_right).offset(5);
    }];
    
    // 热销
    UILabel *hotSaleLabel = [[UILabel alloc] init];
    hotSaleLabel.backgroundColor = [UIColor yh_colorSimpleRedCommon];
    hotSaleLabel.font = [UIFont systemFontOfSize:12];
    hotSaleLabel.textColor = [UIColor whiteColor];
    hotSaleLabel.layer.cornerRadius = 3;
    hotSaleLabel.layer.masksToBounds = YES;
    hotSaleLabel.text = @"热销";
    [hotSaleLabel sizeToFit];
    [bgView addSubview:hotSaleLabel];
    
    [hotSaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(saleTypeLabel.mas_right).offset(5);
    }];
    
    // 推荐
    UILabel *commendLabel = [[UILabel alloc] init];
    commendLabel.backgroundColor = [UIColor yh_colorSimpleBlueCommon];
    commendLabel.font = [UIFont systemFontOfSize:12];
    commendLabel.textColor = [UIColor whiteColor];
    commendLabel.layer.cornerRadius = 3;
    commendLabel.layer.masksToBounds = YES;
    commendLabel.text = @"推荐";
    [commendLabel sizeToFit];
    [bgView addSubview:commendLabel];
    
    [commendLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@9);
        make.left.equalTo(hotSaleLabel.mas_right).offset(5);
    }];
    
}




@end
