//
//  Shortmessage.m
//  Communication
//
//  Created by CIO on 15/2/7.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Shortmessage.h"
#import "pilst.h"
#import "Database.h"
#import "DatabaseModel.h"
@interface Shortmessage ()

@end

@implementation Shortmessage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1];
    self.title = @"短信助手";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"return" style:UIBarButtonItemStyleDone target:self action:@selector(FanhuiBtnBarItem:)];

    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 80, 60, 40);
    [button setTitle:@"plist" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    button.layer.borderColor = [[UIColor purpleColor]CGColor];
    button.layer.borderWidth = 2;
    button.layer.cornerRadius = 5;
    [button addTarget:self action:@selector(XMlbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    for (int i = 0; i < 6; i++) {
        _testLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 90 + i*(40+10), 200, 40)];
        _testLabel.text = array;
        _testLabel.backgroundColor = [UIColor grayColor];
        _testLabel.textColor = [UIColor orangeColor];
        _testLabel.font = [UIFont systemFontOfSize:20];
        _testLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_testLabel];
    }
    
}
-(void)FanhuiBtnBarItem:(UIBarButtonItem*)FanhuiBtnBarItem{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)XMlbutton:(UIButton*)xml{
    NSString  *a = @"i like long dress";

    NSString *b = [a substringFromIndex:4];

//    [self plistFangfa];
    /*
    Database *db = [Database sharDatabase];
    NSLog(@"db  %@",db);
    NSString *tablename = @"eeeeeeeeee";
    NSString *create = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (_id text, pid TEXT, departmentname TEXT, eid TEXT, ctime TEXT)",tablename];
    [db creatDatabase:create];
    
    
//    NSArray *data;

    for (int i = 0; i < 5; i++) {
        NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO %@ (_id , pid , departmentname, eid , ctime) VALUES ('%@','%@','%@','%@','%@')",tablename,@"9527",@"sunkaidi",@"322",@"4333",@"52222"];
        [db saveSql:insertSql];
    }
    
    NSString *readSql = [NSString stringWithFormat:@"SELECT * FROM %@",tablename];
    
    FMResultSet *result = [db readSql:readSql];
    while ([result next]) {
        NSLog(@"%@\n",[result stringForColumn:@"_id"]);
        NSLog(@"%@\n",[result stringForColumn:@"pid"]);
        NSLog(@"%@\n",[result stringForColumn:@"departmentname"]);
        NSLog(@"%@\n",[result stringForColumn:@"eid"]);
        NSLog(@"%@\n",[result stringForColumn:@"ctime"]);
    }
    
    [db.datadb close];
     */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)plistFangfa{
//    建立文件管理
    NSFileManager * IDdata = [NSFileManager defaultManager];
//    找到Documents文件所在的路径
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
//    取得第一个Documents文件夹的路径
    NSString *filePath = [path objectAtIndex:0];

//    把TestPlist文件加入
    NSString *plistPath = [filePath stringByAppendingPathComponent:@"test.plist"];

//    开始创建文件
    [IDdata createFileAtPath:plistPath contents:nil attributes:nil];

//    删除文件
    [IDdata removeItemAtPath:plistPath error:nil];

//    在写入数据之前，需要把要写入的数据先写入一个字典中，创建一个dictionary：
//    创建一个字典
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"zhangsan",@"1",@"lisi",@"2", nil];
    
//    把数据写入plist文件
    [dic writeToFile:plistPath atomically:YES];

//    读取plist文件，首先需要把plist文件读取到字典中
    NSDictionary *dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];

//    打印数据
//    关于plist中的array读写，代码如下：
//    把TestPlist文件加入
    NSString *plistPaths = [filePath stringByAppendingPathComponent:@"tests.plist"];

//    开始创建文件
    [IDdata createFileAtPath:plistPaths contents:nil attributes:nil];

//    创建一个数组
    NSArray *arr = [[NSArray alloc] initWithObjects:@"1",@"2",@"3",@"4", nil];

//    写入
    [arr writeToFile:plistPaths atomically:YES];

//    读取
    NSArray *arr1 = [NSArray arrayWithContentsOfFile:plistPaths];
    
//    打印
    array = [[NSArray alloc ]initWithObjects:@"@@@",@"$$$",@"~~~"@"WWW",@"%%%",@"&&&", nil];
    [array writeToFile:plistPaths atomically:YES];

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
