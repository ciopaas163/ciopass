//
//  PersonInfoCell.m
//  Communication
//
//  Created by helloworld on 15/7/20.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PersonInfoCell.h"

@implementation PersonInfoCell
@synthesize _textLabel,_tetLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}

-(void)setModel:(OrganizationModel *)model
{
    if (_model!=model) {
        _model=model;
        _textLabel.text=model.username;
        _tetLabel.text=model.position;
    }
}

-(void)setTitle:(NSString *)str
{
    if (_title!=str) {
        _title=str;
        _textLabel.text=str;
    }
}

-(void)setSubtitle:(NSString *)subtitle
{
    if (_subtitle!=subtitle) {
        _subtitle=subtitle;
        _tetLabel.text=subtitle;
    }
}

- (void)content{
    
    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(10,5,70,30)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textLabel];
    _tetLabel= [[UILabel alloc]initWithFrame:CGRectMake(_textLabel.frame.origin.x+_textLabel.frame.size.width,_textLabel.frame.origin.y,150,30)];
    _tetLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tetLabel];
    
    
}

@end
