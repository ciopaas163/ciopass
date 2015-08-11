//
//  EnterpriseCell.m
//  Communication
//
//  Created by CIO on 15/2/26.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "EnterpriseCell.h"
#import "Header.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
#define KSCRENHEIGHT [[UIScreen mainScreen] bounds].size.height

@implementation EnterpriseCell
@synthesize _imgBiao,_tet,_tetLabel,_textLabel;
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

-(void)setModel:(NSString *)model{
    if (_model!=model) {
        _model = model;
        _textLabel.text = model;
    }
}

-(void)setUmodel:(NSString *)umodel{
    if (_umodel!=umodel) {
        _umodel = umodel;
        _tetLabel.text = umodel;
    }
}

-(void)setText:(NSString *)text{
    if (_text!=text) {
        _text = text;
        _tet.text = text;
    }
}

- (void)content{
    
    _imgBiao = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    _imgBiao.backgroundColor = [UIColor clearColor];
    _imgBiao.image = [UIImage imageNamed:@"expandable_arrow_right.png"];
    [self.contentView addSubview:_imgBiao];

    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imgBiao.frame.origin.x + _imgBiao.frame.size.width, _imgBiao.frame.origin.y, 100, _imgBiao.frame.size.height)];
    
        _textLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_textLabel];
    _tetLabel= [[UILabel alloc]initWithFrame:CGRectMake(KSCREENWIDTH-80 , _imgBiao.frame.origin.y, 70, _imgBiao.frame.size.height)];
    _tetLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_tetLabel];
    
    _tet= [[UILabel alloc]initWithFrame:CGRectMake(_textLabel.frame.origin.x + _textLabel.frame.size.width, _textLabel.frame.origin.y+5, 120, _textLabel.frame.size.height)];
    _tet.textAlignment = NSTextAlignmentLeft;
    _tet.font = [UIFont systemFontOfSize:13];
    _tet.textColor = COLOR(156, 163, 163, 1);
    _tet.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_tet];

}


@end
