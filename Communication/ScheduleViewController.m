//
//  ScheduleViewController.m
//  Communication
//
//  Created by helloworld on 15/2/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "ScheduleViewController.h"
#import "Header.h"
#import "ParticipantController.h" //参与者
#import "TargetViewController.h"  //目标客户

#import "Database.h"
#import "FMDatabase.h"
#import "ScheduleModel.h"

#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface ScheduleViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
{
    UITableView*  _tableView;
    NSMutableArray *_titleArray;
    NSMutableArray *_detailArray;
    UITextField *biaoTextfiled;
    UITextView *contentView;
    CGRect oldFrame_;
    NSUserDefaults *userDefaults;
    UIButton *menbut;
    
    NSString *timeStr;
    NSInteger row; //选中的cell
    
    NSString *stopStr;
    NSString *alertStr;
    NSString *beginStr;
    
    Database *db;  //数据库
 
    ScheduleModel *Schemodel;    //查询到得数据
    
    NSString *begintime;
    NSString *stoptime;
    NSString *alerttime;
    
    NSString *State;  //状态
    NSString *jishi;  //记事
    NSString *timeT;  //时间
    
    NSString *userType;
    
    NSString *Modular;   //日历模块
    
    
}
@property (nonatomic,strong)UIView *navigationbarView;
@end
@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTranslucent:NO];//默认带有一定透明效果，可以使用以下方法去除系统效果
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
    userType=[NSString stringWithFormat:@"1"];        //记事、提醒
    
    Modular = @"3";
    
    if ([userType isEqualToString:@"1"])
    {
        jishi = [NSString stringWithFormat:@"记事"];
    }
    else
    {
        jishi = [NSString stringWithFormat:@"提醒"];
        
    }

    NSString * timeTt = [self useNSDateFormatter:[NSDate date]]; //当前时间
    
    timeT =[NSString stringWithFormat:@"%d",[self useTime:timeTt]]; //当前时间时间戳
    
    if (self.sysID)
    {
        self.navigationItem.title = @"我的日程";
        
        UIButton *addButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREENWIDTH/6*5+10,7, 25, 25)];
        //    UIButton* addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        //    addButton.frame = CGRectMake(KSCREENWIDTH/6*5+20,12, 20, 20);
        [addButton setImage:[UIImage imageNamed:@"delete_btn_normal.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationController.navigationBar addSubview:addButton];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnBarbutn:)];
        
        db = [Database sharDatabase];   //数据库
        NSString *sql = [NSString stringWithFormat:@"select * from Schedule where sysID = %@",self.sysID];
        NSArray *seachArray =[db searchMovieByName:sql];
        
        Schemodel =(ScheduleModel *)seachArray[0];
       
    }else
    {
        self.title = @"通讯助手";
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(returnBarbutn:)];
    }

    _titleArray = [NSMutableArray arrayWithObjects:@"用户类型",@"任务类型",@"开始时间",@"结束时间",@"提醒时间",@"参与者",@"目标客户", nil];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStyleGrouped];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tag = 9;

    [self.view addSubview:_tableView];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    begintime = [dateFormatter stringFromDate:[self useTimeInterval:Schemodel.begin_time]];
    if ([Schemodel.stop_time isEqualToString:@"0"]) {
        Schemodel.stop_time = @"";
    }
    else
    {
        stoptime = [dateFormatter stringFromDate:[self useTimeInterval:Schemodel.stop_time]];
        NSLog(@"stop_time = %@",stoptime);
    }
    
    if ([Schemodel.alertTime isEqualToString:@"0"]) {
        Schemodel.alertTime = @"";
    }
    else
    {
         alerttime = [dateFormatter stringFromDate:[self useTimeInterval:Schemodel.alertTime]];
        NSLog(@"alert_time = %@",alerttime);
    }
    


   
}

#pragma mark 时间转换格式

-(NSString *)useNSDateFormatter:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //用[NSDate date]可以获取系统当前时间
    NSString *time = [dateFormatter stringFromDate:date];
    return time;

}

#pragma mark ---- returnBarbutn
-(void)returnBarbutn:(UIBarButtonItem*)left
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ----删除按钮

-(void)deleteButtonClick:(UIButton *)sender
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除该日程？" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles:@"取消", nil];
    [alertView show];
}

