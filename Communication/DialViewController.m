//
//  DialViewController.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "DialViewController.h"
#import "Header.h"    //宏
#import "IphoneController.h"
#import "AFNetworking.h"
#import "SGInfoAlert.h"
@interface DialViewController ()//<NSURLConnectionDataDelegate>
{
    
    UILabel * _label;
    NSMutableData *data_;
    NSString *userid;
    NSString *nid;
    NSString *eid;
    NSString *verify;
    NSString *Num;
    NSUserDefaults *userDefaults;
    NSString *urlStr;
    
    IphoneController* iphone;
}

@end

@implementation DialViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通讯助手";
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];

    data_ = [[NSMutableData alloc]init];
    userDefaults = [NSUserDefaults standardUserDefaults];

    _label = [[UILabel alloc] initWithFrame:CGRectMake(40, _navBar.frame.origin.y + _navBar.frame.size.height, self.view.frame.size.width - 40*2, 40)];
    _label.text = @"";
    _label.textAlignment = NSTextAlignmentCenter;
    _label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_label];


    _mobileVie = [[UIView alloc] initWithFrame:CGRectMake(30,_label.frame.origin.y + _label.frame.size.height, self.view.frame.size.width - 30*2, self.view.frame.size.height - (_navBar.frame.size.height + _label.frame.size.height + _navBar.frame.size.height))];
    _mobileVie.backgroundColor = [UIColor clearColor];
    [self.view  addSubview:_mobileVie];

    //      创建联系人
    _btnAdd = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _btnAdd.frame = CGRectMake(0, _navBar.frame.origin.y + _navBar.frame.size.height, 40, 40);
    _btnAdd.tag = 200;
    [_btnAdd addTarget:self action:@selector(buttonAdd:) forControlEvents:UIControlEventTouchUpInside];
    _btnAdd.hidden = YES;
    [self.view addSubview:_btnAdd];


    //      号码删除按键
    _btnDelete = [UIButton buttonWithType:UIButtonTypeInfoDark];
    _btnDelete.frame = (CGRectMake(_label.frame.origin.x + _label.frame.size.width, _label.frame.origin.y, self.view.frame.size.width - _label.frame.size.width - 40, _label.frame.size.height));
    _btnDelete.tag = 201;
    _btnDelete.hidden = YES;
    [_btnDelete addTarget:self action:@selector(buttonAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnDelete];



    for (int i  = 0; i < 13; i++) {
        _btnNumber = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnNumber.frame = (CGRectMake(_mobileVie.bounds.origin.x + 15 +(i%3)*85, _mobileVie.bounds.origin.y  +(i/3) * 65, 58, 58));
//        btnNumber.backgroundColor = COLOR(91, 213, 249, 1);
//        _btnNumber.backgroundColor = [UIColor blackColor];
        _btnNumber.layer.borderColor = [COLOR(91, 213, 249, 1)CGColor];
        _btnNumber.layer.borderWidth = 1;
        _btnNumber.layer.cornerRadius = 58/2;
        _btnNumber.layer.masksToBounds = YES;
        [_btnNumber setShowsTouchWhenHighlighted:YES];
        [_mobileVie addSubview:_btnNumber];

//        NSArray * iphoneArray = @[@"x",@""];
        NSString * title = [NSString stringWithFormat:@"%d",i+1];
//        NSString* delete = [NSString stringWithFormat:@"%d",i +1];
        if (i == 9) {
            title = @"*";
        }
        if (i == 10) {
            title = @"0";
        }
        if (i == 11) {
            title = @"#";
        }
//        if (i == 12) {
//            title = @"+";
//        }
        if (i == 12) {
            _btnNumber.center = CGPointMake(_mobileVie.bounds.origin.x + 15 + ((_btnNumber.frame.size.height)*3 + 25*2)/2, _btnNumber.center.y);
            title = @"呼叫";

//            [btnNumber setImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];

        }
//        if (i == 14) {
//            title = @"x";
//        }
        _btnNumber.tag = i + 100;
        _btnNumber.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_btnNumber setTitle:title forState:UIControlStateNormal];
        _btnNumber.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_btnNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_btnNumber addTarget:self action:@selector(buttonAdd:) forControlEvents:UIControlEventTouchUpInside];
    }
     NSArray* abcArray = @[@"ABC",@"DEF",@"GHI",@"JKL",@"MNO",@"PQRS",@"TUV",@"WXYZ"];
    for (int j = 1; j < 9; j++) {
        _abcLabel = [[UILabel alloc]initWithFrame: (CGRectMake(_mobileVie.bounds.origin.x + 15 +(j%3)*85, _mobileVie.bounds.origin.y  +(j/3) * 65 + 15, 58, 58))];

        _abcLabel.text = abcArray[j - 1];
        _abcLabel.font = [UIFont systemFontOfSize:9];
        _abcLabel.textAlignment = NSTextAlignmentCenter;
        [_mobileVie addSubview:_abcLabel];

    }
}

