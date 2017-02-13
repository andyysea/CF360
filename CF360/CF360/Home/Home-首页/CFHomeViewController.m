///
//  CFHomeViewController.m
//  CF360
//
//  Created by junde on 2017/1/11.
//  Copyright © 2017年 junde. All rights reserved.
//

#import "CFHomeViewController.h"
#import "MessageViewController.h" // 导航栏消息控制器
#import "LoopViewModel.h"         // 轮播图模型
#import "XinTuoViewController.h"    // 信托控制器
#import "ZiGuanViewController.h"    // 资管控制器
#import "YangGuangViewController.h" // 阳光私募控制器
#import "ProductCenterViewController.h"    // 产品中心 title-> 全部产品
#import "HotProductModel.h" // 热销产品模型
#import "HotProductViewCell.h" // 热销产品自定义cell
#import "ProductCommendModel.h" // 产品推荐模型
#import "ProductCommendViewCell.h" // 产品推荐自定义cell
#import "UserAccount.h"            // 用户账户

/**
    定义枚举类型,来设置添加按钮的 tag
 */
typedef NS_ENUM(NSInteger, MyButtonTag) {
    MyButtonTagOfNavLeft = 100,
    MyButtonTagOfNavRight,
    MyButtonTagOfCategory, // 这个是分类按钮累加的基础
    MyButtonTagOfSegment   // 这个是sement按钮的累加基础
};

/** 可重用标识符 */
static NSString *hotCellId = @"hotProductCellId";
static NSString *commendCellId = @"productCommendCellId";

@interface CFHomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
/** 表格视图 */
@property (nonatomic, weak) UITableView *tableView;

/** 轮播图 */
@property (nonatomic, weak) SDCycleScrollView *sycleView;


/** 导航栏右侧消息按钮 */
@property (nonatomic, weak) UIButton *rightNavButton;
/** 热销产品按钮 */
@property (nonatomic, weak) UIButton *hotProButton;
/** 产品推荐按钮 */
@property (nonatomic, weak) UIButton *tuiJProButton;

/** 轮播图模型数组 */
@property (nonatomic, strong) NSMutableArray *loopViewURLArray;
/** 热销产品模型数组 */
@property (nonatomic, strong) NSMutableArray *hotProductArray;
/** 产品推荐模型数组 */
@property (nonatomic, strong) NSMutableArray *productCommendArray;

@end

@implementation CFHomeViewController

#pragma mark - 视图已经出现
///视图出现打开控制器的拖拽手势,消失关闭视图的拖拽手势--> 原因:不这样设置,当点击菜单控制器push时再拖拽回不到首页控制器
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // 关闭侧滑开启左侧菜单控制器的拖拽手势,因为点击方法中需要请求用户账户数据
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:YES];
}

#pragma mark - 视图已经消失
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // 关闭侧滑开启左侧菜单控制器的拖拽手势,因为点击方法中需要请求用户账户数据
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:NO];
}

#pragma mark - 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    _loopViewURLArray = [NSMutableArray array];
    _hotProductArray = [NSMutableArray array];
    _productCommendArray = [NSMutableArray array];
    
    [self setupNavgationBar];
    [self setupUI];
    
}

#pragma mark - 设置轮播图图片数据显示
- (void)setLoopViewDataSource {
    if (self.loopViewURLArray.count) {
        self.sycleView.imageURLStringsGroup = self.loopViewURLArray;
    }
}

#pragma mark - 网络请求方法块
#pragma mark 下拉刷新方法
- (void)loadPulldownRefresh {
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [self loadUnreadMessageNetRequest];
    [self loadLoopViewNetRequest];
    
    // 根据选中的是哪个按钮来设置哪个产品的网络请求,减轻网络请求性能消耗
    if (self.hotProButton.selected) {
        [self loadHotProductNetRequset];
    } else if (self.tuiJProButton.selected) {
        [self loadProductCommendNetRequest];
    }
}

#pragma mark 是否有新消息网络请求
// 该方法只需要在"下拉刷新中"调用即可,不需要提示加载等待禁止交互
- (void)loadUnreadMessageNetRequest {
    
    [[MKNetWorkManager shareManager] loadUnreadMessageCompletionHandler:^(id responseData, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            NSString *numStr = [NSString stringWithFormat:@"%@",dict[@"data"][@"unReadyCount"]];
            if ([numStr isEqualToString:@"0"]) {
                [self.rightNavButton setTitle:@"" forState:UIControlStateNormal];
            } else {
                [self.rightNavButton setTitle:numStr forState:UIControlStateNormal];
            }
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }
    }];
}


