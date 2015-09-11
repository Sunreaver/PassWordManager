//
//  NSString+GetPinYinFirstChar.m
//  PassWord
//
//  Created by 谭伟 on 15/7/15.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "NSString+GetPinYinFirstChar.h"
#import <PinYin4Objc.h>

@implementation NSString (GetPinYinFirstChar)

-(NSString*)getPinYinFirstChar
{
    //拼音翻译
    HanyuPinyinOutputFormat *outputFormat=[[HanyuPinyinOutputFormat alloc] init];
    outputFormat.toneType = ToneTypeWithoutTone;
    outputFormat.vCharType = VCharTypeWithV;
    outputFormat.caseType = CaseTypeLowercase;
    NSString *pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:self
                                         withHanyuPinyinOutputFormat:outputFormat
                                                        withNSString:@" "];
    
    NSArray *arr = [pinyin componentsSeparatedByString:@" "];
    pinyin = @"";
    for (NSString *s in arr)
    {
        pinyin = [pinyin stringByAppendingString:[s substringToIndex:1]];
    }
    return pinyin;
}

@end