#pragma mark ---  【call  删除  添加  [拨打电话] 】
-(void)buttonAdd:(UIButton *)add{
    
     _str = [[NSMutableString alloc] initWithString:_label.text];
    if (add.tag < 100 + 12) {

        [_str insertString:add.titleLabel.text atIndex:_str.length];
          NSLog(@"Number:\t%@",add.titleLabel.text);
    }

//    else if(add.tag == 112){
//        NSLog(@"112");
//
//    }
    else if (add.tag == 112) {
        
        NSLog(@"Call");
        _callActionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人直接拨号",@"企业云通讯",@"个人云通讯", nil];
        _callActionsheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        _callActionsheet.tag = 300;
        [_callActionsheet showInView:self.view];

    }else if (add.tag == 114){
        NSLog(@"114");
    }else if (add.tag == 200) {
        NSLog(@"添加");

         _actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"新建联系人", @"添加到现有联系人",@"添加到客户联系人",nil];
        _actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        _actionSheet.tag = 301;
        [_actionSheet showInView:self.view];

    }else if (add.tag == 201){
        NSLog(@"删除");
          if (_str.length > 0) {
            NSLog(@"kds");
            [_str deleteCharactersInRange:NSMakeRange(_str.length-1, 1)];
        }
    }
    _label.text = _str;
    _label.font = [UIFont boldSystemFontOfSize:20];

    if (_label.text != nil &&![_label.text isEqualToString:@""]) {
        _btnAdd.hidden = NO;
        _btnDelete.hidden = NO;
    }else {
        _btnDelete.hidden =YES;
        _btnAdd.hidden = YES;
    }
    
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    userid = [userDefaults stringForKey:@"userid"];
    nid = [userDefaults stringForKey:@"nid"];
    eid = [userDefaults stringForKey:@"eid"];
    verify = [userDefaults stringForKey:@"verify"];
    Num = [userDefaults stringForKey:@"Num"];
    
    NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"%@\"}]}",Num,_str,userid];
    NSLog(@"nsdic = %@",nsdic);
    
    NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    


    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (actionSheet.tag ==300) {
            if (buttonIndex == 0) {

                NSLog(@"个人直接拨号");
                UIWebView* callwebView = [[UIWebView alloc] init];
                NSURL* telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_str]];
                [callwebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
                [self.view addSubview:callwebView];

            }
            else if (buttonIndex == 1)
            {
                NSLog(@"企业云通讯");
                NSLog(@"个人云通讯");
                NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"\"}]}",_str,Num];
                NSLog(@"nsdic = %@",nsdic);

                NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                urlStr =[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid&id=%@&from=2&telephonenumber=%@&eid@&verify=%@",nid,data,verify];
                NSLog(@"str = %@",urlStr);
                [self get4];

//                urlStr =[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid=%@&id=%@&from=2&telephonenumber=%@&eid=%@&verify=%@",userid,nid,data,eid,verify];
//                [self get4];
            }
            else if (buttonIndex == 2)
            {
                
                NSLog(@"个人云通讯");
                NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"\"}]}",_str,Num];
                NSLog(@"nsdic = %@",nsdic);
                
                NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                 urlStr =[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid&id=%@&from=2&telephonenumber=%@&eid@&verify=%@",nid,data,verify];
                NSLog(@"str = %@",urlStr);
                [self get4];
     
            }
            else if (buttonIndex == 3)
            {

                NSLog(@"取消:0");
            }

        }else if (actionSheet.tag == 301)
        {

            if (buttonIndex == 0) {
                NSLog(@"新建联系人");
            }else if (buttonIndex == 1){
                NSLog(@"添加到现有联系人");
            }else if (buttonIndex == 2){
                NSLog(@"添加到客户联系人:1");
            }else if (buttonIndex == 3){
                NSLog(@"取消:1");
            }

        }
    }
}
-(void)get4
{
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //json解析数据
         
         NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *money=[NSString stringWithFormat:@"%@",[Dic objectForKey:@"post_data_result"]];
         NSLog(@"Dic = %@",Dic);
         NSString *resulterr = @"1";
         if([money isEqualToString:resulterr])
         {
             IphoneController *vc = [[IphoneController alloc]init];
             vc.number = _label.text;
             [self presentViewController:vc animated:YES completion:nil];
         }
         else
         {
             [SGInfoAlert showInfo:@"拨号有误"
              
                           bgColor: [UIColor orangeColor].CGColor
              
                            inView:self.view
              
                          vertical:0.8];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"%@",error);
     }];
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"取消");
    }else if (buttonIndex == 1){
        NSLog(@"确定");
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}



#pragma mark 按钮
-(void)returnButton:(UIBarButtonItem*)leftbutton{
    NSLog(@"返回");
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
