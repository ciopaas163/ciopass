//
//  EnterpriseController.h
//  Communication
//
//  Created by CIO on 15/2/6.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

@interface EnterpriseController : UIViewController



<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ABPeoplePickerNavigationControllerDelegate,ABPersonViewControllerDelegate,
ABNewPersonViewControllerDelegate, ABUnknownPersonViewControllerDelegate>

{
    UITableView* _tableView;

     UINavigationBar* _navBar;

    UINavigationItem* _navItem;
    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;

    NSString* _arrarNSstr;
    NSString* _str;
    NSMutableArray* _MutableArray;
   
}

-(void)alertView;
@end
