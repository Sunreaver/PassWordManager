//
//  PwdData.m
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "PwdData.h"
#import "UserDef.h"

static NSMutableArray *s_data = nil;
static NSMutableArray *s_index = nil;
static NSString *s_searchKey = @"";
static BOOL s_bDataChange = NO;

@implementation PwdData

#pragma mark -初始化
+(NSArray*)data
{
    if (!s_data)
    {
        s_bDataChange = NO;
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:File_Path(@"com.tmp.catch")];
        if (arr)
        {
            s_data = [arr mutableCopy];
        }
        else
        {
            s_data = [NSMutableArray array];
        }
    }
    return s_data;
}

+(NSArray*)pwdList
{
    if (!s_index)
    {
        s_index = [NSMutableArray array];
        for (NSUInteger i = 0; i < [PwdData data].count; ++i)
        {
            [s_index addObject:[NSNumber numberWithUnsignedInteger:i]];
        }
    }
    return s_index;
}

#pragma mark -保存

+(void)storageData
{
    if (s_bDataChange && s_data && s_data.count > 0)
    {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:s_data];
        [data writeToFile:File_Path(@"com.tmp.catch") atomically:YES];
        s_bDataChange = NO;
    }
}

#pragma mark -功能方法

+(void)AddDataWithTip:(NSString *)tip PassWord:(NSString *)pwd Account:(NSString *)acc
{
    s_bDataChange = YES;
    if (acc.length == 0)
    {
        [s_data insertObject:PassWordInit((@{PWD_Tip:tip,PWD_Text:pwd})) atIndex:0];
    }
    else
    {
        [s_data insertObject:PassWordInit((@{PWD_Tip:tip,PWD_Text:pwd,PWD_Account:acc})) atIndex:0];
    }
    [PwdData searchPwdListWithKey:s_searchKey];
}

+(void)EditDataWithTip:(NSString *)tip PassWord:(NSString *)pwd Account:(NSString *)acc Index:(NSInteger)index
{
    s_bDataChange = YES;
    if (acc.length == 0)
    {
        [s_data replaceObjectAtIndex:index withObject:PassWordInit((@{PWD_Tip:tip,PWD_Text:pwd}))];
    }
    else
    {
        [s_data replaceObjectAtIndex:index withObject:PassWordInit((@{PWD_Tip:tip,PWD_Text:pwd,PWD_Account:acc}))];
    }
    [PwdData searchPwdListWithKey:s_searchKey];
}

+(void)DeleteDataAtIndex:(NSUInteger)index
{
    s_bDataChange = YES;
    if (index < s_data.count)
    {
        [s_data removeObjectAtIndex:index];
    }
    [PwdData searchPwdListWithKey:s_searchKey];
}

+(void)moveRow:(NSInteger)move ToRow:(NSInteger)to
{
    s_bDataChange = YES;
    
    id m = s_data[move];
    [s_data removeObjectAtIndex:move];
    [s_data insertObject:m atIndex:to];
    
    [PwdData searchPwdListWithKey:s_searchKey];
}

#pragma mark -搜索

+(void)searchPwdListWithKey:(NSString *)key
{
    s_searchKey = key;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray *arr = [NSMutableArray array];
        if (!key || key.length == 0)
        {
            for (NSUInteger i = 0; i < [PwdData data].count; ++i)
            {
                [arr addObject:[NSNumber numberWithUnsignedInteger:i]];
            }
        }
        else
        {
            //三段查找，相当于结果默认序列为tip > pinyin > acc
            NSUInteger i = 0;
            for (PassWord *pwd in [PwdData data])
            {
                if ([pwd.tip containsString:key])
                {
                    [arr addObject:@(i)];
                }
                ++i;
            }
            i = 0;
            for (PassWord *pwd in [PwdData data])
            {
                if (![arr containsObject:@(i)] && [pwd.tip_pinyin containsString:key])
                {
                    [arr addObject:@(i)];
                }
                ++i;
            }
            i = 0;
            for (PassWord *pwd in [PwdData data])
            {
                if (![arr containsObject:@(i)] && [pwd.acc containsString:key])
                {
                    [arr addObject:@(i)];
                }
                ++i;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            s_index = arr;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedRefreshDataView" object:nil];
        });
    });
}
@end
