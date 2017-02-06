//
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
static NSString *cellId = @"cellId";


@interface CFHomeViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
/** 表格视图 */
@property (nonatomic, weak) UITableView *tableView;

/** 轮播图 */
@property (nonatomic, weak) SDCycleScrollView *sycleView;

/** 热销产品按钮 */
@property (nonatomic, weak) UIButton *hotProButton;
/** 产品推荐按钮 */
@property (nonatomic, weak) UIButton *tuiJProButton;

/** 轮播图模型数组 */
@property (nonatomic, strong) NSMutableArray *loopViewURLArray;


@end

@implementation CFHomeViewController

#pragma mark - 视图加载完成
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 初始化
    _loopViewURLArray = [NSMutableArray array];
    
    [self setupNavgationBar];
    [self setupUI];
    
}

#pragma mark - 视图已经出现
/**
    这里要开启控制器拖拽手势,以便在首页控制器滑动的时候能够打开左侧菜单控制器
 */
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:YES];
}

#pragma mark - 视图已经消失
/**
    这里关闭控制器拖拽手势,避免由首页控制器push到的子控制器也能拖拽,累加之后造成混乱
 */
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.drawerController setPanEnabled:NO];
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
    [self loadLoopViewNetRequest];
    [self loadHotProductNetRequset];
}

#pragma mark 首页轮播图网络请求
- (void)loadLoopViewNetRequest {
    [[MKNetWorkManager shareManager] loadLoopImagesCompletion:^(id responseData, NSError *error) {
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
        }
    }];
}

#pragma mark 热销产品网络请求
- (void)loadHotProductNetRequset {
    // 热销产品防止重复点击请求数据
    [ProgressHUD show:@"努力加载中,请稍后!" Interaction:NO];
    [[MKNetWorkManager shareManager] loadHotProductCompletion:^(id responseData, NSError *error) {
        [self.tableView.mj_header endRefreshing];

        if (error) {
            [ProgressHUD showError:@"加载失败,请确保网络通畅!"];
            return ;
        }
        
        NSDictionary *dict = responseData;
        if ([dict[@"code"] isEqualToString:@"0000"]) {
            [ProgressHUD dismiss];
            NSArray *dataArray = dict[@"data"];
            
            NSLog(@"--> %@",dataArray);
            
        } else if ([dict[@"code"] isEqualToString:@"0001"]) {
            [ProgressHUD showError:@"参数不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"0002"]) {
            [ProgressHUD showError:@"签名不正确!"];
        } else if ([dict[@"code"] isEqualToString:@"1000"]) {
            [ProgressHUD showError:@"未登录!"];
        }
    }];
}

#pragma mark 产品推荐网络请求

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    return cell;
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
            _hotProButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
            [_hotProButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _tuiJProButton.backgroundColor = [UIColor whiteColor];
            [_tuiJProButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
            
            [self loadHotProductNetRequset]; // 加载热销产品请求
        }
            break;
        case 2:
        {
            _hotProButton.backgroundColor = [UIColor whiteColor];
            [_hotProButton setTitleColor:[UIColor yh_colorNavYellowCommon] forState:UIControlStateNormal];
            _tuiJProButton.backgroundColor = [UIColor yh_colorNavYellowCommon];
            [_tuiJProButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [rightNavButton setImage:[UIImage imageNamed:@"icon-信息提示框"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightNavButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    [rightNavButton addTarget:self action:@selector(navButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 设置界面
- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 1> 添加 UITableView
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
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
