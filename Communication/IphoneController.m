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
    [self usecall];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR(131, 189, 206, 1);

    /*
     UILabel*  _nameLabel;  //显示人名

     UILabel* _timerLabel;//显示通话时长；

     UIImageView* _headImage; //显示的头像名字

     UIButton* _btnHandsfree;//免提

     UIButton* _btnSilence;//静音

     UIButton* _btnFault;//挂断

     */
//    返回
    _btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnReturn.frame = CGRectMake(10, 25, 80, 40);
    [_btnReturn setImage:[UIImage imageNamed:@"呼入.png"] forState:UIControlStateNormal];
    [_btnReturn setTitle:@"返回" forState:UIControlStateNormal];
    _btnReturn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [_btnReturn setTitleColor:COLOR(16, 117, 224, 1) forState:UIControlStateNormal];
    [_btnReturn addTarget:self action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    _btnReturn.tag = 400;
    [self.view addSubview:_btnReturn];
//    显示人名
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 200/2, 50, 200, 40)];
    _nameLabel.text = @"联系人";
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:_nameLabel];

//    显示通话时长
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width /2 - 140/2, _nameLabel.frame.origin.x + 20 ,140, _nameLabel.frame.size.height)];
    _timerLabel.text = self.number;
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
    _btnFault.frame = CGRectMake(30, _headImage.frame.origin.y + _headImage.frame.size.height + 120 , self.view.frame.size.width - 30 *2, 45);
    [_btnFault setTitle:@"请返回等待" forState:UIControlStateNormal];
    _btnFault.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btnFault.titleLabel.font = [UIFont boldSystemFontOfSize:22];
    [_btnFault setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _btnFault.layer.borderWidth = 1;
//        _btnFault.layer.borderColor = [[UIColor whiteColor]CGColor];
    _btnFault.backgroundColor = COLOR(31, 151, 96, 1);
    _btnFault.layer.cornerRadius = 10;

    _btnFault.tag = 401;
    [_btnFault addTarget:self action:@selector(btnReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnFault];

    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(_btnFault.frame.origin.x , _btnFault.frame.origin.y - 60 , 250, 50)];
    textLabel.text = @"请稍后,您的电话很快会有来电,接听即可呼叫被叫方";
    textLabel.textColor = COLOR(236, 236, 236, 1);
    textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.font = [UIFont boldSystemFontOfSize:18];
    textLabel.numberOfLines = 0;
    textLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    [self.view addSubview:textLabel];

//    [self usecall];

}

-(void)usecall
{

    callCenter = [[CTCallCenter alloc] init];
    callCenter.callEventHandler=^(CTCall* call)
    {

        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            NSLog(@"Call has been disconnected");
            [self dismissViewControllerAnimated:NO completion:nil];

        }else{

            NSLog(@"Nothing is done");  
        }
    };
}
#pragma mark ---   [ UIButton ]
-(void)btnReturn:(UIButton*)btn{
    switch (btn.tag) {
        case 400:{
            NSLog(@"400");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
            break;
        case 401:{
            NSLog(@"401");
        }
            break;
        case 402:{
            NSLog(@"402");
            

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
