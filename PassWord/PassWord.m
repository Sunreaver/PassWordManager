//
//  PassWord.m
//  PassWord
//
//  Created by 谭伟 on 15/5/27.
//  Copyright (c) 2015年 谭伟. All rights reserved.
//

#import "PassWord.h"
#import "UserDef.h"
#import "PinYin4Objc.h"
#import "NSString+GetPinYinFirstChar.h"
#import "MD5Encode.h"

@interface PassWord()<NSCoding>

@end

@implementation PassWord
@synthesize tip = _tip;
@synthesize pwd = _pwd;
@synthesize acc = _acc;
@synthesize pwid = _pwid;

-(void)setTip:(NSString *)tip
{
    _tip = tip;
}

-(void)setPwd:(NSString *)pwd
{
    _pwd = pwd;
}

-(void)setAcc:(NSString *)acc
{
    _acc = acc;
}

-(void)setPwid:(id)pwid
{
    _pwid = pwid;
}

-(void)setTip_pinyin:(NSString *)tip_pinyin
{
    _tip_pinyin = tip_pinyin;
}

+(instancetype)initWithData:(NSDictionary*)data
{
    PassWord *pw = [[PassWord alloc] init];
    pw.tip = data[PWD_Tip];
    pw.pwd = data[PWD_Text];
    
    if (data[PWD_Account] && [data[PWD_Account] length])
    {
        pw.acc = data[PWD_Account];
    }
    else
    {
        pw.acc = @"...";
    }
    pw.tip_pinyin = [pw.tip getPinYinFirstChar];
    pw.pwid = [pw makePwid];
    return pw;
}

-(NSString *)description
{
    if (self.acc.length > 0)
    {
        return [NSString stringWithFormat:@"(%@:%@:%@),", self.tip, self.pwd, self.acc];
    }
    return [NSString stringWithFormat:@"(%@:%@),", self.tip, self.pwd];
}

-(id)makePwid
{
    return [MD5Encode md5_32:[NSString stringWithFormat:@"%@+%@+%@", self.tip, self.pwd, self.acc]];
}

#pragma mark -NSCoding

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.tip = [aDecoder decodeObjectForKey:PWD_Tip];
        self.pwd = [aDecoder decodeObjectForKey:PWD_Text];
        self.acc = [aDecoder decodeObjectForKey:PWD_Account];
        self.tip_pinyin = [aDecoder decodeObjectForKey:PWD_TipPinYin];
        self.pwid = [aDecoder decodeObjectForKey:@"pid"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.tip forKey:PWD_Tip];
    [aCoder encodeObject:self.pwd forKey:PWD_Text];
    [aCoder encodeObject:self.acc forKey:PWD_Account];
    [aCoder encodeObject:self.tip_pinyin forKey:PWD_TipPinYin];
    [aCoder encodeObject:self.pwid forKey:@"pid"];
}
@end
