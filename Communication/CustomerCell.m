//
//  CustomerCell.m
//  Communication
//
//  Created by CIO on 15/3/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(CusModel *)model{
    if (_model != model) {
        _model = model;
        _textLabel.text = model.groupname;
        NSLog(@"model.groupname:%@",model.groupname);
    }
    
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}
-(void)content{
    _imgBiao = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    _imgBiao.backgroundColor = [UIColor clearColor];
    _imgBiao.image = [UIImage imageNamed:@"向右.9.png"];
    [self.contentView addSubview:_imgBiao];
    
    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imgBiao.frame.origin.x + _imgBiao.frame.size.width, _imgBiao.frame.origin.y, 120, _imgBiao.frame.size.height)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textLabel];

    
}

@end
