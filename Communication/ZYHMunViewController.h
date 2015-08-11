//
//  ZYHMunViewController.h
//  Communication
//
//  Created by helloworld on 15/7/8.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFFNumericKeyboard.h"
@interface ZYHMunViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,AFFNumericKeyboardDelegate>
{
    UITableView * _tableView;
    UISearchBar* searchBar;
    UIView* _mobileVie;
}
@end
