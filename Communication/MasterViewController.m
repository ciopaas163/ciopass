//
//  MasterViewController.m
//  Communication
//
//  Created by helloworld on 15/7/24.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "MasterViewController.h"
#import "GroupViewController.h"
#import "DetailViewController.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import "AFNetworking.h"
#import "SGInfoAlert.h"
#import "IphoneController.h"
#import "PublicAction.h"
// 个人通讯录
#import "Newcustomer.h"     // 新建客户
#import "CustomerModel.h"
#import "MasterCell.h"
#import "Header.h"
#import "ContactModel.h"
#import "MBProgressHUD.h"
#import "newUsercontact.h"
#import "PersonInfoModel.h"
#import "CusMarkViewController.h"
#import "UsercontactGroup.h"
@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize sectionDic,keys;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITextField * field=[[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
        field.text=@"手机通讯录";
        field.textColor=[UIColor whiteColor];
        field.textAlignment = NSTextAlignmentCenter;
        field.font = [UIFont boldSystemFontOfSize:17];
        field.enabled =NO;
        self.navigationItem.titleView=field;
        
        UIBarButtonItem * leftBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back.png" ] style:UIBarButtonItemStylePlain target:self action:@selector(showGroupView)];
        leftBtn.tintColor=[UIColor whiteColor];
        self.navigationItem.leftBarButtonItem=leftBtn;
        UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"导入" style:UIBarButtonItemStylePlain target:self action:@selector(importTap)] autorelease];
        addButton.tintColor=[UIColor whiteColor];
        //insertNewObject
        self.navigationItem.rightBarButtonItem = addButton;
    }
    return self;
}

// 导入通讯录

