//
//  CommunicationSetupViewController.m
//  Communication
//
//  Created by helloworld on 15/2/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CommunicationSetupViewController.h"
#import "QRadioButton.h"
#define KSCREENWIDTH  [[UIScreen mainScreen]bounds].size.width
#define KSCREENHEIGHT [[UIScreen mainScreen]bounds].size.height
@interface CommunicationSetupViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    QRadioButton *rb1;

    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation CommunicationSetupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];

    self.title = @"通讯设置";
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonClick:)];
    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, KSCREENHEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];

}

#pragma mark 返回

-(void)leftButtonClick:(UIButton*)backButton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(8,8,KSCREENWIDTH/2, 26)];
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = [UIColor blackColor];
    
    UILabel *ttLable = [[UILabel alloc]initWithFrame:CGRectMake(115+KSCREENWIDTH/4,8, 30, 26)];
    ttLable.font = [UIFont systemFontOfSize:14];
    [ttLable setText:@"后缀"];
    ttLable.textColor = [UIColor blackColor];
    
    UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(8,8,KSCREENWIDTH/4+35, 26)];
    qianLable.font = [UIFont systemFontOfSize:14];
    qianLable.textColor = [UIColor blackColor];
    
    UITextField* ttField = [[UITextField alloc] initWithFrame:CGRectMake(150+KSCREENWIDTH/4,8,KSCREENWIDTH/4, 26 )];
    ttField.borderStyle = UITextBorderStyleRoundedRect;
    
    
    if (indexPath.section==0)
    {
        titleLable.text = @"云通信被叫显号设置";
        rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId1"];
        [rb1 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb1 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        [rb2 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb2 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        
        [rb1 setChecked:YES];
        rb1.frame = CGRectMake(13,50,20, 20);
        
        rb2.frame = CGRectMake(80,50,20, 20);
        
        CGFloat rb1X = rb1.frame.origin.x+20;
        CGFloat rb2X = rb2.frame.origin.x+20;
        
        UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(rb1X,48,50, 24)];
        qianLable.font = [UIFont systemFontOfSize:14];
        qianLable.textColor = [UIColor blackColor];
        
        UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(rb2X,48,50, 24)];
        qianLabletwo.font = [UIFont systemFontOfSize:14];
        qianLabletwo.textColor = [UIColor blackColor];
        
        qianLable.text = @"手机号";
        qianLabletwo.text = @"固话号";
        [cell.contentView addSubview:rb1];
        [cell.contentView addSubview:rb2];
        [cell.contentView addSubview:qianLable];
        [cell.contentView addSubview:qianLabletwo];
        [cell.contentView addSubview:titleLable];
    }

    else
    {
        UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(28,88,KSCREENWIDTH/4+35, 26)];
        qianLabletwo.font = [UIFont systemFontOfSize:14];
        qianLabletwo.textColor = [UIColor blackColor];
        
        QRadioButton *rb3 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId2"];
        QRadioButton *rb4 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId2"];
        [rb3 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb3 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        [rb4 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb4 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        [rb3 setChecked:YES];
        rb3.frame = CGRectMake(8,50,20, 20);
        rb4.frame = CGRectMake(8,88,20, 20);
        
        titleLable.text = @"设置默认拨号方式";
        qianLable.text = @"直接拨号";
        qianLabletwo.text =  @"云通信（个人)";
        qianLable.frame = CGRectMake(28,48,KSCREENWIDTH/4, 26);
        
        [cell.contentView addSubview:rb3];
        [cell.contentView addSubview:rb4];
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:qianLable];
        [cell.contentView addSubview:qianLabletwo];
        
    }
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return 80;
    }
    else
    {
    return 120;
    }
}


#pragma mark UITableViewDelegate,UITableViewDataSource


