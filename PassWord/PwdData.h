//
//  PwdData.h
//  PassWord
//
//  Created by 谭伟 on 15/5/22.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "PassWord.h"
#import <Foundation/Foundation.h>

#define IndexInPwdList(index) [[PwdData pwdList][index] integerValue]

@interface PwdData : NSObject

+(NSArray*)pwdList;
+(NSArray<PassWord*>*)data;//PassWord

+(void)storageData;
+(void)AddDataWithTip:(NSString*)tip PassWord:(NSString*)pwd Account:(NSString*)acc;
+(void)EditDataWithTip:(NSString*)tip PassWord:(NSString*)pwd Account:(NSString*)acc Index:(NSInteger)index;
+(void)DeleteDataAtIndex:(NSUInteger)index;
+(void)moveRow:(NSInteger)move ToRow:(NSInteger)to;

+(void)searchPwdListWithKey:(NSString*)key;
@end
