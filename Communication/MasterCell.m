#import "MasterCell.h"
#import "MasterViewController.h"
@implementation MasterCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self content];
    }
    return self;
}

- (void)content{
    _butIphone = [[UIButton alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width - 130, 6, 30, 30)];
    _butIphone.backgroundColor = [UIColor clearColor];

    [_butIphone setImage:[UIImage imageNamed:@"拨号常态.png"] forState:UIControlStateNormal];
    [_butIphone setImage:[UIImage imageNamed:@"拨号按下.png"] forState:UIControlStateHighlighted];
    [_butIphone addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_butIphone];

    _Btnmessage = [[UIButton alloc]initWithFrame:CGRectMake(_butIphone.frame.origin.x + _butIphone.frame.size.width + 10, _butIphone.frame.origin.y, _butIphone.frame.size.width, _butIphone.frame.size.height)];
    _Btnmessage.backgroundColor = [UIColor clearColor];
    [_Btnmessage setImage:[UIImage imageNamed:@"短信常态.png"] forState:UIControlStateNormal];
    [_Btnmessage setImage:[UIImage imageNamed:@"短信按下.png"] forState:UIControlStateHighlighted];
    [_Btnmessage addTarget:self action:@selector(Message:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_Btnmessage];




    //    btnChoice
    UIButton* btnChoice = [[UIButton alloc]initWithFrame:CGRectMake(_Btnmessage.frame.origin.x + _Btnmessage.frame.size.width + 5, _Btnmessage.frame.origin.y - 4, 40, 40)];
    btnChoice.backgroundColor = [UIColor clearColor];
    [btnChoice setImage:[UIImage imageNamed:@"未选.png"] forState:UIControlStateNormal];
    [btnChoice setBackgroundImage:[UIImage imageNamed:@"选中_2.png"] forState:UIControlStateSelected];

    [btnChoice addTarget:self action:@selector(selectBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btnChoice];
}

- (void)call:(UIButton *)btn{

    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人直接拨号",@"企业云通讯",@"个人云通讯", nil];
    sheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [sheet showInView:self.superview];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [_delegate callWithNum:self.phoneNum type:buttonIndex];
    }
}

- (void)selectBtn:(UIButton *)btn{
    btn.selected = !btn.selected;

}
#pragma mark == [Message短信]
-(void)Message:(UIButton*)Message{
    NSLog(@"Message:1111");
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
