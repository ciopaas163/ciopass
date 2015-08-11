//
//  CustomerCell.m
//  Communication
//
//  Created by CIO on 15/3/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "CustomerCell.h"
#import "IphoneController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PublicAction.h"
#import "AppDelegate.h"
#define KSCREENWIDTH  [[UIScreen mainScreen] bounds].size.width
@implementation CustomerCell
@synthesize _imgBiao,_textLabel,_telImage;

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
    }
    
}
-(void)setTelphoneNum:(NSString *)telphoneNum
{
    if (_telphoneNum!=telphoneNum) {
        _telphoneNum=telphoneNum;
    }
}
-(void)setTextstr:(NSString *)textstr
{
    if (_textstr!=textstr) {
        _textstr=textstr;
        _textLabel.text=textstr;
    }
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}
-(void)content{
    _imgBiao = [[UIImageView alloc]initWithFrame:CGRectMake(10, 12.5, 25, 25)];
    _imgBiao.backgroundColor = [UIColor clearColor];
    _imgBiao.tintColor=[UIColor blueColor];
    [self.contentView addSubview:_imgBiao];
    
    _textLabel= [[UILabel alloc]initWithFrame:CGRectMake(_imgBiao.frame.origin.x + _imgBiao.frame.size.width, _imgBiao.frame.origin.y, 120, _imgBiao.frame.size.height)];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:_textLabel];
    
    _telImage=[[UIButton alloc]initWithFrame:CGRectMake(self.frame.size.width-80, 5, 30, 30)];
    [_telImage setImage:[UIImage imageNamed:@"dial_normal.png"] forState:UIControlStateNormal];
    [_telImage setImage:[UIImage imageNamed:@"dial_down.png"] forState:UIControlStateHighlighted];
    [_telImage addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_telImage];
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
