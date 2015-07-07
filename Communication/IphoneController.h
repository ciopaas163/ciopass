//
//  IphoneController.h
//  Communication
//
//  Created by CIO on 15/2/9.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
@interface IphoneController : UIViewController

{
    UIButton* _btnReturn;  //返回
    
    UILabel*  _nameLabel;  //显示人名

    UILabel* _timerLabel;//显示通话时长；

    UIImageView* _headImage; //显示的头像名字

    UIButton* _btnHandsfree;//免提

    UIButton* _btnSilence;//静音

    UIButton* _btnFault;//挂断

    CTCallCenter *callCenter;
}
@property(nonatomic,strong)NSString * number;
@property(nonatomic,strong)NSString * name;
-(void)open;
@end