#pragma mark 首页轮播图网络请求
- (void)loadLoopViewNetRequest {

    [[MKNetWorkManager shareManager] loadLoopImagesCompletionHandler:^(id responseData, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            NSArray *dataArray = dict[@"data"];
            
            if (dataArray.count) {
                [self.loopViewURLArray removeAllObjects];
                for (NSDictionary *dataDict in dataArray) {
                    LoopViewModel *model = [LoopViewModel loopViewModelWithDict:dataDict];
                    [self.loopViewURLArray addObject:model.picture];
                }
            }
            // 设置轮播图数据
            [self setLoopViewDataSource];
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }
    }];
}

#pragma mark 热销产品网络请求
- (void)loadHotProductNetRequset {
    // 热销产品防止重复点击请求数据
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadHotProductCompletionHandler:^(id responseData, NSError *error) {
        [self.tableView.mj_header endRefreshing];

        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            NSArray *dataArray = dict[@"data"][@"hotProduct"];
            
            if (dataArray.count) {
                [self.hotProductArray removeAllObjects];
                for (NSDictionary *dataDict in dataArray) {
                    HotProductModel *model = [HotProductModel yy_modelWithDictionary:dataDict];
                    model.auditStatus = dict[@"data"][@"auditStatus"];
                    [self.hotProductArray addObject:model];
                }
            }
            [self.tableView reloadData];
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }
    }];
}

#pragma mark 产品推荐网络请求
- (void)loadProductCommendNetRequest {
    // 防止重复点击请求数据
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadProductCommendCompletionHandler:^(id responseData, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        
        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            
            NSArray *modelArray = [[ProductCommendModel new] productCommendModelArrayWithData:dict];
            if (modelArray.count) {
                [self.productCommendArray removeAllObjects];
                [self.productCommendArray addObjectsFromArray:modelArray];
            }
            [self.tableView reloadData];
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        } else {
            [ProgressHUD dismiss];
        }

    }];
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hotProButton.selected) {
        return 300;
    } else {
        return 126;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
 
    if (self.hotProButton.selected) {
        return 0;
    } else {
        return 30;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.hotProButton.selected) {
        return nil;
    } else {
        UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, 30)];
        customView.backgroundColor = [UIColor whiteColor];
        UILabel *labLine = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, Width_Screen - 20, 1)];
        labLine.backgroundColor = [UIColor yh_colorNavYellowCommon];
        [customView addSubview:labLine];
        
        UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(Width_Screen / 2 - 30, 0, 60, 30)];
        headerLabel.backgroundColor = [UIColor whiteColor];
        headerLabel.textColor = [UIColor yh_colorNavYellowCommon];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.textAlignment = NSTextAlignmentCenter;

        NSArray *contentArray = self.productCommendArray[section];
        ProductCommendModel *model = contentArray[0];
        NSString *sectionName = @"";
        if ([model.CATEGORY isEqualToString:@"xt"]) {
            sectionName = @"信托";
        } else if ([model.CATEGORY isEqualToString:@"zg"]) {
            sectionName = @"资管";
        } else if ([model.CATEGORY isEqualToString:@"ygsm"]) {
            sectionName = @"阳光私募";
        } else if ([model.CATEGORY isEqualToString:@"smgq"]) {
            sectionName = @"私募股权";
        } else if ([model.CATEGORY isEqualToString:@"bx"]) {
            sectionName = @"保险";
        }
        headerLabel.text =  sectionName;
        [customView addSubview:headerLabel];
        
        return customView;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.hotProButton.selected) {
        return 1;
    } else {
        return self.productCommendArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.hotProButton.selected) {
        return self.hotProductArray.count;
    } else {
        NSArray *contentArray = self.productCommendArray[section];
        return contentArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = self.hotProButton.selected ? hotCellId : commendCellId;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    
    if (self.hotProButton.selected) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        HotProductViewCell *hotCell = (HotProductViewCell *)cell;
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        hotCell.model = self.hotProductArray[indexPath.row];
        [self callBackWithCell:hotCell];
    } else {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        ProductCommendViewCell *commendCell = (ProductCommendViewCell *)cell;
        NSArray *contentArray = self.productCommendArray[indexPath.section];
        commendCell.model = contentArray[indexPath.row];
    }
    
    
    return cell;
}


#pragma mark - 热销产品预约按钮点击方法
- (void)callBackWithCell:(HotProductViewCell *)cell {
   
    [cell setClickBookButtonCallBack:^(HotProductViewCell *cell) {
        NSInteger index = [self.tableView indexPathForCell:cell].row;
        
        // 这里可以根据index拿到对应的 model,拿到model中的属性,进行传递跳转详情控制器
        NSLog(@"得到的index -->%zd",index);
    }];
}

