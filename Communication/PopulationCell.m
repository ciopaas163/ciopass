//
//  PopulationCell.m
//  Communication
//
//  Created by CIO on 15/3/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PopulationCell.h"
#import "Header.h"
@implementation PopulationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(CellModel *)model{
    if (_model!=model) {
        _model = model;
        _textLabel.text = model.Name;
        _tet.text =  model.names;

        NSLog(@"model.name%@",model.Name);
        NSLog(@"model.name%@",model.names);

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
//    [self.contentView addSubview:_imgBiao];

    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(15,10, 70, 30)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textLabel];
    _tet= [[UILabel alloc]initWithFrame:CGRectMake(_textLabel.frame.origin.x + _textLabel.frame.size.width, _textLabel.frame.origin.y +5, 120, _textLabel.frame.size.height)];
    _tet.textAlignment = NSTextAlignmentLeft;
    _tet.font = [UIFont systemFontOfSize:13];
    _tet.textColor = COLOR(156, 163, 163, 1);
    _tet.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tet];

    
}



@end
