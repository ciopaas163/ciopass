//
//  MailliTableViewCell.m
//  Communication
//
//  Created by CIO on 15/1/30.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "MailliTableViewCell.h"

@implementation MailliTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    NSString * indetify=@"cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:indetify];
    if (cell==nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetify];
    }
    if (indexPath.section==0) {
        cell.imageView.image = [UIImage imageNamed:@"个人通讯录.png"];
        cell.textLabel.text = @"个人通讯录";
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"手机通讯录.png"];
        cell.textLabel.text = @"手机通讯录";
    }
    
    return cell;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (section==0) {
//        UISearchBar*  searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 2, self.view.frame.size.width-10,44)];
//        searchBar.placeholder = @"搜索";
//        searchBar.delegate = self;
//        searchBar.tag = 8;
//        searchBar.searchBarStyle = UISearchBarStyleMinimal;
//        searchBar.barTintColor = [UIColor whiteColor];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, 100, 50)];
        
        label.text = @"金伦";
        label.backgroundColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [tableView addSubview:label];
        
        return label;
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
//        Personal* personal = [[Personal alloc] init];
//        self.navigationController.navigationBarHidden = NO;
//        [self.navigationController presentViewController:personal animated:YES completion:nil];
    }else if (indexPath.section == 1){
        NSLog(@"手机通讯录");
//        Cellphone* iphone = [[Cellphone alloc]init];
//        [self.navigationController pushViewController:iphone animated:YES];
    }
}
////隐藏分割线；
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    // This will create a "invisible" footer
//    return 0.01f;
//}

@end
