//
//  EnterpriseCell.h
//  Communication
//
//  Created by CIO on 15/2/26.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DatabaseModel.h"
@interface EnterpriseCell : UITableViewCell
@property(strong, nonatomic) NSString * model;
@property(strong,nonatomic)NSString * umodel;
@property(strong,nonatomic)NSString * text;
@property(strong,nonatomic)UIImageView* _imgBiao;
@property(strong, nonatomic)UILabel* _textLabel;

@property(strong, nonatomic)UILabel* _tetLabel;
@property(strong, nonatomic)UILabel *_tet;

@end

