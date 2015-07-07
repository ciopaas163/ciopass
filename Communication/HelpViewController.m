//
//  HelpViewController.m
//  Communication
//
//  Created by helloworld on 15/2/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "HelpViewController.h"
#import "Cell1.h"
#import "Cell2.h"
#import "Header.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height
@interface HelpViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableData *_data;
    NSMutableArray *_titleArray;
    NSMutableArray *_contentArray;
     NSMutableArray *_dataList;
}
@property (assign)BOOL isOpen;
@property (nonatomic,retain)NSIndexPath *selectIndex;
@property (nonatomic,strong)UITableView *expansionTableView;
@end

@implementation HelpViewController


-(void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
//    [self usenavigationbarView];

//    //如何注册企业账号 ？ 请前往网址 http://open.ciopass.com/Admin/Register/index 进行企业用户注册，如何添加组织机构里的联系人 ？ 请在Web后台企业管理-组织结构管理中添加;如何添加个人通讯录？请在个人通讯录界面右上角点击添加个人，或者在手机通讯录中选择联系人点击右上角导入选择导入个人通讯录
//    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助";
    self.isOpen = NO;
    self.selectIndex = nil;
    _dataArray = [[NSMutableArray alloc]init];
    _data = [[NSMutableData alloc]init];
    
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"ExpansionTableTestData" ofType:@"plist"];
    _dataList = [[NSMutableArray alloc] initWithContentsOfFile:path];

    
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KSCREENWIDTH, 30)];
    headView.backgroundColor = COLOR(192, 208, 213, 1);
    UILabel *headLable = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 100, 26)];
    headLable.text = @"常见问题";
    headLable.textColor = [UIColor whiteColor];
    
    [headView addSubview:headLable];
    [self.view addSubview:headView];
    
    self.expansionTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,94, KSCREENWIDTH, KSCRENHEIGHT) style:UITableViewStylePlain];
    self.expansionTableView.delegate = self;
    self.expansionTableView.dataSource = self;
    [self.view addSubview:self.expansionTableView];
    self.expansionTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];

    
}

#pragma mark 导航
-(void)usenavigationbarView
{
    [self.navigationController.navigationBar setHidden:YES];
    UIView * navigationbarView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, KSCREENWIDTH, 44)];
    navigationbarView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:169.0/255.0 blue:224.0/255.0 alpha:1];
    [self.view addSubview:navigationbarView];
    
    UILabel *titleButton = [[UILabel alloc]initWithFrame:CGRectMake(KSCREENWIDTH/2-KSCREENWIDTH/6,4,KSCREENWIDTH/3, 36)];
    //    timeButton.backgroundColor = [UIColor redColor];
    titleButton.textAlignment = NSTextAlignmentCenter;
    titleButton.textColor = [UIColor whiteColor];
    [titleButton setText:@"我的资料"];
    [navigationbarView addSubview:titleButton];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 12, 20, 20)];
    [backButton setImage:[UIImage imageNamed:@"返回.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationbarView addSubview:backButton];
    
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataList count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isOpen) {
        if (self.selectIndex.section ==section) {
            return [[[_dataList objectAtIndex:section] objectForKey:@"list"] count]+1;;
        }
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
         return 70;
    }
    else
    {
        return 45;
    }
   
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isOpen&&self.selectIndex.section == indexPath.section&&indexPath.row!=0) {
        static NSString *CellIdentifier = @"Cell2";
        Cell2 *cell = (Cell2*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSArray *list = [[_dataList objectAtIndex:self.selectIndex.section] objectForKey:@"list"];
        cell.titleLabel.text = [list objectAtIndex:indexPath.row-1];
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"Cell1";
        Cell1 *cell = (Cell1*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:CellIdentifier owner:self options:nil] objectAtIndex:0];
        }
        NSString *name = [[_dataList objectAtIndex:indexPath.section] objectForKey:@"name"];
        cell.titleLabel.text = name;
        [cell changeArrowWithUp:([self.selectIndex isEqual:indexPath]?YES:NO)];
        return cell;
    }
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([indexPath isEqual:self.selectIndex]) {
            self.isOpen = NO;
            [self didSelectCellRowFirstDo:NO nextDo:NO];
            self.selectIndex = nil;
            
        }else
        {
            if (!self.selectIndex) {
                self.selectIndex = indexPath;
                [self didSelectCellRowFirstDo:YES nextDo:NO];
                
            }else
            {
                
                [self didSelectCellRowFirstDo:NO nextDo:YES];
            }
        }
        
    }else
    {
//        NSDictionary *dic = [_dataList objectAtIndex:indexPath.section];
//        NSArray *list = [dic objectForKey:@"list"];
//        NSString *item = [list objectAtIndex:indexPath.row-1];

    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didSelectCellRowFirstDo:(BOOL)firstDoInsert nextDo:(BOOL)nextDoInsert
{
    self.isOpen = firstDoInsert;
    
    Cell1 *cell = (Cell1 *)[self.expansionTableView cellForRowAtIndexPath:self.selectIndex];
    [cell changeArrowWithUp:firstDoInsert];
    
    [self.expansionTableView beginUpdates];
    
    int section =(int) self.selectIndex.section;
    int contentCount = [[[_dataList objectAtIndex:section] objectForKey:@"list"] count];
    NSMutableArray* rowToInsert = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < contentCount + 1; i++) {
        NSIndexPath* indexPathToInsert = [NSIndexPath indexPathForRow:i inSection:section];
        [rowToInsert addObject:indexPathToInsert];
    }
    
    if (firstDoInsert)
    {   [self.expansionTableView insertRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    else
    {
        [self.expansionTableView deleteRowsAtIndexPaths:rowToInsert withRowAnimation:UITableViewRowAnimationTop];
    }
    
    
    [self.expansionTableView endUpdates];
    if (nextDoInsert) {
        self.isOpen = YES;
        self.selectIndex = [self.expansionTableView indexPathForSelectedRow];
        [self didSelectCellRowFirstDo:YES nextDo:NO];
    }
    if (self.isOpen) [self.expansionTableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(void)leftButtonClick:(UIBarButtonItem *)backItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
