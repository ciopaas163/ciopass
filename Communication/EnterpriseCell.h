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
{
    UIImageView* _imgBiao;

    UILabel* _textLabel;
    UILabel* _tetLabel;
}

@property(strong, nonatomic)DatabaseModel* model;

//@property(strong, nonatomic)KeHuModel* kehumodel;

@end
