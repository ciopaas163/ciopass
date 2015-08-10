#import "MasterCell.h"
#import "MasterViewController.h"
#import "PublicAction.h"
#import <AudioToolbox/AudioToolbox.h>
#import "IphoneController.h"
#import "Header.h"
@implementation MasterCell
@synthesize tetLabel,textLabel;
- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    if (_title!=title) {
        _title=title;
        textLabel.text=title;
    }
}

-(void)setSubtitle:(NSString *)subtitle
{
    if (_subtitle!=subtitle) {
        _subtitle=subtitle;
        tetLabel.text=subtitle;
    }
}

- (void)content{
    _butIphone = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 130, 5, 40, 40)];
    _butIphone.backgroundColor = [UIColor clearColor];

    [_butIphone setImage:[UIImage imageNamed:@"dial_normal.png"] forState:UIControlStateNormal];
    [_butIphone setImage:[UIImage imageNamed:@"dial_down.png"] forState:UIControlStateHighlighted];
    [_butIphone addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_butIphone];
    
    _butMessage = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 90, 5, 40, 40)];
    _butMessage.backgroundColor = [UIColor clearColor];
    
    [_butMessage setImage:[UIImage imageNamed:@"user_info_msg_nor.png"] forState:UIControlStateNormal];
    [_butMessage setImage:[UIImage imageNamed:@"user_info_msg_pre.png"] forState:UIControlStateHighlighted];
    [_butMessage addTarget:self action:@selector(Message:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_butMessage];
    
    _butSelected = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 45, 13, 23, 23)];
    //_butSelected.backgroundColor = [UIColor clearColor];
    _butSelected.layer.cornerRadius=23/2;
    _butSelected.layer.borderWidth=1;
    _butSelected.layer.borderColor=COLOR(220, 220, 220, 1).CGColor;
    //[_butSelected addTarget:self action:@selector(clickTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_butSelected];
    
    textLabel= [[UILabel alloc]initWithFrame:CGRectMake(50,5,150,20)];
    textLabel.textAlignment = NSTextAlignmentLeft;
    //_textLabel.font=[UIFont systemFontOfSize:14];
    [self.contentView addSubview:textLabel];
    tetLabel= [[UILabel alloc]initWithFrame:CGRectMake(50,25,150,20)];
    tetLabel.textAlignment = NSTextAlignmentLeft;
    tetLabel.font=[UIFont systemFontOfSize:12];
    [self.contentView addSubview:tetLabel];
    
    _selectImage=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"confirm_exclamation_mark.png"]];
    _selectImage.frame=CGRectMake(_butSelected.frame.origin.x+6, _butSelected.frame.origin.y+6, 12, 12);
    _selectImage.hidden=YES;
    [self.contentView addSubview:_selectImage];
    self.isSelected=NO;
}

-(void)clickTap:(UIButton *)btn
{
    [btn setImage:[UIImage imageNamed:@"confirm_exclamation_mark.png"] forState:UIControlStateNormal];
    //[btn setBackgroundImage:[UIImage imageNamed:@"confirm_exclamation_mark.png"] forState:UIControlStateNormal];
    
}

- (void)call:(UIButton *)btn{
    if (self.subtitle.length<7) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        return;
    }
    IphoneController * dial=[[IphoneController alloc]init];
    dial.number=self.subtitle;
    dial.address=[PublicAction getTelephoneLocation:self.subtitle];
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    [window.rootViewController presentViewController:dial animated:YES completion:nil];
    
    NSUserDefaults* Defaults = [NSUserDefaults standardUserDefaults];
    NSString* _ids = [Defaults objectForKey:@"nid"];
    NSString* _eid = [Defaults objectForKey:@"eid"];
    NSString* _verify = [Defaults objectForKey:@"verify"];
    NSString* _userid = [Defaults objectForKey:@"userid"];
    NSString * _number=[Defaults objectForKey:@"Num"];
    NSDictionary * dict=[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_ids,_eid,_verify,_userid,_number,self.subtitle, nil] forKeys:[NSArray arrayWithObjects:@"_id",@"eid",@"verify",@"userid",@"number",@"callNum", nil]];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [PublicAction dialTelephone:dict];
    });
}

- (void)selectBtn:(UIButton *)btn{
    btn.selected = !btn.selected;

}
#pragma mark == [Message短信]
-(void)Message:(UIButton*)Message{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Message" message:@"还在完成中" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    [self performSelector:@selector(timerAlert:) withObject:alert afterDelay:1.0];
    [alert show];
}
#pragma mark ==[// UIAlertView【2秒钟后自动移除】 移除方法]
-(void)timerAlert:(UIAlertView*)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if (buttonIndex == 0) {
//        NSLog(@"00");
////        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"sms://15013540332"]];
//
//    }else if (buttonIndex == 1){
//        NSLog(@"11");
//    }



//    if (buttonIndex != alertView.cancelButtonIndex) {
//        NSLog(@"Message:54321");
//        [_delegate messageTelephone:self.Telephone];
//    }


//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
