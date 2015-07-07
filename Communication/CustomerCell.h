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
{
    UIImageView* _imgBiao;
    
    UILabel* _textLabel;
}
@property(nonatomic,strong)CusModel* model;

@end
