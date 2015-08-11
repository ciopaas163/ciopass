//
//  AddEventViewController.m
//  Communication
//
//  Created by CIO on 15/8/11.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "AddEventViewController.h"

#define MARGIN 3

@interface AddEventViewController ()

@end

@implementation AddEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // 设置导航栏
    [self setNavigationBar];
    // 初始化中心视图
    [self initCenterView];
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

    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveEvent)];
    rightBtn.tag = 1;
    rightBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBtn;

}

#pragma mark - 初始化中心视图
- (void)initCenterView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN+64, self.view.bounds.size.width - MARGIN*2, self.view.bounds.size.height / 4)];

    headerView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:headerView];

    UILabel *title_label = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, 30, headerView.bounds.size.height / 4)];
    title_label.text = @"标题";
//    title_label.tintColor = [UIColor blackColor];
    title_label.textColor = [UIColor blackColor];
    title_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:title_label];

    UITextField *title_textField = [[UITextField alloc] initWithFrame:CGRectMake(title_label.frame.origin.x + title_label.bounds.size.width, title_label.frame.origin.y, headerView.bounds.size.width - title_label.bounds.size.width - title_label.frame.origin.x, title_label.bounds.size.height)];
    title_textField.textColor = [UIColor blackColor];
    title_textField.borderStyle = UITextBorderStyleLine;
    title_textField.layer.borderWidth = 0.5;
    title_textField.layer.borderColor = [UIColor grayColor].CGColor;
    [headerView addSubview:title_textField];

    UILabel *content_label = [[UILabel alloc] initWithFrame:CGRectMake(MARGIN, title_label.bounds.size.height+2*MARGIN, 30, headerView.bounds.size.height / 4)];
    content_label.text = @"内容";
    //    title_label.tintColor = [UIColor blackColor];
    content_label.textColor = [UIColor blackColor];
    content_label.font = [UIFont systemFontOfSize:13];
    [headerView addSubview:content_label];

    UITextField *content_textField = [[UITextField alloc] initWithFrame:CGRectMake(title_label.frame.origin.x + title_label.bounds.size.width, title_label.frame.origin.y+title_label.bounds.size.height+MARGIN, headerView.bounds.size.width - title_label.bounds.size.width - title_label.frame.origin.x, title_label.bounds.size.height)];
    content_textField.textColor = [UIColor blackColor];
    content_textField.borderStyle = UITextBorderStyleLine;
    content_textField.layer.borderWidth = 0.5;
    content_textField.layer.borderColor = [UIColor grayColor].CGColor;
    [headerView addSubview:content_textField];


}

#pragma mark - 监听按钮点击事件
- (void)back
{

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveEvent
{
//    if (_saveStatus==1)
//    {
//        if (_customerArray)
//        {
//            NSArray * array=[self saveCustomerToLocal];
//            if (array.count>0)
//            {
//                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//                hud.mode = MBProgressHUDModeText;
//                hud.margin = 10.f;
//                hud.yOffset = 150.f;
//                [hud hide:YES afterDelay:1];
//                hud.labelText = @"添加客户成功!";
//                [self.navigationController.view addSubview:hud];
//
//                NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
//                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index-1] animated:YES];
//                dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                    NSDictionary * dict= [self saveCustomerWithUrl:array];
//                    [self updateCustomerLocalID:dict];
//                });
//            }
//        }
//    }else
//    {
//        NSInteger index=[[self.navigationController viewControllers]indexOfObject:self];
//        Newcustomer * cus= [self.navigationController.viewControllers objectAtIndex:index-1];
//        cus.model.cid=self.cid;
//        [self.navigationController popToViewController:cus animated:YES];
//    }
}


@end
