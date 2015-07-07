//
//  Personal.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Personal.h"
#import "PersonalView.h"
#import "MethodController.h"
#import "PersonCell.h"
#import "PersonTagBtn.h"
#import "Header.h"
@interface Personal ()

#define PERSONINFO  @"personInfo"
#define TAGS        @"tags"

<UISearchBarDelegate,PersonViewDelegate>

{
    NSMutableDictionary * _personInfo;
    NSMutableArray * _emptyTags;//未添加过信息的标签
    NSMutableArray * _tags;//所有标签
    
    NSUserDefaults * _defaults;
    
    UITableView * _personTable;
    NSMutableDictionary * _headerBtns;
}

@end

@implementation Personal


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人通讯录";
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnButton:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStyleDone target:self action:@selector(NavigationButton:)];
    [self.navigationItem setRightBarButtonItem:right];

    _defaults = [NSUserDefaults standardUserDefaults];
    
    _headerBtns = [NSMutableDictionary dictionary];
    
    [self getLocalInfo];
    [self personInfoTable];
}

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)getLocalInfo{
    NSDictionary * dict = [_defaults objectForKey:PERSONINFO];
    
    if (dict) {
        _personInfo = [NSMutableDictionary dictionaryWithDictionary:dict];
    }else{
        _personInfo = [NSMutableDictionary dictionary];
       
    }
    
    NSArray * tags = [_defaults objectForKey:TAGS];
    if (tags) {
        _tags = [NSMutableArray arrayWithArray:tags];
    }else{
        _tags = [NSMutableArray array];
    }
    
     _emptyTags = [NSMutableArray array];
    
    NSArray * infoTags = [_personInfo allKeys];//取出带有信息的tag
    NSLog(@"infoTags %@",infoTags);
    for (NSString * tag in _tags) {
        BOOL isExist = NO;//判断该tag是否带有信息
        for (NSString * infoTag in infoTags) {
            if ([tag isEqualToString:infoTag]) {
                isExist = YES;
                break;
            }
        }
        if (!isExist) {//如果该标签不存在信息，保存到数组
            [_emptyTags addObject:tag];
        }

    }
    
    NSLog(@"empty  %@",_emptyTags);
}

- (void)personInfoTable{
    _personTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + 44, self.view.bounds.size.width, self.view.bounds.size.height - 20 -44)];
    _personTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _personTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _personTable.backgroundColor = [UIColor clearColor];
    _personTable.dataSource = self;
    _personTable.delegate = self;
    [self.view addSubview:_personTable];
}

#pragma mark 按钮
-(void)returnButton:(UIBarButtonItem*)leftbutton{
    NSLog(@"返回");
    [self.navigationController popToRootViewControllerAnimated:YES];

}
-(void)NavigationButton:(UIBarButtonItem*)barbutton{
    NSLog(@"%%%%%%%%");
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"添加" message:nil
                                                   delegate:self cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"添加个人", @"添加标签",nil];

    alert.tag = 100;
    [alert show];


}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.tag == 100) {
            if (buttonIndex == 1){
                NSLog(@"as");
                PersonalView* perVcr = [[PersonalView alloc] initWithTags:_emptyTags];
                perVcr.delegate = self;
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:perVcr];
                [self presentViewController:nav animated:YES completion:nil];

            }else if (buttonIndex == 2){
                NSLog(@"cccc");
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"添加标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles: @"确认", nil];
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                alert.tag = 101;
                [alert show];
            }
        }
        
        if (alertView.tag == 101) {
            UITextField * field = (UITextField *)[alertView textFieldAtIndex:0];

            [_tags addObject:field.text];
            [_emptyTags addObject:field.text];
            [_personTable reloadData];
            
            [_defaults setObject:_tags forKey:TAGS];
            [_defaults synchronize];
        }
    }
}

#pragma mark  【 UITableView 】
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"tags %@",_tags);
    return [_tags count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    
    PersonTagBtn * header = (PersonTagBtn *)[_headerBtns objectForKey:@(section)];
    //如果展开状态为NO，则不显示信息栏
    if (!header.selected) {
        num = 0;
    }else{
        NSString * tag = _tags[section];//取出当前section标签
        NSDictionary * dict = [_personInfo objectForKey:tag];//根据标签取出对应model
        NSLog(@"存在信息的标签 %@",dict);
        if (dict) {//如果Model存在，显示出来
            num = 1;
        }
    }
    
    return num;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

//每行返回的高度；
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    PersonTagBtn * header = (PersonTagBtn *)[_headerBtns objectForKey:@(section)];
    
    if (!header) {
        header = [PersonTagBtn buttonWithType:UIButtonTypeCustom];
        header.frame = CGRectMake(0, 0, tableView.bounds.size.width, 40);
        [header setTitle:_tags[section] forState:UIControlStateNormal];
        [header setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        header.index = 100 + section;
        header.backgroundColor = [UIColor whiteColor];
        [header addTarget:self action:@selector(showPersonInfo:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, header.bounds.size.height - 1, header.bounds.size.width, 0.6)];
        line.backgroundColor = COLOR(166, 166, 166, 1);
        [header addSubview:line];
    }
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * indetify=@"cell";
    PersonCell *cell=[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell=[[PersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    
    NSString * tag = _tags[indexPath.section];//取出当前section标签
    NSDictionary * dict = [_personInfo objectForKey:tag];//根据标签取出对应model
    cell.dict = dict;
    
    return cell;
}

#pragma mark ----  【 删除cell行的方法】
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
    }
    
}

#pragma mark 点击标签 展开信息栏
- (void)showPersonInfo:(UIButton *)btn{
    btn.selected = !btn.selected;
    PersonTagBtn * button = (PersonTagBtn *)btn;
    
    [_headerBtns setObject:button forKey:@(button.index - 100)];
    
    [_personTable reloadData];
}

//保存信息
- (void)saveModel:(NSDictionary *)dict withTag:(NSString *)tag{
    [_personInfo setObject:dict forKey:tag];
    
    [_emptyTags removeObject:tag];
    
    NSLog(@"%@",_personInfo);
    
    [_defaults setObject:_personInfo forKey:PERSONINFO];
    [_defaults synchronize];
    
    [_personTable reloadData];
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
