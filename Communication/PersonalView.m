//
//  PersonalView.m
//  Communication
//
//  Created by CIO on 15/2/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PersonalView.h"
#import "PersonViewCell.h"
#import "PersonViewTagCell.h"
@interface PersonalView ()
<UITextFieldDelegate,PersonTagDelegate>
{
    NSMutableArray * _unselectTags;
    
    UITableView * _infoTable;
    
    NSString * _tagText;
}

@end

@implementation PersonalView

- (id)initWithTags:(NSArray *)tags{
    if (self == [super init]) {
        _unselectTags = [NSMutableArray arrayWithArray:tags];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      self.title = @"添加个人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnButton:)];
    self.navigationItem.leftBarButtonItem.tag = 650;

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightButton:)];
    
    _tagText = @"";

    _infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, _navBar.frame.origin.y + _navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height- (_navBar.frame.origin.y + _navBar.frame.size.height))];
    _infoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _infoTable.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    _infoTable.backgroundColor = [UIColor clearColor];
    _infoTable.delegate = self;
    _infoTable.dataSource = self;
    [self.view addSubview:_infoTable];
}


#pragma mark 按钮
-(void)returnButton:(UIBarButtonItem*)leftbutton{

    NSLog(@"650:返回");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

   }

-(void)rightButton:(UIBarButtonItem*)right{
    NSLog(@"保存");
    
    PersonViewCell * name = (PersonViewCell *)[_infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    PersonViewCell * phone = (PersonViewCell *)[_infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    PersonViewCell * telPhone = (PersonViewCell *)[_infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    
    NSLog(@"%@",phone.field.text);
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:name.field.text forKey:NAME];
    [dict setObject:phone.field.text forKey:PHONE];
    [dict setObject:telPhone.field.text forKey:TELPHONE];
    [dict setObject:_tagText forKey:INFOTAG];
    
    [_delegate saveModel:dict withTag:_tagText];

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil
                                                   delegate:self cancelButtonTitle:nil
                                          otherButtonTitles: nil];
    //2秒钟后自动移除
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:1.5];
    [alert show];
}

// UIAlertView【2秒钟后自动移除】 移除方法
- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark 【 UITableView】
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int num = 0;
    
    switch (section) {
        case 0:
            num = 1;
            break;
        case 1:
            num = 3;
            break;
        case 2:{
            if ([_unselectTags count]) {
                num = 1;
            }
        }
            break;
        default:
            break;
    }
    return num;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat height = 0;
    if (indexPath.section == 0) {
        height = 44;
    }
    
    if (indexPath.section == 1) {
        height = 44;
    }
    
    if (indexPath.section == 2) {
        UIView * view = [self unselectTagView];
        height = view.bounds.size.height;
    }

    return height;
}

// tableView 头标的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 7;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * indentify = [NSString stringWithFormat:@"cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    
    if (indexPath.section == 0) {
        PersonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentify];
        if (!cell) {
            cell = [[PersonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
        }
        cell.title = @"姓名：";
        return cell;
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row < 2) {
            PersonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:indentify];
            if (!cell) {
                cell = [[PersonViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
            }
            NSArray * titles = @[@"手机：",@"电话："];
            cell.title = titles[indexPath.row];
            return cell;
        }else{
            PersonViewTagCell * cell = [tableView dequeueReusableCellWithIdentifier:indentify];
            if (!cell) {
                cell = [[PersonViewTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
            }
            cell.delegate = self;
            cell.tagText = _tagText;
            return cell;
        }
    }
    
    PersonViewTagCell * cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if (!cell) {
        cell = [[PersonViewTagCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }

    cell.unselectTagView = [self unselectTagView];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

//未添加标签View高度
- (UIView *)unselectTagView{
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
    view.backgroundColor = [UIColor whiteColor];
    
    NSString * text = @"未添加标签";
    CGFloat height = 44;
    CGRect rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, height)];
    label.text = text;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    CGFloat x = label.frame.origin.x + label.frame.size.width + 20;
    
    CGFloat viewHeight = 0.0f;
    
    CGFloat btnX = x;
    CGFloat centerY = height/2.0;
    for (int i = 0; i < [_unselectTags count]; i++) {
        
        text = _unselectTags[i];
        rect = [text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        
        if (btnX + rect.size.width > view.bounds.size.width - 20) {
            btnX = x;
            centerY += height;
        }
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnX, 0, rect.size.width, 30);
        button.center = CGPointMake(button.center.x, centerY);
        [button setTitle:text forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [[UIColor redColor] CGColor];
        [button addTarget:self action:@selector(selectTag:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        btnX = button.frame.origin.x + button.frame.size.width + 20;
        
        if (i == [_unselectTags count] - 1) {
            viewHeight = centerY + height/2.0 + 10;
        }
    }
    
    CGRect frame = view.frame;
    frame.size.height = viewHeight;
    view.frame = frame;
    
    return view;
}

//删除tag
- (void)delegateTag{
    [_unselectTags addObject:_tagText];
    
    _tagText = @"";
    [_infoTable reloadData];
}

- (void)selectTag:(UIButton *)btn{
    if (_tagText.length) {
        [_unselectTags addObject:_tagText];
    }
    [_unselectTags removeObject:btn.titleLabel.text];
    
    _tagText = btn.titleLabel.text;
    
    [_infoTable reloadData];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
