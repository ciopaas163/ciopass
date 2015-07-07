//
//  PopulationController.m
//  Communication
//
//  Created by CIO on 15/3/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PopulationController.h"
#import "PopulationCell.h"
@interface PopulationController ()

@end

@implementation PopulationController
-(void)viewWillAppear:(BOOL)animated{
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"组织构架";
    /*
    //创建一个导航栏
    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
    [self.view addSubview:_navBar];
    //在这个集合Item中添加标题，按钮
    //style:设置按钮的风格，一共有三种选择
    //创建一个左边按钮
     */
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"] style:UIBarButtonItemStylePlain target:self action:@selector(perFormSetup:)];

    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftBar:)];

    UISearchBar* seaechBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    seaechBar.placeholder = @"搜索";
    seaechBar.searchBarStyle = UISearchBarStyleProminent;
    [self.view addSubview:seaechBar];

    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, seaechBar.frame.origin.y + seaechBar.frame.size.height,seaechBar.frame.size.width, self.view.frame.size.height - 64 - seaechBar.frame.size.height)];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.bounces = YES;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.contentSize = CGSizeMake(0, tableView.bounds.size.height + 1);
    [self.view addSubview:tableView];

    //    调用移除清除UITableView底部多余的分割线
    [self setExtraCellLineHidden:tableView];

}
#pragma mark === [  返回上一界面方法]
-(void)leftBar:(UIBarButtonItem* )left{
    NSLog(@"return");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark  清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];

}
#pragma mark === [UITableView 代理方法]
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
//返回的行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 14;
}
//返回的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* Cell = @"cell";
    PopulationCell* tableCell = [tableView dequeueReusableCellWithIdentifier:Cell];
    if (tableCell == nil) {
        tableCell = [[PopulationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Cell];
    }
    NSArray * labelArray = @[@"刘龙",@"曾兆强",@"徐自强",@"张林",@"nnnn",@"戴学鹏",@"黄嘉豪",@"王文明",@"李兴洲",@"阮中强",@"张品强",@"孙凯迪",@"IOS",@"戴学鹏2"];
    NSArray * labelAy = @[@"php",@"android",@"PM",@"人事专员",@"shichang",@"php",@"VC",@"VC",@"IOS开发",@"AD",@"vc开发",@"IOS",@" ",@"PHP开发"];
    CellModel* model = [[CellModel alloc] init];
    model.Name = labelArray[indexPath.section];
    model.names = labelAy[indexPath.section];

    NSLog(@"NNNName==%@",model.Name);

    tableCell.model = model;

    return tableCell;
}
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"人物个数页面");

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
