//
//  CoreSpotlightData.h
//  HotelCtrl
//
//  Created by 谭伟 on 15/12/4.
//  Copyright © 2015年 &#35885;&#20255;. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PassWord;

@interface CoreSpotlightData : NSObject

+(void)MakeCoreSpotlightListWithArr:(NSArray<PassWord*>*)arr;
+(void)MakeCoreSpotlightListWithData:(PassWord*)data;
+(void)DelCoreSpotlightWithData:(PassWord *)data;

@end
