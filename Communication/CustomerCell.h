//
//  CustomerCell.h
//  Communication
//
//  Created by CIO on 15/3/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CusModel.h"
@interface CustomerCell : UITableViewCell

@property(nonatomic,strong)CusModel* model;
@property(nonatomic,strong)UIImageView* _imgBiao;
@property(nonatomic,strong)UIButton * _telImage;

@property(nonatomic,strong)UILabel* _textLabel;
@property(nonatomic,strong)NSString * textstr;
@property(nonatomic,strong)NSString * telphoneNum;
@end
