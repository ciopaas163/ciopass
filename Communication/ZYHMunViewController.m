//
//  ZYHMunViewController.m
//  Communication
//
//  Created by helloworld on 15/7/8.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "ZYHMunViewController.h"
#import "PublicAction.h"
#import "AFFNumericKeyboard.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ZYHMunViewController ()

@end

@implementation ZYHMunViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    UISegmentedControl * seg=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"聊天",@"通话", nil]];
    seg.segmentedControlStyle= UISegmentedControlStyleBar;//设置
    seg.tintColor= [UIColor colorWithRed:255/255.0 green:250/255.0 blue:250/255.0 alpha:0.8];
    seg.frame=CGRectMake(0, 0, KSCREENWIDTH/2, 28);
    [seg addTarget:self action:@selector(segChange:) forControlEvents:UIControlEventValueChanged];
    //seg.tintColor=[UIColor whiteColor];
    seg.selectedSegmentIndex=0;
    self.navigationItem.titleView=seg;
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    searchBar.placeholder = @"搜索";
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    searchBar.delegate=self;
    [self.view addSubview:searchBar];
    //清除SearchBar背景颜色
    [PublicAction clearSearchBarcolor:searchBar];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 48 - searchBar.frame.size.height )];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.tableFooterView=[[UIView alloc]init];
    [self.view addSubview:_tableView];
    [PublicAction tableViewCenter:_tableView];
}

-(BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return true;
}

-(void)segChange:(id)sender
{

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //[self.view reloadInputViews];
    // Do any additional setup after loading the view.
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.textLabel.text=@"111";
    return cell;
}

-(NSIndexPath *)tableView:(UITableView *)tableView
 willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [searchBar resignFirstResponder];
    return indexPath;
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
