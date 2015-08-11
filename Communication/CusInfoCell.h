//
//  CusInfoCell.h
//  Communication
//
//  Created by helloworld on 15/7/21.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerModel.h"
@interface CusInfoCell : UITableViewCell<UITextFieldDelegate,UITableViewDelegate>
@property(strong, nonatomic) CustomerModel * model;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * subtitle;
@property(strong, nonatomic)UILabel* _textLabel;
@property(nonatomic,strong)UIButton * _telImage;
@property(strong, nonatomic)UITextField* _tetLabel;
@property(nonatomic,strong)NSString * telphoneNum;
@end