#pragma mark ----确认删除日历事件

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==0)
    {
        State =[NSString stringWithFormat:@"删除"];
       
        NSString *title =[NSString stringWithFormat:@"%@",biaoTextfiled.text];
        NSString *Calsql = [NSString stringWithFormat:@"INSERT INTO Calendar (title,State, time,jishi,Modular) VALUES('%@','%@','%@','%@','%@')",title,State,timeT,jishi,Modular];
        [[Database sharDatabase] addMovie:Calsql]; //日历记录，数据添加
        
        NSString* updateSql = [NSString stringWithFormat:@"delete from Schedule where sysID=%@",self.sysID];
        [[Database sharDatabase]deleteMovie:updateSql];
        [self dismissViewControllerAnimated:YES completion:nil];
        
       
    }
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDCell];
    }
    
    //先移除cell 中所有字控件
    for (UIView *subview in [cell.contentView subviews])
    {
        [subview removeFromSuperview];
    }
    if (indexPath.row < 2) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    
    UILabel *timeLable = [[UILabel alloc]initWithFrame:CGRectMake(80,8,150, 24)];
    timeLable.font = [UIFont systemFontOfSize:14];
    timeLable.textColor = [UIColor blackColor];
 
    if (indexPath.row==0)
    {

        QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId3"];
        QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId3"];
        [rb1 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [rb1 setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        [rb2 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [rb2 setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        [rb1 setChecked:YES];
        rb1.frame = CGRectMake(80,10,20, 20);
        rb2.frame = CGRectMake(150,10,20, 20);
        
        CGFloat rb1X = rb1.frame.origin.x+20;
        CGFloat rb2X = rb2.frame.origin.x+50;
        
        UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(rb1X,8,50, 24)];
        qianLable.font = [UIFont systemFontOfSize:14];
        qianLable.textColor = [UIColor blackColor];
        
        UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(rb2X,8,50, 24)];
        qianLabletwo.font = [UIFont systemFontOfSize:14];
        qianLabletwo.textColor = [UIColor blackColor];
        
        qianLable.text = @"企业用户";
        qianLabletwo.text = @"个人用户";
        
        rb1.frame = CGRectMake(80,10,20, 20);
        rb2.frame = CGRectMake(180,10,20, 20);
        qianLable.frame =CGRectMake(rb1X,8,60, 24);
        qianLabletwo.frame =CGRectMake(rb2X,8,60, 24);
        [cell.contentView addSubview:rb1];
        [cell.contentView addSubview:rb2];
        
        [cell.contentView addSubview:qianLable];
        [cell.contentView addSubview:qianLabletwo];
    }
    else if (indexPath.row==1)
    {
        QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId4"];
        QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId4"];
        [rb1 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [rb1 setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        [rb2 setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
        [rb2 setImage:[UIImage imageNamed:@"选中.png"] forState:UIControlStateSelected];
        [rb1 setChecked:YES];
        rb1.frame = CGRectMake(80,10,20, 20);
        rb2.frame = CGRectMake(150,10,20, 20);
        
        CGFloat rb1X = rb1.frame.origin.x+20;
        CGFloat rb2X = rb2.frame.origin.x+20;
        
        UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(rb1X,8,50, 24)];
        qianLable.font = [UIFont systemFontOfSize:14];
        qianLable.textColor = [UIColor blackColor];
        
        UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(rb2X,8,50, 24)];
        qianLabletwo.font = [UIFont systemFontOfSize:14];
        qianLabletwo.textColor = [UIColor blackColor];
        
        qianLable.text = @"记事";
        qianLabletwo.text = @"提醒";
        [rb1 setChecked:YES];
        [cell.contentView addSubview:rb1];
        [cell.contentView addSubview:rb2];
        
        [cell.contentView addSubview:qianLable];
        [cell.contentView addSubview:qianLabletwo];
    }
    else if (indexPath.row==2)
    {
        if (Schemodel.begin_time>0&&timeStr.length==0) {
            timeLable.text = begintime;
            beginStr = begintime;
        }
        else
        {
        timeLable.text = timeStr;
        beginStr = timeStr;
        }
        [cell.contentView addSubview:timeLable];
    }
    else if (indexPath.row==3)
    {
        if (Schemodel.stop_time>0&&timeStr.length==0) {
            timeLable.text = stoptime;
            beginStr = stoptime;
        }
        else
        {
            timeLable.text = timeStr;
            stopStr = timeStr;
        }
        [cell.contentView addSubview:timeLable];
    }
    else if (indexPath.row==4)
    {
        if (Schemodel.stop_time>0&&timeStr.length==0) {
            timeLable.text = alerttime;
            alertStr = alerttime;
        }
        else
        {
            timeLable.text = timeStr;
            alertStr = timeStr;
        }
        [cell.contentView addSubview:timeLable];
    }
    else
    {
        [cell.contentView addSubview:timeLable];
    }

    return cell;
}

#pragma mark 选择某一行

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 2) {
        return;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if (indexPath.row == 2) {
        
        [self  Timescrollbar:indexPath.row];
        
    }else if (indexPath.row == 3){
        NSLog(@"3333");
        [self  Timescrollbar:indexPath.row];

    }else if (indexPath.row == 4){
        NSLog(@"4444");
        [self  Timescrollbar:indexPath.row];

    }else if (indexPath.row == 5){
        NSLog(@"5555");
//        参与者
        ParticipantController* partion = [[ParticipantController alloc]init];
//        [self.navigationController presentViewController:partion animated:YES completion:nil];
        [self.navigationController pushViewController:partion animated:YES];
    }else if (indexPath.row == 6){
        NSLog(@"6666");
//        目标客户
        TargetViewController* target = [[TargetViewController alloc]init];
//        [self.navigationController presentViewController:target animated:YES completion:nil];
        [self.navigationController pushViewController:target animated:YES];
    }
//    NSLog(@"index = %ld",(long)indexPath.row);
}

#pragma mark 时间选择是阴影事件
-(void)usemenBut
{
    
}

#pragma mark ==== [  禁止某行触发事件 ]
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row>1)
    {
        return indexPath;
    }
    else{
        return nil;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-240-64)/5*2)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    CGFloat headerViewY = CGRectGetMidY(headerView.bounds);
    NSLog(@"yy = %f ",headerViewY);
    
    UILabel *nameLable = [[UILabel alloc]initWithFrame:CGRectMake(12,5, 40, 30)];
    nameLable.text = @"标题";

    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:nameLable];
    
    biaoTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(55, 5, KSCREENWIDTH-60, 30)];
    [biaoTextfiled setBorderStyle:UITextBorderStyleRoundedRect];
    [headerView addSubview:biaoTextfiled];
    
    UILabel *textLable = [[UILabel alloc]initWithFrame:CGRectMake(12,40, 40, 30)];
    textLable.text = @"内容";

    textLable.font = [UIFont systemFontOfSize:15];
    textLable.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:textLable];
    
    contentView = [[UITextView alloc]initWithFrame:CGRectMake(55,40, KSCREENWIDTH-60, (KSCREENHEIGHT-240-64)/5*2-45)];
    contentView.layer.borderWidth = 1.0f;
    contentView.font = [UIFont systemFontOfSize:16];
    contentView.layer.borderColor = [[UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1]CGColor];

    
    [headerView addSubview:contentView];
    if (self.sysID) {
        biaoTextfiled.text = Schemodel.title;
        contentView.text = Schemodel.content;
    }
    
    
    [self addKeyboardObserver];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(boardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [_tableView addGestureRecognizer:tapGestureRecognizer];
    return headerView;
    
}
#pragma mark 隐藏键盘
-(void)boardHide:(UITapGestureRecognizer*)tap
{
    [biaoTextfiled resignFirstResponder];
    [contentView resignFirstResponder];
    [self.view sendSubviewToBack:dateView];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, (KSCREENHEIGHT-240-64)/5*3)];
    footerView.backgroundColor = [UIColor whiteColor];
    NSArray *buttonArr = [NSArray arrayWithObjects:@"取消",@"确认",nil];
    for (NSInteger i=0; i<2; i++)
    {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(i*KSCREENWIDTH/4 + 40 + i*(40 + 40),10, KSCREENWIDTH/4, 40)];
        [button setTitle:buttonArr[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:16];
        button.tag = 10+i;

        [footerView addSubview:button];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return footerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-240-64)/5*2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (KSCREENHEIGHT-240-64)/5*3;
}
-(void)backButtonClick:(UIButton *)sender
{
    [biaoTextfiled resignFirstResponder];
    [contentView resignFirstResponder];
    [self popoverPresentationController];
}

