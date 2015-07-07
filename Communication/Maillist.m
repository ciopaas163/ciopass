//
//  Maillist.m
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Maillist.h"
#import "Personal.h" //个人通讯录
#import "SetupController.h"    //设置
#import "MasterViewController.h"  // 获取通讯录
@interface Maillist ()

@end

@implementation Maillist

-(void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35.0/255.0 green:152.0/255.0 blue:217.0/255.0 alpha:1]];

    _viewcon = [MethodController sharedpupsviewcontroller];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"通讯助手";

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, _navBar.frame.origin.y + _navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - 110)];
    _tableView.backgroundColor =  [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    _tableView.bounces = YES;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置.png"] style:UIBarButtonItemStylePlain target:self action:@selector(perFormSetup:)];



}
#pragma mark  --- 设置按钮
-(void)perFormSetup:(UISegmentedControl*)Setup{
    NSLog(@"Setup:设置");
    SetupController* sevc = [[SetupController alloc] init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:sevc];

    [self.navigationController presentViewController:nav animated:YES completion:nil];

}
#pragma mark  键盘自动隐藏
//点击其他地方键盘自动隐藏;
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UISearchBar* Search = [_tableView viewWithTag:1];
    [Search resignFirstResponder];
}

#pragma  UITableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * Cell = @"cell";
    UITableViewCell * tableCell=[tableView dequeueReusableCellWithIdentifier:Cell];
//    自定义图片
    UIImageView * imageNumber = [[UIImageView alloc]initWithFrame:CGRectMake(0, 5, 65, 40)];
//    自定义label
    UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageNumber.frame.origin.x + imageNumber.frame.size.width - 12, imageNumber.frame.origin.y, 100, imageNumber.frame.size.height)];

    if (tableCell==nil) {
        tableCell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Cell];
    }
    if (indexPath.section==0) {
        imageNumber.image = [UIImage imageNamed:@"personal-contact@2x.png"];
        textLabel.text = @"个人通讯录";
    }
    else
    {
        imageNumber.image = [UIImage imageNamed:@"mobile-contact@2x.png"];
        textLabel.text = @"手机通讯录";

    }
    [tableCell.contentView addSubview:imageNumber];
    [tableCell.contentView addSubview:textLabel];

    tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return tableCell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section==0) {
        UISearchBar*  searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(4, 2, self.view.frame.size.width-4 *2,44)];
        searchBar.placeholder = @"搜索";
        searchBar.delegate = self;
        searchBar.searchBarStyle = UISearchBarIconResultsList;
        return searchBar;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 10;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSLog(@"个人通讯录");
//        NSString * phoneName = @"诺基亚";
        Personal* personal = [[Personal alloc] init];
        //        personal.needPhone = phoneName;
//        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:personal];

//        [self presentViewController:nav animated:YES completion:nil];
        [self.navigationController pushViewController:personal animated:YES];

    }else if (indexPath.section == 1){
        NSLog(@"手机通讯录");

        MasterViewController* master = [[MasterViewController alloc] init];
        master.hidesBottomBarWhenPushed  = YES;  //隐藏定义的卡片兰
        ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
        picker.newPersonViewDelegate = self;

        [self.navigationController pushViewController:master animated:YES];

    }
}


//隐藏分割线；
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark 获取通讯录
#pragma mark ABPeoplePickerNavigationControllerDelegate methods
// Displays the information of a selected person
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}

// Dismisses the people picker and shows the application when users tap Cancel.
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker;
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Does not allow users to perform default actions such as dialing a phone number, when they select a person property.
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}



-(void)showPeoplePickerController
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    // Display only a person's phone, email, and birthdate
    NSArray *displayedItems = [NSArray arrayWithObjects:[NSNumber numberWithInt:kABPersonPhoneProperty],
                               [NSNumber numberWithInt:kABPersonEmailProperty],
                               [NSNumber numberWithInt:kABPersonBirthdayProperty], nil];


    picker.displayedProperties = displayedItems;
    // Show the picker
    [self presentViewController:picker animated:YES completion:nil];
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
