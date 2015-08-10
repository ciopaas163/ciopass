//
//  IphoneController.m
//  Communication
//
//  Created by CIO on 15/2/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "IphoneController.h"
#import "Header.h"


@interface IphoneController ()

@end
@implementation IphoneController
-(void)viewWillAppear:(BOOL)animated
{
    [timer setFireDate:[NSDate distantPast]];
    //[self usecall];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"enterprisedial_backgroup.png"]];
    
    currImg=1;
    _btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnReturn.frame = CGRectMake(0, 20, 40, 40);
    [_btnReturn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    _btnReturn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_btnReturn setTitleColor:COLOR(16, 117, 224, 1) forState:UIControlStateNormal];
    [_btnReturn addTarget:self action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    _btnReturn.tag = 400;
    [self.view addSubview:_btnReturn];
//    显示人名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 200/2, 60, 200, 30)];
    //_nameLabel.text = @"联系人";
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor=[UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_nameLabel];
    
    _telephoneNum = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 90, 200, 30)];
    _telephoneNum.text = self.number;
    _telephoneNum.backgroundColor = [UIColor clearColor];
    _telephoneNum.textColor=[UIColor whiteColor];
    _telephoneNum.textAlignment = NSTextAlignmentCenter;
    _telephoneNum.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_telephoneNum];
    
    _location = [[UILabel alloc] initWithFrame:CGRectMake(_nameLabel.frame.origin.x, 120, 200, 30)];
    _location.text = self.address;
    _location.backgroundColor = [UIColor clearColor];
    _location.textColor=[UIColor whiteColor];
    _location.textAlignment = NSTextAlignmentCenter;
    _location.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:_location];
    
//    显示通话时长
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 140/2, _nameLabel.frame.origin.x + 20 ,140, _nameLabel.frame.size.height)];
    //_timerLabel.text = self.number;
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.font = [UIFont systemFontOfSize:20];
    _timerLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_timerLabel];
//    显示的头像图片
    _headImage = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width /2 - 120/2, _nameLabel.frame.origin.y + _nameLabel.frame.size.height + 80, 120, 120)];
    _headImage.image = [UIImage imageNamed:@"Client.png"];
    _headImage.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_headImage];

//      挂断
    _btnFault = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnFault.frame = CGRectMake((self.view.frame.size.width-180)/2, self.view.frame.size.height-70, 180, 35);
    [_btnFault setTitle:@"请关闭等待" forState:UIControlStateNormal];
    _btnFault.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnFault.layer.cornerRadius=35/2;
    _btnFault.titleLabel.font = [UIFont systemFontOfSize:20];
    _btnFault.titleLabel.textColor=[UIColor whiteColor];
    _btnFault.backgroundColor = COLOR(31, 151, 96, 1);
    _btnFault.tag=400;
    [_btnFault addTarget:self action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFault];

    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnFault.frame.origin.x , _btnFault.frame.origin.y - 80 , 200, 50)];
    textLabel.text = @"请稍后,您的电话很快会有来电,接听即可呼叫被叫方";
    textLabel.textColor = COLOR(236, 236, 236, 1);
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    [self.view addSubview:textLabel];
    
    
    UILabel* text= [[UILabel alloc] initWithFrame:CGRectMake(_btnFault.frame.origin.x , _btnFault.frame.origin.y -40 , 180, 40)];
    text.text = @"请返回等待";
    text.textColor = COLOR(236, 236, 236, 1);
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor clearColor];
    text.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:text];

    imageView=[[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-80)/2, (self.view.frame.size.height-160)/2, 80, 80)];
    imageView.image=[UIImage imageNamed:@"dialing1.png"];
    
    [self.view addSubview:imageView];
    
    UILabel* dial = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width-100)/2, self.view.frame.size.height/2, 100, 30)];
    dial.text = @"拨号中...";
    dial.textColor = [UIColor whiteColor];
    dial.textAlignment = NSTextAlignmentCenter;
    dial.backgroundColor = [UIColor clearColor];
    dial.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:dial];
    
   timer= [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(changeImg:) userInfo:nil repeats:YES];
    //[timer setFireDate:[NSDate distantPast]];
}


-(void)changeImg:(NSTimer *)sender
{
    if (currImg==3) {
        currImg=1;
    }else
        currImg++;
    imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"dialing%ld.png",currImg]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [timer setFireDate:[NSDate distantFuture]];
}

-(void)usecall
{

    callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call)
    {

        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else{
 
        }
    };
}
#pragma mark ---   [ UIButton ]
-(void)btnReturn:(UIButton*)btn{
    switch (btn.tag) {
        case 400:{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 401:{
        }
            break;
        case 402:{    

        }
            break;

        default:
            break;
    }
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