/*
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 2;
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *IDCell = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDCell];
    if (cell==nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IDCell];
    }
    
    UITextField* textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 8,KSCREENWIDTH/4, 26)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.delegate = self;
    
    UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(8,8,KSCREENWIDTH/2, 26)];
    titleLable.font = [UIFont systemFontOfSize:16];
    titleLable.textColor = [UIColor blackColor];
    
    UILabel *ttLable = [[UILabel alloc]initWithFrame:CGRectMake(115+KSCREENWIDTH/4,8, 30, 26)];
    ttLable.font = [UIFont systemFontOfSize:14];
    [ttLable setText:@"后缀"];
    ttLable.textColor = [UIColor blackColor];
    
    UILabel *qianLable = [[UILabel alloc]initWithFrame:CGRectMake(8,8,KSCREENWIDTH/4+35, 26)];
    qianLable.font = [UIFont systemFontOfSize:14];
    qianLable.textColor = [UIColor blackColor];
    
    UITextField* ttField = [[UITextField alloc] initWithFrame:CGRectMake(150+KSCREENWIDTH/4,8,KSCREENWIDTH/4, 26 )];
    ttField.borderStyle = UITextBorderStyleRoundedRect;


    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            qianLable.text = @"本地区号";
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:textField];
        }
        else if (indexPath.row==1)
        {
            qianLable.text = @"国际长途区号";
            textField.text=@"86";
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:textField];
        }
        else
        {
            qianLable.text = @"IP号码      前缀";
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:textField];
            [cell.contentView addSubview:ttLable];
            [cell.contentView addSubview:ttField];

        }
    }
    else if(indexPath.section==1)
    {
        if (indexPath.row ==0)
        {
            titleLable.text = @"设置加拨前缀";
            [cell.contentView addSubview:titleLable];
        }
        else if (indexPath.row==1)
        {
            qianLable.text = @"国际长途前缀";
            textField.text=@"00";
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:textField];
        }
        else
        {
            qianLable.text = @"国内长途前缀";
            textField.text=@"0";
            [cell.contentView addSubview:qianLable];
            [cell.contentView addSubview:textField];
        }
        
    }
    else
    {
        UILabel *qianLabletwo = [[UILabel alloc]initWithFrame:CGRectMake(28,88,KSCREENWIDTH/4+35, 26)];
        qianLabletwo.font = [UIFont systemFontOfSize:14];
        qianLabletwo.textColor = [UIColor blackColor];
        
        QRadioButton *rb1 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId2"];
        QRadioButton *rb2 = [[QRadioButton alloc] initWithDelegate:self groupId:@"groupId2"];
        [rb1 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb1 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        [rb2 setImage:[UIImage imageNamed:@"未选1.png"] forState:UIControlStateNormal];
        [rb2 setImage:[UIImage imageNamed:@"选中2.png"] forState:UIControlStateSelected];
        [rb1 setChecked:YES];
        rb1.frame = CGRectMake(8,50,20, 20);
        rb2.frame = CGRectMake(8,88,20, 20);

        titleLable.text = @"设置默认拨号方式";
        qianLable.text = @"直接拨号";
        qianLabletwo.text =  @"IP拨号";
        qianLable.frame = CGRectMake(28,48,KSCREENWIDTH/4, 26);
    
        [cell.contentView addSubview:rb1];
        [cell.contentView addSubview:rb2];
        [cell.contentView addSubview:titleLable];
        [cell.contentView addSubview:qianLable];
        [cell.contentView addSubview:qianLabletwo];

    }
 

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
  
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        if (indexPath.row==0)
        {
            return 120;
        }
    }
    return 45;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

 */
#pragma mark 按钮
-(void)clickButton:(UIBarButtonItem*)leftbutton
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 保存
-(void)rightButtonClick:(UIBarButtonItem *)saveItem
{
    
}
#pragma mark 单选
- (void)didSelectedRadioButton:(QRadioButton *)radio groupId:(NSString *)groupId {
    radio.selected = YES;
    
    
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
