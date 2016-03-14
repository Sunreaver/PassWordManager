//
//  CoreSpotlightData.m
//  HotelCtrl
//
//  Created by 谭伟 on 15/12/4.
//  Copyright © 2015年 &#35885;&#20255;. All rights reserved.
//

#import "CoreSpotlightData.h"
#import "PassWord.h"
#import <CoreSpotlight/CoreSpotlight.h>

@implementation CoreSpotlightData

+(void)MakeCoreSpotlightListWithArr:(NSArray<PassWord*>*)arr
{
    NSMutableArray *seachableItems = [NSMutableArray new];
    [arr enumerateObjectsUsingBlock:^(PassWord *__nonnull data, NSUInteger idx, BOOL * __nonnull stop) {
        CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"views"];
        attributeSet.displayName = data.tip;
        attributeSet.keywords = @[data.tip, data.tip_pinyin];
        attributeSet.contentDescription = [NSString stringWithFormat:@"%@ <%@>", data.pwd, data.acc];
//        UIImage *thumbImage = [UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png",obj]];
//        attributeSet.thumbnailData = UIImagePNGRepresentation(thumbImage);//beta 1 there is a bug
        CSSearchableItem *item = [[CSSearchableItem alloc]
                  initWithUniqueIdentifier:data.pwid
                  domainIdentifier:@"com.yeeuu.PassWord"
                  attributeSet:attributeSet];
        item.expirationDate = [NSDate dateWithTimeIntervalSinceNow:5*365*24*3600];
        [seachableItems addObject:item];
    }];
    [[CSSearchableIndex defaultSearchableIndex] deleteAllSearchableItemsWithCompletionHandler:^(NSError * _Nullable error) {
        [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:seachableItems
                                                       completionHandler:^(NSError * __nullable error) {
                                                       }];
    }];
}

+(void)MakeCoreSpotlightListWithData:(PassWord *)data
{
    CSSearchableItemAttributeSet *attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"views"];
    attributeSet.displayName = data.tip;
    attributeSet.keywords = @[data.tip, data.tip_pinyin];
    attributeSet.contentDescription = [NSString stringWithFormat:@"%@ <%@>", data.pwd, data.acc];
    
    CSSearchableItem *item = [[CSSearchableItem alloc]
                              initWithUniqueIdentifier:data.pwid
                              domainIdentifier:@"com.yeeuu.PassWord"
                              attributeSet:attributeSet];
    item.expirationDate = [NSDate dateWithTimeIntervalSinceNow:5*365*24*3600];
    
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item]
                                                   completionHandler:^(NSError * __nullable error) {
                                                   }];
}

+(void)DelCoreSpotlightWithData:(PassWord *)data
{
    [[CSSearchableIndex defaultSearchableIndex] deleteSearchableItemsWithIdentifiers:@[data.pwid] completionHandler:^(NSError * _Nullable error) {
        
    }];
}


@end
