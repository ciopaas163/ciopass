//
//  CusInfoCell.m
//  Communication
//
//  Created by helloworld on 15/7/21.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CusInfoCell.h"
#import "IphoneController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PublicAction.h"
#import "Header.h"
@implementation CusInfoCell
@synthesize _textLabel,_tetLabel,_telImage;
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


-(void)setModel:(CustomerModel *)model
{
    if (_model!=model) {
        _model=model;
        _textLabel.text=model.name;
        //_tetLabel.text=model;
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
    
    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(10,2.5,68,30)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    //_textLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:_textLabel];
    _tetLabel= [[UITextField alloc]initWithFrame:CGRectMake(_textLabel.frame.origin.x+_textLabel.frame.size.width-10,_textLabel.frame.origin.y,self.frame.size.width-(_textLabel.frame.origin.x+_textLabel.frame.size.width),30)];
    _tetLabel.textAlignment = NSTextAlignmentLeft;
    _tetLabel.enabled=NO;
    [self.contentView addSubview:_tetLabel];
    _telImage=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80, 2.5, 30, 30)];
    _telImage.hidden=YES;
    [_telImage setImage:[UIImage imageNamed:@"dial_normal.png"] forState:UIControlStateNormal];
    [_telImage setImage:[UIImage imageNamed:@"dial_down.png"] forState:UIControlStateHighlighted];
    [_telImage addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_telImage];
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 34, self.frame.size.width, 1)];
    view.backgroundColor=COLOR(241.0, 241.0, 241.0, 1);
    [self.contentView addSubview:view];
}

-(void)photoTapped
{
    if (self.telphoneNum.length<7) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    IphoneController * dial=[[IphoneController alloc]init];
    dial.number=self.telphoneNum;
    dial.address=[PublicAction getTelephoneLocation:self.telphoneNum];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:dial animated:YES completion:nil];
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* _userid = [Defaults objectForKey:@"userid"];
    NSString * _number=[Defaults objectForKey:@"Num"];
    NSDictionary * dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_ids,_eid,_verify,_userid,_number,self.telphoneNum, nil] forKeys:[NSArray arrayWithObjects:@"_id",@"eid",@"verify",@"userid",@"number",@"callNum", nil]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PublicAction dialTelephone:dict];
    });
}
@end