-(void)loadContacts
{
    ABAddressBookRef myAddressBook =nil;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
    {
        myAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
       if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied)
        {
            
        }
        //注册访问通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(myAddressBook, ^(bool granted, CFErrorRef error){
            dispatch_semaphore_signal(sema);});
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        dispatch_release(sema);
    }else
    {
        myAddressBook = ABAddressBookCreate();
    }
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(myAddressBook);
    if (results==nil) {
        return;
    }
    CFMutableArrayRef mresults=CFArrayCreateMutableCopy(kCFAllocatorDefault,
                                                        CFArrayGetCount(results),
                                                        results);
    //将结果按照拼音排序，将结果放入mresults数组中
    CFArraySortValues(mresults,
                      CFRangeMake(0, CFArrayGetCount(results)),
                      (CFComparatorFunction) ABPersonComparePeopleByName,
                      (void*) ABPersonGetSortOrdering());
    //遍历所有联系人
    for (int k=0;k<CFArrayGetCount(mresults);k++) {
        ABRecordRef record=CFArrayGetValueAtIndex(mresults,k);
        [self setLoadData:record];
    }
    keys=[[sectionDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

-(void)setLoadData:(ABRecordRef)record
{
    ContactModel * model=[[ContactModel alloc]init];
    //获取联系人完整名字
    NSString *personname = (NSString *)ABRecordCopyCompositeName(record);
    model.name=personname;
    // 读取电话,不只一个
    ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
    ABRecordID recordID=ABRecordGetRecordID(record);
    model._id=[NSString stringWithFormat:@"%d",recordID];
    for (int k = 0; k<ABMultiValueGetCount(phone); k++)
    {
        _strNumber = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
        NSRange range=NSMakeRange(0,3);
        NSString *str=[_strNumber substringWithRange:range];
        if ([str isEqualToString:@"+86"]) {
            _strNumber=[_strNumber substringFromIndex:3];
            
        }
        _strNumber=[_strNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        _strNumber=[_strNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        _strNumber=[_strNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        _strNumber=[_strNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (k==0) {
            model.mobilePhone=_strNumber;
        }else if(k==1)
        {
            model.telephone1=_strNumber;
        }else
        {
            model.telephone2=_strNumber;
        }
        [phoneDic setObject:record forKey:[NSString stringWithFormat:@"%d",recordID]];
    }
    char first=pinyinFirstLetter([personname characterAtIndex:0]);
    NSString *sectionName;
    if ((first>='a'&&first<='z')||(first>='A'&&first<='Z')) {
        if([self searchResult:personname searchText:@"曾"])
            sectionName = @"Z";
        else if([self searchResult:personname searchText:@"解"])
            sectionName = @"X";
        else if([self searchResult:personname searchText:@"仇"])
            sectionName = @"Q";
        else if([self searchResult:personname searchText:@"朴"])
            sectionName = @"P";
        else if([self searchResult:personname searchText:@"查"])
            sectionName = @"Z";
        else if([self searchResult:personname searchText:@"能"])
            sectionName = @"N";
        else if([self searchResult:personname searchText:@"乐"])
            sectionName = @"Y";
        else if([self searchResult:personname searchText:@"单"])
            sectionName = @"S";
        else
            sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([personname characterAtIndex:0])] uppercaseString];
        //          NSLog(@"EEEEE:%@",sectionName);
    }
    else {
        sectionName=[[NSString stringWithFormat:@"%c",'#'] uppercaseString];
    }
    NSMutableArray * arr=[sectionDic objectForKey:sectionName];
    if (arr.count==0)
    {
        [sectionDic setValue:[NSMutableArray arrayWithObject:model] forKey:sectionName];
    }else
    {
        [arr addObject:model];
        [sectionDic setValue:arr forKey:sectionName];
    }
    [contactDic setObject:model forKey:[NSString stringWithFormat:@"%d",recordID]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    filteredArray=[[NSMutableArray alloc]init] ;
    sectionDic= [[NSMutableDictionary alloc]init] ;
    phoneDic=[[NSMutableDictionary alloc]init] ;
    contactDic=[[NSMutableDictionary alloc]init] ;
    keys=[[NSArray alloc]init] ;
    importDic=[[NSMutableArray alloc]init];
    _phoneNums = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadContacts];
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    userDefaults = [NSUserDefaults standardUserDefaults];
    UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)] autorelease];
    searchBar.placeholder = @"搜索";
    searchBar.delegate=self;
    searchBar.searchBarStyle = UISearchBarStyleProminent;
    searchBar.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    [self.view addSubview:searchBar];
    [PublicAction clearSearchBarcolor:searchBar];
    
    _tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, searchBar.frame.origin.y + searchBar.frame.size.height,searchBar.frame.size.width, self.view.frame.size.height - 64 - searchBar.frame.size.height)] autorelease];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.bounces = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.contentSize = CGSizeMake(0, _tableView.bounds.size.height + 1);
    [PublicAction tableViewCenter:_tableView];
    [_tableView setTableFooterView:[UIView new]];
    [self.view addSubview:_tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [importDic removeAllObjects];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
//显示返回上一层
-(void)showGroupView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertNewObject:(id)sender
{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"添加" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加到客户通讯录",@"添加到个人通讯录", nil];
    [alert show];
}

#pragma mark ===  【  UIAlertView 导入通讯录  】
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=alertView.cancelButtonIndex)
    {
        if (buttonIndex == 1){
            
            [self addContactToCustomer];
        }else if (buttonIndex ==2){
            [self addContactToUser];
        }
    }
}


-(void)addContactToCustomer
{
    if (importDic.count==1)
    {
        [self addCustomerOnlyOne];
    }else
    {
        [self addCustomerWithArray];
    }
}

-(void)addCustomerWithArray
{
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (NSString * key in importDic)
    {
        ContactModel * con=[contactDic objectForKey:key];
        CustomerModel * model=[[CustomerModel alloc]init];
        model.name=con.name;
        model.mobilePhone=con.mobilePhone;
        model.telephone1=con.telephone1;
        model.telephone2=model.telephone2;
        [array addObject:model];
    }
    CusMarkViewController * cus=[[CusMarkViewController alloc]init];
    cus.saveStatus=1;
    cus.customerArray=array;
    [self.navigationController pushViewController:cus animated:YES];
}

-(void)addCustomerOnlyOne
{
    CustomerModel * model=[[CustomerModel alloc]init];
    NSString * key= [importDic objectAtIndex:0];
    ContactModel * con=[contactDic objectForKey:key];
    model.name=con.name;
    model.mobilePhone=con.mobilePhone;
    model.telephone1=con.telephone1;
    model.telephone2=model.telephone2;
    Newcustomer * customer=[[Newcustomer alloc]init];
    customer.status=1;
    customer.model=model;
    [self.navigationController pushViewController:customer animated:YES];

}

