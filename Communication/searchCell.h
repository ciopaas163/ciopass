//
//  searchCell.h
//  Communication
//
//  Created by helloworld on 15/8/12.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface searchCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@property (weak, nonatomic) IBOutlet UILabel *acctitle;

- (IBAction)dialTap:(UIButton *)sender;
@end
