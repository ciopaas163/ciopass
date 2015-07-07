//
//  MasterViewController.m
//  datoucontacts
//
//  Created by houwenjie on 12-7-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "GroupViewController.h"
#import "DetailViewController.h"
#import "pinyin.h"
#import "POAPinyin.h"
#import "AFNetworking.h"
#import "SGInfoAlert.h"
#import "IphoneController.h"

#import "PersonalView.h"        // 个人通讯录
#import "Newcustomer.h"     // 新建客户

#import "MasterCell.h"
@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =@"手机通讯录";
        filteredArray=[[NSMutableArray alloc] init];
        sectionDic= [[NSMutableDictionary alloc] init];
        phoneDic=[[NSMutableDictionary alloc] init];
        contactDic=[[NSMutableDictionary alloc] init];
        
        _phoneNums = [[NSMutableArray alloc] init];
    }
    return self;
}
							
- (void)dealloc
{
    [super dealloc];
//    [_detailViewController release];
//    [filteredArray         release];
//    [sectionDic            release];
//    [phoneDic              release];
//    [contactDic            release];

    
}
// 导入通讯录

-(void)loadContacts
{

    
    [sectionDic removeAllObjects];
    [phoneDic   removeAllObjects];
    [contactDic removeAllObjects];
    for (int i = 0; i < 26; i++) [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'A'+i]];
    [sectionDic setObject:[NSMutableArray array] forKey:[NSString stringWithFormat:@"%c",'#']];
    
    ABAddressBookRef myAddressBook =ABAddressBookCreate();
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
        NSString *personname = (NSString *)ABRecordCopyCompositeName(record);
        ABMultiValueRef phone = ABRecordCopyValue(record, kABPersonPhoneProperty);
        ABRecordID recordID=ABRecordGetRecordID(record);
        for (int k = 0; k<ABMultiValueGetCount(phone); k++)
        {
            _strNumber = (NSString*)ABMultiValueCopyValueAtIndex(phone, k);
            NSRange range=NSMakeRange(0,3);
            NSString *str=[_strNumber substringWithRange:range];
            if ([str isEqualToString:@"+86"]) {
                _strNumber=[_strNumber substringFromIndex:3];

            }
            
            [phoneDic setObject:record forKey:[NSString stringWithFormat:@"%@%d",_strNumber,recordID]];
#pragma mark --- {  找到电话号码 }        
//             NSLog(@"WWWW:%@",_strNumber);
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
             NSLog(@"QQQQQ:%@",sectionName);
        }
        
        [[sectionDic objectForKey:sectionName] addObject:record];
        [contactDic setObject:record forKey:[NSNumber numberWithInt:recordID]];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadContacts];
       userDefaults = [NSUserDefaults standardUserDefaults];
//    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)] autorelease];
    UIBarButtonItem *addButton = [[[UIBarButtonItem alloc] initWithTitle:@"导入" style:UIBarButtonItemStylePlain target:self action:@selector(insertNewObject:)] autorelease];
//    [addButton setTitle:@"23"];

    UIBarButtonItem *groupButton =[[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(showGroupView)] autorelease];

    self.navigationItem.rightBarButtonItem = addButton;
    self.navigationItem.leftBarButtonItem=groupButton;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (![self.searchDisplayController isActive]) {
        [self loadContacts];
        [self.tableView reloadData];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark ---- [返回上一层]
//显示返回上一层
-(void)showGroupView
{
//    GroupViewController *groupView=[[GroupViewController alloc] initWithNibName:@"GroupViewController" bundle:nil];
//    [self.navigationController pushViewController:groupView animated:YES];
//    [groupView release];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)insertNewObject:(id)sender
{

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"添加" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加到客户通讯录",@"添加到个人通讯录", nil];
    [alert show];
}

#pragma mark ===  【  UIAlertView 导入通讯录  】
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSLog(@"buttonIndex == 取消");

    }else if (buttonIndex == 1){

        NSLog(@"buttonIndex == 客户");
        Newcustomer* newcus = [[Newcustomer alloc] init];
        [self.navigationController pushViewController:newcus animated:YES];

    }else if (buttonIndex ==2){

        NSLog(@"buttonIndex == 个人");
//        PersonalView* persona = [[PersonalView alloc]init];
//        [self.navigationController pushViewController:persona animated:YES];
        [self TheNewcontact];

    }
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
    if ([tableView isEqual:self.tableView]) {
    NSMutableArray *indices = [NSMutableArray arrayWithObject:UITableViewIndexSearch];
    for (int i = 0; i < 27; i++) 
            [indices addObject:[[ALPHA substringFromIndex:i] substringToIndex:1]];
    //[indices addObject:@"\ue057"]; // <-- using emoji
    return indices;
    }
    return nil;
}
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if (title == UITableViewIndexSearch) 
	{
		[self.tableView scrollRectToVisible:self.searchDisplayController.searchBar.frame animated:NO];
		return -1;
	}

   return  [ALPHA rangeOfString:title].location;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.tableView]) {
        return 27;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.tableView]) {
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
   return  [[sectionDic objectForKey:key] count];
    }
   return [filteredArray count];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        return nil;
    }
    NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:section]];
    if ([[sectionDic objectForKey:key] count]!=0) {
        return key;
    }
    return nil;
}

