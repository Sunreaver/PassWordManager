//
//  PassWord.h
//  PassWord
//
//  Created by 谭伟 on 15/5/27.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PassWordInit(data) [PassWord initWithData:data]

@interface PassWord : NSObject

@property (nonatomic, readonly) NSString *pwd;//密码
@property (nonatomic, readonly) NSString *tip;//介绍
@property (nonatomic, readonly) NSString *acc;//帐号
@property (nonatomic, readonly) NSString *tip_pinyin;//介绍的拼音

+(instancetype)initWithData:(NSDictionary*)data;
@end
