//
//  MasterViewController.h
//  Communication
//
//  Created by helloworld on 15/7/24.
//  Copyright (c) 2015年 JL. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MasterCell.h"
@class DetailViewController;
@protocol TelephoneDelegate;

@interface MasterViewController : UIViewController
<UISearchDisplayDelegate,ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,callDelegate,UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;
    NSMutableArray * importDic;
    //NSMutableArray *contactNames;
    BOOL *flag;
    
    UIActionSheet* _Actionsheet;
    NSString* _strNumber;//存电话号码:
    
    
    NSString* _strApple;
    
    NSString* stringLing;
    
    UIImageView* _imageView;
    
    UILabel * _label;
    NSMutableData *data_;
    NSString *userid;
    NSString *nid;
    NSString *eid;
    NSString *verify;
    NSString *Num;
    NSUserDefaults *userDefaults;
    NSString *urlStr;
    
    UITableView* _tableView;
    
    UILabel* textView;
    NSMutableString * _string;
    NSMutableString * _str;
    
    NSMutableArray *_phoneNums;
    
}
@property (strong, nonatomic) DetailViewController *detailViewController;
@property(strong,nonatomic)id<TelephoneDelegate>Telephonedelegate;
@property(strong,nonatomic)NSString* Telephone;
@property(strong,nonatomic)NSMutableDictionary *sectionDic;
@property(strong,nonatomic)NSArray * keys;
-(void)messageTelephone:(NSString*)Telephone;

-(void)loadContacts;
@end
