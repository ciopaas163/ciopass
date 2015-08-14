//
//  AddCalendarViewController.m
//  Communication
//
//  Created by CIO on 15/8/12.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "AddCalendarViewController.h"
#import "UUDatePicker.h"

#define PickerViewHeight 220

@interface AddCalendarViewController () <UUDatePickerDelegate>
{
    UIView *_pickerView;
    NSString *_setTimeStr;
    UIButton *_coverBtn;
    int pickerFlag;
    UUDatePicker *_datePicker;
}


@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *companyUser;
@property (weak, nonatomic) IBOutlet UIButton *personUser;
@property (weak, nonatomic) IBOutlet UIButton *note;
// 提醒按钮
@property (weak, nonatomic) IBOutlet UIButton *remind;
// 提醒视图
@property (weak, nonatomic) IBOutlet UIView *remindView;
//  参与者Top约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *participatorContraint;

@property (weak, nonatomic) IBOutlet UILabel *startTime;
@property (weak, nonatomic) IBOutlet UILabel *endTime;
@property (weak, nonatomic) IBOutlet UILabel *remindTime;
@property (weak, nonatomic) IBOutlet UILabel *participatorPersons;
@property (weak, nonatomic) IBOutlet UILabel *targetCustomer;
@end

@implementation AddCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置导航栏
    [self setNavigationBar];

    // 优化视图
    [self optimalView];

}

#pragma mark - 设置导航栏
- (void)setNavigationBar {

    UITextField * field = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
    field.text = @"添加日程";
    field.textColor = [UIColor whiteColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.font = [UIFont boldSystemFontOfSize:17];
    field.enabled = NO;
    self.navigationItem.titleView = field;

    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    btn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = btn;

}

#pragma mark - 优化视图
- (void)optimalView {

    _contentTextView.layer.borderWidth = 0.5;
    _contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;

    _titleTextField.textColor = [UIColor blackColor];
    _titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _titleTextField.layer.borderWidth = 0.5;
    _titleTextField.tintColor = [UIColor blackColor];

    _contentTextView.tintColor = [UIColor blackColor];

    if (!_remind.isSelected) {
        _remindView.hidden = YES;
        _participatorContraint.constant = 0;
    }

    // 加载开始任务当前时间
    _startTime.text = [self loadCurrentDate];
}

//
- (NSString *)loadCurrentDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];

    return [dateFormatter stringFromDate:[NSDate date]];
}

#pragma mark - 日期选择器的代理方法UUDataPickerDelegate
- (void)uuDatePicker:(UUDatePicker *)datePicker year:(NSString *)year month:(NSString *)month day:(NSString *)day hour:(NSString *)hour minute:(NSString *)minute weekDay:(NSString *)weekDay {

    _setTimeStr = [NSString stringWithFormat:@"%@-%@-%@ %@:%@", year, month, day, hour, minute];

}

#pragma mark - 导航栏返回按钮
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 取消按钮
- (IBAction)cancel:(UIButton *)sender {
    [self back];
}

#pragma mark - 保存按钮
- (IBAction)save:(UIButton *)sender {

}

#pragma mark - 日程时间添加选型按钮
// 开始任务
- (IBAction)startTask:(id)sender {

    pickerFlag = 1;
    [self showPickerView];
}

// 结束任务
- (IBAction)endTask:(id)sender {

    pickerFlag = 2;
    [self showPickerView];
}

// 提醒时间
- (IBAction)remindTime:(id)sender {

    pickerFlag = 3;
    [self showPickerView];
}

// 参与者
- (IBAction)participator:(id)sender {
    [self hiddenPickerView];
}

// 目标客户
- (IBAction)targetCustomer:(id)sender {
}

// 企业用户
- (IBAction)companyUser:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
        _personUser.selected = NO;
    }
}
// 个人用户
- (IBAction)personUser:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
        _companyUser.selected = NO;
    }
}

// 记事
- (IBAction)note:(UIButton *)sender {
    if (!sender.isSelected) {
        sender.selected = YES;
        _remind.selected = NO;

        // 隐藏提醒视图，设置约束
        _remindView.hidden = YES;
        _participatorContraint.constant = 0;
    }
}
// 提醒
- (IBAction)remind:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _note.selected = NO;

        // 显示提醒视图，设置约束
        _remindView.hidden = NO;
        _participatorContraint.constant = 30;
    }
}


#pragma mark - 显示日期选择器
- (void)showPickerView {

    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _coverBtn = coverBtn;
    coverBtn.frame = self.view.frame;
    coverBtn.alpha = 0.7;
    coverBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:coverBtn];
    [coverBtn addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];


    CGRect pickerFrame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, PickerViewHeight);

    _pickerView = [[UIView alloc] initWithFrame:pickerFrame];

    _pickerView.backgroundColor = [UIColor whiteColor];


    UUDatePicker *udatePicker = [[UUDatePicker alloc] initWithframe:CGRectMake(0, 20, _pickerView.frame.size.width, _pickerView.frame.size.height - 20) Delegate:self PickerStyle:UUDateStyle_YearMonthDayHourMinute];

    [_pickerView addSubview:udatePicker];

    UIButton *pCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pCancelBtn.frame = CGRectMake(0, 10, _pickerView.frame.size.width/2, 20);
    [pCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [pCancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pCancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [pCancelBtn addTarget:self action:@selector(hiddenPickerView) forControlEvents:UIControlEventTouchUpInside];
    [_pickerView addSubview:pCancelBtn];

    UIButton *pSureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pSureBtn.frame = CGRectMake(_pickerView.frame.size.width/2, 10, _pickerView.frame.size.width/2, 20);
    [pSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [pSureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pSureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [pSureBtn addTarget:self action:@selector(saveDate) forControlEvents:UIControlEventTouchUpInside];

    [_pickerView addSubview:pSureBtn];

    if (_pickerView.superview == nil)
    {
        [self.view.window addSubview: _pickerView];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect endRect = CGRectMake(0, self.view.bounds.size.height - PickerViewHeight, self.view.bounds.size.width, PickerViewHeight);
        _pickerView.frame = endRect;

    } completion:nil];


}


#pragma mark - 隐藏日期选择器
-(void)hiddenPickerView
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGRect endRect = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, PickerViewHeight);
        _pickerView.frame = endRect;

    } completion:^(BOOL finished) {
        [_pickerView removeFromSuperview];
        [_coverBtn removeFromSuperview];
        _coverBtn = nil;
        _pickerView = nil;
    }];

//    self.view.alpha = 1;

}

#pragma mark - 保存日期
- (void)saveDate {

    switch (pickerFlag) {
        case 1:
            NSLog(@"setTimeStr:%@", _setTimeStr);
            if (_setTimeStr == nil) {
                _startTime.text = [self loadCurrentDate];
            } else {
                _startTime.text = _setTimeStr;
            }
            _endTime.text = @"";
            break;
        case 2:
            if ([_setTimeStr compare:_startTime.text options:NSLiteralSearch] != NSOrderedAscending) {
                _endTime.text = _setTimeStr;
            } else {
                _endTime.text = @"";
            }
            break;

        case 3:
            NSLog(@"3setTimeStr:%@", _setTimeStr);
            NSLog(@"_remindTime:%@", _remindTime.text);
            if ([_remindTime.text isEqualToString:@""]) {
                _remindTime.text = [self loadCurrentDate];
                
            }

            break;
        default:
            break;
    }

    [self hiddenPickerView];
}

@end
