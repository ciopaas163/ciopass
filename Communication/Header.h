//
//  Header.h
//  Communication
//
//  Created by CIO on 15/2/5.
//  Copyright (c) 2015年 JL. All rights reserved.
//

#ifndef Communication_Header_h
#define Communication_Header_h


#pragma mark ---{ 宏}

//颜色宏
#define COLOR(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//图片宏
#define IMAGE(name, top) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:top]]
//登录
#define LoginURL @"http://open.ciopaas.com/Admin/Info/get_cti_data?"
/*
 企业(个人)云通讯
 id - 登录ID
 verify - 类似验证码的验证信息
 telephonenumber  - 显示的参数
 【包括：1.主叫人名     2.主叫人电话    3.被叫人名     4.被叫人电话】
 userid  - 员工ID
 eid - 企业ID
 【 from 】
 增加来源参数：from : 1 为电脑端（PC端）
 2 为手机端
 
 
 
 http://open.ciopaas.com/Admin/Info/dial_payment_telephone?userid=100198&id=341&from=2&telephonenumber=&eid=10000101&verify=4Q9PITQS&userid
 
 {“DataList”:[{“callees”:”15883510152","calleesName":"","caller":"13590209020","callerName":"","userId":"100198"}]}
 */

#define IphoneGET 


#endif
