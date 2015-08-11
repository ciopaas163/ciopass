//
//  PublicViewController.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "PublicViewController.h"

@interface PublicViewController ()

@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];

    _navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    //创建一个导航栏集合
    _navItem = [[UINavigationItem alloc] initWithTitle:nil];
    [self.view addSubview:_navBar];
     UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(returnButton)];
    

}


#pragma mark 按钮
-(void)returnButton:(UIBarButtonItem*)leftbutton{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark  [btnRegistration]  【UIAlertView 】
-(void)btnRegistration:(UIButton*)Registration{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提交成功" message:nil
                                                   delegate:self cancelButtonTitle:nil
                                          otherButtonTitles: nil];
    //2秒钟后自动移除
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:0.8];
    [alert show];
}
// UIAlertView【2秒钟后自动移除】 移除方法
- (void) dimissAlert:(UIAlertView *)alert
{
    if(alert)
    {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
