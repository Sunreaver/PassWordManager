//
//  UserDef.h
//  Platform
//
//  Created by Wei Tan on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define WEAK_SELF(weakself) __weak __typeof(self)weakself = self;
#define STRONG_SELF(weakself, strongself) __typeof(weakself)strongself = weakself;

#import <UIKit/UIKit.h>

#ifndef Platform_UserDef_h
#define Platform_UserDef_h

#define PWD_TipPinYin @"tpy"
#define PWD_Tip @"tp"
#define PWD_Text @"p"
#define PWD_Account @"ac"

//获取沙盒文件
#define File_Path(filePath) ([[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSAllDomainsMask, YES) objectAtIndex:0] stringByAppendingPathComponent:filePath])

@interface UserDef : NSObject

+(id)getUserDefValue:(NSString*)key;
+(void)setUserDefValue:(id)value keyName:(NSString*)key;
+(void)removeObjectForKey:(NSString*)key;
+(void)synchronize;
@end

#endif
