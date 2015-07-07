//
//  Maillist.h
//  Communication
//
//  Created by CIO on 15/1/29.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PublicViewController.h"
#import "MethodController.h"

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface Maillist : PublicViewController

<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>
{
    UITableView* _tableView;

    MethodController * _viewcon;
}
@end
