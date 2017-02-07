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
    // 底部视图
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(8, 8, self.contentView.width - 16, self.contentView.height - 16)]; // 这里直接设置frame没有效果,因为代理方法设置的cell大小后走,所以应该添加约束或者在重写模型set方法中把frame再设置一遍
    bgView.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:bgView];
    
}






- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