-(void)addContactToUser
{
    if (importDic.count==1)
    {
        [self addUserContactOnleOne];
    }else
    {
        [self addUserContactWithArray];
    }
}

-(void)addUserContactWithArray
{
    
    NSMutableArray * array=[[NSMutableArray alloc]init];
    for (NSString * key in importDic)
    {
        ContactModel * con=[contactDic objectForKey:key];
        PersonInfoModel * model=[[PersonInfoModel alloc]init];
        model.name=con.name;
        model.mobilePhone=con.mobilePhone;
        model.telephone1=con.telephone1;
        model.telephone2=model.telephone2;
        [array addObject:model];
    }
    UsercontactGroup * group=[[UsercontactGroup alloc]init];
    group.customerArray=array;
    [self.navigationController pushViewController:group animated:YES];
}

-(void)addUserContactOnleOne
{
    PersonInfoModel * model=[[PersonInfoModel alloc]init];
    NSString * key= [importDic objectAtIndex:0];
    ContactModel * con=[contactDic objectForKey:key];
    model.name=con.name;
    model.mobilePhone=con.mobilePhone;
    model.telephone1=con.telephone1;
    newUsercontact * contact=[[newUsercontact alloc]init];
    contact.contact=model;
    contact.status=1;
    [self.navigationController pushViewController:contact animated:YES];
}

#pragma mark  --- 【 苹果自带新建联系人 】
-(void)TheNewcontact{
    
    ABNewPersonViewController *picker = [[ABNewPersonViewController alloc] init];
    picker.newPersonViewDelegate = self;
    
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:picker];
    [self presentModalViewController:navigation animated:YES];
    //    [self.navigationController presentViewController:navigation animated:YES completion:nil];
    
    [picker release];
    [navigation release];
    
    
}
#pragma mark ABNewPersonViewControllerDelegate methods
// Dismisses the new-person view controller.
- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ABPersonViewControllerDelegate methods
// Does not allow users to perform default actions such as dialing a phone number, when they select a contact property.
- (BOOL)personViewController:(ABPersonViewController *)personViewController shouldPerformDefaultActionForPerson:(ABRecordRef)person
                    property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifierForValue
{
    return NO;
}


#pragma mark - Table View
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keys;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * v=[[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 18)] autorelease];
    //112,128,144
    v.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1];
    UILabel * label=[[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 18)] autorelease];
    label.text=[keys objectAtIndex:section];
    label.textAlignment=NSTextAlignmentLeft;
    [v addSubview:label];
    return v;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return  [keys indexOfObject:title];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return keys.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 18;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_tableView]) {
        NSString * key= [keys objectAtIndex:section];
        return  [[sectionDic objectForKey:key] count];
    }
    return [filteredArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    return [keys objectAtIndex:section];
}

