//
//  Database.m
//  Communication
//
//  Created by helloworld on 15/3/2.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#import "Database.h"


#import "DatabaseModel.h"

#import "FMDatabase.h"
#define DBNAME @"Schedule.db"
@interface Database()
@property (nonatomic, strong) FMDatabase *database;
@end
@implementation Database

+(Database*)sharDatabase{   //单例
    static Database* datadb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (datadb ==nil) {
            datadb = [[Database alloc]init];
        }
    });
    return datadb;

}

#pragma mark 初始化
- (id)init
{
    self = [super init];
    if (self)
    {
        NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        path = [path stringByAppendingPathComponent:DBNAME];
        
        self.database = [FMDatabase databaseWithPath:path];
        
        if ([self.database open])
        {
            //创建日历事件表
            NSString *sql = @"create table if not exists Schedule(sysID integer primary key autoincrement,title text, content text,id text,loginID text,operateId text,stop_time text,alertTime text,begin_time text,task_tag text,userType text,SID text,verify text)";
            [self.database executeUpdate:sql];
            
            //创建日历记录表
            NSString *Calsql = @"create table if not exists Calendar(sysID integer primary key autoincrement,title text, State text,time text,jishi text,Modular text)";
            [self.database executeUpdate:Calsql];
            
            
        }
        
        [self.database close];
    }
    return self;
}

#pragma mark 增加日历事件数据

- (BOOL)addMovie:(NSString *)sql
{
    BOOL success = NO;
    if (!sql)
    {
        return success;
    }
    
    if ([self.database open])
    {
        success = [self.database executeUpdate:sql];
    }
    [self.database close];
    
    return success;
}

#pragma mark 删除日历事件某条数据

- (BOOL)deleteMovie:(NSString *)Schedule
{
    if (!Schedule)
    {
        return NO;
    }
    BOOL success = NO;
    if ([self.database open])
    {
//        NSString *sql = @"delete from Schedule where no=?";
        
        success = [self.database executeUpdate:Schedule];
    }
    [self.database close];
    return success;
}
/*
#pragma mark 查询日历事件某条数据

- (NSArray *)searchMovieByName:(NSString *)sql
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    if ([self.database open])
    {
        FMResultSet *set = [self.database executeQuery:sql];
        
        while ([set next]) {
            ScheduleModel *Schedule = [[ScheduleModel alloc] init];
            
            //从数据库取数据
            Schedule.sysID = [set stringForColumn:@"sysID"];
            Schedule.title = [set stringForColumn:@"title"];
            Schedule.content = [set stringForColumn:@"content"];
            Schedule.mid = [set stringForColumn:@"id"];
            Schedule.loginID = [set stringForColumn:@"loginID"];
            Schedule.operateId = [set stringForColumn:@"operateId"];
            Schedule.stop_time = [set stringForColumn:@"stop_time"];
            Schedule.alertTime = [set stringForColumn:@"alertTime"];
            Schedule.begin_time = [set stringForColumn:@"begin_time"];
            Schedule.task_tag = [set stringForColumn:@"task_tag"];
            Schedule.userType = [set stringForColumn:@"userType"];
            Schedule.SID = [set stringForColumn:@"SID"];
            Schedule.verify = [set stringForColumn:@"verify"];
            
//            NSLog(@"Schedule.title=%@",Schedule.title);
            
            [list addObject:Schedule];
        }
        
    }
    
    [self.database close];
    
    
    return list;
}

#pragma mark查询日历事件所有数据

- (NSArray *)allSchedule
{
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    if ([self.database open])
    {
        NSString *sql = @"select * from Schedule";
        FMResultSet *set = [self.database executeQuery:sql];
        
        while ([set next]) {
            ScheduleModel *Schedule = [[ScheduleModel alloc] init];
            
            //从数据库取数据
            Schedule.sysID = [set stringForColumn:@"sysID"];
            Schedule.title = [set stringForColumn:@"title"];
            Schedule.content = [set stringForColumn:@"content"];
            Schedule.mid = [set stringForColumn:@"id"];
            Schedule.loginID = [set stringForColumn:@"loginID"];
            Schedule.operateId = [set stringForColumn:@"operateId"];
            Schedule.stop_time = [set stringForColumn:@"stop_time"];
            Schedule.alertTime = [set stringForColumn:@"alertTime"];
            Schedule.begin_time = [set stringForColumn:@"begin_time"];
            Schedule.task_tag = [set stringForColumn:@"task_tag"];
            Schedule.userType = [set stringForColumn:@"userType"];
            Schedule.SID = [set stringForColumn:@"SID"];
            Schedule.verify = [set stringForColumn:@"verify"];
            
//            NSLog(@"Schedule.title=%@",Schedule.title);
            [list addObject:Schedule];
        }
        
    }
    
    [self.database close];
    
    
    return list;
}
*/
- (BOOL)updateMovie:(NSString *)sql;              //更新某条数据
{
    BOOL success = NO;

    if ([self.database open])
    {
        success = [self.database executeUpdate:sql];
    }
    [self.database close];
    return success;
    
    
}

#pragma mark 查询日历操作记录数据

-(FMResultSet *)searchCalendar:(NSString *)sql
{
 
    if ([self.database open])
    {
        FMResultSet *set = [self.database executeQuery:sql];
        return set;
    }
    
    [self.database close];

    return nil;
}

#pragma mark ======【    孙凯迪   】

//获得存放数据库文件的沙盒地址
-(NSString*)databaseFilePath{

    NSArray* filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documentPath = [filePath objectAtIndex:0];
    //    NSLog(@"~~documentPath:%@",documentPath);
    NSString* dbFilePath = [documentPath stringByAppendingPathComponent:@"MyDatabase.db"];
    //    NSLog(@"####dbFilePath:%@",dbFilePath);

    return dbFilePath;
}

- (BOOL)openDB{
    self.datadb = [FMDatabase databaseWithPath:[self databaseFilePath]];
    if ([self.datadb open]) {
        return YES;
    }
    return NO;
}

//创建数据库的操作
-(void)creatDatabase:(NSString *)sql{


    /*
     per_status 云呼叫是否可用

     per_number_type   云呼叫显号类型 1手机 2 固话
     per_set_maincall_type 云呼叫指定号码 1手机 2 固话
     per_allow_set_type 云呼叫是否能设置显号类型  0 1
     per_allow_set_telephone 云呼叫是否能设置指定号码 0 1


     status 企业付费拨号是否可用
     number_type  企业付费拨号显号类型 1手机 2 固话
     set_maincall_type  企业付费拨号指定号码 1手机 2 固话
     allow_set_type  企业付费拨号是否能设置显号类型  0 1
     allow_set_telephone 企业付费拨号是否能设置指定号码 0 1
     */
    //
    if ([self openDB]) {
        [self.datadb executeUpdate:sql];

        [self.datadb close];
    }

}

- (void)saveSql:(NSString *)sql{
    if ([self openDB]) {
        [self.datadb executeUpdate:sql];

        [self.datadb close];
    }
}

- (FMResultSet *)readSql:(NSString *)sql{
    if ([self openDB]) {
        FMResultSet *result = [self.datadb executeQuery:sql];

        //        [self.datadb close];
        return result;
    }
    return nil;
}


@end

