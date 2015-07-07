//
//  MasterViewController.h
//  datoucontacts
//
//  Created by houwenjie on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "MasterCell.h"
@class DetailViewController;
@protocol TelephoneDelegate;

@interface MasterViewController : UITableViewController
<UISearchDisplayDelegate,ABNewPersonViewControllerDelegate,ABPersonViewControllerDelegate,UIAlertViewDelegate,UIActionSheetDelegate,callDelegate>
{
    NSMutableDictionary *sectionDic;
    NSMutableDictionary *phoneDic;
    NSMutableDictionary *contactDic;
    NSMutableArray *filteredArray;
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


    UILabel* textView;
     NSMutableString * _string;
    NSMutableString * _str;
    
    NSMutableArray *_phoneNums;

}
@property (strong, nonatomic) DetailViewController *detailViewController;
@property(strong,nonatomic)id<TelephoneDelegate>Telephonedelegate;
@property(strong,nonatomic)NSString* Telephone;

-(void)messageTelephone:(NSString*)Telephone;

-(void)loadContacts;
@end