#pragma mark  [   UITableViewCell  ]
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (![tableView isEqual:_tableView]) {
        static NSString *CellIdentifier = @"Cell";
        MasterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //搜索结果
        if (cell == nil) {
            cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        NSDictionary *person=[filteredArray objectAtIndex:indexPath.row];
        cell.textLabel.text=[person objectForKey:@"name"];
        cell.detailTextLabel.text=[person objectForKey:@"phone"];
        
        
        return cell;
    }
    
    static NSString *identifier = @"MyCell";
    MasterCell * tableCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (tableCell == nil) {
        tableCell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier] ;
        //tableCell.delegate = self;
    }
    
    NSString *key=[keys objectAtIndex:indexPath.section];
    NSMutableArray *persons=[sectionDic objectForKey:key];
    ContactModel * model=[persons objectAtIndex:indexPath.row];
    //NSString * personname=(NSString *)ABRecordCopyCompositeName(record);
    tableCell.title=model.name;
    
    UILabel * btn=[[UILabel alloc]initWithFrame:CGRectMake(10, 7.5, 30, 30)];
    btn.text=[model.name substringToIndex:1];
    btn.font=[UIFont systemFontOfSize:18];
    btn.textAlignment=NSTextAlignmentCenter;
    btn.layer.backgroundColor =[PublicAction randomColor].CGColor;
    btn.textColor=[UIColor whiteColor];
    btn.layer.cornerRadius=15;
    tableCell.selectImage.hidden=YES;
    tableCell.isSelected=NO;
    tableCell.butSelected.layer.backgroundColor=[UIColor clearColor].CGColor;
    [tableCell.contentView addSubview:btn];
    //tableCell.imageView
    //ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonPhoneProperty);
   /* NSString * sub=@"";
    CFIndex nCount = ABMultiValueGetCount(phones);
    
    for (int i = 0; i < nCount; i++) {
        NSString * _strIphone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        if (_strIphone.length>0)
        {
            sub=_strIphone;
            break;
        }
    }*/
    tableCell.subtitle=model.mobilePhone;
    return tableCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MasterCell * tableCell=(MasterCell *)[_tableView cellForRowAtIndexPath:indexPath];
    NSString *key=[keys objectAtIndex:indexPath.section];
    NSMutableArray *persons=[sectionDic objectForKey:key];
    ContactModel * model=[persons objectAtIndex:indexPath.row];
    if (!tableCell.isSelected)
    {
        tableCell.butSelected.layer.backgroundColor=COLOR(34,139,34,1).CGColor;
        [importDic addObject:model._id];
        tableCell.selectImage.hidden=NO;
        tableCell.isSelected=YES;
    }else
    {
        tableCell.butSelected.layer.backgroundColor=[UIColor clearColor].CGColor;
        [importDic removeObject:model._id];
        tableCell.selectImage.hidden=YES;
        tableCell.isSelected=NO;
    }
    [self chageRightBtnTitle];
    [_tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)chageRightBtnTitle
{
    NSString * title=@"";
    if (importDic.count>0)
    {
        title=[NSString stringWithFormat:@"导入 (%ld)",importDic.count];
    }else
    {
        title=@"导入";
    }
    UIBarButtonItem *rightBtn = [[[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(importTap)] autorelease];
    rightBtn.tintColor=[UIColor whiteColor];
    //insertNewObject
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)importTap
{
    if (importDic.count==0)
    {
        [self zeroAlert];
    }else
    {
        UIAlertView* alert  = [[UIAlertView alloc] initWithTitle:@"添加" message:nil
                                                        delegate:self cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"添加到客户通讯录", @"添加到个人通讯录",nil];
        
        alert.tag = 100;
        [alert show];
    }
}

-(void)zeroAlert
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    [hud hide:YES afterDelay:1];
    hud.labelText = @"请选择要添加的人员";
    [self.navigationController.view addSubview:hud];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

-(void)messageTelephone:(NSString *)Telephone{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:_strApple]];
}

#pragma mark ====  【  iphoneBtn 拨号 】

- (void)callWithNum:(NSString *)_strIphone type:(int)type{
    
    
    userid = [userDefaults stringForKey:@"userid"];
    nid = [userDefaults stringForKey:@"nid"];
    eid = [userDefaults stringForKey:@"eid"];
    verify = [userDefaults stringForKey:@"verify"];
    Num = [userDefaults stringForKey:@"Num"];
    
    NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"%@\"}]}",Num,_strIphone,userid];
    
    NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _strApple = _strIphone;
    
    NSString* strUrling = [_strApple stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* striZui = [strUrling stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    
    
    if (type == 0) {//个人直接
        UIWebView* callwebView = [[UIWebView alloc] init];
        NSURL* telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_strIphone]];
        [callwebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
        [self.view addSubview:callwebView];
    }else if (type == 1){
    }else if (type == 2){
        
        
        NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"\"}]}",striZui,Num];
        
        NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlStr =[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid&id=%@&from=2&telephonenumber=%@&eid@&verify=%@",nid,data,verify];
        [self get5];
        
    }
}