#pragma mark  Schedule事件添加 确认、取消-------

-(void)buttonClick:(UIButton *)sender
{
    if (sender.tag ==10) {
        [biaoTextfiled resignFirstResponder];
        [contentView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else
    {
      

        
        NSString *begin = [NSString stringWithFormat:@"%d",[self useTime:beginStr]];
        if (begin.length==0) {
            return;
        }
        
        NSString *stop = [NSString stringWithFormat:@"%d",[self useTime:stopStr]];
        NSString *alert = [NSString stringWithFormat:@"%d",[self useTime:alertStr]];
        
        NSString *sid =[userDefaults objectForKey:@"nid"];
        NSString *sverify =[userDefaults objectForKey:@"verify"];
        
        NSString *title =[NSString stringWithFormat:@"%@",biaoTextfiled.text];
        NSString *content=[NSString stringWithFormat:@"%@",contentView.text];
        NSString *mid=[NSString stringWithFormat:@"0"];
        NSString *loginID=[NSString stringWithFormat:@"%@",sid];
        NSString *operateId=[NSString stringWithFormat:@"1"];
        NSString *stop_time=[NSString stringWithFormat:@"%@",stop];
        NSString *alertTime=[NSString stringWithFormat:@"%@",alert];      // 添加开始提醒时间
        NSString *begin_time=[NSString stringWithFormat:@"%@",begin];    // 添加开始时间
        NSString *task_tag=[NSString stringWithFormat:@"4"];
    
        NSString *SID=[NSString stringWithFormat:@"%@",sid];
        NSString *verify=[NSString stringWithFormat:@"%@",sverify];
        
        
        //修改事件
        if (self.sysID)
        {
             NSString* updateSql = [NSString stringWithFormat:@"UPDATE Schedule SET title = '%@',content = '%@', id ='%@',loginID = '%@' ,operateId = '%@',stop_time = '%@',alertTime = '%@',begin_time = '%@',task_tag = '%@',userType = '%@',SID = '%@',verify = '%@' WHERE sysID ='%@'",title,content,mid,loginID,operateId,stop_time,alertTime,begin_time,task_tag,userType,SID,verify,self.sysID];
             [[Database sharDatabase]updateMovie:updateSql];
            
            State = [NSString stringWithFormat:@"修改"];
            
        }
        else
        {
        //添加事件
             NSString *sql = [NSString stringWithFormat:@"INSERT INTO Schedule (title,content, id,loginID,operateId,stop_time,alertTime,begin_time,task_tag,userType,SID,verify) VALUES('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@')",title,content,mid,loginID,operateId,stop_time,alertTime,begin_time,task_tag,userType,SID,verify];
            
             [[Database sharDatabase] addMovie:sql]; //日历事件，数据添加
            
              State = [NSString stringWithFormat:@"新增"];
        }
    
        NSString *Calsql = [NSString stringWithFormat:@"INSERT INTO Calendar (title,State, time,jishi,Modular) VALUES('%@','%@','%@','%@','%@')",title,State,timeT,jishi,Modular];
        [[Database sharDatabase] addMovie:Calsql]; //日历记录，数据添加
        
        
        [biaoTextfiled resignFirstResponder];
        [contentView resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
        
    }
    
}

#pragma mark 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    NSLog(@"did selected radio:%@ groupId:%@", radio.titleLabel.text, groupId);
}
-(void)addKeyboardObserver
{
    //监听键盘弹起
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //监听键盘隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark     UITextField 方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
    return YES;
}

#pragma mark keyboard 键盘的出现和消失处理
- (void)keyboardHide:(NSNotification *)message
{
    NSDictionary *dict = message.userInfo;
    
    //获取键盘的动画参数
    NSNumber *duration = [dict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dict objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    _tableView.frame = self.view.bounds;
    // commit animations
    [UIView commitAnimations];
}

- (void)keyboardShow:(NSNotification *)message
{
    NSDictionary *dict = message.userInfo;
    
    id rectObject = [dict objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyBoardframe;
    //获取键盘的布局大小
    [rectObject getValue:&keyBoardframe];
    
    CGRect keyboardTypeViewFrame = oldFrame_;
    keyboardTypeViewFrame.origin.y -= keyBoardframe.size.height;
    
    //获取键盘的动画参数
    NSNumber *duration = [dict objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [dict objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    // animations settings
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    _tableView.frame = CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT-150);
    // commit animations
    [UIView commitAnimations];
}
#pragma mark ---  【 时间滚动栏  Timescrollbar 】

-(void)Timescrollbar:(NSInteger)indexPath{
    //    dateView  是放置 UIDatePicker和 确定取消button
    dateView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height / 1.8, self.view.frame.size.width, self.view.frame.size.height)];
    dateView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:dateView];
    
    _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, dateView.bounds.origin.y + 40 , dateView.frame.size.width , dateView.frame.size.height - 60)];
//    NSLog(@"kuan:%f",_datePicker.frame.size.height);
    _datePicker.backgroundColor = [UIColor whiteColor];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_datePicker addTarget:self action:@selector(datePickChanged:) forControlEvents:UIControlEventValueChanged];
    _datePicker.userInteractionEnabled = YES;
    [dateView addSubview:_datePicker];
    
    //被选中的行
    row = indexPath;
    //确定
    NSArray* btnText = @[@"确定",@"取消"];
    for (int i = 0; i <2; i++) {
        btncancel = [UIButton buttonWithType:UIButtonTypeCustom];
        btncancel.frame = CGRectMake( 25 + i * (50 + 172), dateView.bounds.origin.y , 50, 30);
        btncancel.backgroundColor = [UIColor clearColor];
        [btncancel setTitle:btnText[i] forState:UIControlStateNormal];
        [btncancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        btncancel.tag = 600+i ;
        [btncancel addTarget:self action:@selector(btnDateTrmer:) forControlEvents:UIControlEventTouchUpInside];
        [dateView addSubview:btncancel];
    }
    
}