#pragma mark  [   UITableViewCell  ]
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [longPressReger release];

    
    if (![tableView isEqual:self.tableView]) {
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

    NSString *identify = [NSString stringWithFormat:@"%d%d",indexPath.section,indexPath.row];
        MasterCell * tableCell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (tableCell == nil) {
            tableCell = [[[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
            tableCell.delegate = self;
        }
    
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];
        ABRecordRef record=[persons objectAtIndex:indexPath.row];
        tableCell.textLabel.text=(NSString *)ABRecordCopyCompositeName(record);
    
    NSLog(@" 名字  = %@",ABRecordCopyCompositeName(record));

        NSData *imageData=(NSData*)ABPersonCopyImageData(record);
    
    ABMultiValueRef phones = (ABMultiValueRef)ABRecordCopyValue(record, kABPersonPhoneProperty);
    
    int nCount = ABMultiValueGetCount(phones);
    
    for (int i = 0; i < nCount; i++) {
        NSString * _strIphone = (NSString *)ABMultiValueCopyValueAtIndex(phones, i);
        
        tableCell.phoneNum = _strIphone;
        NSLog(@"电话号码  =%@",_strIphone);
    }



//    NSLog(@"ASADADADADAAD?:%@",tableCell.phoneNum);

    BOOL status = NO;
    
    
//    NSLog(@"dict %@",sectionDic);     //电话
    
    
    tableCell.butIphone.selected = status;
//        [cell.imageView setImage:[UIImage imageWithData:imageData]];
//         cell.imageView.contentMode=UIViewContentModeScaleToFill;

//    tableCell.accessoryType = UITableViewCellStyleValue2;

    return tableCell;

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

    NSLog(@"userID:%@\tnid:%@\neid:%@\nverify:%@\nNum%@",userid,nid,eid,verify,Num);
    NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"%@\"}]}",Num,_strIphone,userid];
    NSLog(@"nsdic = %@",nsdic);
    NSLog(@"查询:::::%@",_strIphone);

    NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    _strApple = _strIphone;

    NSString* strUrling = [_strApple stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString* striZui = [strUrling stringByReplacingOccurrencesOfString:@"+86" withString:@""];


    NSLog(@"【asdasd】:%@",striZui);

    NSLog(@"!@#$%^REWQ:%@",_strApple);


    if (type == 0) {//个人直接
         NSLog(@"Type:1");
        UIWebView* callwebView = [[UIWebView alloc] init];
        NSURL* telUrl = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",_strIphone]];
        NSLog(@"_strIphone：####:%@",_strIphone);
        [callwebView loadRequest:[NSURLRequest requestWithURL:telUrl]];
        [self.view addSubview:callwebView];
    }else if (type == 1){
        NSLog(@"Type:2");
    }else if (type == 2){

         NSLog(@"Type:2----个人云");

        NSString  *nsdic = [NSString stringWithFormat:@"{\"DataList\":[{\"callees\":\"%@\",\"calleesName\":\"\u962e\u4e2d\u5f3a\",\"caller\":\"%@\",\"callerName\":\"6Ziu5Lit5by6\",\"userId\":\"\"}]}",striZui,Num];
        NSLog(@"nsdic = %@",nsdic);
        NSLog(@"号码：：:%@",striZui);

        NSString *data = [nsdic stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        urlStr =[NSString stringWithFormat:@"http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid&id=%@&from=2&telephonenumber=%@&eid@&verify=%@",nid,data,verify];
        NSLog(@"str = %@",urlStr);
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
         NSLog(@"Dic = %@",Dic);
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
         NSLog(@"%@",error);
     }];


}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];




    ABRecordRef person;
    if (![tableView isEqual:self.tableView]) {
        NSMutableDictionary *record=[filteredArray objectAtIndex:indexPath.row];
        NSString *recordID=[record objectForKey:@"ID"];
        person=[contactDic objectForKey:recordID];
        
        
    }
    else {
        NSString *key=[NSString stringWithFormat:@"%c",[ALPHA characterAtIndex:indexPath.section]];
        NSMutableArray *persons=[sectionDic objectForKey:key];

        person=[persons objectAtIndex:indexPath.row];
    }
#pragma mark ==== [【 允许用户编辑个人信息 】 ]
    /*    Allow users to edit the person’s information  【 允许用户编辑个人信息 】
    ABPersonViewController *picker = [[[ABPersonViewController alloc] init] autorelease];
    picker.personViewDelegate = self;
    picker.displayedPerson = person;
    picker.allowsActions=YES;

//    picker.allowsEditing = YES;
//    [self.navigationController pushViewController:picker animated:YES];
*/
}

#pragma UISearchDisplayDelegate
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self performSelectorOnMainThread:@selector(searchWithString:) withObject:searchString waitUntilDone:YES];

    return YES;
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
    
    NSLog(@"array count %d",[filteredArray count]);
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