-(void)get5{
    
    AFHTTPRequestOperationManager *manager=[[AFHTTPRequestOperationManager alloc]init];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //json解析数据
         
         NSDictionary *Dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
         NSString *money=[NSString stringWithFormat:@"%@",[Dic objectForKey:@"post_data_result"]];
         NSString *resulterr = @"1";
         if([money isEqualToString:resulterr])
         {
             IphoneController *vc = [[IphoneController alloc]init];
             vc.number = _strApple;
             [self presentViewController:vc animated:YES completion:nil];
         }
         else
         {
             [SGInfoAlert showInfo:@"拨号有误"
              
                           bgColor: [UIColor orangeColor].CGColor
              
                            inView:self.view
              
                          vertical:0.8];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     }];
    
    
}


#pragma UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchString waitUntilDone:YES];
    
    return YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchWithString:searchText];
    [_tableView reloadData];

}
-(void)searchWithString:(NSString *)searchString
{
    [filteredArray removeAllObjects];
    NSString * regex = @"(^[0-9]+$)";
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([searchString length]!=0) {
        if ([pred evaluateWithObject:searchString]) { //判断是否是数字
            NSArray *phones=[phoneDic allKeys];
            for (NSString *phone in phones) {
                if ([self searchResult:phone searchText:searchString]) {
                    ABRecordRef person=[phoneDic objectForKey:phone];
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSString *ff=[NSString stringWithFormat:@"%d",recordID];
                    
                    NSString *name=(NSString *)ABRecordCopyCompositeName(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:[phone substringToIndex:(phone.length-ff.length)] forKey:@"phone"];
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                    [record release];
                }
            }
        }
        else {
            //搜索对应分类下的数组
            NSString *sectionName = [[NSString stringWithFormat:@"%c",pinyinFirstLetter([searchString characterAtIndex:0])] uppercaseString];
            NSArray *array=[sectionDic objectForKey:sectionName];
            for (int j=0;j<[array count];j++) {
                ABRecordRef person=[array objectAtIndex:j];
                NSString *name=(NSString *)ABRecordCopyCompositeName(person);
                if ([self searchResult:name searchText:searchString]) { //先按输入的内容搜索
                    ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                    NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                    ABRecordID recordID=ABRecordGetRecordID(person);
                    NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                    [record setObject:name forKey:@"name"];
                    [record setObject:personPhone forKey:@"phone"];
                    [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                    [filteredArray addObject:record];
                    [record release];
                }
                else { //按拼音搜索
                    NSString *string = @"";
                    NSString *firststring=@"";
                    for (int i = 0; i < [name length]; i++)
                    {
                        if([string length] < 1)
                            string = [NSString stringWithFormat:@"%@",
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        else
                            string = [NSString stringWithFormat:@"%@%@",string,
                                      [POAPinyin quickConvert:[name substringWithRange:NSMakeRange(i,1)]]];
                        if([firststring length] < 1)
                            firststring = [NSString stringWithFormat:@"%c",
                                           pinyinFirstLetter([name characterAtIndex:i])];
                        else
                        {
                            if ([name characterAtIndex:i]!=' ') {
                                firststring = [NSString stringWithFormat:@"%@%c",firststring,
                                               pinyinFirstLetter([name characterAtIndex:i])];
                            }
                            
                        }
                    }
                    if ([self searchResult:string searchText:searchString]
                        ||[self searchResult:firststring searchText:searchString])
                    {
                        ABMultiValueRef phone = ABRecordCopyValue(person, kABPersonPhoneProperty);
                        NSString * personPhone = (NSString*)ABMultiValueCopyValueAtIndex(phone, 0);
                        ABRecordID recordID=ABRecordGetRecordID(person);
                        NSMutableDictionary *record=[[NSMutableDictionary alloc] init];
                        [record setObject:name forKey:@"name"];
                        [record setObject:personPhone forKey:@"phone"];
                        [record setObject:[NSNumber numberWithInt:recordID] forKey:@"ID"];
                        [filteredArray addObject:record];
                        [record release];
                        
                    }
                    
                    
                }
            }
        }
    }
}
-(void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
}
-(BOOL)searchResult:(NSString *)contactName searchText:(NSString *)searchT{
    NSComparisonResult result = [contactName compare:searchT options:NSCaseInsensitiveSearch
                                               range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame)
        return YES;
    else
        return NO;
}


@end
