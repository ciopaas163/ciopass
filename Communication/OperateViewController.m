//
//  OperateViewController.m
//  Communications
//
//  Created by helloworld on 15/1/29.
//  Copyright (c) 2015年 helloworld. All rights reserved.
//

#import "OperateViewController.h"
#import "OperateViewCell.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface OperateViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableData *_data;
}
@end

@implementation OperateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KSCREENWIDTH, KSCRENHEIGHT-94) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableHeaderFooterViewWithIdentifier:IDCell];
    if (cell==nil) {
        cell =  (OperateViewCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"OperateViewCell" owner:self options:nil]  lastObject];
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