#pragma mark - 导航栏上 左边/右边 按钮点击方法
- (void)navButtonClick:(UIButton *)button {
    switch (button.tag) {
        case MyButtonTagOfNavLeft:
        {
            // 打开/关闭 左侧菜单控制器
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            delegate.drawerController.closed ? [delegate.drawerController openLeftView] : [delegate.drawerController closeLeftView];
        }
            break;
            
        case MyButtonTagOfNavRight:
        {
            // 跳转消息控制器
            MessageViewController *messageVC = [[MessageViewController alloc] init];
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 轮播图的代理方法,点击回调
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    NSLog(@"点击回调--> %zd",index);
}

#pragma mark - 四个分类按钮的点击方法
- (void)categoryViewButtonClick:(UIButton *)button {
    
    NSInteger tag = button.tag - MyButtonTagOfCategory;
    switch (tag) {
        case 0:
        {
            NSLog(@"--> 信托");
            XinTuoViewController *xinTuoVC = [[XinTuoViewController alloc] init];
            [self.navigationController pushViewController:xinTuoVC animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"--> 资管");
            ZiGuanViewController *ziGuanVC = [[ZiGuanViewController alloc] init];
            [self.navigationController pushViewController:ziGuanVC animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"--> 阳光私募");
            YangGuangViewController *yangGuangVC = [[YangGuangViewController alloc] init];
            [self.navigationController pushViewController:yangGuangVC animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"--> 全部-产品中心");
            ProductCenterViewController *productAllVC = [[ProductCenterViewController alloc] init];
            [self.navigationController pushViewController:productAllVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark - segment 上两个按钮添加方法
- (void)segmentButtonClick:(UIButton *)button {
    NSInteger tag = button.tag - MyButtonTagOfSegment;
    switch (tag) {
        case 1:
        {
            _hotProButton.selected = YES;
            _tuiJProButton.selected = NO;
            _hotProButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
            [_hotProButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _tuiJProButton.backgroundColor = [UIColor whiteColor];
            [_tuiJProButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
            
            [self loadHotProductNetRequset]; // 加载热销产品网络请求
        }
            break;
        case 2:
        {
            _tuiJProButton.selected = YES;
            _hotProButton.selected = NO;
            _hotProButton.backgroundColor = [UIColor whiteColor];
            [_hotProButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
            _tuiJProButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
            [_tuiJProButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self loadProductCommendNetRequest]; // 加载产品推荐网络请求
        }
            break;
        default:
            break;
    }
}


#pragma mark - 设置导航栏
- (void)setupNavgationBar {
    self.title = @"首页";
    // 1>添加导航栏中 能打开左侧菜单控制器的按钮
    UIButton *leftNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    leftNavButton.tag = MyButtonTagOfNavLeft;
    [leftNavButton setImage:[UIImage imageNamed:@"icon-菜单"] forState:UIControlStateNormal];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [leftNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 2> 添加导航栏中间的图标视图 titleView
    UIImageView *navTitleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 24)];
    navTitleView.image = [UIImage imageNamed:@"img-LOGO"];
    navTitleView.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = navTitleView;
    
    // 3> 添加导航栏中右侧的消息按钮
    UIButton *rightNavButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
    rightNavButton.tag = MyButtonTagOfNavRight;
    [rightNavButton setTitle:@"" forState:UIControlStateNormal];
    [rightNavButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
    rightNavButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [rightNavButton setBackgroundImage:[UIImage imageNamed:@"icon-信息提示框"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 记录属性
    _rightNavButton = rightNavButton;
}

#pragma mark - 设置界面
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1> 添加 UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[HotProductViewCell class] forCellReuseIdentifier:hotCellId];
    [tableView registerClass:[ProductCommendViewCell class] forCellReuseIdentifier:commendCellId];
    
    // 2> 创建headerView, 包含轮播图, 四个分类按钮, 两个本控制器得分类按钮
    CGFloat headerViewHeight = Width_Screen * 496 / 640;// 表头视图高度
    CGFloat loopViewHeight = Width_Screen * 260 / 640; // 轮播图父视图高度
    CGFloat categoryViewHeight = Width_Screen * 140 / 640;// 分类按钮父视图高度
    CGFloat segMentViewHeight = Width_Screen * 96 / 640;  // 热销/推荐产品 按钮父视图高度
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, headerViewHeight)];
    headerView.backgroundColor = [UIColor orangeColor];
    tableView.tableHeaderView = headerView;  // 设置为表格的表头视图
    
    // a> 添加轮播图
    UIView *loopBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Width_Screen, loopViewHeight)];
    loopBgView.backgroundColor = [UIColor redColor];
    [headerView addSubview:loopBgView];
    
    SDCycleScrollView *sycleView = [SDCycleScrollView cycleScrollViewWithFrame:loopBgView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"img-BX"]]; // ** 这里的占位图片填充模式不对,所以我跳进框架中做了修改 **
    sycleView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    sycleView.autoScrollTimeInterval = 3.0f;
    [loopBgView addSubview:sycleView];
    
    // b> 添加分类按钮
    UIView *cateBgView = [[UIView alloc] initWithFrame:CGRectMake(0, loopBgView.bottom, Width_Screen, categoryViewHeight)];
    cateBgView.backgroundColor = [UIColor yh_colorWithRed:230 green:230 blue:230];
    [headerView addSubview:cateBgView];
    
    CGFloat margin = (Width_Screen - categoryViewHeight * 4) / 5;
    CGRect rect = CGRectMake(margin, 0, categoryViewHeight, categoryViewHeight);
    CGFloat scale = 0.6;
    
    NSArray *buttonTitles = @[@"信托", @"资管", @"阳光私募", @"全部"];
    NSArray *buttonImageNames = @[@"img-信", @"img-资", @"img-阳", @"img-更多"];
    for (NSInteger i = 0; i < buttonTitles.count; i++) {
        NSString *title = buttonTitles[i];
        NSString *imageName = buttonImageNames[i];
        NSAttributedString *attibutedStr = [NSAttributedString yh_imageTextWithImage:[UIImage imageNamed:imageName] imageWH:categoryViewHeight * scale title:title fontSize:12 titleColor:[UIColor blackColor] spacing:4];
        UIButton *button = [[UIButton alloc] init];
        button.frame = CGRectOffset(rect, (margin + categoryViewHeight) * i, 0);
        [button setAttributedTitle:attibutedStr forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [cateBgView addSubview:button];
        
        button.tag = MyButtonTagOfCategory + i;
        [button addTarget:self action:@selector(categoryViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    // c> 添加两个 segMent
    UIView *segmentbgView = [[UIView alloc] initWithFrame:CGRectMake(0, cateBgView.bottom, Width_Screen, segMentViewHeight)];
    segmentbgView.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:segmentbgView];
    
    UIButton *hotProductBtn = [[UIButton alloc] initWithFrame:CGRectMake(8, (segmentbgView.height - 35) / 2, (Width_Screen - 16) / 2, 35)];
    hotProductBtn.tag = MyButtonTagOfSegment + 1;
    [hotProductBtn setTitle:@"热销产品" forState:UIControlStateNormal];
    [hotProductBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    hotProductBtn.layer.cornerRadius = 2;
    hotProductBtn.layer.masksToBounds = YES;
    hotProductBtn.layer.borderWidth = 0.5;
    hotProductBtn.layer.borderColor = [UIColor yh_colorNavYellowCommon].CGColor;
    hotProductBtn.backgroundColor = [UIColor yh_colorNavYellowCommon];
    [segmentbgView addSubview:hotProductBtn];
    hotProductBtn.selected = YES;
    [hotProductBtn addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tuiJProductBtn = [[UIButton alloc] initWithFrame:CGRectMake(hotProductBtn.right, hotProductBtn.y, hotProductBtn.width, hotProductBtn.height)];
    tuiJProductBtn.tag = MyButtonTagOfSegment + 2;
    [tuiJProductBtn setTitle:@"产品推荐" forState:UIControlStateNormal];
    [tuiJProductBtn setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
    tuiJProductBtn.layer.cornerRadius = 2;
    tuiJProductBtn.layer.masksToBounds = YES;
    tuiJProductBtn.layer.borderWidth = 0.5;
    tuiJProductBtn.layer.borderColor = [UIColor yh_colorNavYellowCommon].CGColor;
    tuiJProductBtn.backgroundColor = [UIColor whiteColor];
    [segmentbgView addSubview:tuiJProductBtn];
    tuiJProductBtn.selected = NO;
    [tuiJProductBtn addTarget:self action:@selector(segmentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3> 添加刷新控件
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadPulldownRefresh)];
    [tableView.mj_header beginRefreshing];
    
    // 4> 属性记录
    _tableView = tableView;
    _sycleView = sycleView;
    _hotProButton = hotProductBtn;
    _tuiJProButton = tuiJProductBtn;
    
}




@end