#pragma mark === [datePickChanged  时间 ]
-(void)datePickChanged:(UIDatePicker*)datepick{
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datepick.date];
    
    _strTimer = [NSString stringWithFormat:@"%ld-%ld-%ld %ld:%ld:00",(long)[components year],(long)[components month],(long)[components day],(long)[components hour],(long)[components minute]];
    
    NSLog(@"时间:%@",_strTimer);
    
    [_btnTimer setTitle:_strTimer forState:UIControlStateNormal];
    
}
-(void)btnDateTrmer:(UIButton*)timerDetermine
{
    if(timerDetermine.tag==600)
    {
        timeStr = _strTimer;
        NSIndexPath *indexPath_1=[NSIndexPath indexPathForRow:row inSection:0];
            NSArray *indexArray=[NSArray arrayWithObject:indexPath_1];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationAutomatic];
    }
     [dateView removeFromSuperview];
    
}

#pragma mark 时间转时间戳

-(int)useTime:(NSString *)str
{
//    NSLog(@"开始时间 = %@",str);
    
    //将传入时间转化成需要的格式
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *fromdate=[format dateFromString:str];
//    NSTimeZone *fromzone = [NSTimeZone systemTimeZone];
//    NSInteger frominterval = [fromzone secondsFromGMTForDate: fromdate];
//    NSDate *fromDate = [fromdate dateByAddingTimeInterval: frominterval];

//    //时间转时间戳

    NSTimeInterval timeInterval2 = (int)[fromdate timeIntervalSince1970];
//    NSLog(@"时间戳 = %d",(int)timeInterval2);
    
//    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval2];
//    NSLog(@" 时间1 = %@",date2);
    
    return timeInterval2;
}

-(NSDate *)useTimeInterval:(NSString *)str
{
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:[str doubleValue]];
    return date2;
}

#pragma mark - Navigation

//    NSInteger io = [self useTime:[NSString stringWithFormat:@"2015-03-05 00:00:00"]];
//
//    NSInteger ik = [self useTime:[NSString stringWithFormat:@"2015-03-05 08:10:20"]];
//
//    NSInteger uc = [self useTime:[NSString stringWithFormat:@"2015-03-06 00:00:00"]];
//
//    NSLog(@"iooooo = %ld",(long)io); // io =  1425513600
//
//    NSLog(@"ikkkkk = %ld",(long)ik);  //ik - io = 29420  ik = 1425543020
//
//    NSLog(@"uccccc = %ld",(long)uc);  //uc - io =86400   uc = 1425600000

//  2015-3-5 0:1:00
//  2015-3-5 9:56:00
//  2015-3-4 7:57:00
//  2015-3-9 8:58:00
//  2015-3-6 0:1:00

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



@end
