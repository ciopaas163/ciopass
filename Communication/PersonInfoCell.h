//
//  PersonInfoCell.h
//  Communication
//
//  Created by helloworld on 15/7/20.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrganizationModel.h"
@interface PersonInfoCell : UITableViewCell
@property(strong, nonatomic) OrganizationModel * model;
@property (strong,nonatomic) NSString * title;
@property (strong,nonatomic) NSString * subtitle;
@property(strong, nonatomic)UILabel* _textLabel;

@property(strong, nonatomic)UILabel* _tetLabel;
@end
