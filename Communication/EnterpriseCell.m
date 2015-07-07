//
//  EnterpriseCell.m
//  Communication
//
//  Created by CIO on 15/2/26.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "EnterpriseCell.h"

@implementation EnterpriseCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(DatabaseModel *)model{
    if (_model!=model) {
        _model = model;
        _textLabel.text = model.departmentname;

        NSLog(@"model.name%@",model.departmentname);
        
    }
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}

- (void)content{
    _imgBiao = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
    _imgBiao.backgroundColor = [UIColor clearColor];
    _imgBiao.image = [UIImage imageNamed:@"向右.9.png"];
    [self.contentView addSubview:_imgBiao];

    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imgBiao.frame.origin.x + _imgBiao.frame.size.width, _imgBiao.frame.origin.y, 120, _imgBiao.frame.size.height)];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
    _tetLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imgBiao.frame.origin.x + _imgBiao.frame.size.width, _imgBiao.frame.origin.y, 120, _imgBiao.frame.size.height)];
    _tetLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tetLabel];


}

@end
